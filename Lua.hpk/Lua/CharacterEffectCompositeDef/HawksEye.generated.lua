UndefineClass("HawksEye")
DefineClass.HawksEye = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "MercHired",
      Handler = function(self, mercId, price, days, alreadyHired)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "MercHired")
        if not reaction_idx then
          return
        end
        local exec = function(self, mercId, price, days, alreadyHired)
          local unit = gv_UnitData[mercId]
          if unit and HasPerk(unit, self.id) and 0 < days then
            local canPlaceError = CanPlaceItemInInventory("Cookie", days, unit)
            if canPlaceError then
              CombatLog("important", T(667077082306, "Scope has baked some biscuits. Unfortunately the inventory is full. "))
              return
            end
            CombatLog("important", T(754424382903, "Scope has baked some biscuits"))
            PlaceItemInInventory("Cookie", days, unit)
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          local objs = {}
          for session_id, data in pairs(gv_UnitData) do
            local obj = g_Units[session_id] or data
            if obj:HasStatusEffect(id) then
              objs[session_id] = obj
            end
          end
          for _, obj in sorted_pairs(objs) do
            exec(self, mercId, price, days, alreadyHired)
          end
        else
          exec(self, mercId, price, days, alreadyHired)
        end
      end,
      HandlerCode = function(self, mercId, price, days, alreadyHired)
        local unit = gv_UnitData[mercId]
        if unit and HasPerk(unit, self.id) and 0 < days then
          local canPlaceError = CanPlaceItemInInventory("Cookie", days, unit)
          if canPlaceError then
            CombatLog("important", T(667077082306, "Scope has baked some biscuits. Unfortunately the inventory is full. "))
            return
          end
          CombatLog("important", T(754424382903, "Scope has baked some biscuits"))
          PlaceItemInInventory("Cookie", days, unit)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(930669061773, "Eagle Eye"),
  Description = T(161077132582, [[
<GameTerm('PinDown')> applies <GameTerm('Exposed')> to the target.

<GameTerm('PinDown')> minimum <em>AP</em> cost is reduced to <em><pindownCostOverwrite> AP</em>.

Scope also makes <GameTerm('Biscuits')>.]]),
  Icon = "UI/Icons/Perks/HawksEye",
  Tier = "Personal"
}
