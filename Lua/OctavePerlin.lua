--[[
	Octave Perlin Lua v1.1.0 

	A plugin for the Noise library.

	Port by Glint
	Octave Perlin by Flafla2, https://flafla2.github.io/2014/08/09/perlinnoise.html
]]--

do
	function Noise.octavePerlin1D(x, octaves, persistence)
		local total, frequency, amplitude, maxValue = 0., 1., 1., 0.
		for i = 0, octaves - 1 do
			total = Noise.perlin1D(x * frequency) * amplitude
			maxValue = maxValue + amplitude
			amplitude = amplitude * persistence
			frequency = frequency * 2
		end
		return total / maxValue
	end

	function Noise.octavePerlin2D(x, y, octaves, persistence)
		local total, frequency, amplitude, maxValue = 0., 1., 1., 0.
		for i = 0, octaves - 1 do
			total = Noise.perlin2D(x * frequency, y * frequency) * amplitude
			maxValue = maxValue + amplitude
			amplitude = amplitude * persistence
			frequency = frequency * 2
		end
		return total / maxValue
	end

	function Noise.octavePerlin3D(x, y, z, octaves, persistence)
		local total, frequency, amplitude, maxValue = 0., 1., 1., 0.
		for i = 0, octaves - 1 do
			total = Noise.perlin3D(x * frequency, y * frequency, z * frequency) * amplitude
			maxValue = maxValue + amplitude
			amplitude = amplitude * persistence
			frequency = frequency * 2
		end
		return total / maxValue
	end
end
