PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu Satellite UI",
  id = "PDASmallButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "MinWidth",
    32,
    "MinHeight",
    32,
    "ScaleModifier",
    point(1250, 1250),
    "LayoutMethod",
    "Box",
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled",
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "Image",
    "UI/PDA/os_system_buttons",
    "FrameBox",
    box(8, 8, 8, 8),
    "SqueezeX",
    true,
    "SqueezeY",
    true,
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idCenterImg",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "HandleKeyboard",
      false,
      "Image",
      "UI/PDA/T_Icon_Pause",
      "ImageColor",
      RGBA(55, 49, 49, 255),
      "DisabledImageColor",
      RGBA(130, 128, 120, 255)
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "StartBlinking(self)",
      "func",
      function(self)
        if self:GetThread("blink-thread") then
          return
        end
        local on = false
        self:CreateThread("blink-thread", function()
          while self.window_state ~= "destroying" do
            on = not on
            self:SetImage(on and "UI/PDA/os_system_buttons_yellow" or "UI/PDA/os_system_buttons")
            Sleep(500)
          end
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "StopBlinking(self, yellow)",
      "func",
      function(self, yellow)
        self:DeleteThread("blink-thread")
        self:SetImage(yellow and "UI/PDA/os_system_buttons_yellow" or "UI/PDA/os_system_buttons")
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "CenterImage",
    "editor",
    "text",
    "default",
    "UI/PDA/T_Icon_Pause",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idCenterImg:SetImage(value)
      self.idCenterImg:SetFlipX(self.FlipX)
    end,
    "Get",
    function(self)
      return self.idCenterImg:GetImage()
    end
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "CenterImageColorization",
    "editor",
    "color",
    "default",
    RGBA(55, 49, 49, 255),
    "Set",
    function(self, value)
      self.idCenterImg:SetImageColor(value)
    end,
    "Get",
    function(self)
      return self.idCenterImg:GetImageColor()
    end
  })
})
