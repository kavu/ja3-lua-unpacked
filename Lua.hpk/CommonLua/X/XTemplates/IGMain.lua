PlaceObj("XTemplate", {
  __is_kind_of = "IGMainActions",
  group = "Common",
  id = "IGMain",
  save_in = "Common",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText(const.ProjectName)
      end,
      "Translate",
      false
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "IGMainActions",
      "Id",
      "idActions"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XList",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutVSpacing",
      20,
      "BorderColor",
      RGBA(32, 32, 32, 0),
      "Background",
      RGBA(255, 255, 255, 0),
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "FocusedBackground",
      RGBA(255, 255, 255, 0)
    }, {
      PlaceObj("XTemplateForEachAction", {
        "toolbar",
        "mainmenu",
        "run_after",
        function(child, context, action, n)
          child:SetText(action.ActionName)
          child:SetOnPressParam(action.ActionId)
        end
      }, {
        PlaceObj("XTemplateTemplate", {"__template", "MenuButton"})
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return {
          ver = BuildVersion or LuaRevision,
          build = rawget(_G, "BuildName")
        }
      end,
      "__class",
      "XText",
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "DrawOnTop",
      true,
      "HandleMouse",
      false,
      "TextStyle",
      "ConsoleLog",
      "Translate",
      true,
      "Text",
      T(507730380699, "Version <u(ver)><opt(build, ' - ', '')>")
    })
  })
})
