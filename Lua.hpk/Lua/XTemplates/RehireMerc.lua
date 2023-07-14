PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "RehireMerc",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "HAlign",
    "center",
    "VAlign",
    "center",
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        rawset(self, "RehireMerc", true)
        for dlg_id, dialog in ipairs(self.parent or empty_table) do
          if dialog ~= self and rawget(dialog, "RehireMerc") then
            dialog:SetVisible(false)
          end
        end
        ZuluModalDialog.Open(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        for dlg_id, dialog in ipairs(self.parent or empty_table) do
          if dialog ~= self and rawget(dialog, "RehireMerc") then
            dialog:SetVisible(true)
            break
          end
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Margins",
      box(50, 0, 0, 0),
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1100,
      "MinHeight",
      480,
      "MaxWidth",
      1100,
      "MaxHeight",
      480,
      "Image",
      "UI/Common/message_background_green",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(-15, 140, 0, 5),
      "Dock",
      "top",
      "HAlign",
      "center",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "MinWidth",
        500,
        "MaxWidth",
        500,
        "MaxHeight",
        100,
        "HandleMouse",
        false,
        "TextStyle",
        "DescriptionTextWhite",
        "Translate",
        true,
        "Text",
        T(665239190000, "<text>"),
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return context.choices
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child:SetText(item)
          local enabled = not context.disabled or not context.disabled[i]
          child:SetEnabled(enabled)
          child.idText:SetEnabled(enabled)
          rawset(child, "OnPressParam", i)
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "RehireMercChoice",
          "OnPressEffect",
          "close"
        })
      })
    })
  })
})
