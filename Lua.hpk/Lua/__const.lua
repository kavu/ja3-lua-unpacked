DefineConst({
  Comment = "AP cost for climbing a one-tile height.",
  group = "Action Point Costs",
  id = "Climb1",
  scale = "AP",
  value = 1500
})
DefineConst({
  Comment = "AP cost for climbing a one-tile height.",
  group = "Action Point Costs",
  id = "Climb2",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "AP cost for climbing a one-tile height.",
  group = "Action Point Costs",
  id = "Climb3",
  scale = "AP",
  value = 4000
})
DefineConst({
  Comment = "AP cost for climbing a four-tile (1 floor) height.",
  group = "Action Point Costs",
  id = "Climb4",
  scale = "AP",
  value = 4000
})
DefineConst({
  Comment = "AP modifier for moving while crouching.",
  group = "Action Point Costs",
  id = "CrouchModifier",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "Action moves extra cost in exploration mode in extra tiles. Currently applies to Climb1, Climb2, Drop1, Drop2, JumpAcross1, JumpAcross2.",
  group = "Action Point Costs",
  id = "CustomInteractableInteractionCost",
  scale = 1000,
  value = 4000
})
DefineConst({
  Comment = "AP modifier for moving in difficult terrain (allow water).",
  group = "Action Point Costs",
  id = "DifficultTerrainModifier",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "AP cost for dropping from a one-tile height.",
  group = "Action Point Costs",
  id = "Drop1",
  scale = "AP",
  value = 1500
})
DefineConst({
  Comment = "AP cost for dropping from a two-tile height.",
  group = "Action Point Costs",
  id = "Drop2",
  scale = "AP",
  value = 2000
})
DefineConst({
  Comment = "AP cost for dropping from a three-tile height.",
  group = "Action Point Costs",
  id = "Drop3",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "AP cost for dropping from a four-tile (1 floor) height.",
  group = "Action Point Costs",
  id = "Drop4",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "Base AP cost to equip an item in combat",
  group = "Action Point Costs",
  id = "EquipItem",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "Action moves extra cost in exploration mo in extra tiles. Currently applies to windows, JumpOver1, JumpOver2, Climb3, Climb4, Drop3, Drop4",
  group = "Action Point Costs",
  id = "ExplorationActionMovesModifierStrong",
  value = 12
})
DefineConst({
  Comment = "Action moves extra cost in exploration mode in extra tiles. Currently applies to Climb1, Climb2, Drop1, Drop2, JumpAcross1, JumpAcross2.",
  group = "Action Point Costs",
  id = "ExplorationActionMovesModifierWeak",
  value = 4
})
DefineConst({
  Comment = "Base AP cost to give an item to another merc when in combat",
  group = "Action Point Costs",
  id = "GiveItem",
  scale = "AP",
  value = 2000
})
DefineConst({
  Comment = "Default AP for any interaction (predefined for specific interactions that take longer or shorter time).",
  group = "Action Point Costs",
  id = "Interact",
  scale = "AP",
  value = 2000
})
DefineConst({
  Comment = "AP cost for jumping across a single tile.",
  group = "Action Point Costs",
  id = "JumpAcross1",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "AP cost for jumping across two tiles.",
  group = "Action Point Costs",
  id = "JumpAcross2",
  scale = "AP",
  value = 4000
})
DefineConst({
  Comment = "AP cost for jumping over a low fence between two tiles.",
  group = "Action Point Costs",
  id = "JumpOver1",
  scale = "AP",
  value = 2000
})
DefineConst({
  Comment = "AP cost for jumping over a tile with an obstacle.",
  group = "Action Point Costs",
  id = "JumpOver2",
  scale = "AP",
  value = 3000
})
DefineConst({
  Comment = "AP required to climb a step (1 voxel) of a vertical ladder",
  group = "Action Point Costs",
  id = "LadderStep",
  scale = "AP",
  value = 500
})
DefineConst({
  Comment = "Base AP cost to pick an item from container when in combat",
  group = "Action Point Costs",
  id = "PickItem",
  scale = "AP",
  value = 1000
})
DefineConst({
  Comment = "AP modifier for moving while prone.",
  group = "Action Point Costs",
  id = "ProneModifier",
  scale = "%",
  value = 100
})
DefineConst({
  Comment = "AP modifier for moving on stairs (up or down).",
  group = "Action Point Costs",
  id = "StairsModifier",
  scale = "%",
  value = 20
})
DefineConst({
  Comment = "Base AP cost to unload ammo in combat",
  group = "Action Point Costs",
  id = "UnloadAmmo",
  scale = "AP",
  value = 0
})
DefineConst({
  Comment = "Base AP cost for walking a single tile distance.",
  group = "Action Point Costs",
  id = "Walk",
  scale = "AP",
  value = 1000
})
DefineConst({
  group = "Action Point Costs",
  id = "WaterMoveSpeedModifier",
  scale = "%",
  value = -25
})
DefineConst({
  Comment = "How much units to repopulate in wave 1/3 after the conflict is over",
  group = "AmbientLife",
  id = "ConflictAftermathRepopulateWave1",
  scale = "%",
  value = 40
})
DefineConst({
  Comment = "How much units to repopulate in wave 2/3 after the conflict is over",
  group = "AmbientLife",
  id = "ConflictAftermathRepopulateWave2",
  scale = "%",
  value = 20
})
DefineConst({
  Comment = "Wave duration",
  group = "AmbientLife",
  id = "ConflictAftermathRepopulateWaveDuration",
  scale = "sec",
  value = 10000
})
DefineConst({
  Comment = "Interval between 3 waves for re-population after conflict",
  group = "AmbientLife",
  id = "ConflictAftermathWavesInterval",
  scale = "sec",
  value = 45000
})
DefineConst({
  Comment = "During conflict Ambient Life is reduced that much",
  group = "AmbientLife",
  id = "ConflictReduction",
  scale = "%",
  value = 30
})
DefineConst({
  Comment = "Angle distance to run from threat while running in Cower command",
  group = "AmbientLife",
  id = "CowerPropagateRadius",
  scale = "m",
  value = 20000
})
DefineConst({
  Comment = "Angle span to avoid(thread direction) while running in Cower command",
  group = "AmbientLife",
  id = "CowerRunAngleSpanAvoid",
  scale = "deg",
  value = 3600
})
DefineConst({
  Comment = "Chance to occasionally change the cower spot(AL_Cower markers and low covers)",
  group = "AmbientLife",
  id = "CowerRunCooldownTime",
  scale = "sec",
  value = 7000
})
DefineConst({
  Comment = "Angle distance to run from threat while running in Cower command",
  group = "AmbientLife",
  id = "CowerRunDist",
  scale = "m",
  value = 7000
})
DefineConst({
  Comment = "Chance to occasionally change the cower spot(AL_Cower markers and low covers)",
  group = "AmbientLife",
  id = "CowerSpotChangeChance",
  scale = "%",
  value = 10
})
DefineConst({
  Comment = "Chance to occasionally change the cower spot(AL_Cower markers and low covers)",
  group = "AmbientLife",
  id = "CowerTimeoutMax",
  scale = "sec",
  value = 30000
})
DefineConst({
  Comment = "Chance to occasionally change the cower spot(AL_Cower markers and low covers)",
  group = "AmbientLife",
  id = "CowerTimeoutMin",
  scale = "sec",
  value = 20000
})
DefineConst({
  Comment = "If player around this distance the enemy AL won't use chairs to sit(coming close will also interrupt this behavior normally)",
  group = "AmbientLife",
  id = "ForbidSitChairEnemyDist",
  scale = "m",
  value = 5000
})
DefineConst({
  Comment = "If player around this distance the enemy AL won't use walls to lean on(coming close will also interrupt this behavior normally)",
  group = "AmbientLife",
  id = "ForbidWallLeanEnemyDist",
  scale = "m",
  value = 5000
})
DefineConst({
  group = "AmbientLife",
  id = "MaraudVisitMax",
  scale = "sec",
  value = 30000
})
DefineConst({
  group = "AmbientLife",
  id = "MaraudVisitMin",
  scale = "sec",
  value = 20000
})
DefineConst({
  group = "AmbientLife",
  id = "MournVisitMax",
  scale = "sec",
  value = 70000
})
DefineConst({
  group = "AmbientLife",
  id = "MournVisitMin",
  scale = "sec",
  value = 45000
})
DefineConst({
  Comment = "Maximum range to search for dead bodies to mourn",
  group = "AmbientLife",
  id = "MournerRange",
  scale = "m",
  value = 10000
})
DefineConst({
  Comment = "Maximum mourners assigned to a dead body",
  group = "AmbientLife",
  id = "MournersMax",
  value = 2
})
DefineConst({
  Comment = "Chance of executing regular Roam instead of Visit - this includes both random spots and AL_Roam markers",
  group = "AmbientLife",
  id = "RoamChance",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "Number of tries picking random point for next Roam spot to choose the one best preserving current orientation of walking",
  group = "AmbientLife",
  id = "RoamKeepDirTries",
  value = 10
})
DefineConst({
  Comment = "Chance to skip the actual play of the roam animation on reaching the roam spot(actually [roam animation + idle animation])",
  group = "AmbientLife",
  id = "RoamSkipAnimChance",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "How much satellite time is needed for the ambient life to re-spawn",
  group = "AmbientLife",
  id = "SatelliteTimeout",
  scale = "h",
  value = 36000
})
DefineConst({
  Comment = "Next visitable must be further than this range",
  group = "AmbientLife",
  id = "VisitIgnoreRange",
  scale = "m",
  value = 4000
})
DefineConst({
  Comment = "Defines the stop animation depending on how close we are to the previous step moment or the next one.",
  group = "AmbientLife",
  id = "WalkStopMomentProximity",
  scale = "%",
  value = 67
})
DefineConst({
  Comment = "Blending time when rotating on spot",
  group = "Animation",
  id = "BlendTimeRotateOnSpot",
  value = 40
})
DefineConst({
  Comment = "Random mod applied to the attacking side rolled from -<value>% to +<value>%",
  group = "AutoResolve",
  id = "AttackerRandomMod",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "This amount is multiplied by the unit's level to get its unmodified power.",
  group = "AutoResolve",
  id = "BaseEnemyPower",
  value = 100
})
DefineConst({
  Comment = "This amount is multiplied by the unit's level to get its unmodified power.",
  group = "AutoResolve",
  id = "BaseMercPower",
  value = 200
})
DefineConst({
  Comment = "This amount is multiplied by the unit's level to get its unmodified power.",
  group = "AutoResolve",
  id = "BaseMilitiaPower",
  value = 150
})
DefineConst({
  Comment = "% mod when you have more than 1 adequate Medics.",
  group = "AutoResolve",
  id = "EnoughMedicsMod",
  scale = "%",
  value = 5
})
DefineConst({
  Comment = "Percent. If the unit is Exhausted.",
  group = "AutoResolve",
  id = "ExhaustedMod",
  scale = "%",
  value = -40
})
DefineConst({
  Comment = "Maximum +% mod per armor piece. Reduced in direct proportion to the item's cost.",
  group = "AutoResolve",
  id = "MaxArmorMod",
  scale = "%",
  value = 15
})
DefineConst({
  Comment = "$ Cost of the item at which you receive the <MaxArmorMod>. ",
  group = "AutoResolve",
  id = "MaxArmorModCost",
  value = 1700
})
DefineConst({
  Comment = "Maximum +% mod from the best leader at 100 Leadership.",
  group = "AutoResolve",
  id = "MaxLeaderMod",
  scale = "%",
  value = 20
})
DefineConst({
  Comment = "Maximum +% mod from the best weapon. Reduced in direct proportion to the item's cost.",
  group = "AutoResolve",
  id = "MaxWeaponMod",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "$ Cost of the item at which you receive the <MaxWeaponMod>. ",
  group = "AutoResolve",
  id = "MaxWeaponModCost",
  value = 1700
})
DefineConst({
  Comment = "Required combined Strength + Dexterity to use Melee in Auto Resolve.",
  group = "AutoResolve",
  id = "MeleeRequiredStats",
  value = 120
})
DefineConst({
  Comment = "Min Leadership to start receiving the Leader mod.",
  group = "AutoResolve",
  id = "MinLeadershipRequired",
  value = 50
})
DefineConst({
  Comment = "Min Medical to count a unit as an adequate Medic.",
  group = "AutoResolve",
  id = "MinMedicalRequired",
  value = 50
})
DefineConst({
  Comment = "% mod when you have more than 1 adequate Medics.",
  group = "AutoResolve",
  id = "NoMedicsMod",
  scale = "%",
  value = -20
})
DefineConst({
  Comment = "Add or subtract % mod from the player's power if the player has numerical advantage or disadvantage (double the units).",
  group = "AutoResolve",
  id = "NumericalAdvantageMod",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "Additional +% when the unit has and is allowed to use Ordnance/Grenades.",
  group = "AutoResolve",
  id = "OrdnanceMod",
  scale = "%",
  value = 15
})
DefineConst({
  Comment = "Percent. If the unit is Tired.",
  group = "AutoResolve",
  id = "TiredMod",
  scale = "%",
  value = -20
})
DefineConst({
  Comment = "Percent. If the unit is Well Rested.",
  group = "AutoResolve",
  id = "WellRestedMod",
  scale = "%",
  value = 10
})
DefineConst({
  group = "AutoResolveDamage",
  id = "CrushingDefeatInjuryChance",
  scale = "%",
  value = 100
})
DefineConst({
  group = "AutoResolveDamage",
  id = "CrushingDefeatSeriousInjuryChance",
  scale = "%",
  value = 66
})
DefineConst({
  group = "AutoResolveDamage",
  id = "DecisiveWinInjuryChance",
  scale = "%",
  value = 25
})
DefineConst({
  group = "AutoResolveDamage",
  id = "DecisiveWinSeriousInjuryChance",
  scale = "%",
  value = 0
})
DefineConst({
  group = "AutoResolveDamage",
  id = "DefeatInjuryChance",
  scale = "%",
  value = 100
})
DefineConst({
  group = "AutoResolveDamage",
  id = "DefeatSeriousInjuryChance",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "Base damage if the unit was injured.",
  group = "AutoResolveDamage",
  id = "InjuryBaseDamage",
  value = 20
})
DefineConst({
  Comment = "Additional damage if the unit was injured. Rolled from 0 to <value>.",
  group = "AutoResolveDamage",
  id = "InjuryRandomDamage",
  value = 30
})
DefineConst({
  Comment = "+% mod for the Militia to take extra damage.",
  group = "AutoResolveDamage",
  id = "MilitiaDamageTakenMod",
  scale = "%",
  value = 0
})
DefineConst({
  Comment = "+% mod for the Militia to take extra damage.",
  group = "AutoResolveDamage",
  id = "MilitiaInjuryAdditiveMod",
  scale = "%",
  value = 0
})
DefineConst({
  Comment = "Death chance for enemies and militia to be used on Decisive Win for their side (for attrition).",
  group = "AutoResolveDamage",
  id = "NPCDeathChanceOnDecisiveWin",
  scale = "%",
  value = 15
})
DefineConst({
  Comment = "Death chance for enemies and militia to be used on Win for their side (for attrition).",
  group = "AutoResolveDamage",
  id = "NPCDeathChanceOnWin",
  scale = "%",
  value = 22
})
DefineConst({
  Comment = "Base damage if the unit was seriously injured.",
  group = "AutoResolveDamage",
  id = "SeriousInjuryBaseDamage",
  value = 30
})
DefineConst({
  Comment = "Additional damage if the unit was seriously injured. Rolled from 0 to <value>. TWICE.",
  group = "AutoResolveDamage",
  id = "SeriousInjuryRandomDamage",
  value = 41
})
DefineConst({
  group = "AutoResolveDamage",
  id = "WinInjuryChance",
  scale = "%",
  value = 40
})
DefineConst({
  group = "AutoResolveDamage",
  id = "WinSeriousInjuryChance",
  scale = "%",
  value = 10
})
DefineConst({
  Comment = "How many times to apply armor degradation on Injury",
  group = "AutoResolveResources",
  id = "ArmorDegradationTimesInjury",
  value = 1
})
DefineConst({
  Comment = "How many times to apply armor degradation on Serious Injury",
  group = "AutoResolveResources",
  id = "ArmorDegradationTimesSeriousInjury",
  value = 3
})
DefineConst({
  Comment = "Use 1 ammo for each X damage dealt.",
  group = "AutoResolveResources",
  id = "DamageToAmmo",
  value = 25
})
DefineConst({
  Comment = "When \"Use Ordnance\" is enabled.",
  group = "AutoResolveResources",
  id = "MaxOrdnanceUsed",
  value = 3
})
DefineConst({
  group = "BaseDropChance",
  id = "Ammo",
  value = 7
})
DefineConst({
  group = "BaseDropChance",
  id = "Armor",
  value = 4
})
DefineConst({
  group = "BaseDropChance",
  id = "ConditionAndRepair",
  value = 30
})
DefineConst({
  group = "BaseDropChance",
  id = "Firearm",
  value = 12
})
DefineConst({
  group = "BaseDropChance",
  id = "Grenade",
  value = 5
})
DefineConst({
  group = "BaseDropChance",
  id = "HeavyWeapon",
  value = 12
})
DefineConst({
  group = "BaseDropChance",
  id = "Medicine",
  value = 100
})
DefineConst({
  group = "BaseDropChance",
  id = "MeleeWeapon",
  value = 12
})
DefineConst({
  group = "BaseDropChance",
  id = "Ordnance",
  value = 50
})
DefineConst({
  group = "BaseDropChance",
  id = "QuestItem",
  value = 100
})
DefineConst({
  group = "BaseDropChance",
  id = "QuickSlotItem",
  value = 50
})
DefineConst({
  group = "BaseDropChance",
  id = "ResourceItem",
  value = 30
})
DefineConst({
  group = "BaseDropChance",
  id = "ToolItem",
  value = 15
})
DefineConst({
  group = "BaseDropChance",
  id = "Valuables",
  value = 100
})
DefineConst({
  Comment = "x,y of the crosshair box that will be checked for moving the camera if it doesn't fit on screen",
  group = "Camera",
  id = "CrosshairPaddingX",
  value = 1100
})
DefineConst({
  Comment = "x,y of the crosshair box that will be checked for moving the camera if it doesn't fit on screen",
  group = "Camera",
  id = "CrosshairPaddingY",
  value = 550
})
DefineConst({
  Comment = "Time to hold the action camera after shots have been fired.",
  group = "Combat",
  id = "ActionCameraHoldTime",
  scale = "sec",
  value = 200
})
DefineConst({
  Comment = "bonus crit chance per aim step",
  group = "Combat",
  id = "AimCritBonus",
  scale = "%",
  value = 0
})
DefineConst({
  Comment = "percentage of Degradation applied to the armor when the attack does not penetrate the armor",
  group = "Combat",
  id = "ArmorDegradePercent",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "bonus damage from Strength",
  group = "Combat",
  id = "AutofireAttribBonus",
  scale = "%",
  value = 0
})
DefineConst({
  Comment = "Sight radius (in tiles) for units aware of the target unit",
  group = "Combat",
  id = "AwareSightRange",
  value = 24
})
DefineConst({
  Comment = "Time to hold the camera at the initializer of the bombard.",
  group = "Combat",
  id = "BombardSetupHoldTime",
  scale = "sec",
  value = 1000
})
DefineConst({
  Comment = "bonus damage from Marksmanship",
  group = "Combat",
  id = "BuckshotAttribBonus",
  scale = "%",
  value = 50
})
DefineConst({
  group = "Combat",
  id = "BulletDelay",
  scale = "sec",
  value = 40
})
DefineConst({
  group = "Combat",
  id = "BulletVelocity",
  scale = "m",
  value = 40000
})
DefineConst({
  group = "Combat",
  id = "CamoAimPenalty",
  scale = "%",
  value = 50
})
DefineConst({
  group = "Combat",
  id = "CamoSightPenalty",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "minimum angle between the attacker, the attack position and the target to perform a Charge attack",
  group = "Combat",
  id = "ChargeMinAngle",
  scale = "deg",
  value = 9000
})
DefineConst({
  group = "Combat",
  id = "ChargeMinDistance",
  scale = "m",
  value = 2400
})
DefineConst({
  group = "Combat",
  id = "CombatPathTurnsAhead",
  value = 0
})
DefineConst({
  group = "Combat",
  id = "ConditionPenaltyNeedsRepair",
  scale = "%",
  value = 10
})
DefineConst({
  group = "Combat",
  id = "ConditionPenaltyPoor",
  scale = "%",
  value = 20
})
DefineConst({
  Comment = "(consecutive attack) Delay before action is executed. But it will start counting before the camera reaches the target.",
  group = "Combat",
  id = "ConsecutiveShootDelay",
  value = 100
})
DefineConst({
  Comment = "(consecutive attack) Delay after aiming anim, before moving camera to target.",
  group = "Combat",
  id = "ConsecutiveShootDelayAfterAim",
  value = 100
})
DefineConst({
  group = "Combat",
  id = "DeathExplosion_AnimationDelay",
  value = 150
})
DefineConst({
  group = "Combat",
  id = "DeathNoiseRange",
  value = 8
})
DefineConst({
  Comment = "missed shots will result in playing dodge animation when fired from closer than this range",
  group = "Combat",
  id = "DodgeMaxDist",
  scale = "m",
  value = 4000
})
DefineConst({
  Comment = "10 sec enemy vr cd to prevent too much spam",
  group = "Combat",
  id = "EnemyVrGlobalCd",
  value = 10000
})
DefineConst({
  group = "Combat",
  id = "ExplosionCrouchDamageMod",
  scale = "%",
  value = -30
})
DefineConst({
  group = "Combat",
  id = "ExplosionProneDamageMod",
  scale = "%",
  value = -60
})
DefineConst({
  Comment = "Footsteps attack color",
  group = "Combat",
  id = "FootstepsAttackColor",
  scale = "sec",
  type = "color",
  value = 4278203993
})
DefineConst({
  Comment = "Footsteps color",
  group = "Combat",
  id = "FootstepsColor",
  scale = "sec",
  type = "color",
  value = 4283255108
})
DefineConst({
  Comment = "Footsteps overwatch color",
  group = "Combat",
  id = "FootstepsOverwatchColor",
  scale = "sec",
  type = "color",
  value = 4284876048
})
DefineConst({
  group = "Combat",
  id = "GloryKillChance",
  scale = "%",
  value = 10
})
DefineConst({
  group = "Combat",
  id = "Gravity",
  scale = "m",
  value = 9807
})
DefineConst({
  Comment = "max damage reduction from cover",
  group = "Combat",
  id = "GrazingChanceInCover",
  scale = "%",
  value = 40
})
DefineConst({
  group = "Combat",
  id = "GrazingHitDamage",
  scale = "%",
  value = 33
})
DefineConst({
  group = "Combat",
  id = "GrenadeLaunchAngle",
  scale = "deg",
  value = 1800
})
DefineConst({
  Comment = "launch angle to use when throwing at a higher position",
  group = "Combat",
  id = "GrenadeLaunchAngle_Incline",
  scale = "deg",
  value = 3600
})
DefineConst({
  group = "Combat",
  id = "GrenadeLaunchAngle_Low",
  scale = "deg",
  value = 900
})
DefineConst({
  group = "Combat",
  id = "GrenadeMaxRPM",
  value = 75
})
DefineConst({
  group = "Combat",
  id = "GrenadeMinDamageForFly",
  value = 30
})
DefineConst({
  group = "Combat",
  id = "GrenadeMinRPM",
  value = 25
})
DefineConst({
  group = "Combat",
  id = "GrenadeStatBonus",
  value = 30
})
DefineConst({
  Comment = "modifier (additive) to Lethal Attack chance",
  group = "Combat",
  id = "HeadshotStealthKillChanceMod",
  scale = "%",
  value = 10
})
DefineConst({
  group = "Combat",
  id = "HealAmountBase",
  value = 20
})
DefineConst({
  Comment = "Maximum health points that any unit can have",
  group = "Combat",
  id = "HealthPointsCap",
  value = 100
})
DefineConst({
  group = "Combat",
  id = "IdleVariantMaxTime",
  scale = "sec",
  value = 20000
})
DefineConst({
  group = "Combat",
  id = "IdleVariantMinTime",
  scale = "sec",
  value = 5000
})
DefineConst({
  Comment = "The maximum distance, in voxels, units can interact with objects.",
  group = "Combat",
  id = "InteractionMaxHeightDifference",
  scale = "m",
  value = 1000
})
DefineConst({
  Comment = "how often move action provokes opportunity attacks",
  group = "Combat",
  id = "InterruptMoveTiles",
  value = 3
})
DefineConst({
  Comment = "defines the loss of speed from bounces for thrown knives",
  group = "Combat",
  id = "KnifeBounceVelocityLoss",
  scale = "%",
  value = 50
})
DefineConst({
  group = "Combat",
  id = "KnifeMaxRPM",
  value = 90
})
DefineConst({
  group = "Combat",
  id = "KnifeMinRPM",
  value = 60
})
DefineConst({
  Comment = "defines the movement speed of the thrown knife as well as the parabolic part of the trajectory (if there's one); units are [m/s]",
  group = "Combat",
  id = "KnifeThrowVelocity",
  scale = "m",
  value = 14000
})
DefineConst({
  Comment = "Leadership Threshold for a unit to be able to perform tactical situation vr",
  group = "Combat",
  id = "LeadershipThresholdVR",
  value = 50
})
DefineConst({
  group = "Combat",
  id = "LieutenantHpMod",
  scale = "%",
  value = 125
})
DefineConst({
  Comment = "bonus out-of-turn interrupt attacks with machine guns at 0 ap",
  group = "Combat",
  id = "MGFreeInterruptAttacks",
  value = 1
})
DefineConst({
  Comment = "Grit(TempHitPoints) stacks up to this amount.",
  group = "Combat",
  id = "MaxGrit",
  value = 30
})
DefineConst({
  group = "Combat",
  id = "MedsPerUse",
  value = 1
})
DefineConst({
  Comment = "extra damage to Prone targets",
  group = "Combat",
  id = "MeleeAttackProneMod",
  scale = "%",
  value = 20
})
DefineConst({
  Comment = "m/s",
  group = "Combat",
  id = "MortarFallVelocity",
  scale = "m",
  value = 30000
})
DefineConst({
  Comment = "radius (in tiles) which will trigger relocation if a combatant approaches",
  group = "Combat",
  id = "NeutralUnitFearRadius",
  value = 5
})
DefineConst({
  Comment = "AP the neutral units use for relocation when feared",
  group = "Combat",
  id = "NeutralUnitRelocateAP",
  scale = "AP",
  value = 12000
})
DefineConst({
  group = "Combat",
  id = "ObstructedAreaAttackDamageReduction",
  scale = "%",
  value = 30
})
DefineConst({
  group = "Combat",
  id = "PainNoiseRange",
  value = 6
})
DefineConst({
  group = "Combat",
  id = "PainNoiseRangeStealthKill",
  value = 3
})
DefineConst({
  group = "Combat",
  id = "RepositionAPPercent",
  scale = "%",
  value = 70
})
DefineConst({
  Comment = "m/s",
  group = "Combat",
  id = "RocketVelocity",
  scale = "m",
  value = 20000
})
DefineConst({
  Comment = "Efficiency of Bandage action when applied to the same unit.",
  group = "Combat",
  id = "SelfBandagePercent",
  scale = "%",
  value = 70
})
DefineConst({
  Comment = "Delay before action is executed. But it will start counting before the camera reaches the target.",
  group = "Combat",
  id = "ShootDelay",
  value = 1300
})
DefineConst({
  Comment = "Delay after aiming anim, before moving camera to target.",
  group = "Combat",
  id = "ShootDelayAfterAim",
  value = 700
})
DefineConst({
  Comment = "Delay after aiming anim, before moving camera to target.",
  group = "Combat",
  id = "ShootDelayAfterAimCinematic",
  value = 500
})
DefineConst({
  group = "Combat",
  id = "ShootDelayAfterInterrupt",
  value = 1000
})
DefineConst({
  Comment = "Delay before action is executed. But it will start counting before the camera reaches the target.",
  group = "Combat",
  id = "ShootDelayCinematic",
  value = 500
})
DefineConst({
  group = "Combat",
  id = "ShootDelayNonAI",
  value = 1000
})
DefineConst({
  Comment = "Delay before action is executed. But it will start counting before the camera reaches the target. But if the target is on screen and there is no camera movement, then this delay doesn't need to be long.",
  group = "Combat",
  id = "ShootDelayTargetOnScreen",
  value = 700
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing hidden units in prone stance",
  group = "Combat",
  id = "SightModHiddenProne",
  value = 10
})
DefineConst({
  Comment = "maximum value for the sight modifier",
  group = "Combat",
  id = "SightModMaxValue",
  value = 120
})
DefineConst({
  Comment = "minimum value for the sight modifier",
  group = "Combat",
  id = "SightModMinValue",
  value = 40
})
DefineConst({
  Comment = "what percentage of the stat difference (Agility - Wisdom) is applied as a sight modifier to units trying to see a Hidden unit",
  group = "Combat",
  id = "SightModStealthStatDiff",
  scale = "%",
  value = 50
})
DefineConst({
  group = "Combat",
  id = "SignatureAbilityRechargeTime",
  scale = "h",
  value = 7200
})
DefineConst({
  Comment = "how many seconds are the timers reduced on each of player's turns",
  group = "Combat",
  id = "TimerTurnTime",
  scale = "sec",
  value = 10000
})
DefineConst({
  Comment = "Sight radius (in tiles) of units who are not aware of the target unit (either Unaware or target is Hidden)",
  group = "Combat",
  id = "UnawareSightRange",
  value = 12
})
DefineConst({
  Comment = "how many milliseconds to wait after a unit dies (when a cinematic camera is in play)",
  group = "Combat",
  id = "UnitDeathKillcamWait",
  value = 1000
})
DefineConst({
  Comment = "how many milliseconds to wait after a unit dies",
  group = "Combat",
  id = "UnitDeathWait",
  value = 0
})
DefineConst({
  Comment = "money",
  group = "CombatTask",
  id = "BonusReward",
  value = 2000
})
DefineConst({
  group = "CombatTask",
  id = "ChanceToGive",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "Give bonus on every X completed task",
  group = "CombatTask",
  id = "CompletedForBonus",
  value = 5
})
DefineConst({
  Comment = "to select favoured task",
  group = "CombatTask",
  id = "FavouredChance",
  scale = "%",
  value = 75
})
DefineConst({
  group = "CombatTask",
  id = "MercCooldown",
  scale = "day",
  value = 172800
})
DefineConst({
  Comment = "present on map to give Combat Tasks",
  group = "CombatTask",
  id = "RequiredEnemies",
  value = 5
})
DefineConst({
  group = "CombatTask",
  id = "SectorCooldown",
  scale = "day",
  value = 86400
})
DefineConst({
  Comment = "Cost of unlocking A.I.M. Gold",
  id = "AIMGoldCost",
  value = 20000
})
DefineConst({
  id = "AreaLootSize",
  value = 10
})
DefineConst({
  Comment = "The time taken between banter lines",
  id = "BanterBetweenLineTime",
  value = 500
})
DefineConst({
  Comment = "The distance (in slabs) for the unit to be able to perform VR",
  id = "BanterSlabDistance",
  value = 20
})
DefineConst({
  id = "BoredBanterCD",
  value = 4
})
DefineConst({
  id = "BoredBanterMinHiredSince",
  value = 4
})
DefineConst({
  Comment = "The time for frase rollover to stay visible",
  id = "ConversationPhraseRolloverTime",
  value = 3000
})
DefineConst({
  id = "DefaultTimeFactor",
  value = 1100
})
DefineConst({
  id = "EmailWaitTime",
  value = 5000
})
DefineConst({
  Comment = "The metric is in tiles.",
  id = "ExamineMarkerInteractionDistance",
  value = 3
})
DefineConst({
  id = "ExplorationFollowDelay",
  value = 600
})
DefineConst({
  id = "ExplorationUnawareStopDist",
  scale = "m",
  value = 2400
})
DefineConst({
  id = "GlobalMercBanterCooldown",
  scale = "h",
  value = 3600
})
DefineConst({
  id = "GlobalVoiceResponseCooldown",
  value = 200
})
DefineConst({
  Comment = "The metric is in tiles.",
  id = "GotoTurnOnPlaceAngle",
  scale = "deg",
  value = 7200
})
DefineConst({
  Comment = "The metric is in tiles.",
  id = "GotoTurnOnPlaceMovingAngle",
  scale = "deg",
  value = 7200
})
DefineConst({
  Comment = "The metric is in tiles.",
  id = "HerbMarkerInteractionDistance",
  value = 4
})
DefineConst({
  id = "InventoryGiveDistance",
  scale = "voxelSizeX",
  value = 24000
})
DefineConst({
  Comment = "Medicine Refill to Salvage meds cost factor",
  id = "MedicineRefillToSalvageFactor",
  value = 200
})
DefineConst({
  Comment = "In millisec, the time to display new quest notes in the corner menu before hiding them.",
  id = "NewQuestShowTime",
  value = 7000
})
DefineConst({
  id = "RequiredPerksForGold",
  value = 3
})
DefineConst({
  id = "RequiredPerksForSilver",
  value = 1
})
DefineConst({
  Comment = "The metric is in tiles.",
  id = "SalvageMarkerInteractionDistance",
  value = 6
})
DefineConst({
  id = "WindStrongSwayChance",
  scale = "%",
  value = 80
})
DefineConst({
  id = "WindWeakSwayChance",
  scale = "%",
  value = 30
})
DefineConst({
  id = "XPQuestReward_Large",
  value = 1000
})
DefineConst({
  id = "XPQuestReward_Medium",
  value = 500
})
DefineConst({
  id = "XPQuestReward_Minor",
  value = 150
})
DefineConst({
  id = "XPQuestReward_Small",
  value = 300
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing units in tall grass or brush",
  group = "EnvEffects",
  id = "BrushSightMod",
  scale = "%",
  value = -15
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing units in dark or difficult to see locations",
  group = "EnvEffects",
  id = "DarknessCTHPenalty",
  scale = "%",
  value = -20
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing units in dark or difficult to see locations",
  group = "EnvEffects",
  id = "DarknessDetectionRate",
  scale = "%",
  value = -30
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing units in dark or difficult to see locations",
  group = "EnvEffects",
  id = "DarknessSightMod",
  scale = "%",
  value = -10
})
DefineConst({
  Comment = "chance to hit modifier in fog",
  group = "EnvEffects",
  id = "DustStormCoverCTHPenalty",
  scale = "%",
  value = -5
})
DefineConst({
  Comment = "sight modifier in fog",
  group = "EnvEffects",
  id = "DustStormGrazeChance",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "move cost modifier in duststorm",
  group = "EnvEffects",
  id = "DustStormMoveCostMod",
  scale = "%",
  value = 30
})
DefineConst({
  Comment = "sight modifier in duststorm",
  group = "EnvEffects",
  id = "DustStormSightMod",
  scale = "%",
  value = -10
})
DefineConst({
  group = "EnvEffects",
  id = "DustStormUnkownFoeDistance",
  scale = "voxelSizeX",
  value = 9600
})
DefineConst({
  Comment = "sight modifier in firestorm",
  group = "EnvEffects",
  id = "FireStormSightMod",
  scale = "%",
  value = -10
})
DefineConst({
  Comment = "sight modifier in fog",
  group = "EnvEffects",
  id = "FogGrazeChance",
  scale = "%",
  value = 25
})
DefineConst({
  Comment = "sight modifier in fog",
  group = "EnvEffects",
  id = "FogSightMod",
  scale = "%",
  value = -30
})
DefineConst({
  group = "EnvEffects",
  id = "FogUnkownFoeDistance",
  scale = "voxelSizeX",
  value = 9600
})
DefineConst({
  group = "EnvEffects",
  id = "RainAimingMultiplier",
  scale = "%",
  value = 100
})
DefineConst({
  Comment = "weapon condition loss modifier during rain",
  group = "EnvEffects",
  id = "RainConditionLossMod",
  scale = "%",
  value = 100
})
DefineConst({
  Comment = "weapon jam chance modifier in rain",
  group = "EnvEffects",
  id = "RainJamChanceMod",
  scale = "%",
  value = 100
})
DefineConst({
  Comment = "maximum resulting mishap chance for the rain effect",
  group = "EnvEffects",
  id = "RainMishapMaxChance",
  scale = "%",
  value = 75
})
DefineConst({
  Comment = "maximum resulting mishap chance for the rain effect",
  group = "EnvEffects",
  id = "RainMishapMinChance",
  scale = "%",
  value = 3
})
DefineConst({
  Comment = "multiplier applied to mishap chance under heavy rain",
  group = "EnvEffects",
  id = "RainMishapMultiplier",
  scale = "%",
  value = 200
})
DefineConst({
  Comment = "noise modifier during rain",
  group = "EnvEffects",
  id = "RainNoiseMod",
  scale = "%",
  value = -50
})
DefineConst({
  Comment = "sight penalty (as % of base value) for seeing units on higher ground",
  group = "EnvEffects",
  id = "SightHeightDiffMod",
  scale = "%",
  value = -15
})
DefineConst({
  Comment = "minimum height difference (in voxels) a unit should be above another for SightHeightDiffMod to apply",
  group = "EnvEffects",
  id = "SightHeightDiffThreshold",
  value = 10
})
DefineConst({
  group = "Healthbar",
  id = "BadgeIconsHeight",
  value = 40
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalDamageFadeInTime",
  value = 900
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalDamageFadeOutTime",
  value = 900
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalDamageTimeOff",
  value = 200
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalDamageTimeOn",
  value = 400
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalSecondaryFadeInTime",
  value = 900
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalSecondaryFadeOutTime",
  value = 900
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalSecondaryTimeOff",
  value = 2600
})
DefineConst({
  group = "Healthbar",
  id = "ConditionalSecondaryTimeOn",
  value = 400
})
DefineConst({
  group = "Imp",
  id = "CertificateCost",
  value = 6999
})
DefineConst({
  Comment = "Max stats points to spread.",
  group = "Imp",
  id = "MaxStatPoints",
  value = 550
})
DefineConst({
  Comment = "The password for the IMP test page login",
  group = "Imp",
  id = "TestPswd",
  type = "text",
  value = "XEP625"
})
DefineConst({
  group = "LearnToLikeDislike",
  id = "becomeDislikedThreshold",
  value = 30
})
DefineConst({
  group = "LearnToLikeDislike",
  id = "becomeLikedThreshold",
  value = 30
})
DefineConst({
  group = "Loyalty",
  id = "CitySectorEnemyTakeOverLoyaltyLoss",
  value = -5
})
DefineConst({
  group = "Loyalty",
  id = "CivilianDeathPenalty",
  value = 5
})
DefineConst({
  group = "Loyalty",
  id = "CivilianDeathPenaltyCityCap",
  value = 30
})
DefineConst({
  Comment = "When losing a conflict in a sector that's not a result of a retreat (losing all mercs in that sector for example) AND that sector doesn't have a city",
  group = "Loyalty",
  id = "ConflictDefeatedLoyaltyLoss",
  value = -5
})
DefineConst({
  Comment = "If a sector that the player owns is defended by militia only (no player squads) and the militia wins",
  group = "Loyalty",
  id = "ConflictMilitiaOnlyWinBonus",
  value = 5
})
DefineConst({
  group = "Loyalty",
  id = "ConflictRetreatPenalty",
  value = -15
})
DefineConst({
  group = "Loyalty",
  id = "ConflictWinBonus",
  value = 5
})
DefineConst({
  group = "Radio",
  id = "StartNewStationDelay",
  scale = "sec",
  value = 4000
})
DefineConst({
  group = "Satellite",
  id = "AggroAttackThreshold",
  value = 3500
})
DefineConst({
  group = "Satellite",
  id = "AggroAttackThresholdNormal",
  value = 5000
})
DefineConst({
  group = "Satellite",
  id = "AggroPerCity",
  value = 20
})
DefineConst({
  group = "Satellite",
  id = "AggroPerGuardpost",
  value = 35
})
DefineConst({
  group = "Satellite",
  id = "AggroPerMine",
  value = 30
})
DefineConst({
  group = "Satellite",
  id = "AggroPerTick",
  value = 50
})
DefineConst({
  group = "Satellite",
  id = "AggroTickRandomMax",
  value = 100
})
DefineConst({
  Comment = "How much hours to pass before sending voice response for BusySatView",
  group = "Satellite",
  id = "BusySatViewHours",
  value = 12
})
DefineConst({
  group = "Satellite",
  id = "CampaignTimeFastSpeed",
  value = 100
})
DefineConst({
  group = "Satellite",
  id = "CampaignTimeNormalSpeed",
  value = 100
})
DefineConst({
  Comment = "Starting hour of Sunrise light models (inclusive)",
  group = "Satellite",
  id = "DayStartHour",
  value = 10
})
DefineConst({
  group = "Satellite",
  id = "DefaultPortPricePerTile",
  value = 100
})
DefineConst({
  Comment = "The travel time of associated squads, enemy squads would consider waiting for when attacking a sector.",
  group = "Satellite",
  id = "EnemySquadWaitTime",
  scale = "h",
  value = 28800
})
DefineConst({
  group = "Satellite",
  id = "GuardPostShowTimer",
  scale = "h",
  value = 86400
})
DefineConst({
  group = "Satellite",
  id = "MaxAggroPerTick",
  value = 500
})
DefineConst({
  group = "Satellite",
  id = "MaxHiredMercs",
  value = 15
})
DefineConst({
  Comment = "The time it takes for a hired merc to arrive to Grand Chien.",
  group = "Satellite",
  id = "MercArrivalTime",
  scale = "h",
  value = 129600
})
DefineConst({
  group = "Satellite",
  id = "MercSquadMaxPeople",
  value = 6
})
DefineConst({
  Comment = "When the sector militia training progress hits this threshold, 'MilitiaUnitsPerTraining' militia units are added to the sector.",
  group = "Satellite",
  id = "MilitiaTrainingThreshold",
  value = 3500
})
DefineConst({
  Comment = "Number of militia units that are trained simultaneously",
  group = "Satellite",
  id = "MilitiaUnitsPerTraining",
  value = 4
})
DefineConst({
  Comment = "Days during which mine's income gets lower until in reaches 0",
  group = "Satellite",
  id = "MineDepletingDays",
  value = 10
})
DefineConst({
  group = "Satellite",
  id = "NaturalHealPerTick",
  value = 1
})
DefineConst({
  Comment = "Starting hour of Sunrise light models (inclusive)",
  group = "Satellite",
  id = "NightStartHour",
  value = 21
})
DefineConst({
  group = "Satellite",
  id = "PatientHealPerTick",
  value = 5
})
DefineConst({
  Comment = "Multiplier for natural healing when the unit is in R&R Operation",
  group = "Satellite",
  id = "RandRActivityHealingMultiplier",
  value = 2
})
DefineConst({
  Comment = "If the player spends this much time in satellite view, he is forced to reload the sector map on satellite close",
  group = "Satellite",
  id = "ReloadMapAfterSatelliteTime",
  scale = "h",
  value = 36000
})
DefineConst({
  Comment = "How much hours to pass before removing blood from dead bodies on map enter.",
  group = "Satellite",
  id = "RemoveBloodAfter",
  value = 24
})
DefineConst({
  Comment = "How much hours to pass before removing dead bodies on map enter.",
  group = "Satellite",
  id = "RemoveDeadBodiesAfter",
  value = 48
})
DefineConst({
  group = "Satellite",
  id = "RiverTravelTime",
  scale = "min",
  value = 7200
})
DefineConst({
  group = "Satellite",
  id = "RoadTravelTimeMod",
  value = 50
})
DefineConst({
  Comment = "This is the time to cross the distance from the center of the sector to it's edge (not from center to center)",
  group = "Satellite",
  id = "SectorTravelTime",
  scale = "h",
  value = 21600
})
DefineConst({
  Comment = "Leadership travel bonus (this - maxLeadership)",
  group = "Satellite",
  id = "SectorTravelTimeBase",
  value = 125
})
DefineConst({
  Comment = "Travel time for DiamondBriefcase squads.",
  group = "Satellite",
  id = "SectorTravelTimeDiamonds",
  scale = "h",
  value = 28800
})
DefineConst({
  Comment = "This is the time to cross the distance from the center of the sector to it's edge (not from center to center)",
  group = "Satellite",
  id = "SectorTravelTimeEnemy",
  scale = "h",
  value = 21600
})
DefineConst({
  Comment = "The time it takes to travel from water sector to water sector",
  group = "Satellite",
  id = "SectorTravelTimeWater",
  scale = "h",
  value = 7200
})
DefineConst({
  Comment = "Used for mine income",
  group = "Satellite",
  id = "SectorsTick",
  scale = "h",
  value = 3600
})
DefineConst({
  group = "Satellite",
  id = "StartingMoney",
  value = 40000
})
DefineConst({
  group = "Satellite",
  id = "StartingMoneyQuickStart",
  value = 15000
})
DefineConst({
  Comment = "Starting hour of Sunrise light models (inclusive)",
  group = "Satellite",
  id = "SunriseStartHour",
  value = 5
})
DefineConst({
  Comment = "Starting hour of Sunrise light models (inclusive)",
  group = "Satellite",
  id = "SunsetStartHour",
  value = 18
})
DefineConst({
  Comment = "Used for activities/operations",
  group = "Satellite",
  id = "Tick",
  scale = "min",
  value = 900
})
DefineConst({
  Comment = "Being idle for 4 hours in satellite view to play voice response.",
  group = "Satellite",
  id = "UnitIdleTime",
  scale = "h",
  value = 28800
})
DefineConst({
  Comment = "Being idle for 8 hours in satellite view restores Energy, although never below the Normal state.",
  group = "Satellite",
  id = "UnitTirednessRestTime",
  scale = "h",
  value = 43200
})
DefineConst({
  Comment = "Energy is decreased after you travel for 16 hours in the Satellite View",
  group = "Satellite",
  id = "UnitTirednessTravelTime",
  scale = "h",
  value = 129600
})
DefineConst({
  Comment = [[
For each HP point above that constant the character loses Energy 1% slower, down to -(1000 -costant)%.
For each HP point below that constant the character loses Energy 1% faster, up to +50%.]],
  group = "Satellite",
  id = "UnitTirednessTravelTimeHP",
  value = 75
})
DefineConst({
  Comment = "How much satellite time is needed to heal 1 wound of the villain",
  group = "Satellite",
  id = "VillainHealWoundTime",
  scale = "h",
  value = 43200
})
DefineConst({
  Comment = "action points",
  group = "Scale",
  id = "AP",
  value = 1000
})
DefineConst({
  Comment = "Duration of a game day",
  group = "Scale",
  id = "day",
  scale = "h",
  value = 86400
})
DefineConst({
  Comment = "Duration of a game hour",
  group = "Scale",
  id = "h",
  scale = "min",
  value = 3600
})
DefineConst({
  Comment = "Duration of a game minute in real-time seconds",
  group = "Scale",
  id = "min",
  value = 60
})
DefineConst({
  Comment = "For how long the new reverb parameters will be applied/interpolated",
  group = "Sound",
  id = "ReverbPresetInterpolationTime",
  scale = "sec",
  value = 1000
})
DefineConst({
  Comment = "How often the reverb parameters are updated",
  group = "Sound",
  id = "ReverbPresetUpdateTime",
  scale = "sec",
  value = 5000
})
DefineConst({
  group = "StatGaining",
  id = "BonusToRoll",
  scale = "%",
  value = 30
})
DefineConst({
  Comment = "The XP required to accumulate to gain a Point after Level 10.",
  group = "StatGaining",
  id = "MilestoneAfterMax",
  value = 2000
})
DefineConst({
  Comment = "Amount to increment the required XP after each point acquired after Level 10.",
  group = "StatGaining",
  id = "MilestoneAfterMaxIncrement",
  value = 100
})
DefineConst({
  group = "StatGaining",
  id = "PerStatCDMax",
  scale = "h",
  value = 216000
})
DefineConst({
  group = "StatGaining",
  id = "PerStatCDMin",
  scale = "h",
  value = 86400
})
DefineConst({
  Comment = "Split evenly throught the XP% of the level.",
  group = "StatGaining",
  id = "PointsPerLevel",
  value = 5
})
DefineConst({
  Comment = "The campaign's starting date as a unix timestamp.",
  group = "StoryBits",
  id = "StartDate",
  value = 954579600
})
DefineConst({
  group = "StoryBits",
  id = "TickDuration",
  scale = "h",
  value = 14400
})
DefineConst({
  group = "TagLookupTable",
  id = "agility",
  translate = true,
  type = "text",
  value = T(173062976593, "<em>Agility</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "agility-f",
  translate = true,
  type = "text",
  value = T(604427989653, "<em>Agility</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "agility-s",
  translate = true,
  type = "text",
  value = T(605709911368, "<em>Agility</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "dexterity",
  translate = true,
  type = "text",
  value = T(445190944231, "<em>Dexterity</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "dexterity-f",
  translate = true,
  type = "text",
  value = T(168838094663, "<em>Dexterity</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "dexterity-s",
  translate = true,
  type = "text",
  value = T(445855730389, "<em>Dexterity</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "explosives",
  translate = true,
  type = "text",
  value = T(740643734848, "<em>Explosives</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "explosives-f",
  translate = true,
  type = "text",
  value = T(987216838762, "<em>Explosives</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "explosives-s",
  translate = true,
  type = "text",
  value = T(786219088415, "<em>Explosives</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "failure",
  translate = true,
  type = "text",
  value = T(660586654399, "<em>(failure)</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "health",
  translate = true,
  type = "text",
  value = T(771315187589, "<em>Health</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "health-f",
  translate = true,
  type = "text",
  value = T(934194806866, "<em>Health</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "health-s",
  translate = true,
  type = "text",
  value = T(538191903225, "<em>Health</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "leadership",
  translate = true,
  type = "text",
  value = T(434575611315, "<em>Leadership</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "leadership-f",
  translate = true,
  type = "text",
  value = T(115961113381, "<em>Leadership</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "leadership-s",
  translate = true,
  type = "text",
  value = T(791099644012, "<em>Leadership</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "loyalty",
  translate = true,
  type = "text",
  value = T(540663603961, "<em>Loyalty</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "marksmanship",
  translate = true,
  type = "text",
  value = T(231310967363, "<em>Marksmanship</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "marksmanship-f",
  translate = true,
  type = "text",
  value = T(377084552469, "<em>Marksmanship</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "marksmanship-s",
  translate = true,
  type = "text",
  value = T(967747929528, "<em>Marksmanship</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "mechanical",
  translate = true,
  type = "text",
  value = T(182951201564, "<em>Mechanical</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "mechanical-f",
  translate = true,
  type = "text",
  value = T(887233553893, "<em>Mechanical</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "mechanical-s",
  translate = true,
  type = "text",
  value = T(907017027968, "<em>Mechanical</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "medical",
  translate = true,
  type = "text",
  value = T(955267014620, "<em>Medical</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "medical-f",
  translate = true,
  type = "text",
  value = T(206296047675, "<em>Medical</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "medical-s",
  translate = true,
  type = "text",
  value = T(725550892596, "<em>Medical</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "negotiator",
  translate = true,
  type = "text",
  value = T(385382636358, "<em>Negotiator</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "psycho",
  translate = true,
  type = "text",
  value = T(373801051640, "<em>Psycho</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "scoundrel",
  translate = true,
  type = "text",
  value = T(101209792712, "<em>Scoundrel</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "strength",
  translate = true,
  type = "text",
  value = T(736618764391, "<em>Strength</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "strength-f",
  translate = true,
  type = "text",
  value = T(136303670108, "<em>Strength</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "strength-s",
  translate = true,
  type = "text",
  value = T(646626968372, "<em>Strength</em> check successful ")
})
DefineConst({
  group = "TagLookupTable",
  id = "success",
  translate = true,
  type = "text",
  value = T(590323149753, "<em>(success)</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "wisdom",
  translate = true,
  type = "text",
  value = T(290895471056, "<em>Wisdom</em>")
})
DefineConst({
  group = "TagLookupTable",
  id = "wisdom-f",
  translate = true,
  type = "text",
  value = T(703234572711, "<em>Wisdom</em> check failed ")
})
DefineConst({
  group = "TagLookupTable",
  id = "wisdom-s",
  translate = true,
  type = "text",
  value = T(940972260976, "<em>Wisdom</em> check successful ")
})
DefineConst({
  Comment = "Mercenaries exploration mode movement speed in crouch stance.",
  group = "UnitMoveSpeed",
  id = "MercCrouchStance",
  value = 2400
})
DefineConst({
  Comment = "Mercenaries exploration mode movement speed in prone stance.",
  group = "UnitMoveSpeed",
  id = "MercProneStance",
  value = 800
})
DefineConst({
  Comment = "Mercenaries exploration mode movement speed in standing stance.",
  group = "UnitMoveSpeed",
  id = "MercStandingStance",
  value = 4800
})
DefineConst({
  Comment = "Bonus damage when using Burst Fire.",
  group = "Weapons",
  id = "BurstDamageBonus",
  scale = "%",
  value = 50
})
DefineConst({
  group = "Weapons",
  id = "BurstFireConeWidthMod",
  scale = "%",
  value = 33
})
DefineConst({
  Comment = "When an attack crits it adds Weapons's Damage x CriticalDamage% ADDITIONAL damage. Without damage Variance.",
  group = "Weapons",
  id = "CriticalDamage",
  scale = "%",
  value = 50
})
DefineConst({
  Comment = "Amount of Condition lost per shot.",
  group = "Weapons",
  id = "DegradePerShot",
  value = 1
})
DefineConst({
  Comment = "Amount of Condition lost per shot.",
  group = "Weapons",
  id = "DegradePerShot_GrenadeLauncher",
  value = 8
})
DefineConst({
  Comment = "Amount of Condition lost per shot.",
  group = "Weapons",
  id = "DegradePerShot_Mortar",
  value = 15
})
DefineConst({
  Comment = "Amount of Condition lost per shot.",
  group = "Weapons",
  id = "DegradePerShot_RocketLauncher",
  value = 15
})
DefineConst({
  group = "Weapons",
  id = "DoubleBarrelDamageBonus",
  value = 50
})
DefineConst({
  Comment = "The minimum condition for broken keyword",
  group = "Weapons",
  id = "ItemConditionBroken",
  value = 0
})
DefineConst({
  Comment = "The minimum condition for excellent keyword",
  group = "Weapons",
  id = "ItemConditionExcellent",
  value = 95
})
DefineConst({
  Comment = "The minimum condition for needs repair keyword",
  group = "Weapons",
  id = "ItemConditionNeedsRepair",
  value = 40
})
DefineConst({
  Comment = "The minimum condition for poor keyword",
  group = "Weapons",
  id = "ItemConditionPoor",
  value = 1
})
DefineConst({
  Comment = "The minimum condition for used keyword.When weapon's Condition is below this value it has a chance to jam.",
  group = "Weapons",
  id = "ItemConditionUsed",
  value = 70
})
DefineConst({
  Comment = "Uses before the item degradation (like planks in armor ) for the items generated from loot.",
  group = "Weapons",
  id = "ItemDegradationCounter",
  value = 5
})
DefineConst({
  Comment = "The number by which the condition loss is divided by when the skill check of unjamming fails.",
  group = "Weapons",
  id = "JamConditionLossDivisor",
  value = 3
})
DefineConst({
  Comment = "The maximum condition loss a weapon can incur if the skill check for unjamming fails.",
  group = "Weapons",
  id = "JamConditionLossMax",
  value = 16
})
DefineConst({
  Comment = "The minimum condition loss a weapon can incur if the skill check for unjamming fails.",
  group = "Weapons",
  id = "JamConditionLossMin",
  value = 3
})
DefineConst({
  Comment = "number of attacks during which the weapon cannot jam again after being unjammed",
  group = "Weapons",
  id = "JamFixNumSafeAttacks",
  value = 2
})
DefineConst({
  Comment = "The condition randomization with +/- that number when generate loot item.",
  group = "Weapons",
  id = "LootConditionRandomization",
  value = 30
})
DefineConst({
  Comment = "maximum amount of over at 10 tiles",
  group = "Weapons",
  id = "OvershootMaxDist",
  scale = "m",
  value = 1400
})
DefineConst({
  Comment = "minimum amount of overshoot at 10 tiles",
  group = "Weapons",
  id = "OvershootMinDist",
  scale = "m",
  value = 900
})
DefineConst({
  Comment = "in tiles",
  group = "Weapons",
  id = "PointBlankRange",
  value = 4
})
DefineConst({
  group = "Weapons",
  id = "ShotgunCollateralDamage",
  value = 50
})
DefineConst({
  Comment = "The number of parts (inventory item) that will be created when scrap each weapon upgrade.",
  group = "Weapons",
  id = "UpgradeScrapParts",
  value = 2
})
