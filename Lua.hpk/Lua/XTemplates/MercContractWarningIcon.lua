PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu Satellite UI",
  id = "MercContractWarningIcon",
  PlaceObj("XTemplateWindow", {
    "comment",
    "contract notification",
    "__class",
    "XButton",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(5, 0, 0, 0),
    "ZOrder",
    3,
    "HAlign",
    "right",
    "VAlign",
    "top",
    "MinWidth",
    26,
    "MinHeight",
    26,
    "MaxWidth",
    26,
    "MaxHeight",
    26,
    "FoldWhenHidden",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if not context.HiredUntil or context.HireStatus ~= "Hired" then
        self:SetVisible(false)
        return
      end
      if Game.CampaignTime >= context.HiredUntil then
        self.idImage:SetImage("UI/PDA/MercPortrait/T_Icon_ContractExpired")
        self:SetRolloverText(T(439457925710, "This merc's contract has expired!"))
        self:SetVisible(true)
      elseif Game.CampaignTime + const.Scale.h * 60 >= context.HiredUntil then
        self.idImage:SetImage("UI/PDA/MercPortrait/T_Icon_ContractExpiring")
        self:SetRolloverText(T(840839971172, "This merc's contract is about to expire!"))
        self:SetVisible(true)
      else
        self:SetVisible(false)
      end
    end,
    "OnPress",
    function(self, gamepad)
      OpenAIMAndSelectMerc(self.context.session_id)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idImage",
      "ImageFit",
      "stretch"
    })
  })
})
