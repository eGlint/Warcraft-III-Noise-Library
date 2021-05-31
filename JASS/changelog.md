# Changelogs for Noise Library (JASS)

    v1.2.1-pre-1.29
        - Fixed skewed noise for 2D Open Simplex
        - Turned GradientTable2D into GradientTable2DX and GradientTable2DY for 2D Open Simplex's extrapolation fix, now requires global variables:
                - GradientTable2DX (integer array)
                - GradientTable2DY (integer array)
        - Added NoiseBitXor function

    v1.2.0-pre-1.29
        - Added InitNoise function, and it is required to be called in initialization
        - Added GeneratePermutationTable and GeneratePermutationTableCustom function
        - Due to the new GeneratePermutationTableCustom function, it requires the global variables:
            - NoiseGetIntegerIntEvent (real)
            - NoiseGetIntegerIntLow (integer)
            - NoiseGetIntegerIntHigh (integer)
            - NoiseGetIntegerIntReturn (integer)
        - Added NoiseVersion constant function

    v1.1.1-pre-1.29
        - Removed "constant" keyword in NoiseBitAnd function

    v1.1.0-pre-1.29
        - Initial release (based on master-v1.1.0)
