PlaceObj("XTemplate", {
  group = "Shortcuts",
  id = "CommonShortcuts",
  save_in = "Common",
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Tools",
    "ActionTranslate",
    false,
    "ActionName",
    "Tools",
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "replace_matching_id",
    true
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Tools.Extras",
      "ActionTranslate",
      false,
      "ActionName",
      "Extras ...",
      "ActionIcon",
      "CommonAssets/UI/Menu/folder.tga",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateAction", {
        "comment",
        "Write screenshot (-PrtScr)",
        "RolloverText",
        "Write screenshot (-PrtScr)",
        "ActionId",
        "DE_Screenshot",
        "ActionTranslate",
        false,
        "ActionName",
        "Screenshot",
        "ActionShortcut",
        "-PrtScr",
        "OnAction",
        function(self, host, source, ...)
          WriteScreenshot(GenerateScreenshotFilename("SS", "AppData/"))
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Isolated object screenshot (-Ctrl-Alt-PrtScr)",
        "RolloverText",
        "Isolated object screenshot (-Ctrl-Alt-PrtScr)",
        "ActionId",
        "DE_Isolated_Object_Screenshot",
        "ActionTranslate",
        false,
        "ActionName",
        "Isolated Object Screenshot",
        "ActionShortcut",
        "-Ctrl-Alt-PrtScr",
        "OnAction",
        function(self, host, source, ...)
          IsolatedObjectScreenshot()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Report Bug (Ctrl-F1)",
        "RolloverText",
        "Report Bug (Ctrl-F1)",
        "ActionId",
        "DE_BugReport",
        "ActionTranslate",
        false,
        "ActionName",
        "Report Bug",
        "ActionIcon",
        "CommonAssets/UI/Icons/bacteria bug insect protection security virus.png",
        "ActionShortcut",
        "Ctrl-F1",
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(CreateXBugReportDlg)
        end,
        "__condition",
        function(parent, context)
          return not Platform.steamdeck or Platform.asserts
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Toggle UI in screenshots (-Ctrl-Shift-PrtScr)",
        "RolloverText",
        "Toggle UI in screenshots (-Ctrl-Shift-PrtScr)",
        "ActionId",
        "DE_ToggleScreenshotInterface",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle UI in screenshots",
        "ActionShortcut",
        "-Ctrl-Shift-PrtScr",
        "OnAction",
        function(self, host, source, ...)
          hr.InterfaceInScreenshot = hr.InterfaceInScreenshot ~= 0 and 0 or 1
          print("UI in screenshots is now", hr.InterfaceInScreenshot ~= 0 and "enabled" or "disabled")
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Write upsampled screenshot (-Ctrl-PrtScr)",
        "RolloverText",
        "Write upsampled screenshot (-Ctrl-PrtScr)",
        "ActionId",
        "DE_UpsampledScreenshot",
        "ActionTranslate",
        false,
        "ActionName",
        "Upsampled Screenshot",
        "ActionShortcut",
        "-Ctrl-PrtScr",
        "OnAction",
        function(self, host, source, ...)
          if Platform.developer then
            CreateRealTimeThread(function()
              WaitNextFrame(3)
              LockCamera("Screenshot")
              local store = {}
              Msg("BeforeUpsampledScreenshot", store)
              WaitNextFrame()
              MovieWriteScreenshot(GenerateScreenshotFilename("SSAA", "AppData/"), 0, 64, false)
              WaitNextFrame()
              Msg("AfterUpsampledScreenshot", store)
              UnlockCamera("Screenshot")
            end)
          end
        end,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "(Ctrl-Alt-K)",
      "ActionId",
      "SVNShowLog",
      "ActionTranslate",
      false,
      "ActionName",
      "SVN Show Log",
      "ActionIcon",
      "CommonAssets/UI/Icons/children flow.png",
      "ActionShortcut",
      "Ctrl-Alt-K",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          SVNShowLog(ConvertToOSPath("svnProject/") .. "..\\")
        end)
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
      "Show game log",
      "RolloverText",
      "Show game log",
      "ActionId",
      "Log Viewer",
      "ActionTranslate",
      false,
      "ActionName",
      "Log Viewer",
      "ActionIcon",
      "CommonAssets/UI/Icons/bullet list.png",
      "ActionShortcut",
      "Ctrl-Alt-F2",
      "ActionState",
      function(self, host)
        if Platform.developer or insideHG() then
          return
        end
        return "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        ShowLog()
      end,
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    " (Ctrl-Alt-U)",
    "ActionId",
    "DisableUIL",
    "ActionTranslate",
    false,
    "ActionShortcut",
    "Ctrl-Alt-U",
    "OnAction",
    function(self, host, source, ...)
      if Platform.publisher or Platform.developer then
        rawset(_G, "OrgXRender", rawget(_G, "OrgXRender") or XRender)
        if XRender == OrgXRender then
          function XRender()
          end
        else
          XRender = OrgXRender
        end
        UIL.Invalidate()
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
    "ActionTranslate",
    false,
    "ActionShortcut",
    "Enter",
    "ActionShortcut2",
    "Alt-Shift-C",
    "OnAction",
    function(self, host, source, ...)
      ShowConsole(true)
    end,
    "__condition",
    function(parent, context)
      return AreCheatsEnabled() or ConsoleEnabled or config.LuaDebugger
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Clear screen (F9)",
    "ActionId",
    "DE_ClearScreen",
    "ActionTranslate",
    false,
    "ActionShortcut",
    "F9",
    "OnAction",
    function(self, host, source, ...)
      cls()
      DbgClear()
    end,
    "__condition",
    function(parent, context)
      return Platform.asserts or IsModEditorMap(CurrentMap)
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Show/Hide the User Actions menu (~)",
    "ActionId",
    "DE_Menu",
    "ActionTranslate",
    false,
    "ActionIcon",
    "CommonAssets/UI/Menu/default.tga",
    "ActionShortcut",
    "-~",
    "OnAction",
    function(self, host, source, ...)
      if not Platform.ged and AreCheatsEnabled() then
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
    "ActionId",
    "actionInGameMainMenu",
    "ActionMode",
    "Game",
    "ActionName",
    T(790736535889, "Main Menu"),
    "ActionShortcut",
    "Escape",
    "ActionGamepad",
    "Start",
    "OnAction",
    function(self, host, source, ...)
      if GetMap() == "" then
        return
      end
      local modal = terminal.desktop:GetModalWindow()
      if not modal or modal == terminal.desktop then
        if not rawget(_G, "CloseBuildMenu") or not CloseBuildMenu() then
          OpenIngameMainMenu()
        end
      else
        CloseIngameMainMenu()
      end
    end,
    "IgnoreRepeated",
    true
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Debug",
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
      return Platform.asserts
    end,
    "replace_matching_id",
    true
  }, {
    PlaceObj("XTemplateAction", {
      "comment",
      "Invoke remote Lua debugger (F11)",
      "RolloverText",
      "Invoke remote Lua debugger (F11)",
      "ActionId",
      "DE_StartRemDebug",
      "ActionTranslate",
      false,
      "ActionName",
      "Start Remote Lua Debugger",
      "ActionIcon",
      "CommonAssets/UI/Icons/media outline play.png",
      "ActionShortcut",
      "F11",
      "ActionGamepad",
      "LeftTrigger-RightTrigger-LeftShoulder-RightShoulder",
      "OnAction",
      function(self, host, source, ...)
        StartDebugger()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Stop Lua debugger (Shift-F11)",
      "RolloverText",
      "Stop Lua debugger (Shift-F11)",
      "ActionId",
      "DE_StopRemDebug",
      "ActionTranslate",
      false,
      "ActionName",
      "Stop Remote Lua Debugger",
      "ActionIcon",
      "CommonAssets/UI/Icons/media stop.png",
      "ActionShortcut",
      "Shift-F11",
      "OnAction",
      function(self, host, source, ...)
        StopDebugger()
      end,
      "replace_matching_id",
      true
    })
  })
})
