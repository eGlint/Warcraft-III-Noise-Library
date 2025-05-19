# Warcraft III Noise Library

[![Build](https://circleci.com/gh/eGlint/Warcraft-III-Noise-Library.svg?&branch=master)](https://circleci.com/gh/eGlint/Warcraft-III-Noise-Library)

This repository contains [Kenneth Perlin's Improved Noise](https://mrl.nyu.edu/~perlin/noise/), [Kurt Spencer's Open Simplex](https://gist.github.com/KdotJPG/b1270127455a94ac5d19), and implemented it to popular Warcraft 3 scripting languages.

Visit [this repository for the Wurst](https://github.com/eGlint/wurstNoiselib)  version of the Noise library.

If you are not familiar with adding octaves to Perlin Noise, [Flafla2's Octave Perlin](https://flafla2.github.io/2014/08/09/perlinnoise.html), is an optional package that can help you.

## Installation

Most Warcraft III map makers already know the common method of putting a script in a custom map: __copy & paste the code in the Trigger Editor__.

If you are not familiar with this method, here are the following instructions.

1. You have a working copy of Warcraft III.
2. You can open the official World Editor in two ways:
    1. __Battle.net__:
        - Open your Battle.net Launcher.
        - Select Warcraft III Reforged.
        - Above the _Game Version_, press the _Launch Editor_ to start the World Editor.
    2. __World Editor.exe__:
        - Locate your Warcraft III installtion. The default Wndows installtion should be `C:\Program Files\Warcraft III`.
        - In the install path of Warcraft III, go to `_retail_\x86_64\World Editor.exe`.
3. Once the World Editor is open, either create a new map or open an existing map you the Noise Library to become available.
4. By default, JASS is the default scripting language of Warcraft III maps. If you are unsure about the current scripting language.
    1. In the menu bar: `Scenario > Map Options...`.
    2. Under _Scripting Language_, the optio in the dropdown menu should either be __JASS__ or __Lua__.
5. Once a map is open, open the Trigger Editor. There are 3 ways to open it.
    1. Find the yellow "A" icon in tool bar.
    2. In the menu bar: `Module > Trigger Editor`.
    3. Press `F4` in your keyboard.
6. __Optional__. If you want to use __vJass__, it is required your  _Scripting Language_ to be __JASS__. On the Trigger Editor's menu bar: `JassHelper > Enable JassHelper` and make sure `Enable vJass` is enabled or checked.
7. To keep it simple, select the top-most node of the tree view: The scroll icon with the name of the current map.
8. Once you click the top-most node, you should be in the Custom Script Code.
9. Now browse this repository, select the folder based on the scripting language you want to use: JASS, vJASS or Lua.
10. Copy the raw content of Noise.j or Noise.lua and paste it at the Custom Script Code textbox.
11. __Optional__. Copy the raw content of OctavePerlin.j or OctavePerlin.lua and strictly paste it below the Noise Library for JASS. For vJass and Lua, you can paste it above or below.
12. Please __thoroughly read the comments__ of the Noise Library script for __any additional installtion instructions__.

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

## Demo Map

If you are stumped on how to make this library work, you can download a demo map of the Noise Library in the [Hive Workshop](https://www.hiveworkshop.com/threads/noise-library-v1-2.319413/#Contents:~:Contents&text=Previews-,Contents,-Add%20resource).

## Contributing

Become part of the [contributors](https://github.com/eGlint/Warcraft-III-Noise-Library/graphs/contributors) by doing a [pull request](https://github.com/eGlint/Warcraft-III-Noise-Library/pulls).

## Changelogs

- [JASS 1.2.1](JASS/changelog.md)
- [vJASS 1.2.2](vJASS/changelog.md)
- [Lua 1.2.1](Lua/changelog.md)
