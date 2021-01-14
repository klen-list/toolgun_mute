-- by Klen_list

local function KHook_ModifyToolGun()
	local toolgun = weapons.GetStored"gmod_tool"

	if not istable(toolgun) then return end

	local tool_init = toolgun.Initialize
	function toolgun:Initialize()
		if not ConVarExists"sv_toolgun_sound" then
			CreateConVar("sv_toolgun_sound", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE})
		end
		if not ConVarExists"sv_toolgun_effects" then
			CreateConVar("sv_toolgun_effects", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE})
		end
		if not ConVarExists"cl_toolgun_sound" then
			CreateClientConVar("cl_toolgun_sound", 1)
		end
		if not ConVarExists"cl_toolgun_effects" then
			CreateClientConVar("cl_toolgun_effects", 1)
		end

		tool_init(self)
	end

	function toolgun:DoShootEffect(hitpos, hitnorm, ent, physbone, predicted)
		-- discard using gmod_drawtooleffects cvar
		local canSound_sv, canEffect_sv = GetConVar"sv_toolgun_sound":GetBool(), GetConVar"sv_toolgun_effects":GetBool()
		local canSound_cl, canEffect_cl  = GetConVar"cl_toolgun_sound":GetBool(), GetConVar"cl_toolgun_effects":GetBool()

		if canSound_sv and canSound_cl then self:EmitSound(self.ShootSound) end

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)

		if not (predicted and canEffect_sv and canEffect_cl) then return end

		local effectdata = EffectData()
			effectdata:SetOrigin(hitpos)
			effectdata:SetNormal(hitnorm)
			effectdata:SetEntity(ent)
			effectdata:SetAttachment(physbone)
		util.Effect("selection_indicator", effectdata)

		effectdata = EffectData()
			effectdata:SetOrigin(hitpos)
			effectdata:SetStart(self:GetOwner():GetShootPos())
			effectdata:SetAttachment(1)
			effectdata:SetEntity(self)
		util.Effect("ToolTracer", effectdata)
	end
	print"> Toolgun Mute loaded."
end
hook.Add("InitPostEntity", "KHook_ModifyToolGun", KHook_ModifyToolGun)