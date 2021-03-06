module Main where

-- Source: https://github.com/wh5a/Algorithm-W-Step-By-Step

import "base" Data.Traversable (for)
import "containers" Data.Map
import "containers" Data.Set
import "mtl" Control.Monad.Except (ExceptT, runExceptT, catchError, throwError)
import "mtl" Control.Monad.State (State, runState, get, modify)
import "pretty" Text.PrettyPrint

data Expression
	= Variable String
	| Literal Literal
	| Application Expression Expression
	| Abstraction String Expression
	| Let String Expression Expression
	deriving (Eq, Ord)

instance Show Expression where
	show (Variable v) = show v
	show (Literal l) = show l
	show (Application e e') = show e ++ "" ++ show e'
	show (Abstraction arg body) = "\\" ++ show arg ++ " -> " ++ show body
	show (Let v e body) = "let " ++ show v ++ " " ++ show e ++ " in " ++ show body

data Literal
	= Integer Integer
	| Boolean Bool
	deriving (Eq, Ord)

instance Show Literal where
	show (Integer i) = show i
	show (Boolean b) = show b

data Grounded
	= Integer'
	| Boolean'
	deriving (Eq, Ord, Show)

data Monotype
	= Parametric Int
	| Grounded Grounded
	| Function Monotype Monotype
	deriving (Eq, Ord, Show)

data Polytype = Polytype [Int] Monotype

-- Finite mappings from type variables to types
type Substitution = Map Int Monotype

mergeSubstitutions :: Substitution -> Substitution -> Substitution
mergeSubstitutions s1 s2 = Data.Map.union (apply s1 <$> s2) s1

class Substitutable a where
	free :: a -> Set Int
	apply :: Substitution -> a -> a

instance Substitutable Monotype where
	free (Parametric n) = Data.Set.singleton n
	free (Grounded Integer') = mempty
	free (Grounded Boolean') = mempty
	free (Function st tt) = Data.Set.union (free st) (free tt)
	apply s (Function st tt) = Function (apply s st) (apply s tt)
	apply _ t = t

instance Substitutable Polytype where
	free (Polytype vars t) = Data.Set.difference (free t) $ Data.Set.fromList vars
	apply s (Polytype vars t) = Polytype vars $ apply (Prelude.foldr Data.Map.delete s vars) t

instance Substitutable a => Substitutable [a] where
	free l = Prelude.foldr Data.Set.union mempty $ free <$> l
	apply s x = apply s <$> x

newtype Г = Г (Map String Polytype)

remove :: Г -> String -> Г
remove (Г env) var = Г $ Data.Map.delete var env

instance Substitutable Г where
	free (Г env) = free $ Data.Map.elems env
	apply s (Г env) = Г $ apply s <$> env

generalize :: Monotype -> Г -> Polytype
generalize t env = flip Polytype t . Data.Set.toList $ Data.Set.difference (free t) (free env)

type Typechecker a = ExceptT Error (State Int) a

data Error
	= Unbound String
	| DoNotUnify Monotype Monotype
	| CheckFail Int Monotype
	| Within Expression Error

instance Show Error where
	show (Unbound n) = "Unbound variable: " ++ n
	show (DoNotUnify t t') = "Monotypes do not unify: " ++ show t ++ " vs. " ++ show t'
	show (CheckFail n t) = "Occurs check fails: " ++ show n ++ " vs. " ++ show t
	show (Within expr err) = show err ++ "\n in " ++ show expr

tc :: Typechecker a -> (Either Error a, Int)
tc t = runState (runExceptT t) 0

newTyVar :: Typechecker Monotype
newTyVar = modify (+1) *> (Parametric <$> get)

-- The instantiation function replaces all bound type variables in a polytype with fresh type variables
instantiate :: Polytype -> Typechecker Monotype
instantiate (Polytype vars t) = flip apply t . Data.Map.fromList . zip vars <$> for vars (const newTyVar)

-- For two types t1 and t2, unification returns the most general unifier
unification :: Monotype -> Monotype -> Typechecker Substitution
unification (Function a b) (Function c d) = do
	input <- unification a c
	result <- unification (apply input b) (apply input d)
	pure $ mergeSubstitutions input result
unification (Parametric u) t = varBind u t
unification t (Parametric u) = varBind u t
unification (Grounded Integer') (Grounded Integer') = pure mempty
unification (Grounded Boolean') (Grounded Boolean') = pure mempty
unification t t' = throwError $ DoNotUnify t t'

varBind :: Int -> Monotype -> Typechecker Substitution
varBind n ((== Parametric n) -> True) = pure mempty
varBind n t@(Data.Set.member n . free -> True) = throwError $ CheckFail n t
varBind n t = pure $ Data.Map.singleton n t

ti :: Г -> Expression -> Typechecker (Substitution, Monotype)
ti (Г env) (Variable n) = case Data.Map.lookup n env of
	Nothing -> throwError $ Unbound n
	Just sigma -> (,) mempty <$> instantiate sigma
ti _ (Literal (Integer _)) = pure (mempty, Grounded Integer')
ti _ (Literal (Boolean _)) = pure (mempty, Grounded Boolean')
ti env (Abstraction n e) = do
	tv <- newTyVar
	let Г env' = remove env n
	let env'' = Г $ Data.Map.union env' $ Data.Map.singleton n $ Polytype [] tv
	(s1, t1) <- ti env'' e
	pure (s1, Function (apply s1 tv) t1)
ti env exp@(Application e1 e2) = do
	tv <- newTyVar
	(s1, t1) <- ti env e1
	(s2, t2) <- ti (apply s1 env) e2
	s3 <- unification (apply s2 t1) (Function t2 tv)
	pure (s3 `mergeSubstitutions` s2 `mergeSubstitutions` s1, apply s3 tv)
	`catchError` (throwError . Within exp)
ti env (Let x e1 e2) = do
	(s1, t1) <- ti env e1
	let Г env' = remove env x
	let t' = generalize t1 $ apply s1 env
	let env'' = Г $ Data.Map.insert x t' env'
	(s2, t2) <- ti (apply s1 env'') e2
	pure (s1 `mergeSubstitutions` s2, t2)

typeInference :: Map String Polytype -> Expression -> Typechecker Monotype
typeInference env e = uncurry apply <$> ti (Г env) e

test :: Expression -> IO ()
test e = case fst $ tc (typeInference mempty e) of
	Left err -> putStrLn $ show e ++ "\n " ++ show err ++ "\n"
	Right t -> putStrLn $ show e ++ " : " ++ show t ++ "\n"

e0 = Let "id" (Abstraction "x" (Variable "x")) (Variable "id")
e1 = Let "id" (Abstraction "x" (Variable "x")) (Application (Variable "id") (Variable "id"))
e2 = Let "id" (Abstraction "x" (Let "y" (Variable "x") (Variable "y"))) (Application (Variable "id") (Variable "id"))
e3 = Let "id" (Abstraction "x" (Let "y" (Variable "x") (Variable "y"))) (Application (Application (Variable "id") (Variable "id")) (Literal (Integer 2)))
e4 = Let "id" (Abstraction "x" (Application (Variable "x") (Variable "x"))) (Variable "id")
e5 = Abstraction "m" (Let "y" (Variable "m") (Let "x" (Application (Variable "y") (Literal (Boolean True))) (Variable "x")))
e6 = Application (Literal (Integer 2)) (Literal (Integer 2))

main = for [e0, e1, e2, e3, e4, e5, e6] test
