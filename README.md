# Decoding Morse code:

Code with libraries: [Pandora](./Problems/pandora/decode-morse-code.hs)

```
....- -> 4
```

# Balanced parentheses:

Code with libraries: [Pandora](./Problems/pandora/balanced-parentheses.hs), [Joint](./Problems/joint/balanced-parentheses.hs)

```
{x} -> OK: all parentheses are balanced
{] -> MISMATCH: open bracket doesn't match to closed one
) -> DEADEND: closed bracket without corresponding opened one
< -> LOGJAM: opened bracket without corresponding closed one
```

# Trapping rain water:

Code with libraries: [Pandora](./Problems/pandora/trapping-rain-water.hs), [Joint](./Problems/joint/trapping-rain-water.hs)

```
7|             |x|x|                     |x|x|
6|             |x|x|x|                   |x|x|x|
5|   |x|       |x|x|x|         |x|~~~~~~~|x|x|x|
4|   |x|     |x|x|x|x|  ==>    |x|~~~~~|x|x|x|x|
3|   |x|   |x|x|x|x|x|         |x|~~~|x|x|x|x|x|
2| |x|x| |x|x|x|x|x|x|       |x|x|~|x|x|x|x|x|x|
1| |x|x|x|x|x|x|x|x|x|       |x|x|x|x|x|x|x|x|x|
0| ===================       ===================
```

# Cellular automata:

Code with libraries: [Pandora](./Problems/pandora/cellular-automata.hs), [Joint](./Problems/joint/cellular-automata.hs)

```
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
[ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ] ===> [ , , , , ,*, , , , , ] ===> [ , , , ,*,*,*, , , , ]
[ , , , ,*,*,*, , , , ] ===> [ , , , ,*, ,*, , , , ] ===> [ , , , ,*,*,*, , , , ] ===> [ , , ,*, , , ,*, , , ]
[ , , , ,*,*,*, , , , ] ===> [ , , ,*, , , ,*, , , ] ===> [ , , ,*,*, ,*,*, , , ] ===> [ , , ,*, , , ,*, , , ]
[ , , , ,*,*,*, , , , ] ===> [ , , , ,*, ,*, , , , ] ===> [ , , , ,*,*,*, , , , ] ===> [ , , ,*, , , ,*, , , ]
[ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ] ===> [ , , , , ,*, , , , , ] ===> [ , , , ,*,*,*, , , , ]
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
[ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]

        ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
        ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , , , ,*, , , , , ] ===> [ , , , ,*,*,*, , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , , ,*,*,*, , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , ,*, ,*, ,*, , , ] ===> [ , ,*, , , , , ,*, , ] ===> [ , , , , , , , , , , ]
        ===> [ , ,*,*,*, ,*,*,*, , ] ===> [ , ,*, , , , , ,*, , ] ===> [ ,*,*,*, , , ,*,*,*, ]
        ===> [ , , ,*, ,*, ,*, , , ] ===> [ , ,*, , , , , ,*, , ] ===> [ , , , , , , , , , , ]
        ===> [ , , , ,*,*,*, , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , , , ,*, , , , , ] ===> [ , , , ,*,*,*, , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , ,*, , , , , ]
        ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ] ===> [ , , , , , , , , , , ]
```
