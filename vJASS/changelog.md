# Changelogs for Noise Library (vJASS)

    v1.2.1
        - Fixed skewed noise for 2D Open Simplex
        - Turned Noise.gradTable2D into Noise.gradTable2DX and Noise.gradTable2DY for 2D Open Simplex's extrapolation fix

    v1.2.0
        - Added Noise.initialize function and it is called during initialization by default
        - Added Noise.generatePermutationTable and Noise.generatePermutationTableCustom
        - Set setGradientTable to a public method
        - Deprecated functions: Noise.permutationInit and Noise.openSimplexInit

    v1.1.0
        - Added Noise.openSimplex2D function
        - Added a whitespace in private function, Noise.lerp

    v1.0.0
        - Initial release
