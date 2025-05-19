# Warcraft III Noise Library

This repository contains [Kenneth Perlin's Improved Noise](https://mrl.nyu.edu/~perlin/noise/), [Kurt Spencer's Open Simplex](https://gist.github.com/KdotJPG/b1270127455a94ac5d19), and implemented it to popular Warcraft 3 scripting languages.

Visit [this repository](https://github.com/eGlint/wurstNoiselib) for the Wurst version of the Noise library.

If you are not familiar with adding octaves to Perlin Noise, [Flafla2's Octave Perlin](https://flafla2.github.io/2014/08/09/perlinnoise.html), is an optional package that can help you.

## Setup

Before using the noise functions, make sure to call the folliwng initialization functions:

JASS:
```
function MyInitialization takes nothing returns nothing 
    call InitNoise()
endfunction
```

vJASS:<br>
The library automatically calls `Noise.initialize()` by [default](vJASS/Noise.j#L10-14).

Lua:<br>
The library automatically calls `Noise.initialize()` by [default](Lua/Noise.lua#L209).

Calling this initialization function will generate random values (uses Warcraft III's GetRandomInt) to the permutation table and set the constant values for the JASS/vJASS versions of the gradient table. 

If you are having any issues with your noise functions during initialization, your permutation and gradient table are possibly uninitialized. 

In case your library that uses the noise functions initializes ahead of the Noise library's initialization, call `InitNoise` (JASS) or `Noise.initialize()` (vJASS/Lua) in your initializer.

## Changelogs

- [JASS 1.2.1](JASS/changelog.md)
- [vJASS 1.2.2](vJASS/changelog.md)
- [Lua 1.2.1](Lua/changelog.md)
