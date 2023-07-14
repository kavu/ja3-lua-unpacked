PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu",
  id = "CombatLogButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "Id",
    "idCombatLogButton",
    "HAlign",
    "right",
    "OnLayoutComplete",
    function(self)
      if self.parent:IsVisible() then
        CombatLogAnchorBox = self.content_box
        Msg("CombatLogButtonChanged")
      end
      if not self:GetThread("buttons_observer") then
        self:CreateThread("buttons_observer", function()
          while self.window_state ~= "destroying" do
            WaitMsg("CombatLogButtonDied")
            self:OnLayoutComplete()
          end
        end)
      end
      if not self:GetThread("resize_observer") then
        self:CreateThread("resize_observer", function()
          while self.window_state ~= "destroying" do
            WaitMsg("SystemSize")
            self:OnLayoutComplete()
          end
        end)
      end
      if not self:GetThread("combat_log_observer") then
        self:CreateThread("combat_log_observer", function()
          while self.window_state ~= "destroying" do
            local _, val = WaitMsg("CombatLogVisibleChanged")
            self:SetVisible(val ~= "visible")
          end
        end)
      end
      local combatLog = GetDialog("CombatLog")
      if combatLog and combatLog.visible and not combatLog:GetThread("animation-close") then
        self:SetVisible(false)
      end
    end,
    "LayoutHSpacing",
    0,
    "Background",
    RGBA(0, 0, 0, 0),
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      OpenCombatLog()
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0),
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        Msg("CombatLogButtonDied")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XTextButton.Open(self)
        local parentLayoutComplete = self.parent.OnLayoutComplete
        function self.parent.OnLayoutComplete()
          parentLayoutComplete(self.parent)
          self:OnLayoutComplete()
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "controller observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "IdNode",
      true,
      "Visible",
      false,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:SetTransparency(GetUIStyleGamepad() and 255 or 0)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "MinWidth",
      24,
      "MinHeight",
      24,
      "MaxWidth",
      24,
      "MaxHeight",
      24,
      "Image",
      "UI/PDA/T_SmallButton",
      "Columns",
      3
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "GetColumn(self)",
        "func",
        function(self)
          return self.parent:GetColumn()
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Margins",
        box(3, 3, 3, 3),
        "Dock",
        "box",
        "Image",
        "UI/PDA/snype_logo",
        "ImageFit",
        "stretch",
        "ImageColor",
        RGBA(61, 122, 153, 255)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Background",
      RGBA(61, 122, 153, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(5, 0, 5, -2),
        "VAlign",
        "center",
        "TextStyle",
        "PDASelectedSquad",
        "Translate",
        true,
        "Text",
        T(488963413186, "SNYPE")
      })
    })
  })
})
