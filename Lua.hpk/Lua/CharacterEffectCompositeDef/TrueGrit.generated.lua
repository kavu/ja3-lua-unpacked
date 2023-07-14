UndefineClass("TrueGrit")
DefineClass.TrueGrit = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitEndTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          if not unit:IsUsingCover() and g_Combat:AreEnemiesAware(g_CurrentTeam) then
            unit:ApplyTempHitPoints(self:ResolveValue("outOfCoverGrit"))
          end
          local nearestEnemy = GetNearestEnemy(unit)
          if nearestEnemy and unit:IsAdjacentTo(nearestEnemy) then
            unit:ApplyTempHitPoints(self:ResolveValue("nextToEnemyGrit"))
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        if not unit:IsUsingCover() and g_Combat:AreEnemiesAware(g_CurrentTeam) then
          unit:ApplyTempHitPoints(self:ResolveValue("outOfCoverGrit"))
        end
        local nearestEnemy = GetNearestEnemy(unit)
        if nearestEnemy and unit:IsAdjacentTo(nearestEnemy) then
          unit:ApplyTempHitPoints(self:ResolveValue("nextToEnemyGrit"))
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(551122384582, "Vanguard"),
  Description = T(684654187590, [[
Gain <em><outOfCoverGrit></em> <GameTerm('Grit')> when you end your turn out of<em> Cover</em>.

Gain <em><nextToEnemyGrit></em> <GameTerm('Grit')> when you end your turn <em>adjacent</em> to an enemy.]]),
  Icon = "UI/Icons/Perks/ContestGround",
  Tier = "Silver",
  Stat = "Health",
  StatValue = 80
}
