PlaceObj("XTemplate", {
  group = "Zulu",
  id = "OptionsActions",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateForEach", {
      "comment",
      "categories",
      "array",
      function(parent, context)
        return OptionsCategories
      end,
      "condition",
      function(parent, context, item, i)
        return not prop_eval(item.no_edit, nil, item) and item.id ~= "Credits"
      end,
      "__context",
      function(parent, context, item, i, n)
        return item
      end,
      "run_after",
      function(child, context, item, i, n, last)
        child.ActionId = i
        child.ActionName = item.display_name
        child.OnActionEffect = "mode"
        child:SetActionToolbar("mainmenu")
      end
    }, {
      PlaceObj("XTemplateAction", {
        "OnAction",
        function(self, host, source, ...)
          local currentOpened = GetDialogModeParam(host:ResolveId("idSubContent"))
          if currentOpened then
            if currentOpened.optObj.id == "Display" then
              CancelDisplayOptions(host:ResolveId("idSubMenu"))
            else
              CancelOptions(host:ResolveId("idSubMenu"))
            end
          end
          if OptionsCategories[self.ActionId].id == "Keybindings" then
            host:ResolveId("idMainMenuButtonsContent"):SetMode("keybindings")
            host:ResolveId("idSubContent"):SetMode("options", {
              optObj = OptionsCategories[table.find(OptionsCategories, "id", "Keybindings")]
            })
          else
            host:ResolveId("idSubContent"):SetMode("options", {
              optObj = OptionsCategories[self.ActionId]
            })
            for _, button in ipairs(host:ResolveId("idList")) do
              if button.class == "XButton" then
                local textId = button.idBtnText
                if button.action and button == source then
                  textId:SetTextStyle("MMButtonTextSelected")
                  button.focused = true
                  button.enabled = false
                else
                  textId:SetTextStyle("MMButtonText")
                  button.focused = false
                  button.enabled = true
                end
              end
            end
          end
          host:ResolveId("idSubSubContent"):SetMode("empty")
          host:ResolveId("idSubMenuTittle"):SetText(self.ActionName)
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idBack",
      "ActionName",
      T(849407578275, "BACK"),
      "ActionToolbar",
      "mainmenu",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "back",
      "OnAction",
      function(self, host, source, ...)
        host:ResolveId("idSubMenuTittle"):SetText(T(""))
        local currentOpened = GetDialogModeParam(host:ResolveId("idSubContent"))
        if currentOpened then
          if currentOpened.optObj.id == "Display" then
            CancelDisplayOptions(host:ResolveId("idSubMenu"), "clear")
          else
            CancelOptions(host:ResolveId("idSubMenu"), "clear")
          end
        else
          XAction.OnAction(self, host, source)
        end
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idGoToSubMenu",
      "ActionGamepad",
      "DPadRight",
      "ActionState",
      function(self, host)
        return GoToSubMenu_ActionState(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        GoToSubMenu_OnAction(self, host, source, ...)
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idGoToSubMenu",
      "ActionGamepad",
      "LeftThumbRight",
      "ActionState",
      function(self, host)
        return GoToSubMenu_ActionState(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        GoToSubMenu_OnAction(self, host, source, ...)
      end,
      "FXPress",
      "MainMenuButtonClick"
    })
  })
})
