# Changelogs for Noise Library (Lua)

    v1.2.1
        - Fixed skewed noise for 2D Open Simplex
        - Turned Noise.gradTable2D into a 2D table for 2D Open Simplex's extrapolation fix
        - Replaced all BlzBitAnd function calls into Lua's bitwise & operator
        - For the function Noise.generatePermutationTable, getRandomIntInterface argument is now type-safe

    v1.2.0
        - Added Noise.initialize function and it is called during initialization by default
        - Added Noise.generatePermutationTable
        - Deprecated functions: Noise.permutationInit

    v1.1.0
        - Added Noise.openSimplex2D function
        - Added a whitespace in the local function, lerp

    v1.0.1
        - Fixed wrong parameters for the function perlin1D (thanks to Drake53)
        - Fixed wrong parameters for the function grad1D

    v1.0.0
        - Initial release
