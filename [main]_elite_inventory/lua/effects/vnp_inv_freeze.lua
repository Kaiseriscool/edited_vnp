
function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	local ply = data:GetEntity()
	
	local NumParticles = 4
	local emitter = ParticleEmitter( vOffset )
	
	for i = 0, NumParticles do
		local particle = emitter:Add( "particles/smokey.vtf", vOffset )
		if ( particle ) then
			particle:SetColor( 200, 200, 255 )

			particle:SetDieTime( 2 )

			particle:SetStartAlpha( math.Rand( 30, 30 ) )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( 50 )
			particle:SetEndSize( 10 )

			particle:SetRoll( math.Rand( 0, 360 ) )

			particle:SetAirResistance( 100 )

			particle:SetVelocity( ply:GetVelocity() )
			particle:SetGravity( Vector( 0, 0, 100 ) )
		end
	end

	for i = 0, NumParticles do
		local particle = emitter:Add( "particles/balloon_bit.vtf", vOffset + Vector( 0, 0, 30 ) )
		if ( particle ) then
			particle:SetColor( 200, 200, 255 )

			particle:SetDieTime( .3 )

			particle:SetStartAlpha( math.Rand( 150, 175 ) )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( math.Rand( 2, 3 ) )
			particle:SetEndSize( 1 )

			particle:SetRoll( math.Rand( 0, 360 ) )

			particle:SetAirResistance( 100 )

			particle:SetVelocity( VectorRand() * 300 + ply:GetVelocity() )
			particle:SetGravity( Vector( 0, 0, -1500 ) )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end