UndefineClass("Drunk")
DefineClass.Drunk = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id and data.action.ActionType == "Ranged Attack" then
            data.mod_add = data.mod_add + self:ResolveValue("range_cth_mod")
            data.display_name = T({
              776394275735,
              "Perk: <name>",
              name = self.DisplayName
            })
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
        if cth_id == self.id and data.action.ActionType == "Ranged Attack" then
          data.mod_add = data.mod_add + self:ResolveValue("range_cth_mod")
          data.display_name = T({
            776394275735,
            "Perk: <name>",
            name = self.DisplayName
          })
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          obj:RemoveStatusEffect("Conscience_Sinful")
          obj:RemoveStatusEffect("Conscience_Guilty")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:RemoveStatusEffect("Conscience_Sinful")
        obj:RemoveStatusEffect("Conscience_Guilty")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(356009705485, "Inebriated"),
  Description = T(948415774949, [[
Increased <em>Damage</em> with <em>Melee Attacks</em>

Lower <em>Accuracy</em> with <em>Ranged Attacks</em>
]]),
  AddEffectText = T(464514537198, "<DisplayName> is drunk"),
  RemoveEffectText = T(456783400197, "<DisplayName> is no longer drunk"),
  Icon = "UI/Hud/Status effects/drunk",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
