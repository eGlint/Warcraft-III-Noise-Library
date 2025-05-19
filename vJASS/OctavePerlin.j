/*
	Octave Perlin vJASS v1.1.0 

	A plugin for the Noise library.

	Port by Glint
	Octave Perlin by Flafla2, https://flafla2.github.io/2014/08/09/perlinnoise.html
*/

library NoisePlugin requires Noise
	module OctavePerlin
		static method octavePerlin1D takes real x, integer octaves, real persistence returns real
			local real total = 0.
			local real frequency = 1.
			local real amplitude = 1.
			local real maxValue = 0.
			local integer i = 0
			loop
				exitwhen i >= octaves
				set total = perlin1D(x * frequency) * amplitude
				set maxValue = maxValue + amplitude
				set amplitude = amplitude * persistence
				set frequency = frequency * 2.
				set i = i + 1
			endloop
			return total / maxValue
		endmethod

		static method octavePerlin2D takes real x, real y, integer octaves, real persistence returns real
			local real total = 0.
			local real frequency = 1.
			local real amplitude = 1.
			local real maxValue = 0.
			local integer i = 0
			loop
				exitwhen i >= octaves
				set total = perlin2D(x * frequency, y * frequency) * amplitude
				set maxValue = maxValue + amplitude
				set amplitude = amplitude * persistence
				set frequency = frequency * 2.
				set i = i + 1
			endloop
			return total / maxValue
		endmethod

		static method octavePerlin3D takes real x, real y, real z, integer octaves, real persistence returns real
			local real total = 0.
			local real frequency = 1.
			local real amplitude = 1.
			local real maxValue = 0.
			local integer i = 0
			loop
				exitwhen i >= octaves
				set total = perlin3D(x * frequency, y * frequency, z * frequency) * amplitude
				set maxValue = maxValue + amplitude
				set amplitude = amplitude * persistence
				set frequency = frequency * 2.
				set i = i + 1
			endloop
			return total / maxValue
		endmethod
	endmodule
endlibrary