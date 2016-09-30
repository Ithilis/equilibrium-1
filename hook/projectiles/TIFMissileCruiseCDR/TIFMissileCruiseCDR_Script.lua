#
# Terran Land-Based Cruise Missile
#
local TMissileCruiseProjectile = import('/lua/terranprojectiles.lua').TMissileCruiseProjectile02
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

OldTIFMissileCruiseCDR = TIFMissileCruiseCDR

TIFMissileCruiseCDR = Class(OldTIFMissileCruiseCDR) {

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        TMissileCruiseProjectile.OnImpact(self, targetType, targetEntity)
        
        local pos = self:GetPosition() --create a vision bubble at impact location
        local spec = {
            X = pos[1],
            Z = pos[3],
            Radius = self.Data.Radius,
            LifeTime = self.Data.Lifetime,
            Army = self.Data.Army,
            Omni = false,
            WaterVision = false,
        }
        local vizEntity = VizMarker(spec)
        
    end,
}
TypeClass = TIFMissileCruiseCDR
