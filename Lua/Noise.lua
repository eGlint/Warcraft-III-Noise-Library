--[[
	Perlin Noise Lua v1.0.1

	Port by Glint
	Perlin Noise by Kenneth Perlin, https://mrl.nyu.edu/~perlin/noise/
]]--
do
	Noise = {} 

	Noise.version = "1.0.0"
	Noise.permutation = {}

	local function floor(value)
		local n = R2I(value)
		if value < 0. and value - n ~= 0. then n = n - 1 end
		return n
	end

	local function fade(t) 
		return t * t * t * (t * (t * 6. - 15.) + 10.)
	end

	local function lerp(t, a, b)
		return a + t * (b -a)
	end

	local function grad1D(hash, x)
		local h = BlzBitAnd(hash, 15)
		return (BlzBitAnd(h, 1) == 0 and x or -x) 
	end

	function Noise.perlin1D (x)
		local X = BlzBitAnd(floor(x), 255)
		x = x - floor(x)
		return lerp(fade(x), grad1D(Noise.permutation[X], x), grad1D(Noise.permutation[X + 1], x - 1)) * 2
	end

	local function grad2D(hash, x, y)
		local h = BlzBitAnd(hash, 15)
		local u, v = h < 8 and x or y, h < 4 and y or x
		return (BlzBitAnd(h, 1) == 0 and u or -u) + (BlzBitAnd(h, 2) == 0 and v or -v)
	end

	function Noise.perlin2D (x, y)
		local X, Y = BlzBitAnd(floor(x), 255), BlzBitAnd(floor(y), 255)
		x, y = x - floor(x), y - floor(y)
		local u, v = fade(x), fade(y)
		local A = Noise.permutation[X] + Y
		local B = Noise.permutation[X + 1] + Y
		local a1 = lerp(u, grad2D(Noise.permutation[A], x, y), grad2D(Noise.permutation[B], x - 1, y))
		local a2 = lerp(u, grad2D(Noise.permutation[A + 1], x, y - 1), grad2D(Noise.permutation[B + 1], x - 1, y - 1))
		return lerp(v, a1, a2)
	end

	local function grad3D(hash, x, y, z)
		local h = BlzBitAnd(hash, 15)
		local u, v = h < 8 and x or y, h < 4 and y or ((h == 12 or h == 14) and x or z)
		return (BlzBitAnd(h, 1) == 0 and u or -u) + (BlzBitAnd(h, 2) == 0 and v or -v)
	end

	function Noise.perlin3D (x, y, z)
		local X, Y, Z = BlzBitAnd(floor(x), 255), BlzBitAnd(floor(y), 255), BlzBitAnd(floor(z), 255)
		x, y, z = x - floor(x), y - floor(y), z - floor(z) 
		local u, v, w = fade(x), fade(y), fade(z)
		local A = Noise.permutation[X] + Y
		local AA = Noise.permutation[A] + Z
		local AB = Noise.permutation[A + 1] + Z
		local B = Noise.permutation[X + 1] + Y
		local BA = Noise.permutation[B] + Z
		local BB = Noise.permutation[B + 1] + Z
		local a1 = lerp(u, grad3D(Noise.permutation[AA], x, y, z), grad3D(Noise.permutation[BA], x - 1, y, z))
		local a2 = lerp(u, grad3D(Noise.permutation[AB], x, y - 1, z), grad3D(Noise.permutation[BB], x - 1, y - 1, z))
		local b1 = lerp(u, grad3D(Noise.permutation[AA + 1], x, y, z - 1), grad3D(Noise.permutation[BA + 1], x - 1, y, z - 1))
		local b2 = lerp(u, grad3D(Noise.permutation[AB + 1], x, y - 1, z - 1), grad3D(Noise.permutation[BB + 1], x - 1, y - 1, z - 1))
		return lerp(w, lerp(v, a1, a2), lerp(v, b1, b2))
	end

	function Noise.permutationInit ()
		for i = 0, 255 do
			Noise.permutation[i] = GetRandomInt(0, 255)
			Noise.permutation[i + 256] = Noise.permutation[i]
		end
	end
end