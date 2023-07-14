PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpStartPage",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(536912996016, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Dock",
      "top",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 20, 20, 20),
        "LayoutMethod",
        "VList",
        "ChildrenHandleMouse",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(145135869022, "Welcome to the institute for mercenary profiling (I.M.P.)")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true,
          "Text",
          T(378365803881, "At I.M.P. we know the mercenary trade. We can offer you advice that will help you handle the pressures that a mission can put on you, and suggest custom tailored mercenaries for your team. We know you better than yourself!")
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Dock",
      "box",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "IdNode",
        false,
        "Margins",
        box(20, 20, 0, 20),
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "VScroll",
        "idScrollbar"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 20, 0),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "HandleMouse",
            false,
            "TextStyle",
            "PDAIMPContentTitle",
            "Translate",
            true,
            "Text",
            T(157984480848, "What you get")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "HandleMouse",
            false,
            "TextStyle",
            "PDAIMPContentText",
            "Translate",
            true,
            "Text",
            T(543112840540, [[
I.M.P. analyzes you scientifically. We look at your personality, your physical abilities and your skills, and we give an exact measure of who you are and what you can do.
Right now we have 1 slot for a Personality Evaluation Test (P.E.T.) which can be taken by you or any person you want to field as your mercenary. No surprises! Guaranteed estimation of your abilities with scientific accuracy!]])
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "line",
            "__class",
            "XImage",
            "Margins",
            box(0, 5, 0, 5),
            "VAlign",
            "center",
            "Transparency",
            141,
            "Image",
            "UI/PDA/separate_line_vertical",
            "ImageFit",
            "stretch-x"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "HandleMouse",
            false,
            "TextStyle",
            "PDAIMPContentTitle",
            "Translate",
            true,
            "Text",
            T(466440547454, "What do you need to do")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "HandleMouse",
            false,
            "TextStyle",
            "PDAIMPContentText",
            "Translate",
            true,
            "Text",
            T(646954510709, "You only need to fill a short survey of 10 questions: the P.E.T. The test can be taken as soon as you want, and you will get immediate results within the same hour. That's how fast our computers are!")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XZuluScroll",
          "Id",
          "idScrollbar",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "UseClipBox",
          false,
          "Target",
          "idScrollArea",
          "AutoHide",
          true
        })
      })
    })
  })
})
