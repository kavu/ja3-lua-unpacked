PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "IGMainActions",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idClose",
      "ActionName",
      T(236424697363, "RETURN TO GAME"),
      "ActionToolbar",
      "mainmenu",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idSave",
      "ActionName",
      T(711143528069, "Save Game"),
      "ActionToolbar",
      "mainmenu",
      "ActionState",
      function(self, host)
        return CanSaveGame() and "enabled" or "disabled"
      end,
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "SaveWIP",
      "OnAction",
      function(self, host, source, ...)
        host:SetMode(self.OnActionParam)
        CreateRealTimeThread(function()
          LoadingScreenOpen("idLoadingScreen", "save load")
          local saves = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
          saves:WaitGetSaveItems()
          WaitCaptureCurrentScreenshot()
          LoadingScreenClose("idLoadingScreen", "save load")
          Sleep(5)
          g_SelectedSave = false
          if host.window_state == "destroying" then
            return
          end
          host:ResolveId("idSubContent"):SetMode("savegame", saves)
          host:ResolveId("idSubMenuTittle"):SetText(self.ActionName)
        end)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idLoad",
      "ActionName",
      T(844486065439, "Load Game"),
      "ActionToolbar",
      "mainmenu",
      "ActionState",
      function(self, host)
        return CanLoadGame() and "enabled" or "disabled"
      end,
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
            if host.window_state == "destroying" then
              return
            end
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
      "idReplays",
      "ActionName",
      T(159033147825, "LOAD REPLAY"),
      "ActionToolbar",
      "mainmenu",
      "ActionState",
      function(self, host)
        return CanLoadGame() and "enabled" or "disabled"
      end,
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "replays",
      "OnAction",
      function(self, host, source, ...)
        local err, files = AsyncListFiles(config.GameRecordsPath, "*", "recursive")
        if err then
          print(err)
          return
        end
        files = table.reverse(files)
        host:SetMode(self.OnActionParam)
        host:ResolveId("idSubContent"):SetMode(self.OnActionParam, files)
        host:ResolveId("idSubMenuTittle"):SetText(self.ActionName)
      end,
      "__condition",
      function(parent, context)
        return ShowReplayUI
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idMultiplayer",
      "ActionName",
      T(834155302103, "Multiplayer"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        MultiplayerInGameHostSetUI()
      end,
      "__condition",
      function(parent, context)
        return not Platform.demo and Game and Game.CampaignStarted
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idHelp",
      "ActionName",
      T(197682800350, "Help"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
        OpenHelpMenu()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idMercControl",
      "ActionName",
      T(686499586296, "Co-Op Merc Control"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
        NetSyncEvent("OpenCoopMercsManagement")
      end,
      "__condition",
      function(parent, context)
        return IsCoOpGame() and NetIsHost()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idOptions",
      "ActionName",
      T(541172222567, "Options"),
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
      "idCheats",
      "ActionName",
      T(467200053152, "Cheats"),
      "ActionToolbar",
      "mainmenu",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "Cheats",
      "__condition",
      function(parent, context)
        return AreCheatsEnabled()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idBugReport",
      "ActionName",
      T(712641969318, "Bug Report"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
        CreateRealTimeThread(CreateXBugReportDlg)
      end,
      "__condition",
      function(parent, context)
        return not Platform.steamdeck
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCombatTest",
      "ActionName",
      T(419346159695, "Combat Tests"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "MAPS",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "CombatTest"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idQuickStart",
      "ActionName",
      T(755922374863, "QUICK START"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "MAPS",
      "OnAction",
      function(self, host, source, ...)
        EditorDeactivate()
        local campaign = "HotDiamonds"
        local new_game_params = {difficulty = "Normal"}
        NetGossip("QuickStart", campaign, new_game_params, GetCurrentPlaytime(), Game and Game.CampaignTime)
        CreateRealTimeThread(QuickStartCampaign, campaign, new_game_params)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatEndingPeace",
      "ActionName",
      T(177454894846, "Ending (Peace)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "MAPS",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncEvent("HotDiamonds_SetupEnding", "peace")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatEndingCivilWar",
      "ActionName",
      T(946956453030, "Ending (Civil War)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "MAPS",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncEvent("HotDiamonds_SetupEnding", "civil war")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatEndingCoup",
      "ActionName",
      T(818511714716, "Ending (Coup)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "MAPS",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncEvent("HotDiamonds_SetupEnding", "coup")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idAddMerc",
      "ActionName",
      T(111489019094, "Add Mercenary"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "HIRING",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "AddMerc"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idRemoveMerc",
      "ActionName",
      T(442809960593, "Remove Mercenary"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "HIRING",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "RemoveMerc"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idPresetSquad",
      "ActionName",
      T(447764793539, "Change to Preset Squad"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "HIRING",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "PresetSquad",
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idAddWeapon",
      "ActionName",
      T(974342367497, "Add Weapon"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "AddWeapon"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idMercHireStatus",
      "ActionName",
      T(302308637832, "Set Merc Hire Status"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "HIRING",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "MercHireStatus"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idStartCombatNow",
      "ActionName",
      T(857058944110, "Start Combat Now"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatDbgStartCombat()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idKillEnemies",
      "ActionName",
      T(363109047049, "Kill Enemies"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("KillAllEnemies")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idEnableTeleport",
      "ActionName",
      T(523255580551, "Enable Teleport"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CheatEnableTeleport()
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idExecute",
      "ActionName",
      T(172819835508, "Execute..."),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          local text = WaitInputText(nil, "Enter code to execute:")
          if text then
            local f, err = load(text)
            if f then
              f()
              NetGossip("CheatExecute...", text, GetCurrentPlaytime(), Game and Game.CampaignTime)
              CloseMenuDialogs()
            else
              WaitMessage(terminal.desktop, Untranslated("Error"), Untranslated(err))
            end
          end
        end)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleTeamGodMode",
      "ActionName",
      T(144846950782, "God Mode (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CheatPoVTeam("GodMode")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleTeamInfiniteAP",
      "ActionName",
      T(420637931620, "Infinite AP (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CheatPoVTeam("InfiniteAP")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleInvulnerability",
      "ActionName",
      T(317031106564, "Invulnerability (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CheatPoVTeam("Invulnerability")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleAlwaysHit",
      "ActionName",
      T(474038022265, "Always Hit (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("AlwaysHit")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleAlwaysMiss",
      "ActionName",
      T(607830665050, "Always Miss (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("AlwaysMiss")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleWeakDamage",
      "ActionName",
      T(844770719605, "Weak Damage (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("WeakDamage")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleStrongDamage",
      "ActionName",
      T(231819785763, "Strong Damage (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("StrongDamage")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleInGameInterface",
      "ActionName",
      T(708163662590, "Toggle Game UI"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "CombatUIHidden")
        CloseMenuDialogs()
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat; enabling will prevent unit Stealth",
      "RolloverText",
      T(162270591211, "Warning: enabling this will make units unable to become Hidden."),
      "ActionId",
      "idToggleFullVisibility",
      "ActionName",
      T(692386507713, "Full Visibility (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("FullVisibility")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleVisibleCth",
      "ActionName",
      T(273270532651, "Show Chance to Hit (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "ShowCth")
        CloseMenuDialogs()
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleBigGuns",
      "ActionName",
      T(606913569390, "Big Guns (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "BigGuns")
        CloseMenuDialogs()
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleAutoResolveWins",
      "ActionName",
      T(728314285388, "Autoresolve Wins (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("AutoResolve")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleFreeParts",
      "ActionName",
      T(516122668721, "Parts Costs (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("FreeParts")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleFreeMeds",
      "ActionName",
      T(562777735588, "Meds Costs (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("FreeMeds")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleSkillCheck",
      "ActionName",
      T(691839939763, "Successful skill check (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("SkillCheck")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleOneHpEnemies",
      "ActionName",
      T(712435441991, "OneHpEnemies (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("OneHpEnemies")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleFastActivity",
      "ActionName",
      T(434093606970, "Fast Operation (toggle)"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        NetSyncCheatEnableIG("FastActivity")
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idLevelUp",
      "ActionName",
      T(932813475139, "Level Up"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CheatSelectedObjLevelUp()
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idLevelUpMax",
      "ActionName",
      T(651121926194, "Level Up Max"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CheatSelectedObjLevelUp(true)
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idRestoreEnergy",
      "ActionName",
      T(554288963755, "Restore Energy"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CheatRestoreEnergy()
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idRevealTraps",
      "ActionName",
      T(960199362383, "Reveal Traps"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CheatRevealTrapsIG()
        CloseMenuDialogs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idHeallMercs",
      "ActionName",
      T(898477935029, "Heal Mercenaries"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatHealAllMercs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatGetMoney",
      "ActionName",
      T(402856397119, "Add Money"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("CheatGetMoney")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatAddAmmo",
      "ActionName",
      T(792619595144, "Add Ammo"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("CheatAddAmmo", SelectedObj)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatRevealIntel",
      "ActionName",
      T(105628626083, "Reveal Intel for current sector"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("CheatRevealIntelForCurrentSector")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idCheatUnlockAIMPremium",
      "ActionName",
      T(423599907055, "Unlock A.I.M. Gold"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "HIRING",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("CheatUnlockAIMPremium")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idSetLoyalty",
      "ActionName",
      T(921070062585, "Set Loyalty"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "SetLoyaltyCheat"
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleAmbientLife",
      "ActionName",
      T(151350874939, "Toggle Ambient Life"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "ActionShortcut",
      "Alt-Shift-A",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "ToggleAmbientLife",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncEvents.CheatEnable("FullVisibility", true)
        Msg("WallVisibilityChanged")
        AmbientLifeToggle()
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      T(309513569916, "Reveals Intel for current sector"),
      "ActionId",
      "idTriggerWorldFlipCheat",
      "ActionName",
      T(883426138654, "Trigger World Flip"),
      "ActionIcon",
      "CommonAssets/UI/Icons/internet search web.png",
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncEvent("CheatWorldFlip")
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idToggleCMT",
      "ActionName",
      T(287218548799, "Toggle Hiding Trees/Roofs"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "ActionShortcut",
      "Alt-Shift-H",
      "OnActionEffect",
      "mode",
      "OnActionParam",
      "ToggleAmbientLife",
      "OnAction",
      function(self, host, source, ...)
        CheatToggleHideTreeRoofs()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idSelectAnyUnit",
      "ActionName",
      T(184045723568, "Select Any Unit"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnActionEffect",
      "back",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatSelectAnyUnit()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idClearSelection",
      "ActionName",
      T(538170260107, "Clear Selection"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "GENERAL",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatClearSelection()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idGrantAP10",
      "ActionName",
      T(231842539172, "Grant AP 10"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatGrantSelectedObjAP(10)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idGrantAP100",
      "ActionName",
      T(657226502864, "Grant AP 100"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatGrantSelectedObjAP(100)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idRemoveAP1",
      "ActionName",
      T(878513566041, "Remove 1 AP"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatRemoveSelectedObjAP(1)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idAdd10MercStats",
      "ActionName",
      T(304451034300, "Add +10 merc stats"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatIG("CheatAddMercStats")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idRespecPerkPoints",
      "ActionName",
      T(144644896837, "Respec Perk Points"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        CheatRespecPerkPoints(SelectedObj)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idShowSquadsPower",
      "ActionName",
      T(917884301069, "Show squads power"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        NetSyncCheatEnableIG("ShowSquadsPower")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cheat",
      "ActionId",
      "idAchievementsDebug",
      "ActionName",
      T(769821748902, "Achievements"),
      "ActionToolbar",
      "cheats",
      "ActionToolbarSection",
      "COMBAT",
      "OnAction",
      function(self, host, source, ...)
        CloseMenuDialogs()
        OpenDialog("AchievementsDebug")
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idQuit",
      "ActionName",
      T(469439401526, "Main Menu"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          if WaitQuestion(host, T(824112417429, "Warning"), T(356287104069, "Exit to the main menu?"), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
            LoadingScreenOpen("idLoadingScreen", "main menu")
            if Game and gv_InitialHiringDone then
              RequestAutosave({
                autosave_id = "exitGame",
                save_state = "ExitGame",
                display_name = T({
                  380441884540,
                  "<u(Id)>_ExitGame",
                  gv_Sectors[gv_CurrentSectorId]
                }),
                mode = "immediate"
              })
            end
            host:Close()
            OpenPreGameMainMenu("")
            LoadingScreenClose("idLoadingScreen", "main menu")
          end
        end)
      end
    })
  })
})
