# Changelogs for Perlin Noise JASS

    v1.2.0
        - Added InitNoise function, and it is required to be called in initialization
        - Added GeneratePermutationTable and GeneratePermutationTableCustom function
        - Due to the new GeneratePermutationTableCustom function, it requires the global variables:
            - NoiseGetIntegerIntEvent (real)
            - NoiseGetIntegerIntLow (integer)
            - NoiseGetIntegerIntHigh (integer)
            - NoiseGetIntegerIntReturn (integer)
        - Added NoiseVersion constant function.

    v1.1.0
        - Added OpenSimplex2D function
        - Added a whitespace in function, Lerp

    v1.0.0
        - Initial release
