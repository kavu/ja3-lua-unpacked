PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "PGMainActions",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idContinue",
      "ActionName",
      T(621514059338, "CONTINUE"),
      "ActionToolbar",
      "mainmenu",
      "ActionState",
      function(self, host)
        return g_LatestSave and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        if self:ActionState() == "enabled" then
          local saveLoadObj = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
          saveLoadObj:Load(host, g_LatestSave, Platform.developer)
        end
      end
    }),
    PlaceObj("XTemplateForEach", {
      "array",
      function(parent, context)
        return GameStartTypes
      end,
      "condition",
      function(parent, context, item, i)
        return item.id ~= "QuickStart" and item.id ~= "Satellite"
      end,
      "run_after",
      function(child, context, item, i, n, last)
        child.ActionId = item.id
        child.ActionName = item.Name
        function child.OnAction(...)
          if Platform.developer then
            g_DbgAutoClickLoadingScreenStart = false
          end
          item.func()
        end
      end
    }, {
      PlaceObj("XTemplateAction", {
        "ActionToolbar",
        "mainmenu",
        "OnActionEffect",
        "close",
        "OnAction",
        function(self, host, source, ...)
          local effect = self.OnActionEffect
          local param = self.OnActionParam
          if effect == "close" and host and host.window_state ~= "destroying" then
            host:Close(param ~= "" and param or nil)
          elseif effect == "mode" and host then
            host:SetMode(param)
          elseif effect == "back" and host then
            SetBackDialogMode(host)
          else
            if effect == "popup" then
              local actions_view = GetParentOfKind(source, "XActionsView")
              if actions_view then
                actions_view:PopupAction(self.ActionId, host, source)
              else
                XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
              end
            else
            end
          end
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idMultiplayer",
      "ActionName",
      T(787666103448, "MULTIPLAYER"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        if Platform.developer then
          g_DbgAutoClickLoadingScreenStart = false
        end
        MultiplayerLobbySetUI("multiplayer")
      end,
      "__condition",
      function(parent, context)
        return not Platform.demo and not Game
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idLoad",
      "ActionName",
      T(222566664371, "LOAD GAME"),
      "ActionToolbar",
      "mainmenu",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "LoadWIP",
      "OnAction",
      function(self, host, source, ...)
        local effect = self.OnActionEffect
        local param = self.OnActionParam
        if effect == "close" and host and host.window_state ~= "destroying" then
          host:Close(param ~= "" and param or nil)
        elseif effect == "mode" and host then
          host:SetMode(param)
          CreateRealTimeThread(function()
            LoadingScreenOpen("idLoadingScreen", "save load")
            local saves = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
            saves:WaitGetSaveItems()
            LoadingScreenClose("idLoadingScreen", "save load")
            Sleep(5)
            g_SelectedSave = false
            host:ResolveId("idSubContent"):SetMode("loadgame", saves)
            host:ResolveId("idSubMenuTittle"):SetText(self.ActionName)
          end)
        elseif effect == "back" and host then
          SetBackDialogMode(host)
        else
          if effect == "popup" then
            local actions_view = GetParentOfKind(source, "XActionsView")
            if actions_view then
              actions_view:PopupAction(self.ActionId, host, source)
            else
              XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
            end
          else
          end
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idOptions",
      "ActionName",
      T(670984943483, "OPTIONS"),
      "ActionToolbar",
      "mainmenu",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "Options",
      "OnAction",
      function(self, host, source, ...)
        local effect = self.OnActionEffect
        local param = self.OnActionParam
        if effect == "close" and host and host.window_state ~= "destroying" then
          host:Close(param ~= "" and param or nil)
        elseif effect == "mode" and host then
          host:SetMode(param)
          local displayOptions = OptionsCategories[1]
          host:ResolveId("idSubContent"):SetMode("options", {optObj = displayOptions})
          host:ResolveId("idSubSubContent"):SetMode("empty")
          host:ResolveId("idSubMenuTittle"):SetText(displayOptions.display_name)
          host:ResolveId("idList")[1].idBtnText:SetTextStyle("MMButtonTextSelected")
          host:ResolveId("idList")[1].focused = true
          host:ResolveId("idList")[1].enabled = false
        elseif effect == "back" and host then
          SetBackDialogMode(host)
        else
          if effect == "popup" then
            local actions_view = GetParentOfKind(source, "XActionsView")
            if actions_view then
              actions_view:PopupAction(self.ActionId, host, source)
            else
              XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
            end
          else
          end
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idCredits",
      "ActionName",
      T(854488533674, "CREDITS"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        OpenDialog("Credits")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idMods",
      "ActionName",
      T(405038833124, "Mod Manager"),
      "ActionToolbar",
      "mainmenu",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "ModManager",
      "OnAction",
      function(self, host, source, ...)
        local effect = self.OnActionEffect
        local param = self.OnActionParam
        if effect == "close" and host and host.window_state ~= "destroying" then
          host:Close(param ~= "" and param or nil)
        elseif effect == "mode" and host then
          CreateRealTimeThread(function()
            LoadingScreenOpen("idLoadingScreen", "load mods")
            ModsUIObjectCreateAndLoad()
            LoadingScreenClose("idLoadingScreen", "load mods")
            Sleep(1)
            host:SetMode(param)
            UpdateModsCount(host)
            host:ResolveId("idSubContent"):SetMode("installedmods")
            host:ResolveId("idSubMenuTittle"):SetText(self.ActionName)
          end)
        elseif effect == "back" and host then
          SetBackDialogMode(host)
        elseif effect == "popup" then
          local actions_view = GetParentOfKind(source, "XActionsView")
          if actions_view then
            actions_view:PopupAction(self.ActionId, host, source)
          else
            XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
          end
        end
      end,
      "__condition",
      function(parent, context)
        return Platform.desktop and not Platform.demo
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idQuit",
      "ActionName",
      T(747351508877, "QUIT"),
      "ActionToolbar",
      "mainmenu",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        QuitGame(host)
      end,
      "__condition",
      function(parent, context)
        return not Platform.console
      end
    })
  })
})
