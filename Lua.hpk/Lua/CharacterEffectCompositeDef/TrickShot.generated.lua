UndefineClass("TrickShot")
DefineClass.TrickShot = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttack",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttack")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          if not results.miss and IsKindOf(target, "Unit") then
            if attack_args.target_spot_group == "Legs" then
              target:AddStatusEffect("KnockDown")
            elseif attack_args.target_spot_group == "Arms" then
              target:AddStatusEffect("Numbness")
            elseif attack_args.target_spot_group == "Groin" then
              target:AddStatusEffect("Exposed")
            end
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, action, target, results, attack_args)
          end
        else
          exec(self, attacker, action, target, results, attack_args)
        end
      end,
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        if not results.miss and IsKindOf(target, "Unit") then
          if attack_args.target_spot_group == "Legs" then
            target:AddStatusEffect("KnockDown")
          elseif attack_args.target_spot_group == "Arms" then
            target:AddStatusEffect("Numbness")
          elseif attack_args.target_spot_group == "Groin" then
            target:AddStatusEffect("Exposed")
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(989219478012, "Trick Shot"),
  Description = T(287611874277, [[
<em>Legs</em> shots apply <GameTerm('Knockdown')>.

<em>Arms</em> shots apply <GameTerm('Numbness')>.

<em>Groin</em> shots apply <GameTerm('Exposed')>.]]),
  Icon = "UI/Icons/Perks/TrickShot",
  Tier = "Gold",
  Stat = "Wisdom",
  StatValue = 90
}
