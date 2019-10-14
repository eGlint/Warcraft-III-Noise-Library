//
//	Perlin Noise JASS v1.0.0
//
//	Port by Glint
//	Perlin Noise by Kenneth Perlin, https://mrl.nyu.edu/~perlin/noise/
//

function Floor takes real value returns integer
	local integer n = R2I(value)
	if value < 0 and value - n != 0. then
		set n = n - 1
	endif
	return n
endfunction

function RealTernaryOp takes boolean cond, real a, real b returns real
	if cond then
		return a
	else
		return b
	endif
endfunction

function Fade takes real t returns real
	return t * t * t * (t * (t * 6. - 15.) + 10.)
endfunction

function Lerp takes real t, real a, real b returns real
	return a + t * (b -a)
endfunction

function Gradient1D takes integer hash, real x returns real
	local integer h = BlzBitAnd(hash, 15)
	return RealTernaryOp(BlzBitAnd(h, 1) == 0, x, -x)
endfunction

function PerlinNoise1D takes real x returns real
	local integer X = BlzBitAnd(Floor(x), 255)
	set x = x - Floor(x)
	return Lerp(Fade(x), Gradient1D(udg_NoisePermutation[X], x), Gradient1D(udg_NoisePermutation[X + 1], x - 1)) * 2
endfunction

function Gradient2D takes integer hash, real x, real y returns real
	local integer h = BlzBitAnd(hash, 15)
	local real u = RealTernaryOp(h < 8, x, y)
	local real v = RealTernaryOp(h < 4, y, x)
	return RealTernaryOp(BlzBitAnd(h, 1) == 0, u, -u) + RealTernaryOp(BlzBitAnd(h, 2) == 0, v, -v)
endfunction

function PerlinNoise2D takes real x, real y returns real
	local integer X = BlzBitAnd(Floor(x), 255)
	local integer Y = BlzBitAnd(Floor(y), 255)
	local real u
	local real v
	local integer A
	local integer B
	local real lerpA1
	local real lerpA2
	set x = x - Floor(x)
	set y = y - Floor(y)
	set u = Fade(x)
	set v = Fade(y)
	set A = udg_NoisePermutation[X] + Y
	set B = udg_NoisePermutation[X + 1] + Y
	set lerpA1 = Lerp(u, Gradient2D(udg_NoisePermutation[A], x, y), Gradient2D(udg_NoisePermutation[B], x - 1., y))
	set lerpA2 = Lerp(u, Gradient2D(udg_NoisePermutation[A + 1], x, y - 1.), Gradient2D(udg_NoisePermutation[B + 1], x - 1., y - 1.))
	return Lerp(v, lerpA1, lerpA2)
endfunction

function Gradient3D takes integer hash, real x, real y, real z returns real
	local integer h = BlzBitAnd(hash, 15)
	local real u = RealTernaryOp(h < 8, x, y)
	local real v = RealTernaryOp(h < 4, y, RealTernaryOp(h == 12 or h == 14, x, z))
	return RealTernaryOp(BlzBitAnd(h, 1) == 0, u, -u) + RealTernaryOp(BlzBitAnd(h, 2) == 0, v, -v)
endfunction

function PerlinNoise3D takes real x, real y, real z returns real
	local integer X = BlzBitAnd(Floor(x), 255)
	local integer Y = BlzBitAnd(Floor(y), 255)
	local integer Z = BlzBitAnd(Floor(z), 255)
	local real u
	local real v
	local real w
	local integer A
	local integer AA
	local integer AB
	local integer B
	local integer BA
	local integer BB
	local real lerpA1
	local real lerpA2
	local real lerpB1
	local real lerpB2
	set x = x - Floor(x)
	set y = y - Floor(y)
	set z = z - Floor(z)
	set u = Fade(x)
	set v = Fade(y)
	set w = Fade(z)
	set A = udg_NoisePermutation[X] + Y
	set AA = udg_NoisePermutation[A] + Z
	set AB = udg_NoisePermutation[A + 1] + Z
	set B = udg_NoisePermutation[X + 1] + Y
	set BA = udg_NoisePermutation[B] + Z
	set BB = udg_NoisePermutation[B + 1] + Z
	set lerpA1 = Lerp(u, Gradient3D(udg_NoisePermutation[AA], x, y, z), Gradient3D(udg_NoisePermutation[BA], x - 1., y, z))
	set lerpA2 = Lerp(u, Gradient3D(udg_NoisePermutation[AB], x, y - 1., z), Gradient3D(udg_NoisePermutation[BB], x - 1., y - 1., z))
	set lerpB1 = Lerp(u, Gradient3D(udg_NoisePermutation[AA + 1], x, y, z - 1.), Gradient3D(udg_NoisePermutation[BA + 1], x - 1., y, z - 1.))
	set lerpB2 = Lerp(u, Gradient3D(udg_NoisePermutation[AB + 1], x, y - 1., z - 1.), Gradient3D(udg_NoisePermutation[BB + 1], x - 1., y - 1., z - 1.))
	return Lerp(w, Lerp(v, lerpA1, lerpA2), Lerp(v, lerpB1, lerpB2))
endfunction