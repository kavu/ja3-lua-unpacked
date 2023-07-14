PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu PDA",
  id = "PDAMercProfileButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "MinWidth",
    124,
    "MinHeight",
    141,
    "MaxWidth",
    124,
    "MaxHeight",
    141,
    "LayoutMethod",
    "VList",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "RolloverOnFocus",
    false,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "ChildrenHandleMouse",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local dlg = GetDialog(self)
      self:SetSelected(dlg.SelectedMercId == context.session_id)
    end,
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0),
    "OnPress",
    function(self, gamepad)
      local mercProfiles = GetDialog(self)
      local context = self:GetContext()
      mercProfiles:SetSelectedMercId(context.session_id)
    end,
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idContent",
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idSelectedRounding",
        "Dock",
        "box",
        "Visible",
        false,
        "Image",
        "UI/PDA/os_portrait_selection",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idPortraitBG",
        "IdNode",
        false,
        "Margins",
        box(5, 5, 5, 0),
        "Image",
        "UI/Hud/portrait_background",
        "ImageFit",
        "stretch"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextImage",
          "UIEffectModifierId",
          "Default",
          "Id",
          "idPortrait",
          "IdNode",
          false,
          "ZOrder",
          2,
          "Margins",
          box(0, -20, 0, 0),
          "ImageFit",
          "largest",
          "ImageRect",
          box(36, 0, 264, 246),
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetImage(context.Portrait)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XSquareWindow",
          "Id",
          "idClassIconBg",
          "ZOrder",
          3,
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "MinWidth",
          28,
          "MinHeight",
          28,
          "MaxWidth",
          28,
          "MaxHeight",
          28,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextImage",
            "Id",
            "idClassIcon",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            20,
            "MinHeight",
            20,
            "MaxWidth",
            20,
            "MaxHeight",
            20,
            "ImageFit",
            "stretch",
            "ImageColor",
            RGBA(230, 222, 202, 255),
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetImage(GetMercSpecIcon(context))
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBottomSection",
        "Margins",
        box(5, 0, 5, 0),
        "Dock",
        "bottom",
        "MinHeight",
        30,
        "MaxHeight",
        30,
        "LayoutMethod",
        "HList",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idName",
          "Margins",
          box(2, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "PDAMercNameCard_Light",
          "Translate",
          true,
          "Text",
          T(654881283600, "<Nick>")
        })
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "Selected",
    "Set",
    function(self, value)
      self.Selected = value
      local light = RGBA(230, 222, 202, 255)
      local dark = RGBA(32, 35, 47, 255)
      if value then
        self:ResolveId("idName"):SetTextStyle("PDAMercNameCard")
        self:ResolveId("idBottomSection"):SetBackground(light)
        self:ResolveId("idClassIconBg"):SetBackground(light)
        self:ResolveId("idClassIcon"):SetImageColor(dark)
        self:ResolveId("idSelectedRounding"):SetVisible(true)
      else
        self:ResolveId("idName"):SetTextStyle("PDAMercNameCard_Light")
        self:ResolveId("idBottomSection"):SetBackground(dark)
      end
    end
  })
})
