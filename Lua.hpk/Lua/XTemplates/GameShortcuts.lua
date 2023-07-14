PlaceObj("XTemplate", {
  Comment = "Game-specific shortcuts and Cheats",
  RequireActionSortKeys = true,
  group = "Shortcuts",
  id = "GameShortcuts",
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Debug",
    "ActionSortKey",
    "5000",
    "ActionTranslate",
    false,
    "ActionName",
    "Debug",
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ToggleGameSessionExport",
      "ActionSortKey",
      "950",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Game Session Export",
      "ActionIcon",
      "CommonAssets/UI/Icons/analytics document file paper report statistics",
      "OnAction",
      function(self, host, source, ...)
        DbgToggleGameSessionExport()
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Show/Hide the User Actions menu (~)",
    "ActionId",
    "DE_Menu",
    "ActionSortKey",
    "998",
    "ActionTranslate",
    false,
    "ActionIcon",
    "CommonAssets/UI/Menu/default.tga",
    "ActionShortcut",
    "-~",
    "OnAction",
    function(self, host, source, ...)
      if Platform.developer and not Platform.ged and AreCheatsEnabled() then
        if IsEditorActive() then
          XShortcutsTarget:FocusSearch()
        else
          XShortcutsTarget:Toggle()
        end
      end
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Shows console (Enter, Alt-Shift-C)",
    "ActionId",
    "DE_Console",
    "ActionSortKey",
    "999",
    "ActionTranslate",
    false,
    "ActionShortcut",
    "Enter",
    "ActionShortcut2",
    "Alt-Shift-C",
    "OnAction",
    function(self, host, source, ...)
      if Platform.developer then
        ShowConsole(true)
      end
    end,
    "__condition",
    function(parent, context)
      return AreCheatsEnabled() or ConsoleEnabled or config.LuaDebugger
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "E_SelectedGridMarker",
    "ActionMode",
    "Editor",
    "ActionSortKey",
    "1000",
    "ActionTranslate",
    false,
    "ActionName",
    "Open in Grid Marker Editor",
    "ActionIcon",
    "CommonAssets/UI/Menu/object_options.tga",
    "ActionState",
    function(self, host)
      local sel = editor.GetSel()
      for _, obj in ipairs(sel) do
        if IsKindOf(obj, "GridMarker") then
          return
        end
      end
      return "hidden"
    end,
    "OnAction",
    function(self, host, source, ...)
      local grid_markers = table.ifilter(editor.GetSel(), function(_, o)
        return IsKindOf(o, "GridMarker")
      end)
      OpenGedGridMarkersEditor(grid_markers)
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Cheats",
    "ActionSortKey",
    "1010",
    "ActionTranslate",
    false,
    "ActionName",
    "Cheats",
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewGame",
      "ActionSortKey",
      "1020",
      "ActionTranslate",
      false,
      "ActionName",
      "New Game",
      "ActionIcon",
      "CommonAssets/UI/Menu/folder.tga",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GameStartTypes
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.ActionId = item.id
          child.ActionName = item.Name
          child.OnAction = item.func
          child:SetActionSortKey("0" .. tostring(i))
        end
      }, {
        PlaceObj("XTemplateAction", {
          "ActionIcon",
          "CommonAssets/UI/Icons/media play",
          "replace_matching_id",
          true
        })
      }),
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          local err, savegames = AsyncListFiles("svnAssets/Source/TestSaves/", "*.savegame.sav")
          if err then
            return ""
          else
            return savegames
          end
        end,
        "run_after",
        function(child, context, item, i, n, last)
          local _, file, ext = SplitPath(item)
          child.ActionId = file
          child.ActionName = file
          function child.OnAction()
            CreateRealTimeThread(function(file, ext)
              LoadingScreenOpen("idLoadingScreen", "save load")
              local err = LoadGame(file .. ext)
              if err then
                print(err)
              end
              LoadingScreenClose("idLoadingScreen", "save load")
            end, file, ext)
          end
          child:SetActionSortKey("1" .. tostring(i))
        end
      }, {
        PlaceObj("XTemplateAction", {
          "ActionTranslate",
          false,
          "ActionIcon",
          "CommonAssets/UI/Icons/media play"
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Quick Test Exploration",
      "RolloverText",
      "Quick Test Exploration",
      "ActionId",
      "TestExploration",
      "ActionSortKey",
      "1030",
      "ActionTranslate",
      false,
      "ActionName",
      "Quick Test Exploration",
      "ActionIcon",
      "CommonAssets/UI/Icons/map.png",
      "ActionShortcut",
      "Ctrl-Shift-E",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          DbgStartExploration()
        end)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Test Ambient Life",
      "RolloverText",
      "Quick Test Ambient Life",
      "ActionId",
      "QuickTestAmbientLife",
      "ActionSortKey",
      "1040",
      "ActionTranslate",
      false,
      "ActionName",
      "Quick Test Ambient Life",
      "ActionIcon",
      "CommonAssets/UI/Icons/map.png",
      "ActionShortcut",
      "Alt-Shift-A",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvents.CheatEnable("FullVisibility", true)
        Msg("WallVisibilityChanged")
        AmbientLifeToggle()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Start Combat Now",
      "RolloverText",
      "Start Combat Now",
      "ActionId",
      "TestCombat",
      "ActionSortKey",
      "1060",
      "ActionTranslate",
      false,
      "ActionName",
      "Start Combat Now",
      "ActionIcon",
      "CommonAssets/UI/Icons/starburst.png",
      "OnAction",
      function(self, host, source, ...)
        CheatDbgStartCombat()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Achievements Debug",
      "ActionId",
      "AchievementsDebug",
      "ActionSortKey",
      "1060",
      "ActionTranslate",
      false,
      "ActionName",
      "Achievements Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/achievement medal winner",
      "ActionShortcut",
      "Alt-Shift-Y",
      "OnAction",
      function(self, host, source, ...)
        OpenDialog("AchievementsDebug")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Reset achievements",
      "ActionId",
      "ResetAchievements",
      "ActionSortKey",
      "1060",
      "ActionTranslate",
      false,
      "ActionName",
      "Reset Achievements",
      "ActionIcon",
      "CommonAssets/UI/Icons/achievement medal winner",
      "OnAction",
      function(self, host, source, ...)
        ResetAchievements()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Select any unit",
      "RolloverText",
      "Can selects unit not under control - enemy, dead, controlled by another player",
      "ActionId",
      "SelectAnyUnit",
      "ActionSortKey",
      "1070",
      "ActionTranslate",
      false,
      "ActionName",
      "Select Any Unit",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "ActionShortcut",
      "Ctrl-Shift-MouseL",
      "OnAction",
      function(self, host, source, ...)
        CheatSelectAnyUnit()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Clear Selection",
      "RolloverText",
      "Clear Selection",
      "ActionId",
      "ClearSelection",
      "ActionSortKey",
      "1080",
      "ActionTranslate",
      false,
      "ActionName",
      "Clear Selection",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "ActionShortcut",
      "Ctrl-Shift-MouseR",
      "OnAction",
      function(self, host, source, ...)
        SelectObj()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "grant 10 ap",
      "RolloverText",
      "grant 10 ap to current unit",
      "ActionId",
      "Grant10AP",
      "ActionSortKey",
      "1090",
      "ActionTranslate",
      false,
      "ActionName",
      "Grant 10 AP",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        CheatGrantSelectedObjAP(10)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "grant 100 ap",
      "RolloverText",
      "grant 100 ap to current unit",
      "ActionId",
      "Grant100AP",
      "ActionSortKey",
      "1100",
      "ActionTranslate",
      false,
      "ActionName",
      "Grant 100 AP",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "ActionShortcut",
      "Ctrl-Alt-J",
      "OnAction",
      function(self, host, source, ...)
        CheatGrantSelectedObjAP(100)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "remove 1 ap",
      "RolloverText",
      "remove 1 ap to current unit",
      "ActionId",
      "Remove1AP",
      "ActionSortKey",
      "1110",
      "ActionTranslate",
      false,
      "ActionName",
      "Remove 1 AP",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        CheatRemoveSelectedObjAP(1)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Adds 100 ammo of each type",
      "RolloverText",
      "Fills up each weapon and gives 100 ammo of each type in squad inventory.",
      "ActionId",
      "AddAmmo",
      "ActionSortKey",
      "1120",
      "ActionTranslate",
      false,
      "ActionName",
      "Add Ammo",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatAddAmmo", SelectedObj)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Add +10 merc stats",
      "RolloverText",
      "Add +10 to all merc stats.",
      "ActionId",
      "AddMercStats",
      "ActionSortKey",
      "1120",
      "ActionTranslate",
      false,
      "ActionName",
      "Add +10 Merc Stats",
      "ActionIcon",
      "UI/Icons/hf_elite",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatAddMercStats")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Grants 100,000 money",
      "RolloverText",
      "Grants 100,000 money",
      "ActionId",
      "GetMoney",
      "ActionSortKey",
      "1130",
      "ActionTranslate",
      false,
      "ActionName",
      "Get $100 000",
      "ActionIcon",
      "CommonAssets/UI/Icons/accessories bra clothes clothing fashion underwear woman.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatGetMoney")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "god mode",
      "RolloverText",
      "Enable God Mode",
      "ActionId",
      "GodMode",
      "ActionSortKey",
      "1140",
      "ActionTranslate",
      false,
      "ActionName",
      "God Mode",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        local pov_team = GetPoVTeam()
        if pov_team then
          NetSyncEvent("CheatEnable", "GodMode", nil, pov_team.side)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "panic selected",
      "RolloverText",
      "Enable God Mode",
      "ActionId",
      "PanicSelectedUnit",
      "ActionSortKey",
      "1150",
      "ActionTranslate",
      false,
      "ActionName",
      "Panic Selected Unit",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        if IsKindOf(SelectedObj, "Unit") then
          NetSyncEvent("CheatEnable", "PanicUnit", nil, nil, SelectedObj)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "kill enemies",
      "RolloverText",
      "kill all enemies on the map",
      "ActionId",
      "KillEnemies",
      "ActionSortKey",
      "1160",
      "ActionTranslate",
      false,
      "ActionName",
      "Kill Enemies",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("KillAllEnemies")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "rendering stats markers debug",
      "RolloverText",
      "Rendering stats markers debug",
      "ActionId",
      "StatsMarkersDebug",
      "ActionSortKey",
      "1170",
      "ActionTranslate",
      false,
      "ActionName",
      "Stats Markers Debug",
      "ActionShortcut",
      "Alt-Shift-R",
      "OnAction",
      function(self, host, source, ...)
        StatsMarkerDebugNext()
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Level Up",
      "RolloverText",
      "Level up selected unit",
      "ActionId",
      "LevelUp",
      "ActionSortKey",
      "1180",
      "ActionTranslate",
      false,
      "ActionName",
      "LevelUp",
      "ActionIcon",
      "CommonAssets/UI/Icons/arrow double up.png",
      "OnAction",
      function(self, host, source, ...)
        if not SelectedObj or not IsKindOfClasses(SelectedObj, "Unit", "UnitData") then
          return
        end
        local u = SelectedObj
        local dlg = GetDialog("FullscreenGameDialogs")
        if dlg then
          u = dlg:GetContext().unit
        end
        NetSyncEvents.CheatLevelUp(u)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "defeat villains",
      "RolloverText",
      "retreat/defeat lieutenants",
      "ActionId",
      "DefeatVillains",
      "ActionSortKey",
      "1190",
      "ActionTranslate",
      false,
      "ActionName",
      "Defeat Villains",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("DefeatAllVillains")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "heal mercs",
      "RolloverText",
      "heals all mercs",
      "ActionId",
      "HealMercs",
      "ActionSortKey",
      "1200",
      "ActionTranslate",
      false,
      "ActionName",
      "Heal Mercs",
      "ActionIcon",
      "CommonAssets/UI/Icons/foot print shoe sign track.png",
      "OnAction",
      function(self, host, source, ...)
        UIHealAllMercs()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle hidden units",
      "RolloverText",
      "toggle hidden unit visibility",
      "ActionId",
      "ToggleHiddenUnits",
      "ActionSortKey",
      "1210",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Hidden Units",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        local value = rawget(_G, "g_InvisibleUnitOpacity") or 0
        rawset(_G, "g_InvisibleUnitOpacity", value == 0 and 45 or 0)
        NetSyncEvent("RecalcVisibility")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "reveal traps in sight",
      "RolloverText",
      "reveal traps in sight",
      "ActionId",
      "RevealTraps",
      "ActionSortKey",
      "1220",
      "ActionTranslate",
      false,
      "ActionName",
      "Reveal Traps",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        local pov_team = GetPoVTeam()
        if pov_team then
          NetSyncEvent("CheatRevealTraps", pov_team.side)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "reveal all sectors in Satellite View",
      "RolloverText",
      "reveal all sectors in Satellite View",
      "ActionId",
      "RevealAllSectors",
      "ActionSortKey",
      "1230",
      "ActionTranslate",
      false,
      "ActionName",
      "Reveal All Sectors(Satellite View)",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        RevealAllSectors()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle shot dispersion",
      "RolloverText",
      "toggle shot dispersion",
      "ActionId",
      "ToggleShotDispersion",
      "ActionSortKey",
      "1240",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Shot Dispersion",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        g_DrawShotDispersion = not g_DrawShotDispersion
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle auto-resolve wins",
      "RolloverText",
      "toggle auto-resolve wins",
      "ActionId",
      "ToggleAutoResolveWins",
      "ActionSortKey",
      "1250",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Auto Resolve Wins",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "AutoResolve")
        print("AutoResolve wins turned " .. (CheatEnabled("AutoResolve") and "ON" or "OFF"))
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle disable discovery alert",
      "RolloverText",
      "toggle disable discovery alert",
      "ActionId",
      "ToggleDisableDiscoveryAlert",
      "ActionSortKey",
      "1260",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Disable Discovery Alert",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "DisableDiscoveryAlert")
        print("DisableDiscoveryAlert turned " .. (CheatEnabled("DisableDiscoveryAlert") and "ON" or "OFF"))
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "RespecPerkPoints",
      "ActionSortKey",
      "1270",
      "ActionTranslate",
      false,
      "ActionName",
      "Respec Perk Points",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        CheatRespecPerkPoints(SelectedObj)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle Tac Camera Bounds Lock",
      "RolloverText",
      "Toggle Tac Camera Bounds Lock",
      "ActionId",
      "TTCBL",
      "ActionSortKey",
      "1280",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Tac Camera Bounds Lock",
      "ActionIcon",
      "CommonAssets/UI/Icons/lock login padlock password safe secure.png",
      "OnAction",
      function(self, host, source, ...)
        hr.CameraTacUseVoxelBorder = not hr.CameraTacUseVoxelBorder
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle Room/Building Invisibility",
      "RolloverText",
      "Toggle Room/Building Invisibility",
      "ActionId",
      "TRBI",
      "ActionSortKey",
      "1290",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Room/Building Invisibility",
      "ActionIcon",
      "CommonAssets/UI/Icons/home house landing page main page property real estate.png",
      "OnAction",
      function(self, host, source, ...)
        ToggleWallInvisibilityEnabled()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Toggle Wall Invisibility Debug",
      "ActionId",
      "ToggleWallInvisibilityDebug",
      "ActionSortKey",
      "1300",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Wall Invisibility Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/home house landing page main page property real estate.png",
      "OnAction",
      function(self, host, source, ...)
        CheatToggleWallInvisibilityDebug()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Toggle Wall Invisibility Outside of Combat",
      "ActionId",
      "ToggleWallInvisibilityOutsideOfCombat",
      "ActionSortKey",
      "1310",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Wall Invisibility Outside of Combat",
      "ActionIcon",
      "CommonAssets/UI/Icons/home house landing page main page property real estate.png",
      "OnAction",
      function(self, host, source, ...)
        CheatToggleWallInvisibilityOutsideOfCombat()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Track Damage to Objects",
      "ActionId",
      "TrackDamageToObjects",
      "ActionSortKey",
      "1320",
      "ActionTranslate",
      false,
      "ActionName",
      "Track Damage to Objects",
      "ActionIcon",
      "CommonAssets/UI/Icons/home house landing page main page property real estate.png",
      "OnAction",
      function(self, host, source, ...)
        if #g_TrackerTexts <= 0 then
          ShowMe("CombatObject.HitPoints")
        else
          ShowMe()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Toggle CMT Collision Debug",
      "ActionId",
      "ToggleCMTCollisionDbg",
      "ActionSortKey",
      "1330",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle CMT Collision Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/box cube geometry.png",
      "OnAction",
      function(self, host, source, ...)
        ToggleCMTCollisionDbg()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle Conversation Debug",
      "RolloverText",
      "Toggle Conversation Debug",
      "ActionId",
      "ToggleConversationDebug",
      "ActionSortKey",
      "1340",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Conversation Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/conversation discussion language.png",
      "OnAction",
      function(self, host, source, ...)
        ToggleConversationDebug()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Reveals Intel for current sector",
      "RolloverText",
      "Reveals Intel for current sector",
      "ActionId",
      "RevealIntel",
      "ActionSortKey",
      "1350",
      "ActionTranslate",
      false,
      "ActionName",
      "Reveal Intel for current sector",
      "ActionIcon",
      "CommonAssets/UI/Icons/internet search web.png",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatRevealIntelForCurrentSector")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Reveals Intel for current sector",
      "ActionId",
      "ResetBants",
      "ActionSortKey",
      "1360",
      "ActionTranslate",
      false,
      "ActionName",
      "Reset Banter Markers",
      "OnAction",
      function(self, host, source, ...)
        CheatResetBanterMarkers()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Start recording a game replay or save the current replay if recording.",
      "ActionId",
      "RecordReplay",
      "ActionSortKey",
      "1370",
      "ActionTranslate",
      false,
      "ActionName",
      "Record or Save Replay",
      "OnAction",
      function(self, host, source, ...)
        if IsGameReplayRecording() then
          SaveGameRecord()
        else
          ZuluStartRecordingReplay()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Show squads power in UI",
      "ActionId",
      "ShowSquadsPower",
      "ActionSortKey",
      "1370",
      "ActionTranslate",
      false,
      "ActionName",
      "Show squads power",
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("CheatEnable", "ShowSquadsPower")
      end
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Editors.Game",
    "ActionSortKey",
    "1380",
    "ActionMenubar",
    "DevMenu",
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "EditorShortcuts",
    "ActionSortKey",
    "1390",
    "__condition",
    function(parent, context)
      return Platform.editor
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AdjustObject",
      "ActionMode",
      "Editor",
      "ActionSortKey",
      "1400",
      "ActionShortcut",
      "J",
      "OnAction",
      function(self, host, source, ...)
        AdjustSelectionToVoxels(false)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Show Grid Marker Areas (Alt-Shift-G)",
      "RolloverText",
      "Show Grid Marker Areas (Alt-Shift-G)",
      "ActionId",
      "E_ShowGridMarkersAreas",
      "ActionMode",
      "Editor",
      "ActionSortKey",
      "1410",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/Smooth",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Alt-Shift-G",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return XEditorShowGridMarkersAreas == true
      end,
      "OnAction",
      function(self, host, source, ...)
        XEditorShowGridMarkersAreas = not XEditorShowGridMarkersAreas
        XEditorUpdateGridMarkersAreas()
        local statusbar = GetDialog("XEditorStatusbar")
        if statusbar then
          statusbar:ActionsUpdated()
        end
      end
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Visualize CMT Cube",
    "ActionId",
    "VisualizeCMTCube",
    "ActionSortKey",
    "1420",
    "ActionShortcut",
    "Ctrl-7",
    "OnAction",
    function(self, host, source, ...)
      VisualizeCMTCube()
    end,
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Toggle Blacklisted Entities Visualization",
    "ActionId",
    "ToggleBlacklistEntitiesVisualization",
    "ActionSortKey",
    "1425",
    "ActionToolbar",
    "Debug",
    "ActionShortcut",
    "Ctrl-Shift-7",
    "OnAction",
    function(self, host, source, ...)
      ToggleBlacklistEntitiesVisualization()
    end,
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Place AL_SitChair",
    "ActionId",
    "E_Place_AL_SitChair",
    "ActionSortKey",
    "1430",
    "ActionTranslate",
    false,
    "ActionName",
    "Place AL_SitChair",
    "ActionIcon",
    "CommonAssets/UI/Menu/EV_OpenFirst.tga",
    "ActionState",
    function(self, host)
      if IsKindOf(editor.GetSel()[1], "ChairSittable") then
        return
      end
      return "hidden"
    end,
    "OnAction",
    function(self, host, source, ...)
      local chair = editor.GetSel()[1]
      if not IsKindOf(chair, "ChairSittable") then
        return
      end
      local marker = PlaceObject("AL_SitChair")
      chair:Attach(marker, chair:GetSpotBeginIndex("Sit"))
      marker:Detach()
      local axis = marker:GetAxis()
      local x, y, z = axis:xyz()
      if x == 0 and y == 0 and z < 0 then
        marker:SetAxisAngle(-axis, marker:GetAngle() + 10800)
      end
      if not chair:GetPos():IsValidZ() then
        marker:SetPos(marker:GetPos():SetInvalidZ())
      end
      marker.VisitSupportCollection = marker.VisitSupportCollection or {}
      table.insert(marker.VisitSupportCollection, chair)
      marker:SetGameFlags(const.gofPermanent)
      marker:EditorEnter()
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Place AL_SitChair_SleepingAtTable",
    "ActionId",
    "E_Place_AL_SitChair_SleepingAtTable",
    "ActionSortKey",
    "1440",
    "ActionTranslate",
    false,
    "ActionName",
    "Place AL_SitChair_SleepingAtTable",
    "ActionIcon",
    "CommonAssets/UI/Menu/EV_OpenFirst.tga",
    "ActionState",
    function(self, host)
      if IsKindOf(editor.GetSel()[1], "ChairSittable") then
        return
      end
      return "hidden"
    end,
    "OnAction",
    function(self, host, source, ...)
      local chair = editor.GetSel()[1]
      if not IsKindOf(chair, "ChairSittable") then
        return
      end
      local marker = PlaceObject("AL_SitChair_SleepingAtTable")
      chair:Attach(marker, chair:GetSpotBeginIndex("Sitanddrink"))
      marker:Detach()
      local axis = marker:GetAxis()
      local x, y, z = axis:xyz()
      if x == 0 and y == 0 and z < 0 then
        marker:SetAxisAngle(-axis, marker:GetAngle() + 10800)
      end
      if not chair:GetPos():IsValidZ() then
        marker:SetPos(marker:GetPos():SetInvalidZ())
      end
      marker.VisitSupportCollection = marker.VisitSupportCollection or {}
      table.insert(marker.VisitSupportCollection, chair)
      marker:SetGameFlags(const.gofPermanent)
      marker:EditorEnter()
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "AL Visit Support Create",
    "ActionId",
    "E_AL_Marker_Visit_Support_Create",
    "ActionSortKey",
    "1450",
    "ActionTranslate",
    false,
    "ActionName",
    "AL Create Visit Support Set",
    "ActionIcon",
    "CommonAssets/UI/Menu/EV_OpenFirst.tga",
    "ActionShortcut",
    "Ctrl-Alt-Shift-A",
    "ActionState",
    function(self, host)
      local AL_marker, other_object
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") then
          AL_marker = obj
        elseif IsKindOf(obj, "Object") then
          other_object = obj
        end
        if AL_marker and other_object then
          break
        end
      end
      if not AL_marker or not other_object then
        return "hidden"
      end
    end,
    "OnAction",
    function(self, host, source, ...)
      local AL_marker
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") then
          AL_marker = obj
          break
        end
      end
      AL_marker:CreateVisitSupportCollection()
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "AL Visit Support Remove",
    "ActionId",
    "E_AL_Marker_Support_Remove",
    "ActionSortKey",
    "1460",
    "ActionTranslate",
    false,
    "ActionName",
    "AL Remove Visit Support Set",
    "ActionIcon",
    "CommonAssets/UI/Menu/EV_OpenFirst.tga",
    "ActionState",
    function(self, host)
      local AL_marker, combat_object
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") and obj.VisitSupportCollection then
          return
        end
      end
      return "hidden"
    end,
    "OnAction",
    function(self, host, source, ...)
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") and obj.VisitSupportCollection then
          obj:RemoveVisitSupportCollection()
        end
      end
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "AL Test Marker",
    "ActionId",
    "E_AL_Test_Marker",
    "ActionSortKey",
    "1470",
    "ActionTranslate",
    false,
    "ActionName",
    "AL Test Marker",
    "ActionIcon",
    "CommonAssets/UI/Menu/EV_OpenFirst.tga",
    "ActionShortcut",
    "Alt-Shift-L",
    "ActionState",
    function(self, host)
      local AL_marker
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") then
          AL_marker = obj
        end
        if AL_marker then
          break
        end
      end
      if not AL_marker then
        return "hidden"
      end
    end,
    "OnAction",
    function(self, host, source, ...)
      local AL_marker
      for _, obj in ipairs(editor.GetSel() or empty_table) do
        if IsKindOf(obj, "AmbientLifeMarker") then
          AL_marker = obj
          break
        end
      end
      if AL_marker then
        EditorDeactivate()
        AL_marker:DbgTest()
      end
    end,
    "ActionContexts",
    {
      "SingleSelection",
      "MultipleSelection"
    },
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Scripting",
    "ActionSortKey",
    "1480",
    "ActionTranslate",
    false,
    "ActionName",
    "Scripting",
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GridMarkersEditor",
      "ActionSortKey",
      "1490",
      "ActionTranslate",
      false,
      "ActionName",
      "Grid Markers",
      "ActionIcon",
      "CommonAssets/UI/Icons/dashboard display grid view layout.png",
      "OnAction",
      function(self, host, source, ...)
        OpenGedGridMarkersEditor()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SatelliteSectorsEditor",
      "ActionSortKey",
      "1500",
      "ActionTranslate",
      false,
      "ActionName",
      "Satellite Sectors",
      "ActionIcon",
      "CommonAssets/UI/Icons/globe 2.png",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          if not next(gv_Sectors) then
            if WaitQuestion(terminal.desktop, Untranslated("New Game"), Untranslated([[
To use this editor, a new game will be started, changing the current map.

You will lose all changes made. Continue?]]), Untranslated("Yes"), Untranslated("No")) ~= "ok" then
              return
            end
            QuickStartCampaign("HotDiamonds", {difficulty = "Normal"})
            WaitPlayerControl()
          end
          OpenGedSatelliteSectorEditor(Game.Campaign and CampaignPresets[Game.Campaign] or CampaignPresets.HotDiamonds)
        end)
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Characters",
    "ActionSortKey",
    "1510",
    "ActionName",
    T(856201102974, "Characters"),
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AnimMetadataEditor",
      "ActionSortKey",
      "1520",
      "ActionTranslate",
      false,
      "ActionName",
      "Anim Metadata Editor",
      "ActionIcon",
      "CommonAssets/UI/Icons/video.tga",
      "OnAction",
      function(self, host, source, ...)
        OpenAnimationMomentsEditor()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit command",
      "RolloverText",
      "toggle unit command",
      "ActionId",
      "ToggleUnitCommand",
      "ActionSortKey",
      "1530",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Command",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit.command", "Units command")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle aim IK debug",
      "RolloverText",
      "toggle aim IK debug",
      "ActionId",
      "ToggleAimIKDebug",
      "ActionSortKey",
      "1540",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Aim IK Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        local value = rawget(_G, "g_IKDebug") or false
        if value then
          rawset(_G, "g_IKDebug", false)
        else
          rawset(_G, "g_IKDebug", {})
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "show the stat gaining table",
      "ActionId",
      "ShowStatGaining",
      "ActionSortKey",
      "1550",
      "ActionTranslate",
      false,
      "ActionName",
      "Show Stat Gaining",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "ActionShortcut",
      "Ctrl-Shift-Q",
      "OnAction",
      function(self, host, source, ...)
        local unit = SelectedObj
        if unit and (IsKindOf(unit, "Unit") or IsKindOf(unit, "UnitData")) then
          local statGaining = StatGainingInspectorFormat(unit)
          if statGaining then
            Inspect(statGaining)
          end
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "spawns AL unit to test closest marker",
      "ActionId",
      "TestALMarker",
      "ActionSortKey",
      "1560",
      "ActionTranslate",
      false,
      "ActionName",
      "Test AL Closest Marker",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "ActionShortcut",
      "Alt-L",
      "OnAction",
      function(self, host, source, ...)
        DbgTestClosestALMarker()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Tests AL Zones with unchecked 'Reachable Only' property",
      "ActionId",
      "TestUnreachableALZones",
      "ActionSortKey",
      "1570",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Unreachable AL Zones",
      "ActionIcon",
      "CommonAssets/UI/Icons/group.png",
      "OnAction",
      function(self, host, source, ...)
        MapForEach("map", "AmbientZoneMarker", function(zone)
          zone:VME_Checks("check unreachables")
        end)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit anim style",
      "RolloverText",
      "toggle unit anim style",
      "ActionId",
      "ToggleAppearanceLabels",
      "ActionSortKey",
      "1580",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Appearance Labels",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("DummyUnit.Appearance", "DummyUnit Appearance")
        ToggleTextTrackers("Unit.Appearance", "Unit Appearance")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle gas masks",
      "RolloverText",
      "toggle gas masks",
      "ActionId",
      "ToggleGasMasks",
      "ActionSortKey",
      "1590",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Gas Masks",
      "OnAction",
      function(self, host, source, ...)
        MapForEach("map", "AppearanceObject", function(unit)
          local head_entity = unit.parts.Head and unit.parts.Head:GetEntity()
          if head_entity and string.match(head_entity, "GasMask") then
            unit:UnequipGasMask()
          else
            unit:EquipGasMask()
          end
        end)
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "satellite and game",
    "ActionMode",
    "Game, Satellite, UI, Exploration",
    "ActionSortKey",
    "-1"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionToggleSatellite",
      "ActionMode",
      "Game, Satellite, UI",
      "ActionSortKey",
      "1600",
      "ActionName",
      T(625126806199, "Satellite View"),
      "ActionShortcut",
      "M",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        SatelliteToggleActionRun()
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOpenCharacter",
      "ActionSortKey",
      "1610",
      "ActionName",
      T(686811210567, "Merc Info"),
      "ActionShortcut",
      "C",
      "ActionGamepad",
      "LeftTrigger-ButtonX",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if GetDialog("SatelliteConflict") then
          return "disabled"
        end
        if not AnyPlayerSquads() then
          return "disabled"
        end
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        local unit
        if gv_SatelliteView then
          local inventory = GetDialog("FullscreenGameDialogs")
          if inventory then
            unit = inventory.context.unit
          else
            local dlg = GetSatelliteDialog()
            local selSquad = dlg and dlg.selected_squad
            if not selSquad then
              return
            end
            unit = gv_UnitData[selSquad.units[1]]
          end
        elseif Selection and 1 <= #Selection then
          unit = Selection[1]
        else
          return
        end
        OpenCharacterScreen(unit)
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionLevelUpViewContextMenu",
      "ActionSortKey",
      "1620",
      "ActionName",
      T(456663890965, "Level Up"),
      "ActionState",
      function(self, host)
        if not GetInGameInterfaceModeDlg() then
          return "hidden"
        end
        local contextMenu = GetInGameInterfaceModeDlg().idContextMenu
        if not contextMenu then
          return "hidden"
        end
        local unitId = contextMenu.idContent and contextMenu.idContent.context and contextMenu.idContent.context.unit_id
        if not unitId then
          return "hidden"
        end
        local unit = g_Units[unitId] or gv_UnitData[unitId]
        return unit.perkPoints and unit.perkPoints > 0 and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        local contextMenu = GetInGameInterfaceModeDlg().idContextMenu
        if not contextMenu then
          return
        end
        local unitId = contextMenu.idContent and contextMenu.idContent.context and contextMenu.idContent.context.unit_id
        if not unitId then
          return
        end
        OpenCharacterScreen(g_Units[unitId] or gv_UnitData[unitId], "perks")
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionLevelUpView",
      "ActionSortKey",
      "1630",
      "ActionName",
      T(391831532718, "Perks"),
      "ActionShortcut",
      "L",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        local unit
        if Selection and #Selection >= 1 then
          unit = Selection[1]
        else
          return
        end
        OpenCharacterScreen(unit, "perks")
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOpenCharacterContextMenu",
      "ActionSortKey",
      "1640",
      "ActionName",
      T(455134687102, "Merc Info"),
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        local contextMenu = GetInGameInterfaceModeDlg().idContextMenu
        if not contextMenu then
          return
        end
        local unitId = contextMenu.idContent and contextMenu.idContent.context and contextMenu.idContent.context.unit_id
        if not unitId then
          return
        end
        OpenCharacterScreen(g_Units[unitId])
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "OpenHelp",
      "ActionSortKey",
      "1650",
      "ActionName",
      T(156152227082, "Show Help"),
      "ActionShortcut",
      "F1",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        return GetPreGameMainMenu() and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        OpenHelpMenu()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idInventory",
      "ActionSortKey",
      "1660",
      "ActionName",
      T(710877191741, "Inventory"),
      "ActionShortcut",
      "I",
      "ActionGamepad",
      "LeftTrigger-ButtonY",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if AnyPlayerControlStoppers() then
          return "disabled"
        end
        if GetDialog("ModifyWeaponDlg") then
          return "disabled"
        end
        if GetDialog("PDADialog") then
          return "disabled"
        end
        if GameState.disable_pda then
          return "disabled"
        end
        if not GetDialog("PDADialogSatellite") then
          return CombatActions.Inventory:GetUIState(Selection)
        end
        return "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local full_screen = GetDialog("FullscreenGameDialogs")
        if full_screen and full_screen:IsVisible() then
          full_screen:Close()
          return
        end
        if not GetDialog("PDADialogSatellite") then
          local unit = Selection[1]
          if unit then
            OpenInventory(unit)
          end
          return
        end
        local sat_dlg = GetSatelliteDialog()
        local firstUnit
        if sat_dlg then
          firstUnit = sat_dlg.selected_squad and sat_dlg.selected_squad.units and sat_dlg.selected_squad.units[1]
        elseif gv_CurrentSectorId then
          local squads = GetCurrentSectorPlayerSquads()
          if squads and 1 <= #squads then
            firstUnit = squads[1] and squads[1].units and squads[1].units[1]
          end
        end
        if not firstUnit then
          local playerSquads = GetPlayerMercSquads()
          if playerSquads and 1 <= #playerSquads then
            firstUnit = playerSquads[1] and playerSquads[1].units and playerSquads[1].units[1]
          end
        end
        if not firstUnit then
          return
        end
        local invDlg = OpenInventory(gv_UnitData[firstUnit], GetSectorInventory(self.OnActionParam))
        self.OnActionParam = false
        ObjModified(sat_dlg)
        local pdaScreen = GetDialog("PDADialogSatellite").idPDAScreen
        pdaScreen:TurnOffScreen()
        local oldClose = invDlg.Close
        function invDlg.Close(...)
          oldClose(invDlg, ...)
          pdaScreen:TurnOnScreen()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionInGameMainMenu",
      "ActionSortKey",
      "1670",
      "ActionName",
      T(705614277559, "Toggle In Game Main Menu"),
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "Start",
      "OnAction",
      function(self, host, source, ...)
        local modal = terminal.desktop:GetModalWindow()
        if not modal or modal == terminal.desktop then
          OpenIngameMainMenu()
        else
          CloseIngameMainMenu()
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOpenNotes",
      "ActionSortKey",
      "1680",
      "ActionName",
      T(331467263779, "Notes"),
      "ActionShortcut",
      "F4",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if GetDialog("PDADialog") then
          return "enabled"
        end
        if GetDialog("SatelliteConflict") then
          return "disabled"
        end
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        local full_screen = GetDialog("FullscreenGameDialogs")
        if full_screen and full_screen.window_state == "open" then
          full_screen:Close()
        end
        local dlg = GetDialog("PDADialog")
        if not dlg or dlg.Mode ~= "quests" then
          OpenDialog("PDADialog", GetInGameInterface(), {Mode = "quests"})
          return
        end
        local notesDlg = dlg.idContent.idSubContent
        if notesDlg.Mode ~= "tasks" then
          notesDlg:SetMode("tasks")
          return
        end
        dlg:CloseAction(host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOpenEmail",
      "ActionSortKey",
      "1690",
      "ActionName",
      T(782869854240, "Email"),
      "ActionShortcut",
      "F6",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if GetDialog("PDADialog") then
          return "enabled"
        end
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        OpenEmail()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOpenBrowser",
      "ActionSortKey",
      "1700",
      "ActionName",
      T(304830845673, "Browser"),
      "ActionShortcut",
      "F2",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if GetDialog("PDADialog") then
          return "enabled"
        end
        return SatelliteToggleActionState()
      end,
      "OnAction",
      function(self, host, source, ...)
        local full_screen = GetDialog("FullscreenGameDialogs")
        if full_screen and full_screen.window_state == "open" then
          full_screen:Close()
        end
        local dlg = GetDialog("PDADialog")
        if dlg and dlg.Mode == "browser" then
          dlg:CloseAction(host)
        else
          OpenDialog("PDADialog", GetInGameInterface(), {Mode = "browser"})
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ModifyWeapon",
      "ActionSortKey",
      "1710",
      "ActionName",
      T(651782746273, "Weapon Mods"),
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if not GetMercInventoryDlg() then
          return "disabled"
        end
        if GetDialog("ModifyWeaponDlg") then
          return "disabled"
        end
        if IsInMultiplayerGame() and g_Combat then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local pt = terminal:GetMousePos()
        local win = terminal.desktop:GetMouseTarget(pt)
        while win and not IsKindOf(win, "XInventorySlot") do
          win = win:GetParent()
        end
        if win then
          local _, left, top = win:FindTile(pt)
          local owner = win.context
          local item = owner:GetItemInSlot(win.slot_name, false, left, top)
          if IsKindOf(item, "Firearm") then
            local dlg = GetDialog("ModifyWeaponDlg")
            if not dlg then
              OpenDialog("ModifyWeaponDlg", nil, {
                weapon = item,
                slot = owner:GetItemPackedPos(item),
                owner = owner
              })
            end
            return
          end
        end
        local inventoryUnit = GetInventoryUnit()
        if not inventoryUnit then
          return
        end
        OpenModifyFromInventory(inventoryUnit)
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idSquadManagement",
      "ActionSortKey",
      "1701",
      "ActionName",
      T(792201264072, "Manage Squads"),
      "ActionShortcut",
      "J",
      "ActionBindable",
      true,
      "ActionButtonTemplate",
      "PDACommonButton",
      "ActionState",
      function(self, host)
        if GameState.disable_pda then
          return "disabled"
        end
        return not (GetDialog("PDADialog") or GetMercInventoryDlg()) and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local pdaDiag = GetDialog("PDADialogSatellite")
        if pdaDiag then
          OpenDialog("PDASquadManagement", pdaDiag.idDisplayPopupHost)
        else
          local igi = GetInGameInterface()
          if igi then
            OpenDialog("PDASquadManagement", igi)
          end
        end
      end
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Combat",
    "ActionSortKey",
    "1720",
    "ActionName",
    T(920262040504, "Combat"),
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }, {
    PlaceObj("XTemplateAction", {
      "comment",
      "Shows All Debug Covers",
      "RolloverText",
      "Quick Test Combat",
      "ActionId",
      "ShowDebugCovers",
      "ActionSortKey",
      "1730",
      "ActionTranslate",
      false,
      "ActionName",
      "Show Debug Covers",
      "ActionIcon",
      "CommonAssets/UI/Icons/starburst.png",
      "ActionShortcut",
      "Ctrl-Shift-X",
      "OnAction",
      function(self, host, source, ...)
        DbgDrawCovers(nil, nil, nil, "hide floors")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "AI Debug",
      "RolloverText",
      "Quick Test Combat",
      "ActionId",
      "AIDebug",
      "ActionSortKey",
      "1740",
      "ActionTranslate",
      false,
      "ActionName",
      "AI Debug",
      "ActionIcon",
      "CommonAssets/UI/Icons/starburst.png",
      "OnAction",
      function(self, host, source, ...)
        SetInGameInterfaceMode("IModeAIDebug")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Shows Debug Covers around Cursor",
      "ActionId",
      "ShowCoversInRange",
      "ActionSortKey",
      "1750",
      "ActionTranslate",
      false,
      "ActionName",
      "Covers Around Cursor",
      "ActionIcon",
      "CommonAssets/UI/Menu/object_options.tga",
      "ActionShortcut",
      "Ctrl-Alt-H",
      "OnAction",
      function(self, host, source, ...)
        DbgDrawCovers("box", GetVoxelBox(0, GetCursorPos()), nil, "hide floors")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Select Debug Covers around Cursor",
      "ActionId",
      "SelectCoversInRange",
      "ActionSortKey",
      "1760",
      "ActionTranslate",
      false,
      "ActionName",
      "Covers Around Cursor",
      "ActionIcon",
      "CommonAssets/UI/Menu/object_options.tga",
      "ActionShortcut",
      "Ctrl-Shift-Z",
      "OnAction",
      function(self, host, source, ...)
        editor.ChangeSelWithUndoRedo(GetCoverObjects(GetTerrainCursor()))
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle grenade volume display",
      "RolloverText",
      "toggle grenade volumes",
      "ActionId",
      "ToggleGrenadeVolumes",
      "ActionSortKey",
      "1770",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Grenade Volumes",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        local value = not rawget(_G, "g_ShowGrenadeVolume") and true
        rawset(_G, "g_ShowGrenadeVolume", value)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle fires",
      "RolloverText",
      "toggle fires",
      "ActionId",
      "ToggleFires",
      "ActionSortKey",
      "1780",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Fires",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        ToggleFiresDebug()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle gas debug",
      "RolloverText",
      "toggle fires",
      "ActionId",
      "ToggleGas",
      "ActionSortKey",
      "1790",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Gas",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        ToggleGasDebug()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle noise sources",
      "RolloverText",
      "toggle noise sources",
      "ActionId",
      "ToggleNoiseSources",
      "ActionSortKey",
      "1800",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Noise Sources",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        ToggleNoiseSources()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle Weapon Noise",
      "RolloverText",
      "Toggle Weapon Noise",
      "ActionId",
      "ToggleWeaponNoise",
      "ActionSortKey",
      "1810",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Weapon Noise",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        DbgToggleWeaponNoise()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle voxel stealth",
      "RolloverText",
      "toggle voxel stealth",
      "ActionId",
      "ToggleVoxelStealthDbgVis",
      "ActionSortKey",
      "1820",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Voxel Stealth Dbg",
      "ActionIcon",
      "CommonAssets/UI/Icons/explore eye view vision.png",
      "ActionShortcut",
      "Alt-Shift-S",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        CycleVSDbgVisMode()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cycle environment sounds visualization",
      "RolloverText",
      "cycle environment sounds visualization",
      "ActionId",
      "CycleEnvSndVis",
      "ActionSortKey",
      "1824",
      "ActionTranslate",
      false,
      "ActionName",
      "Cycle Environmental Sounds Visualization",
      "ActionIcon",
      "CommonAssets/UI/Icons/explore eye view vision.png",
      "ActionShortcut",
      "Alt-Shift-E",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        DbgCycleEnvSoundsVis()
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
      "reset noise sources",
      "RolloverText",
      "reset noise sources",
      "ActionId",
      "ResetNoiseSources",
      "ActionSortKey",
      "1830",
      "ActionTranslate",
      false,
      "ActionName",
      "Reset Noise Sources",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        ResetNoiseSources()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Display target dummies",
      "ActionId",
      "ToggleTargetDummies",
      "ActionSortKey",
      "1840",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Target Dummies",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        DbgDrawToggleTargetDummies()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Display line of sight lines from the selected objects to his enemies",
      "ActionId",
      "ToggleLOS",
      "ActionSortKey",
      "1850",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle LOS Lines",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        DbgDrawToggleLOS()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Display line of fire lines from the selected objects to his enemies",
      "ActionId",
      "ToggleLOF",
      "ActionSortKey",
      "1860",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle LOF Lines",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        DbgDrawToggleLOF()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Display line of fire lines from the selected objects eyes",
      "ActionId",
      "ToggleLOF_Eyes",
      "ActionSortKey",
      "1861",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle LOF Eye Lines",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        s_DbgDrawLOF_EYE = not s_DbgDrawLOF_EYE
        DbgDrawToggleLOF()
        if not s_DbgDrawLOF then
          DbgDrawToggleLOF()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Display line of fire lines from the selected object to his next enemy",
      "ActionId",
      "LOFNextEnemy",
      "ActionSortKey",
      "1870",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle LOF Next Enemy",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        DbgDrawToggleLOF()
        DbgDrawLOFNext()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      "Cycles through different experimental LOS modes",
      "ActionId",
      "CycleLOS",
      "ActionSortKey",
      "1880",
      "ActionTranslate",
      false,
      "ActionName",
      "Cycle Through Experimental Line of Sight Modes",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        DbgCycleExperimentalLOS()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle ap costs",
      "RolloverText",
      "toggle ap costs",
      "ActionId",
      "ToggleAPCosts",
      "ActionSortKey",
      "1890",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle AP Costs",
      "ActionIcon",
      "CommonAssets/UI/Icons/bill currency invoice money payment.png",
      "OnAction",
      function(self, host, source, ...)
        if not Platform.developer then
          return
        end
        local value = SelectedObj and not rawget(_G, "g_APCostsShown") or false
        rawset(_G, "g_APCostsShown", value)
        if value then
          DbgDrawCombatNodes(GetCombatPath(SelectedObj))
        else
          DbgDrawCombatNodes(false)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ToggleDistractedDebug",
      "ActionSortKey",
      "2950",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Distracted Debug",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->o:GetStatusEffect(\"Distracted\") and \"Distracted\" or \"\"", "Distracted Debug")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ToggleDistanceDebug",
      "ActionSortKey",
      "3000",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Distance Debug",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->SelectedObj and o:GetDist(SelectedObj) or \"\"", "Distance Debug")
        ToggleTextTrackers("Unit->SelectedObj and o:GetDist(SelectedObj)/const.Scale.voxelSizeX or \"\"")
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "camera",
    "ActionMode",
    "Game",
    "BindingsMenuCategory",
    "Camera"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPanUp",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1900",
      "ActionName",
      T(860699076265, "Pan Up"),
      "ActionShortcut",
      "W",
      "ActionShortcut2",
      "Up",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPanDown",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1910",
      "ActionName",
      T(468155182806, "Pan Down"),
      "ActionShortcut",
      "S",
      "ActionShortcut2",
      "Down",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPanLeft",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1920",
      "ActionName",
      T(628692606069, "Pan Left"),
      "ActionShortcut",
      "A",
      "ActionShortcut2",
      "Left",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPanRight",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1930",
      "ActionName",
      T(526927962316, "Pan Right"),
      "ActionShortcut",
      "D",
      "ActionShortcut2",
      "Right",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCamRotateWithMouse",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1940",
      "ActionName",
      T(204397672331, "Camera Rotation (Hold)"),
      "ActionShortcut",
      "MouseM",
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRotLeft",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1950",
      "ActionName",
      T(779188867578, "Rotate Left"),
      "ActionShortcut",
      "Q",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRotRight",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1960",
      "ActionName",
      T(789644553765, "Rotate Right"),
      "ActionShortcut",
      "E",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionZoomIn",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1970",
      "ActionName",
      T(978592762508, "Zoom In"),
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionZoomOut",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "1980",
      "ActionName",
      T(449821348034, "Zoom Out"),
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCamFloorUp",
      "ActionSortKey",
      "1990",
      "ActionName",
      T(540203561148, "Floor Up"),
      "ActionShortcut",
      "T",
      "ActionGamepad",
      "LeftTrigger-RightThumbUp",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        return cameraTac.IsActive() and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        if camera.IsLocked() then
          return
        end
        cameraTac.SetFloor(cameraTac:GetFloor() + 1, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCamFloorDown",
      "ActionSortKey",
      "2000",
      "ActionName",
      T(569509621088, "Floor Down"),
      "ActionShortcut",
      "G",
      "ActionGamepad",
      "LeftTrigger-RightThumbDown",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        return cameraTac.IsActive() and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        if camera.IsLocked() then
          return
        end
        cameraTac.SetFloor(cameraTac:GetFloor() - 1, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCamOverview",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2010",
      "ActionName",
      T(842838970476, "Overview Camera"),
      "ActionShortcut",
      "O",
      "ActionGamepad",
      "LeftTrigger-ButtonA",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "Camera",
      "OnAction",
      function(self, host, source, ...)
        if cameraTac.GetForceOverview() then
          return "disabled"
        end
        if CurrentActionCamera then
          return "disabled"
        end
        if IsCameraLocked() then
          return "disabled"
        end
        cameraTac.SetOverview(not cameraTac.GetIsInOverview())
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCamReset",
      "ActionSortKey",
      "2020",
      "ActionName",
      T(942514416310, "Reset Camera"),
      "ActionGamepad",
      "LeftThumbClick",
      "ActionBindSingleKey",
      true,
      "OnAction",
      function(self, host, source, ...)
        ResetTacticalCamera()
      end,
      "__condition",
      function(parent, context)
        return Platform.trailer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionHideAll",
      "ActionMode",
      "ForwardToC",
      "ActionSortKey",
      "2030",
      "ActionName",
      T(257743841672, "Hide All Walls"),
      "ActionShortcut",
      "Ctrl-H",
      "ActionBindable",
      true,
      "ActionBindSingleKey",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "actionCloseTutorialPopup",
    "ActionSortKey",
    "31",
    "ActionGamepad",
    "+ButtonB",
    "ActionState",
    function(self, host)
      return CurrentTutorialPopup and "enabled" or "disabled"
    end,
    "OnAction",
    function(self, host, source, ...)
      local popupId = GetCurrentOpenedTutorialId()
      if popupId then
        TutorialDismissHint({id = popupId})
        CloseCurrentTutorialPopup()
      end
    end
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "game",
    "ActionMode",
    "Game",
    "BindingsMenuCategory",
    "Game",
    "ActionState",
    function(self, host)
      return gv_SatelliteView and "disabled"
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "EndTurn",
      "ActionSortKey",
      "2040",
      "ActionName",
      T(217018288574, "End Turn"),
      "ActionShortcut",
      "Ctrl-Enter",
      "ActionBindable",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        return g_Combat and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("EndTurn", netUniqueId)
      end,
      "IgnoreRepeated",
      true,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "EndTurn",
      "ActionSortKey",
      "2050",
      "ActionName",
      T(217018288574, "End Turn"),
      "ActionShortcut",
      "Enter",
      "ActionBindable",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        return g_Combat and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        NetSyncEvent("EndTurn", netUniqueId)
      end,
      "IgnoreRepeated",
      true,
      "__condition",
      function(parent, context)
        return not Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionAttackAim",
      "ActionSortKey",
      "2060",
      "ActionTranslate",
      false,
      "ActionName",
      "Attack Aim",
      "ActionShortcut",
      "MouseR",
      "ActionGamepad",
      "RightTrigger",
      "ActionState",
      function(self, host)
        local dlg = GetInGameInterfaceModeDlg()
        local crosshair = dlg and dlg:ResolveId("idAttackCrosshair")
        return crosshair and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetInGameInterfaceModeDlg()
        local crosshair = dlg and dlg:ResolveId("idAttackCrosshair")
        if dlg then
          crosshair:ToggleAim()
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionAttackAimGamepadReverse",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "LeftTrigger",
      "ActionState",
      function(self, host)
        local dlg = GetInGameInterfaceModeDlg()
        local crosshair = dlg and dlg:ResolveId("idAttackCrosshair")
        return crosshair and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetInGameInterfaceModeDlg()
        local crosshair = dlg and dlg:ResolveId("idAttackCrosshair")
        if dlg then
          crosshair:ToggleAim("prev")
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "toggleHide",
      "ActionSortKey",
      "2070",
      "ActionName",
      T(665673507980, "Sneak Mode"),
      "ActionShortcut",
      "H",
      "ActionBindable",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        if g_GamepadTarget then
          return "disabled"
        end
        local igiM = GetInGameInterfaceModeDlg()
        return igiM and igiM.crosshair and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local igiM = GetInGameInterfaceModeDlg()
        if IsKindOf(igiM, "IModeCommonUnitControl") then
          igiM:ToggleHide()
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPauseGame",
      "ActionSortKey",
      "2080",
      "ActionTranslate",
      false,
      "ActionName",
      "Pause Game (Developer Mode)",
      "ActionGamepad",
      "ButtonY",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        TogglePause()
      end,
      "IgnoreRepeated",
      true,
      "__condition",
      function(parent, context)
        return Platform.trailer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPauseGameKeyboard",
      "ActionSortKey",
      "2081",
      "ActionTranslate",
      false,
      "ActionName",
      "Pause Game (Developer Mode)",
      "ActionShortcut",
      "Pause",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        TogglePause()
      end,
      "IgnoreRepeated",
      true,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionSpeedUp",
      "ActionSortKey",
      "2090",
      "ActionTranslate",
      false,
      "ActionName",
      "Speed Up",
      "ActionShortcut",
      "+",
      "ActionShortcut2",
      "Numpad +",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        SetTimeFactor(Clamp(GetTimeFactor() * 12 / 10, 20, 100000), "sync")
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionSpeedDown",
      "ActionSortKey",
      "2100",
      "ActionTranslate",
      false,
      "ActionName",
      "Speed Down",
      "ActionShortcut",
      "-",
      "ActionShortcut2",
      "Numpad -",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        SetTimeFactor(Clamp(GetTimeFactor() * 10 / 12, 0, 100000), "sync")
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionToggleHighSpeed",
      "ActionSortKey",
      "2110",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle High Speed",
      "ActionShortcut",
      "Numpad *",
      "ActionShortcut2",
      "Shift-8",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        if GetTimeFactor() == const.DefaultTimeFactor then
          SetTimeFactor(const.DefaultTimeFactor * 10, "sync")
        else
          SetTimeFactor(const.DefaultTimeFactor, "sync")
        end
      end,
      "IgnoreRepeated",
      true,
      "__condition",
      function(parent, context)
        return Platform.developer
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Movement End Stance Up (DONT CHANGE SORT)",
      "RolloverText",
      T(225394721511, "Change Movement End Stance Up"),
      "ActionId",
      "MovementEndStanceUp",
      "ActionSortKey",
      "0",
      "ActionName",
      T(935905874257, "Change Stance Up while moving"),
      "ActionShortcut",
      "Ctrl-Z",
      "ActionGamepad",
      "DPadUp",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        local enabled
        local dialog = GetDialog("IModeCombatMovement") or GetDialog("IModeCombatMovingAttack")
        if dialog and dialog.targeting_blackboard and dialog.targeting_blackboard.movement_avatar then
          local rollover = dialog.targeting_blackboard.movement_avatar
          rollover = rollover and rollover.rollover
          enabled = rollover and rollover:IsVisible()
        end
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local dialog = GetDialog("IModeCombatMovement")
        if dialog and dialog.targeting_blackboard and dialog.targeting_blackboard.movement_avatar and dialog.targeting_blackboard.idUpArrow then
          if dialog.targeting_blackboard.fxToDoStance == "Crouch" then
            dialog.targeting_blackboard.playerToDoStanceAtEnd = "Standing"
          elseif dialog.targeting_blackboard.fxToDoStance == "Prone" then
            dialog.targeting_blackboard.playerToDoStanceAtEnd = "Crouch"
          end
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Movement End Stance Down (DONT CHANGE SORT)",
      "RolloverText",
      T(972189872195, "Change Movement End Stance Down"),
      "ActionId",
      "MovementEndStanceDown",
      "ActionSortKey",
      "0",
      "ActionName",
      T(315135164705, "Change Stance Down while moving"),
      "ActionShortcut",
      "Ctrl-X",
      "ActionGamepad",
      "DPadDown",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        local enabled
        local dialog = GetDialog("IModeCombatMovement") or GetDialog("IModeCombatMovingAttack")
        if dialog and dialog.targeting_blackboard and dialog.targeting_blackboard.movement_avatar then
          local rollover = dialog.targeting_blackboard.movement_avatar
          rollover = rollover and rollover.rollover
          enabled = rollover and rollover:IsVisible()
        end
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local dialog = GetDialog("IModeCombatMovement")
        if dialog and dialog.targeting_blackboard and dialog.targeting_blackboard.movement_avatar and dialog.targeting_blackboard.idDownArrow then
          if dialog.targeting_blackboard.fxToDoStance == "Crouch" then
            dialog.targeting_blackboard.playerToDoStanceAtEnd = "Prone"
          elseif dialog.targeting_blackboard.fxToDoStance == "Standing" then
            dialog.targeting_blackboard.playerToDoStanceAtEnd = "Crouch"
          end
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Change Stance Up",
      "RolloverText",
      T(261888702775, "Change Stance Up"),
      "ActionId",
      "ChangeStanceUp",
      "ActionSortKey",
      "2120",
      "ActionName",
      T(421573979767, "Change Stance Up"),
      "ActionShortcut",
      "Z",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        ChangeStanceExploration("up")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Change Stance Down",
      "RolloverText",
      T(813352149414, "Change Stance Down"),
      "ActionId",
      "ChangeStanceDown",
      "ActionSortKey",
      "2130",
      "ActionName",
      T(910731295482, "Change Stance Down"),
      "ActionShortcut",
      "X",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        ChangeStanceExploration("down")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ChangeStanceUpGamepad",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "DPadUp",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if cameraTac.GetIsInOverview() then
          return "disabled"
        end
        local igiM = GetInGameInterfaceModeDlg()
        if igiM and igiM.crosshair then
          return "disabled"
        end
        return cameraFly.IsActive() and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        GamepadFocusStanceList()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ChangeStanceDownGamepad",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "DPadDown",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if cameraTac.GetIsInOverview() then
          return "disabled"
        end
        local igiM = GetInGameInterfaceModeDlg()
        if igiM and igiM.crosshair then
          return "disabled"
        end
        return cameraFly.IsActive() and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        GamepadFocusStanceList()
      end
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      T(972189872195, "Change Movement End Stance Down"),
      "ActionId",
      "MovementKeepStance",
      "ActionSortKey",
      "2160",
      "ActionName",
      T(227386015067, "Toggle Keep Stance while Moving"),
      "ActionShortcut",
      "V",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        local enabled
        local dialog = GetDialog("IModeCombatMovement") or GetDialog("IModeCombatMovingAttack")
        if dialog and dialog.targeting_blackboard and dialog.targeting_blackboard.movement_avatar then
          local rollover = dialog.targeting_blackboard.movement_avatar
          rollover = rollover and rollover.rollover
          enabled = rollover and rollover:IsVisible()
        end
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local currentMercId = SelectedObj
        currentMercId = currentMercId and currentMercId.session_id
        if not g_MercKeepStanceOption then
          g_MercKeepStanceOption = {}
        end
        NetSyncEvent("ToggleMercKeepStance", currentMercId)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Report Bug (Ctrl-F1) currently disabled for steamdeck",
      "RolloverText",
      "Report Bug (Ctrl-F1)",
      "ActionId",
      "idBugReport",
      "ActionSortKey",
      "2160",
      "ActionTranslate",
      false,
      "ActionName",
      "Report Bug",
      "ActionShortcut",
      "Ctrl-F1",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(CreateXBugReportDlg)
      end,
      "__condition",
      function(parent, context)
        return not Platform.steamdeck
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestCombatStartFromAltShortcut1",
      "ActionSortKey",
      "2170",
      "ActionTranslate",
      false,
      "ActionName",
      "TestCombatStartFromAltShortcut1",
      "ActionShortcut",
      "Alt-1",
      "OnAction",
      function(self, host, source, ...)
        TestCombatStartFromAltShortcut(1)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestCombatStartFromAltShortcut2",
      "ActionSortKey",
      "2180",
      "ActionTranslate",
      false,
      "ActionName",
      "TestCombatStartFromAltShortcut2",
      "ActionShortcut",
      "Alt-2",
      "OnAction",
      function(self, host, source, ...)
        TestCombatStartFromAltShortcut(2)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestCombatStartFromAltShortcut3",
      "ActionSortKey",
      "2190",
      "ActionTranslate",
      false,
      "ActionName",
      "TestCombatStartFromAltShortcut3",
      "ActionShortcut",
      "Alt-3",
      "OnAction",
      function(self, host, source, ...)
        TestCombatStartFromAltShortcut(3)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestCombatStartFromAltShortcut4",
      "ActionSortKey",
      "2200",
      "ActionTranslate",
      false,
      "ActionName",
      "TestCombatStartFromAltShortcut4",
      "ActionShortcut",
      "Alt-4",
      "OnAction",
      function(self, host, source, ...)
        TestCombatStartFromAltShortcut(4)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestCombatStartFromAltShortcut5",
      "ActionSortKey",
      "2210",
      "ActionTranslate",
      false,
      "ActionName",
      "TestCombatStartFromAltShortcut5",
      "ActionShortcut",
      "Alt-5",
      "OnAction",
      function(self, host, source, ...)
        TestCombatStartFromAltShortcut(5)
      end,
      "__condition",
      function(parent, context)
        return Platform.developer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TogglePrependTranslateID",
      "ActionSortKey",
      "2211",
      "ActionTranslate",
      false,
      "ActionName",
      "TogglePrependTranslateID",
      "ActionShortcut",
      "Ctrl-Shift-D",
      "OnAction",
      function(self, host, source, ...)
        ToggleTranslatePrependIDs()
      end,
      "__condition",
      function(parent, context)
        if Platform.steam then
          local beta, branch_name = SteamGetCurrentBetaName()
          if branch_name:find("lqa") then
            return true
          end
        end
        return Platform.developer and not IsEditorActive()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextUnit",
      "ActionMode",
      "Game, UI",
      "ActionSortKey",
      "2220",
      "ActionName",
      T(534421707752, "Next Unit"),
      "ActionShortcut",
      "Tab",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 then
          return "disabled"
        end
        local modeDlg = GetInGameInterfaceModeDlg()
        if IsKindOf(modeDlg, "IModeCombatAttackBase") then
          return modeDlg.action.IsTargetableAttack and "enabled" or "disabled"
        elseif IsKindOf(modeDlg, "IModeCommonUnitControl") or IsKindOf(modeDlg, "IModeDeployment") then
          return "enabled"
        end
        return "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        local modeDlg = GetInGameInterfaceModeDlg()
        if IsKindOf(modeDlg, "IModeCombatAttackBase") then
          modeDlg:NextTarget()
        elseif IsKindOf(modeDlg, "IModeCommonUnitControl") or IsKindOf(modeDlg, "IModeDeployment") then
          modeDlg:NextUnit()
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionNextSquad",
      "ActionMode",
      "Game, UI",
      "ActionSortKey",
      "2230",
      "ActionName",
      T(519154837104, "Next Squad"),
      "ActionShortcut",
      "Ctrl-Tab",
      "ActionGamepad",
      "LeftTrigger-RightShoulder",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 then
          return "disabled"
        end
        return "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local squads, team = GetSquadsOnMap()
        if #squads <= 1 then
          return
        end
        local currentSquadIdx = table.find(squads, g_CurrentSquad)
        currentSquadIdx = currentSquadIdx + 1
        if currentSquadIdx > #squads then
          currentSquadIdx = 1
        end
        g_CurrentSquad = squads[currentSquadIdx]
        Msg("CurrentSquadChanged")
        for i, u in ipairs(team.units) do
          local squad = u:GetSatelliteSquad()
          if squad and squad.UniqueId == g_CurrentSquad then
            SelectObj(u)
            return
          end
        end
        return "break"
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPrevSquad",
      "ActionMode",
      "Game, UI",
      "ActionSortKey",
      "2231",
      "ActionTranslate",
      false,
      "ActionGamepad",
      "LeftTrigger-LeftShoulder",
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 then
          return "disabled"
        end
        return "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local squads, team = GetSquadsOnMap()
        if #squads <= 1 then
          return
        end
        local currentSquadIdx = table.find(squads, g_CurrentSquad)
        currentSquadIdx = currentSquadIdx - 1
        if currentSquadIdx < 1 then
          currentSquadIdx = #squads
        end
        g_CurrentSquad = squads[currentSquadIdx]
        Msg("CurrentSquadChanged")
        for i, u in ipairs(team.units) do
          local squad = u:GetSatelliteSquad()
          if squad and squad.UniqueId == g_CurrentSquad then
            SelectObj(u)
            return
          end
        end
        return "break"
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ViewUnit",
      "ActionSortKey",
      "2240",
      "ActionName",
      T(483343243578, "Center on Selected Merc"),
      "ActionShortcut",
      "Home",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        if SelectedObj then
          ViewPos(SelectedObj:GetPos())
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionFreeAim",
      "ActionMode",
      "Game, UI",
      "ActionSortKey",
      "2250",
      "ActionName",
      T(818860944721, "Free Aim"),
      "ActionShortcut",
      "F",
      "ActionGamepad",
      "RightTrigger-ButtonX",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        return Selection and #Selection > 0 and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        EnterFreeAimWithDefaultCombatAction(Selection[1])
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Teleport",
      "RolloverText",
      "Teleport",
      "ActionId",
      "Teleport",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2260",
      "ActionTranslate",
      false,
      "ActionName",
      "Teleport",
      "ActionIcon",
      "CommonAssets/UI/Icons/gps location map my location target.png",
      "ActionShortcut",
      "Ctrl-T",
      "ActionState",
      function(self, host)
        return CheatEnabled("Teleport") and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        CheatTeleportToCursor()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "cycle mode",
      "ActionId",
      "CrosshairCycleFiringMode",
      "ActionSortKey",
      "2270",
      "ActionName",
      T(853914412265, "Cycle Firing Modes"),
      "ActionShortcut",
      "\\",
      "ActionBindable",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetInGameInterfaceModeDlg()
        local crosshair = dlg and dlg:ResolveId("idAttackCrosshair")
        if crosshair then
          crosshair:CycleFiringModes()
        end
      end
    }),
    PlaceObj("XTemplateForEach", {
      "comment",
      "CombatActions -> Shotcut Actions",
      "array",
      function(parent, context)
        return table.keys2(CombatActions)
      end,
      "run_after",
      function(child, context, item, i, n, last)
        item = CombatActions[item]
        child.ActionId = "combatAction" .. item.id
        child.ActionBindable = item.ConfigurableKeybind and not not item.ShowIn
        child.ActionName = item.DisplayName
        child:SetActionShortcut(Platform.developer and item.ActionShortcutDev or item.ActionShortcut or nil)
        child.default_ActionShortcut = child.ActionShortcut
        child:SetActionShortcut2(item.ActionShortcut2 or nil)
        child.default_ActionShortcut2 = child.ActionShortcut2
        child:SetActionGamepad(item.ActionGamepad or nil)
        child.default_ActionGamepad = child.ActionGamepad
        local groupKey = table.find(Presets.CombatAction, Presets.CombatAction[item.group])
        child:SetActionSortKey(item.KeybindingSortId)
        StripDeveloperShortcuts(child)
      end
    }, {
      PlaceObj("XTemplateAction", {
        "BindingsMenuCategory",
        "CombatActions",
        "ActionState",
        function(self, host)
          return "disabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          PlayFX("IactDisabled")
        end,
        "IgnoreRepeated",
        true,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectBasicAttack",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2280",
      "ActionName",
      T(573776065280, "Primary Attack"),
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectHeavyAttack",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2290",
      "ActionName",
      T(964076579032, "Heavy Weapon Attack"),
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Reload",
      "ActionMode",
      "Game, UI",
      "ActionSortKey",
      "2300",
      "ActionName",
      T(499625519053, "Reload"),
      "ActionShortcut",
      "R",
      "ActionGamepad",
      "LeftTrigger-DPadLeft",
      "ActionBindable",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "OnAction",
      function(self, host, source, ...)
        CreateGameTimeThread(function()
          if Selection and #Selection > 1 then
            CombatActions.ReloadMultiSelection:UIBegin(Selection, {reload_all = true})
            return
          end
          local mode_dlg = GetInGameInterfaceModeDlg()
          if not mode_dlg or not SelectedObj then
            return
          end
          if HasCombatActionInProgress(SelectedObj) then
            return
          end
          local weaponUI = mode_dlg:ResolveId("idWeaponUI")
          local equippedSetUI = weaponUI and weaponUI:ResolveId("idEquippedSet")
          local nextToWepButtons = equippedSetUI and equippedSetUI:ResolveId("idButtons")
          local weapons = {}
          for i, wUI in ipairs(nextToWepButtons) do
            if wUI.Id ~= "idSwitch" then
              local button = wUI:ResolveId("idReloadButton")
              if button and button.enabled then
                weapons[#weapons + 1] = wUI.context
              end
              for j, swUI in ipairs(wUI) do
                local button = swUI:ResolveId("idSubReloadButton")
                if button and button.enabled then
                  weapons[#weapons + 1] = swUI.context
                end
              end
            end
          end
          for i, w in ipairs(weapons) do
            if QuickReloadButton(false, w, 1 < #weapons) then
              WaitMsg("WeaponReloaded", 1000)
            end
          end
        end)
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectSignatureAbility",
      "ActionSortKey",
      "2310",
      "ActionName",
      T(824740449786, "Talent"),
      "ActionShortcut",
      "K",
      "ActionBindable",
      true,
      "ActionBindSingleKey",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectOverwatch",
      "ActionSortKey",
      "2320",
      "ActionName",
      T(733210936253, "Overwatch / Set Machine Gun"),
      "ActionShortcut",
      "Y",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectTakedown",
      "ActionSortKey",
      "2340",
      "ActionName",
      T(983398909721, "Prepare Takedown"),
      "ActionShortcut",
      "B",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectBandage",
      "ActionSortKey",
      "2350",
      "ActionName",
      T(101582787580, "Bandage"),
      "ActionShortcut",
      "N",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectThrowGrenade",
      "ActionSortKey",
      "2360",
      "ActionName",
      T(815844645044, "Throw"),
      "ActionShortcut",
      "Shift-G",
      "ActionBindable",
      true,
      "ActionBindSingleKey",
      true,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionRedirectCancelShot",
      "ActionSortKey",
      "2370",
      "ActionName",
      T(534909737868, "Distracting Shot"),
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local selObj = Selection and Selection[1]
        if not selObj or not selObj.ui_actions then
          return "hidden"
        end
        local _, state = XActionRedirectToCombatAction(self.ActionId, selObj)
        if not state then
          return "disabled"
        end
        return state
      end,
      "OnAction",
      function(self, host, source, ...)
        local selObj = Selection[1]
        if not selObj or not selObj.ui_actions then
          return
        end
        local action = XActionRedirectToCombatAction(self.ActionId, selObj)
        if action and action:GetVisibility(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "HighlightInteractables",
      "ActionSortKey",
      "2380",
      "ActionName",
      T(125097084556, "Highlight Interactables"),
      "ActionShortcut",
      "Alt",
      "ActionBindable",
      true,
      "ActionMouseBindable",
      false,
      "ActionState",
      function(self, host)
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 then
          return "disabled"
        end
        return "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local mode = true
        if GetAccountStorageOptionValue("InteractableHighlight") == "Toggle" then
          mode = not interactablesOn
        end
        HighlightAllInteractables(mode)
      end,
      "OnShortcutUp",
      function(self, host, source, ...)
        if GetAccountStorageOptionValue("InteractableHighlight") == "Hold" then
          HighlightAllInteractables(false)
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "RolloverText",
      " (Shift-C)",
      "ActionId",
      "G_CameraChange",
      "ActionSortKey",
      "2390",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Camera Type",
      "ActionShortcut",
      "Shift-C",
      "OnAction",
      function(self, host, source, ...)
        if cameraFly.IsActive() then
          SetMouseDeltaMode(false)
          if rawget(_G, "GetPlayerControlObj") and GetPlayerControlObj() then
            ApplyCameraAndControllers()
          else
            SetupInitialCamera()
          end
        else
          cameraFly.Activate(1)
          if rawget(_G, "GetPlayerControlObj") and GetPlayerControlObj() then
            PlayerControl_RecalcActive(true)
          end
          SetMouseDeltaMode(true)
        end
      end,
      "__condition",
      function(parent, context)
        return Platform.developer or Platform.cheats or Platform.trailer
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ExplorationSelectionToggle",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2400",
      "ActionName",
      T(499856472762, "Select All Mercs in Squad"),
      "ActionShortcut",
      "~",
      "ActionGamepad",
      "LeftThumbClick",
      "ActionBindable",
      true,
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        if GetUIStyleGamepad() then
          return "hidden"
        end
        return (g_Combat or gv_Deployment) and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        ToggleAllUnitsSelectionInSquad()
      end,
      "IgnoreRepeated",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "rolloverMoreInfo",
    "ActionSortKey",
    "2410",
    "ActionName",
    T(615097358487, "Rollover More Info"),
    "ActionShortcut",
    "Insert",
    "ActionBindable",
    true,
    "ActionState",
    function(self, host)
      return HasMoreInfo(RolloverWin or g_RolloverShowMoreInfoFakeRollover) and "enabled" or "disabled"
    end,
    "OnAction",
    function(self, host, source, ...)
      if self:ActionState() == "enabled" then
        PlayFX("activityButtonPress_MoreInfo", "start")
        g_RolloverShowMoreInfo = not g_RolloverShowMoreInfo
        ObjModified("g_RolloverShowMoreInfo")
      end
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "GamepadOpenCommandMenu",
    "ActionSortKey",
    "2943",
    "ActionGamepad",
    "Back",
    "ActionBindSingleKey",
    true,
    "OnAction",
    function(self, host, source, ...)
      OpenStartButton()
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "GamepadOpenCommandMenuPS",
    "ActionSortKey",
    "2943",
    "ActionGamepad",
    "TouchPadClick",
    "ActionBindSingleKey",
    true,
    "OnAction",
    function(self, host, source, ...)
      OpenStartButton()
    end
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "tactical/exploration gamepad controls",
    "ActionMode",
    "Game"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrimaryClickUp",
      "ActionSortKey",
      "2420",
      "ActionGamepad",
      "-ButtonA",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igi = GetInGameInterfaceModeDlg()
        local enabled = IsKindOfClasses(igi, "IModeExploration", "IModeCombatBase", "IModeDeployment")
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 or AnyPlayerControlStoppers() then
          enabled = false
        end
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if IsKindOfClasses(igi, "IModeExploration", "IModeCombatBase", "IModeDeployment") then
          igi:OnMouseButtonUp()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrimaryClickDown",
      "ActionSortKey",
      "2421",
      "ActionGamepad",
      "+ButtonA",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igi = GetInGameInterfaceModeDlg()
        local enabled = IsKindOfClasses(igi, "IModeExploration", "IModeCombatBase", "IModeDeployment")
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 or AnyPlayerControlStoppers() then
          enabled = false
        end
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if IsKindOfClasses(igi, "IModeExploration", "IModeCombatBase", "IModeDeployment") then
          igi:OnMouseButtonDown()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadTeleport",
      "ActionSortKey",
      "2430",
      "ActionGamepad",
      "LeftTrigger-RightTrigger-ButtonA",
      "OnAction",
      function(self, host, source, ...)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igi = GetInGameInterfaceModeDlg()
        if not IsKindOf(igi, "GamepadUnitControl") then
          return
        end
        CheatTeleportToCursor()
      end,
      "__condition",
      function(parent, context)
        return CheatEnabled("Teleport")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CloseAreaAimCrosshair",
      "ActionSortKey",
      "2440",
      "ActionGamepad",
      "ButtonB",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igi = GetInGameInterfaceModeDlg()
        local enabled = g_Combat and IsKindOf(igi, "IModeCombatAreaAim") and igi.crosshair
        return enabled and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        igi:SetTarget(false)
        XInputSuppressButtonUpHoldCheck("ButtonB")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadTargetingExit",
      "ActionSortKey",
      "2489",
      "ActionGamepad",
      "ButtonB",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if not g_GamepadTarget then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        igi:GamepadSelectionSetTarget(false)
        XInputSuppressButtonUpHoldCheck("ButtonB")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ExplorationSelectionToggle",
      "ActionMode",
      "Game",
      "ActionSortKey",
      "2450",
      "ActionName",
      T(777099799450, "Selection Toggle"),
      "ActionGamepad",
      "LeftThumbClick",
      "ActionBindable",
      true,
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        return g_Combat and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        ToggleAllUnitsSelectionInSquad()
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadPrevUnit",
      "ActionSortKey",
      "2460",
      "ActionGamepad",
      "LeftShoulder",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if not cameraTac.IsActive() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if IsKindOf(igi, "IModeCombatAttackBase") then
          igi:PrevTarget()
        elseif igi then
          igi:NextUnit(nil, nil, nil, "prev")
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadNextUnit",
      "ActionSortKey",
      "2470",
      "ActionGamepad",
      "RightShoulder",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if not cameraTac.IsActive() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if IsKindOf(igi, "IModeCombatAttackBase") then
          igi:NextTarget()
        elseif igi then
          igi:NextUnit()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadAimTakeCoverOrOverwatch",
      "ActionSortKey",
      "2480",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if not IsKindOf(igi, "GamepadUnitControl") then
          return
        end
        if rawget(igi, "crosshair") and not igi.crosshair.noAim then
          igi.crosshair:ToggleAim()
        elseif g_GamepadTarget then
          local takeCoverAction = CombatActions.TakeCover
          if takeCoverAction:GetUIState(Selection) == "enabled" then
            takeCoverAction:UIBegin(Selection)
          end
        else
          InvokeShortcutAction(igi, "actionRedirectOverwatch")
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadTargetingNext",
      "ActionSortKey",
      "2490",
      "ActionGamepad",
      "RightTrigger",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if not cameraTac.IsActive() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if not IsKindOf(igi, "IModeCombatAttackBase") then
          local unit = Selection and Selection[1]
          local action = unit and unit:GetDefaultAttackAction("ranged")
          local args = {}
          if action and action.AimType ~= "parabola aoe" then
            local firstTarget = GetTargetsToShowAboveActionBar(unit)
            firstTarget = firstTarget and table.sort(firstTarget, function(a, b)
              local aVal = g_unitOrder[a] or 0
              local bVal = g_unitOrder[b] or 0
              return aVal < bVal
            end)
            args.target = firstTarget and firstTarget[1]
          end
          local state = action and CheckAndReportImpossibleAttack(unit, action, args)
          if state and state == "enabled" then
            action:UIBegin({unit}, args)
          end
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadCameraToUnitAndHighlightInteractables",
      "ActionSortKey",
      "2942",
      "ActionGamepad",
      "RightThumbClick",
      "ActionBindSingleKey",
      true,
      "ActionState",
      function(self, host)
        if g_ZuluMessagePopup and #g_ZuluMessagePopup > 0 then
          return "disabled"
        end
        return "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local mode = not interactablesOn
        if Selection and Selection[1] and mode then
          SnapCameraToObj(Selection[1])
        end
        HighlightAllInteractables(mode)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadQuickAction",
      "ActionSortKey",
      "2071",
      "ActionGamepad",
      "ButtonX",
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        local igiM = GetInGameInterfaceModeDlg()
        return igiM and igiM.crosshair and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local action = DetermineUnitCombatActionButtonX()
        if action and action:GetUIState(Selection) == "enabled" then
          action:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadChangeWeapons",
      "ActionSortKey",
      "2071",
      "ActionGamepad",
      "LeftTrigger-DPadRight",
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local changeWeapon = CombatActions.ChangeWeapon
        if changeWeapon:GetUIState(Selection) == "enabled" then
          changeWeapon:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadActionBarFocusLeft",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "DPadLeft",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igiM = GetInGameInterfaceModeDlg()
        if igiM and igiM.crosshair then
          return "disabled"
        end
        if not cameraTac.IsActive() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if not IsKindOf(igi, "GamepadUnitControl") then
          return
        end
        igi:FocusActionBar("left")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadActionBarFocusRight",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "DPadRight",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        local igiM = GetInGameInterfaceModeDlg()
        if igiM and igiM.crosshair then
          return "disabled"
        end
        if not cameraTac.IsActive() then
          return "disabled"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        local igi = GetInGameInterfaceModeDlg()
        if not IsKindOf(igi, "GamepadUnitControl") then
          return
        end
        igi:FocusActionBar("right")
      end
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "actionQuickSave",
    "ActionSortKey",
    "2500",
    "ActionName",
    T(988782431105, "Quick Save"),
    "ActionShortcut",
    "Shift-F8",
    "ActionBindable",
    true,
    "OnAction",
    function(self, host, source, ...)
      QuickSave()
    end,
    "IgnoreRepeated",
    true,
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "actionQuickSave",
    "ActionSortKey",
    "2500",
    "ActionName",
    T(988782431105, "Quick Save"),
    "ActionShortcut",
    "F5",
    "ActionBindable",
    true,
    "OnAction",
    function(self, host, source, ...)
      QuickSave()
    end,
    "IgnoreRepeated",
    true,
    "__condition",
    function(parent, context)
      return not Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "actionQuickLoad",
    "ActionSortKey",
    "2510",
    "ActionName",
    T(364634199316, "Quick Load"),
    "ActionShortcut",
    "Shift-F9",
    "ActionBindable",
    true,
    "OnAction",
    function(self, host, source, ...)
      QuickLoad()
    end,
    "IgnoreRepeated",
    true,
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "actionQuickLoad",
    "ActionSortKey",
    "2510",
    "ActionName",
    T(364634199316, "Quick Load"),
    "ActionShortcut",
    "F9",
    "ActionBindable",
    true,
    "OnAction",
    function(self, host, source, ...)
      QuickLoad()
    end,
    "IgnoreRepeated",
    true,
    "__condition",
    function(parent, context)
      return not Platform.developer and not IsModEditorMap(CurrentMap)
    end
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "satellite",
    "ActionMode",
    "Satellite",
    "BindingsMenuCategory",
    "Satellite",
    "ActionState",
    function(self, host)
      return gv_SatelliteView and "enabled" or "disabled"
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionPause",
      "ActionMode",
      "Satellite",
      "ActionSortKey",
      "2520",
      "ActionName",
      T(769454735094, "Pause/Resume"),
      "ActionShortcut",
      "Space",
      "ActionGamepad",
      "DPadLeft",
      "ActionBindable",
      true,
      "ActionState",
      function(self, host)
        if GetUIStyleGamepad() and IsCampaignPaused() then
          return "disabled"
        end
        return GetDialog("PDADialog") and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        if not IsCampaignPaused() then
          PauseCampaignTime("UI")
        else
          ResumeCampaignTime("UI")
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionResumeGamepad",
      "ActionMode",
      "Satellite",
      "ActionSortKey",
      "2521",
      "ActionName",
      T(660426612618, "Pause/Resume"),
      "ActionGamepad",
      "DPadRight",
      "ActionState",
      function(self, host)
        if not GetUIStyleGamepad() then
          return "disabled"
        end
        if not IsCampaignPaused() then
          return "disabled"
        end
        return GetDialog("PDADialog") and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        ResumeCampaignTime("UI")
        if CampaignPauseReasons.SatelliteConflict then
          local conflictSector = AnyNonWaitingConflict()
          if not conflictSector then
            return
          end
          OpenSatelliteConflictDlg(conflictSector)
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadCenterSquad",
      "ActionSortKey",
      "1",
      "ActionGamepad",
      "RightThumbClick",
      "OnAction",
      function(self, host, source, ...)
        local selSquad = gv_Squads[g_CurrentSquad]
        if not selSquad or not selSquad.CurrentSector then
          return
        end
        SatelliteSetCameraDest(selSquad.CurrentSector, 300)
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Teleport",
      "RolloverText",
      "Teleport",
      "ActionId",
      "Teleport (Satellite)",
      "ActionMode",
      "Satellite",
      "ActionSortKey",
      "2530",
      "ActionTranslate",
      false,
      "ActionName",
      "Teleport",
      "ActionIcon",
      "CommonAssets/UI/Icons/gps location map my location target.png",
      "ActionShortcut",
      "Ctrl-T",
      "ActionState",
      function(self, host)
        return CheatEnabled("Teleport") and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        CheatTeleportToCursor()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "PDA actions"
    }, {
      PlaceObj("XTemplateAction", {
        "comment",
        "used in the satellite context menu",
        "ActionId",
        "idCancelTravel",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2550",
        "ActionName",
        T(459198625487, "Stop Travel"),
        "ActionGamepad",
        "ButtonB",
        "ActionMouseBindable",
        false,
        "ActionBindSingleKey",
        true,
        "ActionButtonTemplate",
        "PDACommonButton",
        "ActionState",
        function(self, host)
          return CanCancelSatelliteSquadTravel()
        end,
        "OnAction",
        function(self, host, source, ...)
          local squad = GetSatelliteContextMenuValidSquad()
          SatelliteCancelTravelSelectedSquad(squad)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "CycleSquadsInRollover",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2560",
        "ActionShortcut",
        "H",
        "ActionGamepad",
        "LeftThumbClick",
        "ActionState",
        function(self, host)
          local rollover = RolloverWin and RolloverWin.idCurrentSquadCont
          if not rollover then
            return "hidden"
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local rollover = RolloverWin and RolloverWin.idCurrentSquadCont
          if not rollover then
            return
          end
          local currentSquad = rawget(rollover, "selectedSquad")
          local allSquads = rawget(rollover, "allSquads")
          currentSquad = currentSquad + 1
          if currentSquad > #allSquads then
            currentSquad = 1
          end
          rawset(rollover, "selectedSquad", currentSquad)
          rollover:SetContext(allSquads[currentSquad])
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idTravel",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2570",
        "ActionName",
        T(736577684433, "Travel/Cancel Travel"),
        "ActionShortcut",
        "P",
        "ActionBindable",
        true,
        "ActionState",
        function(self, host)
          local travelActionState = SatelliteCanTravelState()
          if travelActionState ~= "enabled" then
            return CanCancelSatelliteSquadTravel()
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local dlg = GetSatelliteDialog()
          if dlg and dlg.selected_squad then
            local canCancelTravel = CanCancelSatelliteSquadTravel(dlg.selected_squad)
            if canCancelTravel == "enabled" then
              SatelliteCancelTravelSelectedSquad()
              return
            elseif canCancelTravel == "disabled" then
              return
            end
            g_SatelliteUI:TravelWithSquad(dlg.selected_squad.UniqueId)
            g_SatelliteUI:TravelDestinationSelect()
            local mouseTarget = GetDialog(g_SatelliteUI):GetMouseTarget(terminal.GetMousePos())
            if IsKindOf(mouseTarget, "SectorWindow") then
              g_SatelliteUI:TravelDestinationSelect(mouseTarget.context.Id)
            elseif IsKindOf(mouseTarget, "SquadWindow") then
              g_SatelliteUI:TravelDestinationSelect(mouseTarget.context.CurrentSector)
            elseif IsKindOf(mouseTarget, "SatelliteIconClickThrough") then
              g_SatelliteUI:TravelDestinationSelect(mouseTarget.context.sector.Id)
            end
            ObjModified(Game)
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idGoAboveground",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2590",
        "ActionName",
        T(443684614429, "Go Aboveground"),
        "ActionShortcut",
        "Ctrl-P",
        "ActionState",
        function(self, host)
          local dlg = GetSatelliteDialog()
          if not dlg then
            return "hidden"
          end
          local squad, sector_id = GetSatelliteContextMenuValidSquad()
          if not (squad and squad.CurrentSector) or squad.arrival_squad then
            return "disabled"
          end
          if gv_Sectors[squad.CurrentSector].GroundSector == sector_id then
            sector_id = squad.CurrentSector
          end
          if not IsSectorUnderground(sector_id) or not not IsConflictMode(sector_id) then
            return "hidden"
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(function()
            local squad, sector_id = GetSatelliteContextMenuValidSquad()
            if squad then
              local squad_id = squad.UniqueId
              local squad_id = CheckSquadBusy(squad_id)
              if not squad_id then
                return
              end
              NetSyncEvent("SatelliteReachSector", squad_id, gv_Sectors[squad.CurrentSector].GroundSector, true)
            end
          end)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idOperations",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2600",
        "ActionName",
        T(343521841000, "<ActionName_ActivitiesCount()>"),
        "ActionShortcut",
        "O",
        "ActionGamepad",
        "ButtonY",
        "ActionBindable",
        true,
        "ActionState",
        function(self, host)
          local squad, sector_id = GetSatelliteContextMenuValidSquad()
          if not squad then
            squad, sector_id = GetSatelliteContextMenuValidSquad("selected")
          end
          if not squad or squad.CurrentSector ~= sector_id then
            return "disabled", T(135920052594, "Operations unavailable: No mercs are present in this sector")
          end
          local operationsInSector = GetOperationsInSector(sector_id)
          if IsConflictMode(squad.CurrentSector) then
            return "disabled", T(860971947053, "Operations unavailable: In conflict")
          elseif IsSquadTravelling(squad) or squad.route then
            return "disabled", T(228228608481, "Operations unavailable: Squad is Traveling")
          elseif not next(operationsInSector) or not table.find(operationsInSector, "enabled", true) then
            return "disabled", T(734928451581, "No available operations in this sector")
          else
            return "enabled"
          end
        end,
        "OnAction",
        function(self, host, source, ...)
          local squad, sector_id = GetSatelliteContextMenuValidSquad()
          if not squad then
            squad, sector_id = GetSatelliteContextMenuValidSquad("selected")
          end
          if squad then
            local popupHost = GetDialog("PDADialogSatellite")
            popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
            if not popupHost then
              return
            end
            OpenDialog("SectorOperationsUI", popupHost, gv_Sectors[sector_id])
            TutorialHintsState.TrainMilitia = TutorialHintsState.TrainMilitiaShown and true
            TutorialHintsState.Wounded = TutorialHintsState.WoundedShown and true
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "actionContextMenuViewSectorStash",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2610",
        "ActionName",
        T(956547202009, "Sector Stash"),
        "ActionShortcut",
        "H",
        "ActionBindable",
        true,
        "ActionMouseBindable",
        false,
        "ActionState",
        function(self, host)
          if not g_SatelliteUI then
            return "disabled"
          end
          local sectorId = g_SatelliteUI.context_menu and g_SatelliteUI.context_menu[1] and g_SatelliteUI.context_menu[1].context.sector_id
          sectorId = sectorId or g_SatelliteUI.rollover_sector and g_SatelliteUI.rollover_sector.Id
          local sector = gv_Sectors[sectorId]
          if not sector or not sector.Map then
            return "hidden"
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local sectorId = g_SatelliteUI.context_menu and g_SatelliteUI.context_menu[1] and g_SatelliteUI.context_menu[1].context.sector_id
          sectorId = sectorId or g_SatelliteUI.rollover_sector and g_SatelliteUI.rollover_sector.Id
          if not sectorId then
            return
          end
          OpenSectorStashUIForSector(sectorId)
        end
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "used in the satellite info panel",
        "ActionId",
        "idExplore",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2640",
        "ActionName",
        T(846703701561, "Tactical View"),
        "ActionState",
        function(self, host)
          local squad, sector_id = GetSatelliteContextMenuValidSquad()
          if not squad then
            squad, sector_id = GetSatelliteContextMenuValidSquad("selected")
          end
          if not squad or squad.CurrentSector ~= sector_id and gv_Sectors[squad.CurrentSector].GroundSector ~= sector_id then
            return "disabled", T(559943858432, "Tactical View: No merc squad present in this sector")
          end
          local enabled, err = GetSquadEnterSectorState()
          if enabled then
            return "enabled"
          else
            return "disabled", err
          end
        end,
        "OnAction",
        function(self, host, source, ...)
          local squad, sector_id = GetSatelliteContextMenuValidSquad()
          if not squad then
            squad, sector_id = GetSatelliteContextMenuValidSquad("selected")
          end
          if squad then
            UIEnterSector(squad.CurrentSector)
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idPerks",
        "ActionMode",
        "Satellite",
        "ActionSortKey",
        "2620",
        "ActionName",
        T(455134687102, "Merc Info"),
        "ActionState",
        function(self, host)
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local unit_id = g_SatelliteUI and g_SatelliteUI.context_menu
          if not unit_id then
            return
          end
          unit_id = unit_id and unit_id:ResolveId("idContent"):GetContext().unit_id
          local unit = gv_UnitData[unit_id]
          OpenCharacterScreen(unit)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "GamepadPrevSquad",
        "ActionSortKey",
        "1",
        "ActionGamepad",
        "LeftTrigger-LeftShoulder",
        "ActionState",
        function(self, host)
        end,
        "OnAction",
        function(self, host, source, ...)
          local playerSquads = GetPlayerMercSquads()
          local curSel = g_CurrentSquad
          local curSelIdx = table.find(playerSquads, "UniqueId", g_CurrentSquad)
          if not curSelIdx then
            return
          end
          curSelIdx = curSelIdx - 1
          if curSelIdx < 1 then
            curSelIdx = #playerSquads
          end
          local newSquad = playerSquads[curSelIdx]
          if not newSquad or not g_SatelliteUI then
            return
          end
          g_SatelliteUI:SelectSquad(newSquad)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "GamepadNextSquad",
        "ActionSortKey",
        "1",
        "ActionGamepad",
        "LeftTrigger-RightShoulder",
        "ActionState",
        function(self, host)
        end,
        "OnAction",
        function(self, host, source, ...)
          local playerSquads = GetPlayerMercSquads()
          local curSel = g_CurrentSquad
          local curSelIdx = table.find(playerSquads, "UniqueId", g_CurrentSquad)
          if not curSelIdx then
            return
          end
          curSelIdx = curSelIdx + 1
          if curSelIdx > #playerSquads then
            curSelIdx = 1
          end
          local newSquad = playerSquads[curSelIdx]
          if not newSquad or not g_SatelliteUI then
            return
          end
          g_SatelliteUI:SelectSquad(newSquad)
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SatelliteControlOverlay",
      "ActionMode",
      "Satellite",
      "ActionSortKey",
      "2630",
      "ActionTranslate",
      false,
      "ActionName",
      "Control Overlay",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        SetSatelliteOverlay("control")
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SatelliteIntelOverlay",
      "ActionMode",
      "Satellite",
      "ActionSortKey",
      "2640",
      "ActionTranslate",
      false,
      "ActionName",
      "Intel Overlay",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        SetSatelliteOverlay("intel")
      end,
      "IgnoreRepeated",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "semi-cheats, to be disabled"
  }, {
    PlaceObj("XTemplateAction", {
      "comment",
      "Destruction Test",
      "ActionId",
      "DE_TestExplode",
      "ActionSortKey",
      "2650",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Explode",
      "ActionShortcut",
      "Ctrl-]",
      "OnAction",
      function(self, host, source, ...)
        CreateGameTimeThread(DbgExplosionFX)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Destruction Test Display Range",
      "ActionId",
      "DE_TestExplodeToggleRange",
      "ActionSortKey",
      "2651",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Explode Toggle Range",
      "ActionShortcut",
      "]",
      "OnAction",
      function(self, host, source, ...)
        DbgExplosionFX_ShowRange = not DbgExplosionFX_ShowRange
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Destruction Test",
      "ActionId",
      "DE_TestCarpetBomb",
      "ActionSortKey",
      "2660",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Carpet Bomb",
      "ActionShortcut",
      "Ctrl-Shift-,",
      "OnAction",
      function(self, host, source, ...)
        DbgCarpetExplosionDamage("bomb")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "molotov test",
      "ActionId",
      "DE_TestMolotov",
      "ActionSortKey",
      "2670",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Molotov",
      "ActionShortcut",
      "Ctrl-Numpad *",
      "OnAction",
      function(self, host, source, ...)
        CreateGameTimeThread(DbgIncendiaryExplosion)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Bullet Impact Test",
      "ActionId",
      "DE_TestShoot",
      "ActionSortKey",
      "2680",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Shoot",
      "ActionShortcut",
      "Ctrl-/",
      "OnAction",
      function(self, host, source, ...)
        CreateGameTimeThread(DbgBulletDamage)
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Bullet Destruction Test",
      "ActionId",
      "DE_TestShootDamage",
      "ActionSortKey",
      "2690",
      "ActionTranslate",
      false,
      "ActionName",
      "Test Shoot Damage",
      "ActionShortcut",
      "Ctrl-'",
      "OnAction",
      function(self, host, source, ...)
        CreateGameTimeThread(DbgBulletDamage, nil, 10000)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "G_HideCombatUI",
      "ActionSortKey",
      "2700",
      "ActionTranslate",
      false,
      "ActionName",
      "Hide Combat UI",
      "ActionShortcut",
      "Shift-I",
      "OnAction",
      function(self, host, source, ...)
        PlaybackNetSyncEvent("CheatEnable", "CombatUIHidden")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "G_HideWorldCombatUI",
      "ActionSortKey",
      "2710",
      "ActionTranslate",
      false,
      "ActionName",
      "Hide In-World Combat UI",
      "ActionShortcut",
      "Shift-Y",
      "OnAction",
      function(self, host, source, ...)
        PlaybackNetSyncEvent("CheatEnable", "IWUIHidden")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "G_HideReplayUI",
      "ActionSortKey",
      "2720",
      "ActionTranslate",
      false,
      "ActionName",
      "Hide Replay UI",
      "ActionShortcut",
      "Shift-J",
      "OnAction",
      function(self, host, source, ...)
        PlaybackNetSyncEvent("CheatEnable", "ReplayUIHidden")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "G_HideOptionalCombatUI",
      "ActionSortKey",
      "2730",
      "ActionTranslate",
      false,
      "ActionName",
      "Hide optional combat UI",
      "ActionShortcut",
      "Shift-L",
      "OnAction",
      function(self, host, source, ...)
        PlaybackNetSyncEvent("CheatEnable", "OptionalUIHidden")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle CMT",
      "RolloverText",
      "Quick Test Ambient Life",
      "ActionId",
      "ToggleCMT",
      "ActionSortKey",
      "2740",
      "ActionTranslate",
      false,
      "ActionName",
      "ToggleCMT",
      "ActionIcon",
      "CommonAssets/UI/Icons/map.png",
      "ActionShortcut",
      "Alt-Shift-H",
      "OnAction",
      function(self, host, source, ...)
        ToggleVisibilitySystems("ActionShortcut")
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Animation",
    "ActionSortKey",
    "2750",
    "ActionName",
    T(666895910911, "Animation"),
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "__condition",
    function(parent, context)
      return Platform.developer
    end
  }, {
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle RTS camera",
      "RolloverText",
      "toggle RTS camera",
      "ActionId",
      "ToggleRTSCamera",
      "ActionSortKey",
      "2700",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle RTS Camera",
      "OnAction",
      function(self, host, source, ...)
        if cameraRTS.IsActive() then
          cameraTac.Activate()
          print("CameraTac activated")
        else
          cameraRTS.Activate()
          print("CameraRTS activated")
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit animation",
      "RolloverText",
      "toggle unit animation",
      "ActionId",
      "ToggleUnitAnimation",
      "ActionSortKey",
      "2710",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Animation",
      "ActionShortcut",
      "Ctrl-Shift-T",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->o:GetAnimSpeedModifier() == 1000 and o:GetStateText() or string.format(\"%s (speed %d)\", o:GetStateText(), o:GetAnimSpeedModifier())", "Unit Animation")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit command",
      "RolloverText",
      "toggle unit command",
      "ActionId",
      "ToggleUnitCommand",
      "ActionSortKey",
      "2714",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Command",
      "ActionShortcut",
      "Ctrl-Alt-Shift-T",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->o.command", "Unit Command")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit anim duration",
      "RolloverText",
      "toggle unit anim duration",
      "ActionId",
      "ToggleUnitAnimDuration",
      "ActionSortKey",
      "2720",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Anim Duration",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->string.format('%d / %d', o:GetAnimPhase(), GetAnimDuration(o:GetEntity(), o:GetAnim(1)))", "Unit Anim Duration")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit anim style",
      "RolloverText",
      "toggle unit anim style",
      "ActionId",
      "ToggleUnitAnimStyle",
      "ActionSortKey",
      "2730",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Anim Style",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->(GetAnimationStyle(o, o.cur_idle_style or o.cur_move_style) or empty_table).Name or ''", "Unit Anim Style")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle IK",
      "RolloverText",
      "toggle inverse kinematic",
      "ActionId",
      "IKDisabled",
      "ActionSortKey",
      "2740",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle IK",
      "OnAction",
      function(self, host, source, ...)
        config.IKDisabled = not config.IKDisabled
        print("IK Disabled: " .. (config.IKDisabled and "Off" or "On"))
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle placing left hand on weapon grip",
      "RolloverText",
      "toggle placing left hand on weapon grip",
      "ActionId",
      "WeaponGripIKDisabled",
      "ActionSortKey",
      "2750",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle IK Weapon Grip",
      "OnAction",
      function(self, host, source, ...)
        config.WeaponGripIKDisabled = not config.WeaponGripIKDisabled
        print("Weapon Grip IK: " .. (config.WeaponGripIKDisabled and "Off" or "On"))
        if IsValid(SelectedObj) then
          SelectedObj:SetWeaponGrip(true)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle unit orientation",
      "RolloverText",
      "toggle unit orientation",
      "ActionId",
      "ToggleUnitOrientation",
      "ActionSortKey",
      "2770",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Unit Orientation",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("Unit->o:GetVisualOrientationAngle()/60", "Unit Orientation")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle selected unit animation",
      "RolloverText",
      "toggle unit animation",
      "ActionId",
      "ToggleSelectedUnitAnimation",
      "ActionSortKey",
      "2780",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Selected Unit Animation",
      "OnAction",
      function(self, host, source, ...)
        ToggleTextTrackers("SelectedObj:GetStateText()", "Selected Unit Animation")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle pain animation",
      "RolloverText",
      "toggle pain animation",
      "ActionId",
      "TogglePainAnimation",
      "ActionSortKey",
      "2790",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Pain Animation",
      "OnAction",
      function(self, host, source, ...)
        if (const.AnimChannel_Pain or 0) ~= 0 then
          ToggleTextTrackers("Unit->o:GetAnim(const.AnimChannel_Pain)>=0 and GetStateName(o:GetAnim(const.AnimChannel_Pain)) or ''", "Pain Animation")
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle right hand grip animation",
      "RolloverText",
      "toggle right hand grip animation",
      "ActionId",
      "ToggleRightHandGripAnimation",
      "ActionSortKey",
      "2800",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Right Hand Grip Animation",
      "OnAction",
      function(self, host, source, ...)
        if (const.AnimChannel_RightHandGrip or 0) ~= 0 then
          ToggleTextTrackers("Unit->o:GetAnim(const.AnimChannel_RightHandGrip)>=0 and GetStateName(o:GetAnim(const.AnimChannel_RightHandGrip)) or ''", "Right Hand Grip Animation")
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle turn animation",
      "RolloverText",
      "toggle turn animation",
      "ActionId",
      "ToggleTurnAnimation",
      "ActionSortKey",
      "2810",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Turn Animation",
      "OnAction",
      function(self, host, source, ...)
        if (const.PathTurnAnimChnl or 0) ~= 0 then
          ToggleTextTrackers("Unit->o:GetAnim(const.PathTurnAnimChnl+1)>=0 and GetStateName(o:GetAnim(const.PathTurnAnimChnl+1)) or ''", "Turn Animation")
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "toggle broken state",
      "RolloverText",
      "toggle broken state",
      "ActionId",
      "ToggleBrokenState",
      "ActionSortKey",
      "2820",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Broken State",
      "OnAction",
      function(self, host, source, ...)
        local oo = editor.GetSel()
        for _, o in ipairs(oo) do
          if IsValid(o) then
            local cur_state = o:GetStateText()
            if cur_state ~= "broken" then
              if o:HasState("broken") then
                o:SetState(ComputeBrokenStateForObj(o))
                rawset(o, "pre_broken_state", cur_state)
              else
                print(o.class .. " has no \"broken\" state.")
              end
            else
              local new_state = rawget(o, "pre_broken_state") or "idle"
              rawset(o, "pre_broken_state", nil)
              if o:HasState(new_state) then
                o:SetState(new_state)
              else
                print(o.class .. " - something broke when restoring to previous state, \194\175\\_(\227\131\132)_/\194\175")
              end
            end
            if IsKindOf(o, "AutoAttachObject") then
              o:SetAutoAttachMode(o:GetAutoAttachMode())
            end
          end
        end
        if not oo or #oo <= 0 then
          print("No selection")
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "MercenariesMoveStyle",
      "ActionSortKey",
      "3000",
      "ActionTranslate",
      false,
      "ActionName",
      "Mercenaries move style...",
      "ActionIcon",
      "CommonAssets/UI/Menu/folder.tga",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateForEach", {
        "comment",
        "Set merc default move style",
        "array",
        function(parent, context)
          return GetMoveStyleCombo()
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.ActionId = "MoveStyle_" .. item
          child.ActionName = item
          child.OnActionParam = item
        end
      }, {
        PlaceObj("XTemplateAction", {
          "ActionTranslate",
          false,
          "ActionIcon",
          "CommonAssets/UI/Icons/gear option setting setup.png",
          "OnAction",
          function(self, host, source, ...)
            const.MercWalkStyle = self.OnActionParam ~= "" and self.OnActionParam or nil
          end
        })
      })
    })
  })
})
