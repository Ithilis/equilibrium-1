#
# Terran Land-Based Cruise Missile
#
local TMissileCruiseProjectile = import('/lua/terranprojectiles.lua').TMissileCruiseProjectile
local Explosion = import('/lua/defaultexplosions.lua')
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

OldTIFMissileCruise04 = TIFMissileCruise04

TIFMissileCruise04 = Class(OldTIFMissileCruise04) {

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
        
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
TypeClass = TIFMissileCruise04
