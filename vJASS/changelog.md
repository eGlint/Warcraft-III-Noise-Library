# Changelogs for Noise Library (vJASS)

    v1.2.2-pre-1.29
    - Replaced 'getIntegerInt' names into 'getRandomInt'

    v1.2.1-pre-1.29
        - Fixed skewed noise for 2D Open Simplex
        - Turned Noise.gradTable2D into Noise.gradTable2DX and Noise.gradTable2DY for 2D Open Simplex's extrapolation fix
        - Added Noise.bitXor function

    v1.2.0-pre-1.29
        - Added Noise.initialize function and it is called during initialization by default
        - Added Noise.generatePermutationTable and Noise.generatePermutationTableCustom
        - Set setGradientTable to a public method
        - Deprecated functions: Noise.permutationInit and Noise.openSimplexInit

    v1.1.0-pre-1.29
        - Initial release (based on master-v1.1.0)
