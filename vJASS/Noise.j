/*
	Perlin Noise vJASS 1.0.0

	Port by Glint
	Perlin Noise by Kenneth Perlin, https://mrl.nyu.edu/~perlin/noise/
*/

library Noise
	
	private module Init
        private static method onInit takes nothing returns nothing
			call permutationInit()
        endmethod
    endmodule

	struct Noise extends array
		readonly static string version = "1.0.0"
		static integer array permutation

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
			return a + t * (b -a)
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

		static method permutationInit takes nothing returns nothing 
			local integer i = 0
			loop
				exitwhen i > 255
				set permutation[i] = GetRandomInt(0, 255)
        			set permutation[i + 256] = permutation[i]
        			set i = i + 1
			endloop
		endmethod 
	endstruct
endlibrary