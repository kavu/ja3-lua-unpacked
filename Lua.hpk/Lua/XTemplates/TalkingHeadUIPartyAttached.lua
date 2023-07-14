PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu",
  id = "TalkingHeadUIPartyAttached",
  PlaceObj("XTemplateWindow", {
    "comment",
    "see PartyAttachedUI.lua",
    "__class",
    "XPopup",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MaxWidth",
    290,
    "LayoutMethod",
    "HList",
    "UseClipBox",
    false,
    "Visible",
    false,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "ChildrenHandleMouse",
    false,
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idPortraitBG",
      "IdNode",
      false,
      "Margins",
      box(5, 5, 5, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "FoldWhenHidden",
      true,
      "Background",
      RGBA(255, 255, 255, 255),
      "Image",
      "UI/Hud/portrait_background",
      "ImageFit",
      "stretch"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "UIEffectModifierId",
        "Default",
        "Id",
        "idPortrait",
        "IdNode",
        false,
        "ZOrder",
        2,
        "Margins",
        box(0, -10, 0, 0),
        "MaxHeight",
        85,
        "ImageFit",
        "height",
        "ImageRect",
        box(36, 0, 264, 246)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idStatGain",
        "IdNode",
        true,
        "Margins",
        box(0, 0, 0, 9),
        "VAlign",
        "bottom",
        "DrawOnTop",
        true,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          if not context then
            return
          end
          UpdateStatGainVisualization(self, context)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "Padding",
            box(2, 2, 2, 2),
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "MinWidth",
            24,
            "MinHeight",
            24,
            "MaxWidth",
            24,
            "MaxHeight",
            24,
            "Background",
            RGBA(230, 222, 202, 255),
            "BackgroundRectGlowColor",
            RGBA(230, 222, 202, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idStatIcon",
              "Image",
              "UI/Icons/st_marksmanship",
              "ImageFit",
              "stretch",
              "ImageColor",
              RGBA(32, 35, 47, 255)
            })
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "MinWidth",
            24,
            "MinHeight",
            24,
            "MaxWidth",
            24,
            "MaxHeight",
            24,
            "Background",
            RGBA(230, 222, 202, 255),
            "BackgroundRectGlowColor",
            RGBA(230, 222, 202, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idStatCount",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "HUDHeaderDarkSmall",
              "ContextUpdateOnOpen",
              true,
              "Text",
              "+3"
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "HealthBar",
        "Id",
        "idBar",
        "BorderWidth",
        1,
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "MinWidth",
        80,
        "MinHeight",
        9,
        "MaxWidth",
        80,
        "MaxHeight",
        9,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "Background",
        RGBA(42, 43, 47, 255),
        "Image",
        "UI/Hud/ap_bar_pad",
        "Progress",
        {0, 0},
        "DisplayTempHp",
        true,
        "FitSegments",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Margins",
      box(0, 5, 0, 0),
      "VAlign",
      "top",
      "OnLayoutComplete",
      function(self)
        if rawget(self, "animated") then
          return
        end
        rawset(self, "animated", true)
        self:CreateThread("animation", function()
          while not self.parent.visible do
            Sleep(10)
          end
          self:AddInterpolation({
            id = "size",
            type = const.intRect,
            duration = 200,
            originalRect = box(0, 0, 1000, 1000),
            targetRect = box(0, 0, 1, 1),
            OnLayoutComplete = IntRectTopLeftRelative,
            flags = const.intfInverse
          })
          Sleep(250)
          self:AddInterpolation({
            id = "size",
            type = const.intRect,
            duration = 300,
            originalRect = box(0, 0, 1000, 1000),
            targetRect = box(0, 0, 1150, 1150),
            OnLayoutComplete = IntRectTopLeftRelative,
            flags = bor(const.intfInverse, const.intfPingPong)
          })
        end)
      end,
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "BorderWidth",
        2,
        "Padding",
        box(5, 5, 5, 5),
        "BorderColor",
        RGBA(52, 55, 61, 255),
        "Background",
        RGBA(32, 35, 47, 215)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "HAlign",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "HUDTalkingHeadAttached",
          "Translate",
          true
        })
      })
    })
  })
})
