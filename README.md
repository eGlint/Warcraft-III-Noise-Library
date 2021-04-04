# Warcraft III (Pre-1.29) Noise Library 

This repository contains [Kenneth Perlin's Improved Noise](https://mrl.nyu.edu/~perlin/noise/), [Kurt Spencer's Open Simplex](https://gist.github.com/KdotJPG/b1270127455a94ac5d19), and implemented it to popular Warcraft 3 scripting languages.

If you are not familiar with adding octaves to Perlin Noise, [Flafla2's Octave Perlin](https://flafla2.github.io/2014/08/09/perlinnoise.html), is an optional package that can help you.

If your map or project aims to run only after 1.29 of Warcraft III, use [this](https://github.com/eGlint/Warcraft-III-Noise-Library) version of Noise Library instead.

## Backwards Compatibility Guide

Before adding this library in your map, make sure to follow the instructions below. Not following the instructions will show this message when you run the map and use the Noise functions: 

JASS: 
> NoiseBitAnd: Not implemented

vJASS: 
> Noise.bitAnd: Not implemented

In order to make Noise Library work in pre-1.29 of Warcraft III, you are required to have these libraries in your map or workspace:

- JASS</br>
[Bitwise](https://www.hiveworkshop.com/threads/snippet-bitwise.331760/) by d07.RiV
- vJASS</br>
[Bitwise v1.0.0.1](https://www.hiveworkshop.com/threads/snippet-bitwise.249223/) by Nestharus, Magtheridon96 & Bannar

Once you added the Bitwise library in your map or workspace, now add the Noise Library.

For JASS, change the statement inside `NoiseBitAnd` from:
```
function NoiseBitAnd takes integer x, integer y returns integer
	//return AND(x, y) // Bitwise by d07.RiV
	call BJDebugMsg("NoiseBitAnd: Not implemented") 
	return 0
endfunction 
```
to:
```
function NoiseBitAnd takes integer x, integer y returns integer
	return AND(x, y) // Bitwise by d07.RiV
endfunction 
```

For vJASS, Jasshelper will automatically recognize the Bitwise library.

If you want to use your own implementation of Bitwise And for the Noise Library, remove the `BJDebugMsg` that prompts "Not implemented" and replace `return 0` to `return MyBitwiseAnd(x,y)`.

Alternatively, you can replace `return 0` to `return ModuloInteger(x, y + 1)`. It might work but it is not recommeded since ModuloInteger and a true implementation of Bitwise And behave differently.

## Changelogs

- [JASS 1.1.0-pre-1.29](JASS/changelog.md)
- [vJASS 1.1.0-pre-1.29](vJASS/changelog.md)