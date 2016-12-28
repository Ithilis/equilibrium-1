#****************************************************************************
#**
#**  File     :  /data/projectiles/SDFLightChronatronCannon02/SDFLightChronatronCannon02_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Light Chronatron Cannon Projectile script, Seraphim sub-commander overcharge, XSL0301
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SLightChronatronCannonOverCharge = import('/lua/seraphimprojectiles.lua').SLightChronatronCannonOverCharge

SDFLightChronatronCannon02 = Class(SLightChronatronCannonOverCharge) {

    OnImpact = function(self, targetType, targetEntity)
        --dynamic overcharge damage script - sacu version - 6000 cap, 1:1 damage:energy ratio
        --the OC damage scales with energy drain in tiers for ease of use, with a minimum drain of 1000
        if targetType == 'Unit' or targetType == 'Shield' then
            
            local targetHealth = targetEntity:GetHealth() -- our target health, unit or shield
                
            if targetType == 'Unit' and targetEntity.MyShield then --if we have a personal shield we need to add its hp on. doesnt apply to bubble shields
                -- WARN('shield hp: ' .. targetEntity.MyShield:GetHealth())
                targetHealth = targetHealth + targetEntity.MyShield:GetHealth()
            end
            
            --the damage scales so that it doesnt overkill the target and waste energy, and it always spends enough to kill it, or try.
            --armoured units need that taken into account, and shields need to work out their owner's armour.
            local armType = 1 --1 for units, 0.15 for structures, 0.1 for acu
            
            if targetType == 'Shield' and targetEntity.Owner then
                --WARN('shield armour mult: ' .. targetEntity.Owner:GetArmorMult('Overcharge'))
                armType = targetEntity.Owner:GetArmorMult('Overcharge')
            elseif targetType == 'Unit' then
                --WARN('unit armour mult: ' .. targetEntity:GetArmorMult('Overcharge'))
                armType = targetEntity:GetArmorMult('Overcharge')
            else
                WARN('Equilibrium - somethings gone wrong with working out the armour! Assuming no armour.')
            end
            
            --apply our buffs - we use a function to work out how much hp it has and how much damage to do.
            self.DamageData.DamageAmount = self:CalcDamage(armType, targetHealth)
            
            --logging
            
            -- WARN('target total current hp: ' .. targetHealth)
            -- WARN(repr(targetEntity))
        end
        
        SLightChronatronCannonOverCharge.OnImpact(self, targetType, targetEntity)
    end,
    
    CalcDamage = function(self, armourType, Health)
        
        local energyStored = self:GetLauncher():GetAIBrain():GetEconomyStored('ENERGY')
        local chargesAvailable = math.floor(energyStored/1000)
        --each charge is 1000 energy and adds damage
    
        --to enable the OC ui to work the first 2000 is drained on the weapon on fire, the rest is decided on impact.
        
        --each charge adds 1000 damage, and we dont want to overkill our target and waste energy
        
        local chargesNeeded = math.ceil(Health/(1000*armourType))
        
        --buildings + ACUs need a special exception to the damage calculation since they have armour.
        
        --This is already after the initial 1000 has been drained from the weapon so we start from 0 and not 1
        local chargesUsed = math.min(chargesNeeded, chargesAvailable + 1)
        
        --cap our damage at 6000 for sacu, so you cant own exps super easy.
        chargesUsed = math.min(chargesUsed, 6)
        
        local energyNeeded = math.max((chargesUsed)*1000 - 1000, 0) --we subtract the initial charge from the cost, math.max incase it aims for dead unit
        
        --drain the energy
        CreateEconomyEvent(self:GetLauncher(), energyNeeded, 0, 0.1)
        
        --apply our buffs
        local damage = 1000*chargesUsed
        --acus take 10x less damage so 100 per charge
        --buildings take 6.67x less damage so 150 per charge
        
        
        --logging - remember that we have one free charge to use from the weapon drain.
        -- WARN('charges needed for target: ' .. chargesNeeded)
        -- WARN('charges available: ' .. chargesAvailable)
        -- WARN('charges used: ' .. chargesUsed)
        -- WARN('energy drained: ' .. energyNeeded)
        
        return damage
    end
    
}
TypeClass = SDFLightChronatronCannon02