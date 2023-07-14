UndefineClass("Protected")
DefineClass.Protected = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if IsKindOf(obj, "Unit") and (g_Combat or g_StartingCombat or g_TestingSaveLoadSystem) then
            obj:RemoveStatusEffect("FreeMove")
            local ap_carry = Min(self:ResolveValue("max_ap_carried") * const.Scale.AP, obj.ActionPoints)
            obj:SetEffectValue("protected_ap_carry", ap_carry)
            if not obj.infinite_ap then
              obj.ActionPoints = 0
            end
            ObjModified(obj)
          end
          UpdateTakeCoverAction()
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") and (g_Combat or g_StartingCombat or g_TestingSaveLoadSystem) then
          obj:RemoveStatusEffect("FreeMove")
          local ap_carry = Min(self:ResolveValue("max_ap_carried") * const.Scale.AP, obj.ActionPoints)
          obj:SetEffectValue("protected_ap_carry", ap_carry)
          if not obj.infinite_ap then
            obj.ActionPoints = 0
          end
          ObjModified(obj)
        end
        UpdateTakeCoverAction()
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          if IsKindOf(obj, "Unit") then
            obj:SetEffectValue("protected_ap_carry")
          end
          UpdateTakeCoverAction()
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          obj:SetEffectValue("protected_ap_carry")
        end
        UpdateTakeCoverAction()
      end,
      param_bindings = false
    })
  },
  DisplayName = T(569020076106, "Taking cover"),
  Description = T(682670978880, "While coming from the <em>other side</em> of the <em>Cover</em> attacks against this unit have a high chance to become <em>Grazing hits</em> and the targeted body part is selected automatically."),
  type = "Buff",
  Icon = "UI/Hud/Status effects/protected",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
