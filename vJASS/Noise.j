/*
	Noise vJASS 1.2.2

	Port by Glint, https://github.com/eGlint/Warcraft-III-Noise-Library
	Perlin Noise by Kenneth Perlin, https://mrl.nyu.edu/~perlin/noise/
	Open Simplex by Kurt Spencer, https://gist.github.com/KdotJPG/b1270127455a94ac5d19
*/
library Noise

	private module Init
			private static method onInit takes nothing returns nothing
				call initialize()
			endmethod
	endmodule

	struct Noise extends array
		readonly static string version = "1.2.2"
		readonly static real STRETCH_CONSTANT_2D = -0.21132486 
		readonly static real SQUISH_CONSTANT_2D = 0.36602540
		readonly static integer NORM_CONSTANT_2D = 47
		readonly static integer PMASK = 255
		readonly static real SQUISH_CONSTANT_2D_X = 2. * SQUISH_CONSTANT_2D 
		readonly static real SQUISH_CONSTANT_2D_Y = 2. * SQUISH_CONSTANT_2D

		static integer array permutation
		static integer array gradTable2DX
		static integer array gradTable2DY
		
		implement Init
		implement optional OctavePerlin
	
		private static method floor takes real value returns integer
			local integer n = R2I(value)
			if value < 0. and value - n != 0. then
				set n = n - 1
			endif
			return n
		endmethod
		
		private static method realTernaryOp takes boolean cond, real a, real b returns real
			if cond then
				return a
			else
				return b
			endif
		endmethod
		
		private static method fade takes real t returns real
			return t * t * t * (t * (t * 6. - 15.) + 10.)
		endmethod

		private static method lerp takes real t, real a, real b returns real
			return a + t * (b - a)
		endmethod

		private static method grad1D takes integer hash, real x returns real
			local integer h = BlzBitAnd(hash, 15)
			return realTernaryOp(BlzBitAnd(h, 1) == 0, x, -x)
		endmethod

		static method perlin1D takes real x returns real
			local integer X = BlzBitAnd(floor(x), 255)
			set x = x - floor(x)
			return lerp(fade(x), grad1D(permutation[X], x), grad1D(permutation[X + 1], x - 1.)) * 2
		endmethod

		private static method grad2D takes integer hash, real x, real y returns real
			local integer h = BlzBitAnd(hash, 15)
			local real u = realTernaryOp(h < 8, x, y)
			local real v = realTernaryOp(h < 4, y, x)
			return realTernaryOp(BlzBitAnd(h, 1) == 0, u, -u) + realTernaryOp(BlzBitAnd(h, 2) == 0, v, -v)
		endmethod

		static method perlin2D takes real x, real y returns real
			local integer X = BlzBitAnd(floor(x), 255)
			local integer Y = BlzBitAnd(floor(y), 255)
			local real u
			local real v
			local integer A
			local integer B
			local real lerpA1
			local real lerpA2
			set x = x - floor(x)
			set y = y - floor(y)
			set u = fade(x)
			set v = fade(y)
			set A = permutation[X] + Y
			set B = permutation[X + 1] + Y
			set lerpA1 = lerp(u, grad2D(permutation[A], x, y), grad2D(permutation[B], x - 1., y))
			set lerpA2 = lerp(u, grad2D(permutation[A + 1], x, y - 1.), grad2D(permutation[B + 1], x - 1., y - 1.))
			return lerp(v, lerpA1, lerpA2)
		endmethod

		private static method grad3D takes integer hash, real x, real y, real z returns real
			local integer h = BlzBitAnd(hash, 15)
			local real u = realTernaryOp(h < 8, x, y)
			local real v = realTernaryOp(h < 4, y, realTernaryOp(h == 12 or h == 14, x, z))
			return realTernaryOp(BlzBitAnd(h, 1) == 0, u, -u) + realTernaryOp(BlzBitAnd(h, 2) == 0, v, -v)
		endmethod

		static method perlin3D takes real x, real y, real z returns real
			local integer X = BlzBitAnd(floor(x), 255)
			local integer Y = BlzBitAnd(floor(y), 255)
			local integer Z = BlzBitAnd(floor(z), 255)
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
			set x = x - floor(x)
			set y = y - floor(y)
			set z = z - floor(z)
			set u = fade(x)
			set v = fade(y)
			set w = fade(z)
			set A = permutation[X] + Y
			set AA = permutation[A] + Z
			set AB = permutation[A + 1] + Z
			set B = permutation[X + 1] + Y
			set BA = permutation[B] + Z
			set BB = permutation[B + 1] + Z
			set lerpA1 = lerp(u, grad3D(permutation[AA], x, y, z), grad3D(permutation[BA], x - 1., y, z))
			set lerpA2 = lerp(u, grad3D(permutation[AB], x, y - 1., z), grad3D(permutation[BB], x - 1., y - 1., z))
			set lerpB1 = lerp(u, grad3D(permutation[AA + 1], x, y, z - 1.), grad3D(permutation[BA + 1], x - 1., y, z - 1.))
			set lerpB2 = lerp(u, grad3D(permutation[AB + 1], x, y - 1., z - 1.), grad3D(permutation[BB + 1], x - 1., y - 1., z - 1.))
			return lerp(w, lerp(v, lerpA1, lerpA2), lerp(v, lerpB1, lerpB2))
		endmethod

		private static method extrapolate2D takes integer xsb, integer ysb, real dx, real dy returns real 
			local integer index = BlzBitAnd(permutation[BlzBitXor(permutation[BlzBitAnd(xsb, PMASK)], BlzBitAnd(ysb, PMASK))], 7)
			return gradTable2DX[index] * dx + gradTable2DY[index] * dy
		endmethod 

		static method openSimplex2D takes real x, real y returns real 
			local real strechOffset = (x + y) * STRETCH_CONSTANT_2D
			local real xs = x + strechOffset
			local real ys = y + strechOffset
			local integer xsb = floor(xs)
			local integer ysb = floor(ys)
			local real squishOffset = (xsb + ysb) * SQUISH_CONSTANT_2D
			local real xb = xsb + squishOffset
			local real yb = ysb + squishOffset
			local real xins = xs - xsb 
			local real yins = ys - ysb
			local real inSum = xins + yins
			local real dx0 = x - xb
			local real dy0 = y - yb
			local real dx_ext
			local real dy_ext
			local integer xsv_ext
			local integer ysv_ext
			local real value = 0
			local real dx1 = dx0 - 1. - SQUISH_CONSTANT_2D
			local real dy1 = dy0 - SQUISH_CONSTANT_2D
			local real attn1 = 2. - dx1 * dx1 - dy1 * dy1
			local real dx2 = dx0 - SQUISH_CONSTANT_2D
			local real dy2 = dy0 - 1 - SQUISH_CONSTANT_2D
			local real attn2 = 2. - dx2 * dx2 - dy2 * dy2
			local real zins
			local real attn0 
			local real attn_ext
			if attn1 > 0 then
				set attn1 = attn1 * attn1
				set value = attn1 * attn1 * extrapolate2D(xsb + 1, ysb, dx1, dy1)
			endif
			if attn2 > 0 then 
				set attn2 = attn2 * attn2
				set value = value + attn2 * attn2 * extrapolate2D(xsb, ysb + 1, dx2, dy2)
			endif
			if inSum <= 1 then 
				set zins = 1. - inSum
				if zins > xins or zins > yins then 
					if xins > yins then
						set xsv_ext = xsb + 1
						set ysv_ext = ysb - 1
						set dx_ext = dx0 - 1.
						set dy_ext = dy0 + 1.
					else
						set xsv_ext = xsb - 1
						set ysv_ext = ysb + 1
						set dx_ext = dx0 + 1.
						set dy_ext = dy0 - 1.
					endif
				else 
					set xsv_ext = xsb + 1
					set ysv_ext = ysb + 1
					set dx_ext = dx0 - 1 - SQUISH_CONSTANT_2D_X
					set dy_ext = dy0 - 1 - SQUISH_CONSTANT_2D_Y
				endif
			else 
				set zins = 2. - inSum
				if zins < xins or zins < yins then 
					if xins > yins then 
						set xsv_ext = xsb + 2
						set ysv_ext = ysb
						set dx_ext = dx0 - 2 - SQUISH_CONSTANT_2D_X
						set dy_ext = dy0 - SQUISH_CONSTANT_2D_Y
					else 
						set xsv_ext = xsb
						set ysv_ext = ysb + 2
						set dx_ext = dx0 - SQUISH_CONSTANT_2D_X
						set dy_ext = dy0 - 2 - SQUISH_CONSTANT_2D_Y
					endif
				else
					set dx_ext = dx0 
					set dy_ext = dy0
					set xsv_ext = xsb 
					set ysv_ext = ysb
				endif
				set xsb = xsb + 1
				set ysb = ysb + 1
				set dx0 = dx0 - 1 - SQUISH_CONSTANT_2D_X
				set dy0 = dy0 - 1 - SQUISH_CONSTANT_2D_Y
			endif
			set attn0 = 2 - dx0 * dx0 - dy0 * dy0
			if attn0 > 0 then 
				set attn0 = attn0 * attn0
				set value = value + attn0 * attn0 * extrapolate2D(xsb, ysb, dx0, dy0)
			endif
			set attn_ext = 2 - dx_ext * dx_ext - dy_ext * dy_ext
			if attn_ext > 0 then 
				set attn_ext = attn_ext * attn_ext
				set value = value + attn_ext * attn_ext * extrapolate2D(xsv_ext, ysv_ext, dx_ext, dy_ext)
			endif
			return value / NORM_CONSTANT_2D
		endmethod

		static method setGradientTable2D takes nothing returns nothing 
			set gradTable2DX[0] = 5
			set gradTable2DY[0] = 2
			set gradTable2DX[1] = 2
			set gradTable2DY[1] = 5
			set gradTable2DX[2] = -2
			set gradTable2DY[2] = 5
			set gradTable2DX[3] = -5
			set gradTable2DY[3] = 2
			set gradTable2DX[4] = -5
			set gradTable2DY[4] = -2
			set gradTable2DX[5] = -2
			set gradTable2DY[5] = -5
			set gradTable2DX[6] = 2
			set gradTable2DY[6] = -5
			set gradTable2DX[7] = 5
			set gradTable2DY[7] = -2
		endmethod

		// Deprecated as of 1.2.0, use Noise.initialize() instead.
		static method openSimplexInit takes nothing returns nothing 
			call BJDebugMsg("Noise.openSimplexInit(), use Noise.initialize() instead.")
			call setGradientTable2D()
		endmethod

		// Deprecated as of 1.2.0, use Noise.initialize() instead.
		static method permutationInit takes nothing returns nothing 
			call BJDebugMsg("Noise.permutationInit(), use Noise.initialize() instead.")
			call generatePermutationTable()
		endmethod

		static method generatePermutationTable takes nothing returns nothing 
			local integer i = 0
			loop
				exitwhen i > 255
				set permutation[i] = GetRandomInt(0, 255)
				set permutation[i + 256] = permutation[i]
				set i = i + 1
			endloop
		endmethod

		private static real getRandomIntEvent
		private static integer p_getRandomIntLow
		private static integer p_getRandomIntHigh
		private static integer p_getRandomIntReturn
		
		static method operator getRandomIntLow  takes nothing returns integer 
			return p_getRandomIntLow 
		endmethod

		static method operator getRandomIntHigh takes nothing returns integer 
			return p_getRandomIntHigh
		endmethod

		static method operator getRandomIntReturn= takes integer value returns nothing 
			set p_getRandomIntReturn = value
		endmethod

		static method generatePermutationTableCustom takes code GetRandomIntInterface returns nothing 
			local integer i = 0
			local trigger trig = CreateTrigger()
			call TriggerRegisterVariableEvent(trig, "s__Noise_getRandomIntEvent", EQUAL, 1)
			call TriggerAddAction(trig, GetRandomIntInterface)
			loop
				exitwhen i > 255
				set p_getRandomIntLow = 0
				set p_getRandomIntHigh = 255
				set getRandomIntEvent = 1
				set getRandomIntEvent = 0
				set permutation[i] = p_getRandomIntReturn 
				set permutation[i + 256] = permutation[i]
				set i = i + 1
			endloop
			call DestroyTrigger(trig)
		endmethod
		
		static method initialize takes nothing returns nothing
			call generatePermutationTable()
			call setGradientTable2D()
		endmethod
	endstruct
endlibrary
