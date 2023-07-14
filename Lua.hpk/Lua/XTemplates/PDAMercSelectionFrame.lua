PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMercSelectionFrame",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idSelectionFrame",
    "Visible",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "Image",
      "UI/PDA/MercPortrait/T_MercPortrait_SelectedCornerPin",
      "ImageColor",
      RGBA(27, 31, 45, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "right",
      "VAlign",
      "top",
      "Image",
      "UI/PDA/MercPortrait/T_MercPortrait_SelectedCornerPin",
      "ImageColor",
      RGBA(27, 31, 45, 255),
      "FlipX",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "left",
      "VAlign",
      "bottom",
      "Image",
      "UI/PDA/MercPortrait/T_MercPortrait_SelectedCornerPin",
      "ImageColor",
      RGBA(27, 31, 45, 255),
      "FlipY",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Image",
      "UI/PDA/MercPortrait/T_MercPortrait_SelectedCornerPin",
      "ImageColor",
      RGBA(27, 31, 45, 255),
      "FlipX",
      true,
      "FlipY",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetPressed(self, pressed)",
      "func",
      function(self, pressed)
        local b = self.box
        local center = b:Center()
        if pressed == "down" then
          self:AddInterpolation({
            id = "frameGrow",
            type = const.intRect,
            duration = 0,
            originalRect = sizebox(center, 100, 100),
            targetRect = sizebox(center, 105, 105)
          })
        elseif pressed == "up" then
          self:AddInterpolation({
            id = "frameGrow",
            type = const.intRect,
            duration = 0,
            originalRect = sizebox(center, 100, 100),
            targetRect = sizebox(center, 110, 110)
          })
        end
        self:SetVisible(true)
      end
    })
  })
})
