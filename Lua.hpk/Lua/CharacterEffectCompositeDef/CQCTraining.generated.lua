UndefineClass("CQCTraining")
DefineClass.CQCTraining = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id then
            local attacker, target = data.attacker, data.target
            local value = self:ResolveValue("cqc_bonus_max")
            local tileSpace = DivRound(attacker:GetDist2D(target), const.SlabSizeX) - 1
            if 0 < tileSpace then
              local lossPerTile = self:ResolveValue("cqc_bonus_loss_per_tile")
              value = value - lossPerTile * tileSpace
            end
            data.mod_add = Max(0, value)
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, cth_id, data)
          end
        else
          exec(self, attacker, cth_id, data)
        end
      end,
      HandlerCode = function(self, attacker, cth_id, data)
        if cth_id == self.id then
          local attacker, target = data.attacker, data.target
          local value = self:ResolveValue("cqc_bonus_max")
          local tileSpace = DivRound(attacker:GetDist2D(target), const.SlabSizeX) - 1
          if 0 < tileSpace then
            local lossPerTile = self:ResolveValue("cqc_bonus_loss_per_tile")
            value = value - lossPerTile * tileSpace
          end
          data.mod_add = Max(0, value)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(144446625840, "CQC Training"),
  Description = T(145788352124, "Major <em>Accuracy</em> bonus when attacking enemies at short range (degrades with distance)."),
  Icon = "UI/Icons/Perks/CQCTraining",
  Tier = "Specialization"
}
