--[[
	Noise Lua v1.2.1

	Port by Glint, https://github.com/eGlint/Warcraft-III-Noise-Library
	Perlin Noise by Kenneth Perlin, https://mrl.nyu.edu/~perlin/noise/
	Open Simplex by Kurt Spencer, https://gist.github.com/KdotJPG/b1270127455a94ac5d19
]]--
do
	Noise = {} 

	Noise.version = "1.2.1"
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
		return a + t * (b - a)
	end

	local function grad1D(hash, x)
		local h = hash & 15
		return (h & 1 == 0 and x or -x) 
	end

	function Noise.perlin1D (x)
		local X = floor(x) & 255
		x = x - floor(x)
		return lerp(fade(x), grad1D(Noise.permutation[X], x), grad1D(Noise.permutation[X + 1], x - 1)) * 2
	end

	local function grad2D(hash, x, y)
		local h = hash & 15
		local u, v = h < 8 and x or y, h < 4 and y or x
		return (h & 1 == 0 and u or -u) + (h & 2 == 0 and v or -v)
	end

	function Noise.perlin2D (x, y)
		local X, Y = floor(x) & 255, floor(y) & 255
		x, y = x - floor(x), y - floor(y)
		local u, v = fade(x), fade(y)
		local A = Noise.permutation[X] + Y
		local B = Noise.permutation[X + 1] + Y
		local a1 = lerp(u, grad2D(Noise.permutation[A], x, y), grad2D(Noise.permutation[B], x - 1, y))
		local a2 = lerp(u, grad2D(Noise.permutation[A + 1], x, y - 1), grad2D(Noise.permutation[B + 1], x - 1, y - 1))
		return lerp(v, a1, a2)
	end

	local function grad3D(hash, x, y, z)
		local h = hash & 15
		local u, v = h < 8 and x or y, h < 4 and y or ((h == 12 or h == 14) and x or z)
		return (h & 1 == 0 and u or -u) + (h & 2 == 0 and v or -v)
	end

	function Noise.perlin3D (x, y, z)
		local X, Y, Z = floor(x) & 255, floor(y) & 255, floor(z) & 255
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

	-- Deprecated as of 1.2.0, use Noise.generatePermutationTable() instead.
	function Noise.permutationInit ()
		print("Noise.permutationInit() is deprecated. Use Noise.generatePermutationTable() instead.")
		Noise.generatePermutationTable()
	end

	function Noise.generatePermutationTable(getRandomIntInterface)
		for i = 0, 255 do
			Noise.permutation[i] = type(getRandomIntInterface) == "function" and getRandomIntInterface(0, 255) or GetRandomInt(0, 255)
			Noise.permutation[i + 256] = Noise.permutation[i]
		end
	end

	Noise.STRETCH_CONSTANT_2D = -0.211324865405187
	Noise.SQUISH_CONSTANT_2D = 0.366025403784439
	Noise.NORM_CONSTANT_2D = 47
	Noise.PMASK = 255
	Noise.SQUISH_CONSTANT_2D_X, Noise.SQUISH_CONSTANT_2D_Y = 2. * Noise.SQUISH_CONSTANT_2D, 2. * Noise.SQUISH_CONSTANT_2D
	Noise.gradTable2D = 
	{	
		[0] = 
		{ 5,  2}, { 2,  5},
		{-2,  5}, {-5,  2},
		{-5, -2}, {-2, -5},
		{ 2, -5}, { 5, -2}
	}

	local function extrapolate2D(xsb, ysb, dx, dy)
		local index = Noise.permutation[Noise.permutation[xsb & Noise.PMASK] ~ (ysb & Noise.PMASK)] & 7
		return Noise.gradTable2D[index][1] * dx + Noise.gradTable2D[index][2] * dy
	end

	function Noise.openSimplex2D(x, y)
		local strechOffset = (x + y) * Noise.STRETCH_CONSTANT_2D
		local xs = x + strechOffset
		local ys = y + strechOffset
		local xsb = floor(xs)
		local ysb = floor(ys)
		local squishOffset = (xsb + ysb) * Noise.SQUISH_CONSTANT_2D
		local xb = xsb + squishOffset
		local yb = ysb + squishOffset
		local xins = xs - xsb 
		local yins = ys - ysb
		local inSum = xins + yins
		local dx0 = x - xb
		local dy0 = y - yb
		local dx_ext
		local dy_ext
		local xsv_ext
		local ysv_ext
		local value = 0.
		local dx1 = dx0 - 1. - Noise.SQUISH_CONSTANT_2D
		local dy1 = dy0 - Noise.SQUISH_CONSTANT_2D
		local attn1 = 2. - dx1 * dx1 - dy1 * dy1
		local dx2 = dx0 - Noise.SQUISH_CONSTANT_2D
		local dy2 = dy0 - 1. - Noise.SQUISH_CONSTANT_2D
		local attn2 = 2. - dx2 * dx2 - dy2 * dy2
		local ins
		local attn0 
		local attn_ext
		if attn1 > 0. then
			attn1 = attn1 * attn1
			value = attn1 * attn1 * extrapolate2D(xsb + 1, ysb, dx1, dy1)
		end
		if attn2 > 0. then 
			attn2 = attn2 * attn2
			value = value + attn2 * attn2 * extrapolate2D(xsb, ysb + 1, dx2, dy2)
		end
		if inSum <= 1 then 
			zins = 1. - inSum
			if zins > xins or zins > yins then 
				if xins > yins then
					xsv_ext = xsb + 1
					ysv_ext = ysb - 1
					dx_ext = dx0 - 1.
					dy_ext = dy0 + 1.
				else
					xsv_ext = xsb - 1
					ysv_ext = ysb + 1
					dx_ext = dx0 + 1.
					dy_ext = dy0 - 1.
				end
			else 
				xsv_ext = xsb + 1
				ysv_ext = ysb + 1
				dx_ext = dx0 - 1. - Noise.SQUISH_CONSTANT_2D_X
				dy_ext = dy0 - 1. - Noise.SQUISH_CONSTANT_2D_Y
			end
		else 
			zins = 2. - inSum
			if zins < xins or zins < yins then 
				if xins > yins then 
					xsv_ext = xsb + 2
					ysv_ext = ysb
					dx_ext = dx0 - 2. - Noise.SQUISH_CONSTANT_2D_X
					dy_ext = dy0 - Noise.SQUISH_CONSTANT_2D_Y
				else 
					xsv_ext = xsb
					ysv_ext = ysb + 2
					dx_ext = dx0 - Noise.SQUISH_CONSTANT_2D_X
					dy_ext = dy0 - 2. - Noise.SQUISH_CONSTANT_2D_Y
				end
			else
				dx_ext = dx0 
				dy_ext = dy0
				xsv_ext = xsb 
				ysv_ext = ysb
			end
			xsb = xsb + 1
			ysb = ysb + 1
			dx0 = dx0 - 1. - Noise.SQUISH_CONSTANT_2D_X
			dy0 = dy0 - 1. - Noise.SQUISH_CONSTANT_2D_Y
		end
		attn0 = 2. - dx0 * dx0 - dy0 * dy0
		if attn0 > 0. then 
			attn0 = attn0 * attn0
			value = value + attn0 * attn0 * extrapolate2D(xsb, ysb, dx0, dy0)
		end
		attn_ext = 2. - dx_ext * dx_ext - dy_ext * dy_ext
		if attn_ext > 0. then 
			attn_ext = attn_ext * attn_ext
			value = value + attn_ext * attn_ext * extrapolate2D(xsv_ext, ysv_ext, dx_ext, dy_ext)
		end
		return value / Noise.NORM_CONSTANT_2D
	end

	function Noise.initialize()
		Noise.generatePermutationTable()
	end

	Noise.initialize()
end
