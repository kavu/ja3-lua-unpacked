PlaceObj("XTemplate", {
  group = "Shortcuts",
  id = "EditorShortcuts",
  save_in = "Common",
  PlaceObj("XTemplateAction", {
    "comment",
    "Context menu actions",
    "ActionMode",
    "Editor",
    "ActionTranslate",
    false
  }, {
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle Spots",
      "ActionId",
      "E_ToggleSpots",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Spots",
      "ActionIcon",
      "CommonAssets/UI/Menu/EV_OpenFirst.tga",
      "OnAction",
      function(self, host, source, ...)
        ToggleSpotVisibility(editor.GetSel())
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
      "comment",
      "Toggle Surfaces",
      "ActionId",
      "E_ToggleSurfaces",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Surfaces",
      "ActionIcon",
      "CommonAssets/UI/Menu/EV_OpenFirst.tga",
      "ActionState",
      function(self, host)
        local sel = editor.GetSel()
        if sel and sel[1] and not HasAnySurfaces(sel[1], -1) then
          return "hidden"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        ToggleSurfaceVisibility(editor.GetSel())
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
      "comment",
      "Entity viewer",
      "ActionId",
      "E_EV_OpenFirst",
      "ActionTranslate",
      false,
      "ActionName",
      "Entity viewer",
      "ActionIcon",
      "CommonAssets/UI/Menu/EV_OpenFirst.tga",
      "OnAction",
      function(self, host, source, ...)
        CreateEntityViewer(editor.GetSel()[1])
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
      "comment",
      "Art Spec",
      "ActionId",
      "E_AS_OpenFirst",
      "ActionTranslate",
      false,
      "ActionName",
      "Art Spec",
      "ActionIcon",
      "CommonAssets/UI/Menu/EV_OpenFirst.tga",
      "OnAction",
      function(self, host, source, ...)
        local spec = EntitySpecPresets[selo() and selo():GetEntity() or ""]
        if spec then
          spec:OpenEditor()
        end
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
      "comment",
      "Anim Moments",
      "ActionId",
      "E_AnimMoments",
      "ActionTranslate",
      false,
      "ActionName",
      "Anim Metadata",
      "ActionIcon",
      "CommonAssets/UI/Icons/video.tga",
      "ActionState",
      function(self, host)
        local sel = editor.GetSel()
        if sel and sel[1] and not sel[1]:IsAnimated() then
          return "hidden"
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        OpenAnimationMomentsEditor(editor.GetSel()[1])
      end,
      "ActionContexts",
      {
        "SingleSelection"
      },
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Properties (Ctrl-O); Ctrl-RMB is there only to be displayed in context menu",
      "ActionId",
      "E_SelectedOptions",
      "ActionTranslate",
      false,
      "ActionName",
      "Properties",
      "ActionIcon",
      "CommonAssets/UI/Menu/object_options.tga",
      "ActionShortcut",
      "Ctrl-RMB",
      "ActionShortcut2",
      "Ctrl-O",
      "OnAction",
      function(self, host, source, ...)
        OpenGedGameObjectEditor(editor.GetSel())
      end,
      "ActionContexts",
      {
        "SingleSelection",
        "MultipleSelection"
      },
      "replace_matching_id",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionMode",
    "Editor",
    "ActionTranslate",
    false,
    "ActionMenubar",
    "DevMenu",
    "OnActionEffect",
    "popup",
    "replace_matching_id",
    true
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Editor",
      "ActionTranslate",
      false,
      "ActionName",
      "Editor",
      "ActionMenubar",
      "DevMenu",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Editor.Selections",
        "ActionTranslate",
        false,
        "ActionName",
        "Selections ...",
        "ActionIcon",
        "CommonAssets/UI/Menu/folder.tga",
        "OnActionEffect",
        "popup",
        "replace_matching_id",
        true
      }, {
        PlaceObj("XTemplateAction", {
          "comment",
          "Select Route",
          "RolloverText",
          "Select Route",
          "ActionId",
          "DE_SelectRoute",
          "ActionTranslate",
          false,
          "ActionName",
          "Select Route",
          "ActionIcon",
          "CommonAssets/UI/Menu/SelectRoute.tga",
          "OnAction",
          function(self, host, source, ...)
            local way_pt = selo()
            if not way_pt then
              return
            end
            local route = FindRouteWaypoints(way_pt.Route)
            editor.ClearSel()
            editor.AddToSel(route)
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Turn selected templates into spawned objects (Ctrl-Shift-Y)",
          "RolloverText",
          "Turn selected templates into spawned objects (Ctrl-Shift-Y)",
          "ActionId",
          "E_TurnSelectionToObjects",
          "ActionTranslate",
          false,
          "ActionName",
          "Spawn selected templates",
          "ActionIcon",
          "CommonAssets/UI/Menu/SelectionToObjects.tga",
          "ActionShortcut",
          "Ctrl-Shift-Y",
          "OnAction",
          function(self, host, source, ...)
            Template.TurnTemplatesIntoObjects(editor.GetSel())
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Turn selected objects into templates (Ctrl-Shift-T)",
          "RolloverText",
          "Turn selected objects into templates (Ctrl-Shift-T)",
          "ActionId",
          "E_TurnSelectionToTemplates",
          "ActionTranslate",
          false,
          "ActionName",
          "Turn selection to templates",
          "ActionIcon",
          "CommonAssets/UI/Menu/SelectionToTemplates.tga",
          "OnAction",
          function(self, host, source, ...)
            Template.TurnObjectsIntoTemplates(editor.GetSel())
          end,
          "replace_matching_id",
          true
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Editor.Objects",
        "ActionTranslate",
        false,
        "ActionName",
        "Objects ...",
        "ActionIcon",
        "CommonAssets/UI/Menu/folder.tga",
        "OnActionEffect",
        "popup",
        "replace_matching_id",
        true
      }, {
        PlaceObj("XTemplateAction", {
          "comment",
          "Removes texts from the selected objects",
          "RolloverText",
          "Removes texts from the selected objects",
          "ActionId",
          "E_RemoveTextsFromSelected",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove Texts from Selected",
          "OnAction",
          function(self, host, source, ...)
            local objs = editor.GetSel()
            for i = 1, #objs do
              objs[i]:DestroyAttaches("Text")
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Removes texts from the selected objects",
          "RolloverText",
          "Removes texts from the selected objects",
          "ActionId",
          "E_RemoveAllTexts",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove All Texts",
          "OnAction",
          function(self, host, source, ...)
            RemoveAllTexts()
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Adds LOD and distance indicators for the selected objects",
          "RolloverText",
          "Adds LOD and distance indicators for the selected objects",
          "ActionId",
          "E_ShowLOD",
          "ActionTranslate",
          false,
          "ActionName",
          "Show LOD info",
          "OnAction",
          function(self, host, source, ...)
            local objs = editor.GetSel()
            for i = 1, #objs do
              do
                local o = objs[i]
                local f = function()
                  local pDist = o:GetVisualPos() - camera.GetPos()
                  return "Distance: " .. tostring(pDist:Len() / guim) .. [[

LOD: ]] .. tostring(o:GetCurrentLOD())
                end
                o:AttachUpdatingText(f)
              end
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Displays spots with orientation and name on the selected objects",
          "RolloverText",
          "Displays spots with orientation and name on the selected objects",
          "ActionId",
          "E_ShowSpots",
          "ActionTranslate",
          false,
          "ActionName",
          "Show Spots",
          "OnAction",
          function(self, host, source, ...)
            local objs = editor.GetSel()
            for i = 1, #objs do
              objs[i]:ShowSpots()
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Hides spots from the selected objects. If no objects are selected, it hides all spots",
          "RolloverText",
          "Hides spots from the selected objects. If no objects are selected, it hides all spots",
          "ActionId",
          "E_HideSpots",
          "ActionTranslate",
          false,
          "ActionName",
          "Hide Spots",
          "OnAction",
          function(self, host, source, ...)
            local objs = editor.GetSel()
            for i = 1, #objs do
              objs[i]:HideSpots()
            end
          end,
          "replace_matching_id",
          true
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Editor.Window",
        "ActionTranslate",
        false,
        "ActionName",
        "Window ...",
        "ActionIcon",
        "CommonAssets/UI/Menu/folder.tga",
        "OnActionEffect",
        "popup",
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Editor settings",
        "RolloverText",
        "Editor settings",
        "ActionId",
        "E_EditorSettings",
        "ActionTranslate",
        false,
        "ActionName",
        "Editor Settings",
        "ActionIcon",
        "CommonAssets/UI/Menu/object_options.tga",
        "ActionShortcut",
        "Ctrl-F3",
        "OnAction",
        function(self, host, source, ...)
          XEditorSettings:ToggleGedEditor()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Replay Particles",
        "RolloverText",
        "Toggle Particles Replay",
        "ActionId",
        "E_EditorToggleReplayParticles",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Replay Particles",
        "ActionIcon",
        "CommonAssets/UI/Menu/object_options.tga",
        "ActionShortcut",
        "Alt-E",
        "OnAction",
        function(self, host, source, ...)
          EditorSettings:SetTestParticlesOnChange(not EditorSettings:GetTestParticlesOnChange())
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Replay Particles",
        "RolloverText",
        "Toggle Particles Replay",
        "ActionId",
        "E_EditorReplayParticles",
        "ActionTranslate",
        false,
        "ActionName",
        "Replay Particles",
        "ActionIcon",
        "CommonAssets/UI/Menu/object_options.tga",
        "ActionShortcut",
        "Shift-E",
        "OnAction",
        function(self, host, source, ...)
          RecreateSelectedParticle("no delay")
        end,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Map",
      "ActionTranslate",
      false,
      "ActionName",
      "Map",
      "ActionMenubar",
      "DevMenu",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateAction", {
        "comment",
        "Saves the map (Ctrl-S)",
        "RolloverText",
        "Saves the map (Ctrl-S)",
        "ActionId",
        "DE_SaveDefaultMap",
        "ActionSortKey",
        "000",
        "ActionTranslate",
        false,
        "ActionName",
        "Save Map",
        "ActionIcon",
        "CommonAssets/UI/Menu/save_city.tga",
        "ActionShortcut",
        "Ctrl-S",
        "OnAction",
        function(self, host, source, ...)
          if cameraFly.IsActive() then
            return
          end
          CreateRealTimeThread(XEditorSaveMap)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Saves the list of entities present on the map",
        "RolloverText",
        "Saves the list of entities present on the map",
        "ActionId",
        "DE_SaveDefaultMapEntityList",
        "ActionSortKey",
        "0001",
        "ActionTranslate",
        false,
        "ActionName",
        "Save Map Entity List",
        "ActionIcon",
        "CommonAssets/UI/Menu/SaveMapEntityList.tga",
        "OnAction",
        function(self, host, source, ...)
          SaveMapEntityList(GetMap() .. "entlist.txt")
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "OpenMapFolder",
        "ActionSortKey",
        "0002",
        "ActionTranslate",
        false,
        "ActionName",
        "Open Map Folder",
        "OnAction",
        function(self, host, source, ...)
          AsyncExec("explorer " .. ConvertToOSPath("svnAssets/Source/" .. GetMap()))
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "BuildingRulesEditor",
        "ActionSortKey",
        "0004",
        "ActionTranslate",
        false,
        "ActionName",
        "Building Rules Editor",
        "OnAction",
        function(self, host, source, ...)
          OpenGedBuildingRulesEditor()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "NewRoom",
        "ActionSortKey",
        "0003",
        "ActionTranslate",
        false,
        "ActionName",
        "New Room",
        "ActionToolbar",
        "EditorRoomTools",
        "ActionToolbarSection",
        "Room",
        "ActionShortcut",
        "Ctrl-Shift-N",
        "OnAction",
        function(self, host, source, ...)
          SetDialogMode("XEditor", "XCreateRoomTool")
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "NewGuides",
        "ActionSortKey",
        "0004",
        "ActionTranslate",
        false,
        "ActionName",
        "New Guides",
        "ActionToolbar",
        "EditorRoomTools",
        "ActionToolbarSection",
        "Place Guides",
        "ActionShortcut",
        "Ctrl-Shift-G",
        "OnAction",
        function(self, host, source, ...)
          SetDialogMode("XEditor", "XCreateGuidesTool")
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ToggleRoomSelectionMode",
        "ActionSortKey",
        "0005",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Room Selection Mode",
        "ActionShortcut",
        "Ctrl-;",
        "OnAction",
        function(self, host, source, ...)
          ToggleRoomSelectionMode()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ToggleDestroyedAttachSelection",
        "ActionSortKey",
        "0005",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Destroyed Attach Selection",
        "ActionShortcut",
        "Ctrl-N",
        "OnAction",
        function(self, host, source, ...)
          ToggleDestroyedAttachSelectionMode()
        end,
        "__condition",
        function(parent, context)
          return Platform.developer and const.SlabSizeX and ShouldAttachSelectionShortcutWork()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ToggleInvulnerabilityMarkings",
        "ActionSortKey",
        "0005",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Invulnerability Markings",
        "ActionShortcut",
        "Ctrl-I",
        "OnAction",
        function(self, host, source, ...)
          ToggleInvulnerabilityMarkings()
        end,
        "__condition",
        function(parent, context)
          return Platform.developer and PersistableGlobals.DestructionInProgressObjs and const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "CreateBlackPlanes",
        "ActionSortKey",
        "0005",
        "ActionTranslate",
        false,
        "ActionName",
        "Create Black Planes From Edge Room Edges",
        "OnAction",
        function(self, host, source, ...)
          AnalyseRoomsAndPlaceBlackPlanesOnEdges()
        end,
        "__condition",
        function(parent, context)
          return Platform.developer and ShouldBlackPlanesShortcutWork()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "DeleteBlackPlanes",
        "ActionSortKey",
        "0005",
        "ActionTranslate",
        false,
        "ActionName",
        "Delete All Black Planes",
        "OnAction",
        function(self, host, source, ...)
          CleanBlackPlanes()
        end,
        "__condition",
        function(parent, context)
          return Platform.developer and ShouldBlackPlanesShortcutWork()
        end,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Terrain",
      "ActionTranslate",
      false,
      "ActionName",
      "Terrain",
      "ActionMenubar",
      "DevMenu",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateAction", {
        "comment",
        "Fix All Passability Holes",
        "RolloverText",
        "Fix All Passability Holes",
        "ActionId",
        "E_FindPassHoles",
        "ActionTranslate",
        false,
        "ActionName",
        "Fix All Passability Holes",
        "ActionIcon",
        "CommonAssets/UI/Menu/passability.tga",
        "OnAction",
        function(self, host, source, ...)
          XEditorUndo:BeginOp({
            passability = true,
            impassability = true,
            name = "Changed passability"
          })
          table.map(terrain.FindAndFillPassabilityHoles(30, 31), StoreErrorSource)
          XEditorUndo:EndOp()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ExportTerrainEditor",
        "ActionSortKey",
        "_002",
        "ActionTranslate",
        false,
        "ActionName",
        "Export Terrain",
        "OnAction",
        function(self, host, source, ...)
          local filename = GetMapName() .. ".heightmap.raw"
          if terrain.ExportHeightMap(filename) then
            print(string.format("Terrain heightmap exported to <color 0 255 0>'%s'</color>.", ConvertToOSPath(filename)))
          else
            print(string.format("<color 255 0 0>Error exporting terrain heightmap!</color>"))
          end
        end,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Objects",
      "ActionTranslate",
      false,
      "ActionName",
      "Objects",
      "ActionMenubar",
      "DevMenu",
      "OnActionEffect",
      "popup",
      "replace_matching_id",
      true
    }, {
      PlaceObj("XTemplateAction", {
        "comment",
        "Hide selected objects",
        "RolloverText",
        "Hide selected objects",
        "ActionId",
        "E_HideSelected",
        "ActionTranslate",
        false,
        "ActionName",
        "Hide selected",
        "ActionIcon",
        "CommonAssets/UI/Menu/HideSelected.tga",
        "OnAction",
        function(self, host, source, ...)
          editor.HideSelected()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Hide unselected objects",
        "RolloverText",
        "Hide unselected objects",
        "ActionId",
        "E_HideUnselected",
        "ActionTranslate",
        false,
        "ActionName",
        "Hide unselected",
        "ActionIcon",
        "CommonAssets/UI/Menu/HideUnselected.tga",
        "OnAction",
        function(self, host, source, ...)
          editor.HideUnselected()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Show all hidden objects",
        "RolloverText",
        "Show all hidden objects",
        "ActionId",
        "E_ShowAll",
        "ActionTranslate",
        false,
        "ActionName",
        "Show all",
        "ActionIcon",
        "CommonAssets/UI/Menu/ShowAll.tga",
        "OnAction",
        function(self, host, source, ...)
          editor.ShowHidden()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Add objects to collection (Ctrl-G)",
        "RolloverText",
        "Add objects to collection (Ctrl-G)",
        "ActionId",
        "E_AddToCollection",
        "ActionTranslate",
        false,
        "ActionName",
        "Add objects to collection",
        "ActionShortcut",
        "Ctrl-G",
        "OnAction",
        function(self, host, source, ...)
          Collection.AddToCollection()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Unlock collection (Alt-Shift-Z)",
        "RolloverText",
        "Unlock collection (Alt-Shift-Z)",
        "ActionId",
        "E_UnlockCollection",
        "ActionTranslate",
        false,
        "ActionName",
        "Unlock collection",
        "ActionIcon",
        "CommonAssets/UI/Menu/UnlockCollection.tga",
        "ActionShortcut",
        "Alt-Shift-Z",
        "ActionToggle",
        true,
        "ActionToggled",
        function(self, host)
          return editor.GetLockedCollectionIdx() ~= 0
        end,
        "OnAction",
        function(self, host, source, ...)
          Collection.UnlockAll()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Create collection (G)",
        "RolloverText",
        "Create collection (G)",
        "ActionId",
        "E_CollectObjects",
        "ActionTranslate",
        false,
        "ActionName",
        "Create collection",
        "ActionIcon",
        "CommonAssets/UI/Menu/CollectObjects.tga",
        "ActionShortcut",
        "G",
        "OnAction",
        function(self, host, source, ...)
          if IsEditorActive() then
            local sel = editor.GetSel()
            if sel and 0 < #sel then
              Collection.Collect(sel)
            end
          end
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Lock collection (Alt-Z)",
        "RolloverText",
        "Lock collection (Alt-Z)",
        "ActionId",
        "E_LockCollection",
        "ActionTranslate",
        false,
        "ActionName",
        "Lock selected collection",
        "ActionIcon",
        "CommonAssets/UI/Menu/LockCollection.tga",
        "ActionShortcut",
        "Alt-Z",
        "OnAction",
        function(self, host, source, ...)
          local obj = editor.GetSel()[1]
          local col = obj and obj:GetRootCollection()
          if col then
            col:SetLocked(true)
          end
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Select objects that share class with the selection",
        "RolloverText",
        "Select objects that share class with the selection",
        "ActionId",
        "E_SelectAllObjectsFromThisClass",
        "ActionTranslate",
        false,
        "ActionName",
        "Select objects that share class with the selection",
        "OnAction",
        function(self, host, source, ...)
          local sel = editor.GetSel()
          if not sel or #sel == 0 then
            return
          end
          local classes = table.get_unique(table.map(sel, "class"))
          editor.ClearSel()
          editor.AddToSel(MapGet("map", classes) or empty_table)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Select all objects by a class name",
        "RolloverText",
        "Select all objects by a class name",
        "ActionId",
        "E_SelectObjectByClassName",
        "ActionTranslate",
        false,
        "ActionName",
        "Select objects by class name",
        "ActionIcon",
        "CommonAssets/UI/Menu/SelectByClassName.tga",
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(function()
            local class = WaitInputText(nil, "Select by Class", "CObject")
            if not class then
              return
            end
            editor.SelectByClass(class)
          end)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Selection editor (Ctrl-E)",
        "RolloverText",
        "Selection editor (Ctrl-E)",
        "ActionId",
        "E_ObjsStats",
        "ActionTranslate",
        false,
        "ActionName",
        "Selection editor",
        "ActionIcon",
        "CommonAssets/UI/Menu/SelectionEditor.tga",
        "ActionShortcut",
        "Ctrl-E",
        "OnAction",
        function(self, host, source, ...)
          if cameraFly.IsActive() then
            return
          end
          if not GetDialog("SelectionEditorDlg") then
            XEditorSetDefaultTool()
            OpenDialog("SelectionEditorDlg")
          end
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Select Similar Slabs (Ctrl-.)",
        "RolloverText",
        "Select Similar Slabs (Ctrl-.)",
        "ActionId",
        "E_SelectSimilarSlabs",
        "ActionTranslate",
        false,
        "ActionName",
        "Select Similar Slabs",
        "ActionShortcut",
        "Ctrl-.",
        "OnAction",
        function(self, host, source, ...)
          EditorSelectSimilarSlabs()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Select Similar Slabs Precise (Ctrl-Shift-.)",
        "RolloverText",
        "Select Similar Slabs Precise (Ctrl-Shift-.)",
        "ActionId",
        "E_SelectSimilarSlabsPrecise",
        "ActionTranslate",
        false,
        "ActionName",
        "Select Similar Slabs Precise",
        "ActionShortcut",
        "Ctrl-Shift-.",
        "OnAction",
        function(self, host, source, ...)
          EditorSelectSimilarSlabs(true)
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Destroy Selected Objects (Shift-D)",
        "RolloverText",
        "Destroy Selected Objects (Shift-D)",
        "ActionId",
        "E_DestroySelectedObjects",
        "ActionTranslate",
        false,
        "ActionName",
        "Destroy Selected Objects",
        "ActionShortcut",
        "Shift-D",
        "OnAction",
        function(self, host, source, ...)
          EditorDestroyRepairSelectedObjs("destroy")
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Repair Selected Objects (Shift-R)",
        "RolloverText",
        "Repair Selected Objects (Shift-R)",
        "ActionId",
        "E_RepairSelectedObjects",
        "ActionTranslate",
        false,
        "ActionName",
        "Repair Selected Objects",
        "ActionShortcut",
        "Shift-R",
        "OnAction",
        function(self, host, source, ...)
          EditorDestroyRepairSelectedObjs()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Associate Lights For Destruction",
        "RolloverText",
        "Associate Lights For Destruction",
        "ActionId",
        "E_AssociateLightsForDestruction",
        "ActionTranslate",
        false,
        "ActionName",
        "Associate Lights For Destruction",
        "ActionMenubar",
        "Map",
        "ActionShortcut",
        "Shift-V",
        "OnAction",
        function(self, host, source, ...)
          AssociateLights()
        end,
        "__condition",
        function(parent, context)
          return ShouldShowAssociateLightsShortcut()
        end,
        "replace_matching_id",
        true
      })
    }),
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
          "Toggle Objects Rotation",
          "RolloverText",
          "Toggle Objects Rotation",
          "ActionId",
          "tex_EditorRotateSelObjects",
          "ActionTranslate",
          false,
          "ActionName",
          "Toggle Objects Rotation",
          "ActionIcon",
          "CommonAssets/UI/Menu/RotateObjectsTool.tga",
          "OnAction",
          function(self, host, source, ...)
            local sel = editor:GetSel()
            local objects = editor.RotatingObjects
            for i = 1, #sel do
              local selelem = sel[i]
              local bFound = false
              for j = #objects, 1, -1 do
                local elem = objects[j]
                if elem.obj == selelem then
                  table.remove(objects, j)
                  selelem:SetAngle(60 * elem.angle)
                  bFound = true
                end
              end
              if not bFound then
                objects[#objects + 1] = {
                  obj = selelem,
                  angle = selelem:GetAngle() / 60
                }
              end
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Show-Hide Collision Geometry of selected objects",
          "RolloverText",
          "Show-Hide Collision Geometry of selected objects",
          "ActionId",
          "E_ShowCollisionGeometry",
          "ActionTranslate",
          false,
          "ActionName",
          "Show-Hide Collision Geometry",
          "ActionIcon",
          "CommonAssets/UI/Menu/CollisionGeometry.tga",
          "OnAction",
          function(self, host, source, ...)
            ToggleHR("ShowSelectionCollisions")
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Toggle particles (Shift-P)",
          "RolloverText",
          "Toggle particles (Shift-P)",
          "ActionId",
          "E_ToggleParticles",
          "ActionTranslate",
          false,
          "ActionName",
          "Toggle Particles",
          "ActionShortcut",
          "Shift-P",
          "OnAction",
          function(self, host, source, ...)
            ToggleInvisibleObjectHelpers()
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Toggle Camera Type (Ctrl-Shift-W)",
          "RolloverText",
          "Toggle Camera Type (Ctrl-Shift-W)",
          "ActionId",
          "E_CameraChange",
          "ActionTranslate",
          false,
          "ActionName",
          "Toggle Camera Type",
          "ActionIcon",
          "CommonAssets/UI/Menu/CameraToggle.tga",
          "ActionShortcut",
          "Ctrl-Shift-W",
          "OnAction",
          function(self, host, source, ...)
            if cameraRTS.IsActive() then
              cameraFly.Activate(1)
            elseif cameraFly.IsActive() then
              cameraMax.Activate(1)
            else
              cameraRTS.Activate(1)
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Camera Save (Alt-,)",
          "RolloverText",
          "Camera Save (Alt-,)",
          "ActionId",
          "E_CameraSave",
          "ActionTranslate",
          false,
          "ActionName",
          "Camera Save",
          "ActionIcon",
          "CommonAssets/UI/Menu/UnlockCamera.tga",
          "ActionShortcut",
          "Alt-,",
          "OnAction",
          function(self, host, source, ...)
            LocalStorage.saved_camera = {
              GetCamera()
            }
            SaveLocalStorage()
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Camera Load (Alt-.)",
          "RolloverText",
          "Camera Load (Alt-.)",
          "ActionId",
          "E_CameraLoad",
          "ActionTranslate",
          false,
          "ActionName",
          "Camera Load",
          "ActionIcon",
          "CommonAssets/UI/Menu/CameraEditor.tga",
          "ActionShortcut",
          "Alt-.",
          "OnAction",
          function(self, host, source, ...)
            if LocalStorage.saved_camera then
              SetCamera(unpack_params(LocalStorage.saved_camera))
            end
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Toggle spawned objects (Ctrl-Shift-H)",
          "RolloverText",
          "Toggle spawned objects (Ctrl-Shift-H)",
          "ActionId",
          "E_ToggleSpawnedObjects",
          "ActionTranslate",
          false,
          "ActionName",
          "Toggle spawned objects",
          "ActionIcon",
          "CommonAssets/UI/Menu/ToggleSpawn.tga",
          "ActionShortcut",
          "Ctrl-Shift-H",
          "ActionToggle",
          true,
          "ActionToggled",
          function(self, host)
            return HiddenSpawnedObjects
          end,
          "OnAction",
          function(self, host, source, ...)
            ToggleSpawnedObjects()
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "List new entities for the past 7 days",
          "RolloverText",
          "List new entities for the past 7 days",
          "ActionId",
          "List New Entities",
          "ActionTranslate",
          false,
          "ActionName",
          "List new entities",
          "OnAction",
          function(self, host, source, ...)
            CreateRealTimeThread(function()
              _ListNewEntities(7)
            end)
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Install URL handler",
          "RolloverText",
          "Install URL handler",
          "ActionId",
          "Install URL handler",
          "ActionTranslate",
          false,
          "ActionName",
          "Install URL handler",
          "OnAction",
          function(self, host, source, ...)
            CreateRealTimeThread(function()
              SetupHGRunUrl()
            end)
          end,
          "replace_matching_id",
          true
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Tools.Collections",
        "ActionTranslate",
        false,
        "ActionName",
        "Collections ...",
        "ActionIcon",
        "CommonAssets/UI/Menu/folder.tga",
        "OnActionEffect",
        "popup",
        "replace_matching_id",
        true
      }, {
        PlaceObj("XTemplateAction", {
          "comment",
          "Remove All Collections",
          "RolloverText",
          "Remove All Collections",
          "ActionId",
          "DE_RemoveAllCollections",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove All Collections",
          "OnAction",
          function(self, host, source, ...)
            local removed = Collection.RemoveAll()
            print(removed, "collections removed")
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Remove All Nested Collections",
          "RolloverText",
          "Remove All Nested Collections",
          "ActionId",
          "DE_RemoveAllNestedCollections",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove Nested Collections",
          "OnAction",
          function(self, host, source, ...)
            local removed = Collection.RemoveAll(1)
            print(removed, "collections removed")
          end,
          "replace_matching_id",
          true
        }),
        PlaceObj("XTemplateAction", {
          "comment",
          "Remove All Single Object Collections",
          "RolloverText",
          "Remove All Single Object Collections",
          "ActionId",
          "DE_RemoveAllSingleObjectCollections",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove Single Object Collections",
          "OnAction",
          function(self, host, source, ...)
            local cols, removed = Collection.GetValid("remove_invalid", 2)
            print(removed, "collections removed")
          end,
          "replace_matching_id",
          true
        })
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Align object to terrain (Shift-A)",
        "RolloverText",
        "Align object to terrain (Shift-A)",
        "ActionId",
        "E_AxisOrientation",
        "ActionTranslate",
        false,
        "ActionName",
        "Align object to terrain",
        "ActionIcon",
        "CommonAssets/UI/Menu/Axis.tga",
        "ActionShortcut",
        "Shift-A",
        "OnAction",
        function(self, host, source, ...)
          local RndOffs = function(deg)
            local pt, sign, x, y, z
            sign = AsyncRand(2)
            if sign == 0 then
              sign = -1
            end
            x = sign * AsyncRand(deg)
            sign = AsyncRand(2)
            if sign == 0 then
              sign = -1
            end
            y = sign * AsyncRand(deg)
            sign = AsyncRand(2)
            if sign == 0 then
              sign = -1
            end
            z = sign * AsyncRand(deg)
            pt = point(x, y, z)
            return pt
          end
          local objects = editor:GetSel()
          XEditorUndo:BeginOp({
            objects = objects,
            name = string.format("Aligned %d objects to terrain", #objects)
          })
          SuspendPassEdits("E_AxisOrientation")
          rawset(_G, "sState", rawget(_G, "sState") or "Up")
          if sState == "Up" then
            for i = 1, #objects do
              local obj = objects[i]
              local dir, angle = obj:GetOrientation()
              obj:SetOrientation(axis_z, angle)
            end
            sState = "terrain_normal"
          elseif sState == "terrain_normal" then
            for i = 1, #objects do
              local obj = objects[i]
              local dir, angle = obj:GetOrientation()
              obj:SetOrientation(terrain.GetTerrainNormal(obj:GetPos()), angle)
            end
            sState = "terrain_normal_deviation"
          elseif sState == "terrain_normal_deviation" then
            for i = 1, #objects do
              local obj = objects[i]
              local dir, angle = obj:GetOrientation()
              dir = terrain.GetTerrainNormal(obj:GetPos()) + RndOffs(30)
              obj:SetOrientation(dir, angle)
            end
            sState = "Up"
          end
          ResumePassEdits("E_AxisOrientation")
          XEditorUndo:EndOp(objects)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        " (Alt-D)",
        "RolloverText",
        " (Alt-D)",
        "ActionId",
        "E_DistributeObjects",
        "ActionTranslate",
        false,
        "ActionName",
        "Distribute Objects",
        "ActionShortcut",
        "Alt-D",
        "OnAction",
        function(self, host, source, ...)
          if g_DistribObjs then
            return
          end
          local sel = editor.GetSel()
          if #sel < 2 then
            print("Select 2 (or more) objects")
            return
          end
          g_DistribObjs = DistribObjs:new({obj_sel = sel, project = true})
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Mirror selected object (Shift-M)",
        "RolloverText",
        "Mirror selected object (Shift-M)",
        "ActionId",
        "E_Mirror",
        "ActionTranslate",
        false,
        "ActionName",
        "Mirror object",
        "ActionIcon",
        "CommonAssets/UI/Menu/Mirror.tga",
        "ActionShortcut",
        "Shift-M",
        "OnAction",
        function(self, host, source, ...)
          local sel = editor:GetSel()
          editor.MirrorSel(sel)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        " (Ctrl-Alt-R)",
        "RolloverText",
        " (Ctrl-Alt-R)",
        "ActionId",
        "E_CustomScale",
        "ActionTranslate",
        false,
        "ActionName",
        "Random Scale Objects",
        "ActionShortcut",
        "Ctrl-Alt-R",
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(function()
            local ol = editor.GetSel()
            local n = WaitInputText(nil, "Scale Range (e.g. 90-110)", LocalStorage.CustomEditorOps and LocalStorage.CustomEditorOps.E_CustomScale or "80-120")
            if not n or not tonumber(n) then
              return
            end
            local low, high
            low = tonumber(n)
            if low == nil then
              low, high = string.match(n, "(%d+)%-(%d+)")
              low = tonumber(low)
              high = tonumber(high)
            else
              high = low
            end
            XEditorUndo:BeginOp({
              objects = editor.GetSel(),
              name = string.format("Random scaled %d objects", #editor.GetSel())
            })
            for i = 1, #ol do
              local o = ol[i]
              o:SetScale(low + AsyncRand(high - low + 1))
            end
            XEditorUndo:EndOp(editor.GetSel())
            LocalStorage.CustomEditorOps = LocalStorage.CustomEditorOps or {}
            LocalStorage.CustomEditorOps.E_CustomScale = n
          end)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        " (Ctrl-R)",
        "RolloverText",
        " (Ctrl-R)",
        "ActionId",
        "E_RandomRotate",
        "ActionTranslate",
        false,
        "ActionName",
        "Random rotate objects",
        "ActionShortcut",
        "Ctrl-R",
        "OnAction",
        function(self, host, source, ...)
          local ol = editor.GetSel()
          XEditorUndo:BeginOp({
            objects = editor.GetSel(),
            name = string.format("Random rotated %d objects", #editor.GetSel())
          })
          for i = 1, #ol do
            local o = ol[i]
            o:SetAngle(AsyncRand(21600))
          end
          XEditorUndo:EndOp(editor.GetSel())
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        " (Ctrl-K)",
        "RolloverText",
        " (Ctrl-K)",
        "ActionId",
        "E_Rotate90X",
        "ActionTranslate",
        false,
        "ActionName",
        "Rotate Object 180",
        "ActionShortcut",
        "Ctrl-K",
        "OnAction",
        function(self, host, source, ...)
          local ol = editor.GetSel()
          XEditorUndo:BeginOp({
            objects = editor.GetSel(),
            name = string.format("Rotated %d objects", #editor.GetSel())
          })
          for i = 1, #ol do
            local o = ol[i]
            local axis, angle = ComposeRotation(axis_y, 5400, o:GetAxis(), o:GetAngle())
            o:SetAxis(axis)
            o:SetAngle(angle)
          end
          XEditorUndo:EndOp(editor.GetSel())
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "(Ctrl-J)",
        "RolloverText",
        "(Ctrl-J)",
        "ActionId",
        "E_Rotate90Z",
        "ActionTranslate",
        false,
        "ActionName",
        "Rotate Object 90 Z",
        "ActionShortcut",
        "Ctrl-J",
        "OnAction",
        function(self, host, source, ...)
          local ol = editor.GetSel()
          XEditorUndo:BeginOp({
            objects = editor.GetSel(),
            name = string.format("Rotated %d objects", #editor.GetSel())
          })
          for i = 1, #ol do
            local o = ol[i]
            local axis, angle = ComposeRotation(axis_z, 5400, o:GetAxis(), o:GetAngle())
            o:SetAxis(axis)
            o:SetAngle(angle)
          end
          XEditorUndo:EndOp(editor.GetSel())
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Select objects on the same floor (Shift-F)",
        "RolloverText",
        "Select objects on the same floor (Shift-F)",
        "ActionId",
        "SelectFloor",
        "ActionTranslate",
        false,
        "ActionName",
        "Select objects on the same floor",
        "ActionIcon",
        "CommonAssets/UI/Menu/Cube.tga",
        "ActionShortcut",
        "Shift-F",
        "OnAction",
        function(self, host, source, ...)
          SelectSameFloorObjects(editor.GetSel())
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Snap selected object(s) onto terrain (Ctrl-D)",
        "RolloverText",
        "Snap selected object(s) onto terrain (Ctrl-D)",
        "ActionId",
        "E_ResetZ",
        "ActionTranslate",
        false,
        "ActionName",
        "Snap objects to terrain",
        "ActionShortcut",
        "Ctrl-D",
        "OnAction",
        function(self, host, source, ...)
          editor.ResetZ()
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "(Ctrl-Alt-I)",
        "RolloverText",
        "(Ctrl-Alt-I)",
        "ActionId",
        "E_RecreateRoomWallOrFloor",
        "ActionTranslate",
        false,
        "ActionName",
        "Recreate Room Slab Wall or Floor",
        "ActionShortcut",
        "Ctrl-Alt-I",
        "OnAction",
        function(self, host, source, ...)
          RecreateSelectedSlabFloorWall()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Snap selected object(s) onto room roof (Ctrl-Alt-D)",
        "RolloverText",
        "Snap selected object(s) onto room roof (Ctrl-Alt-D)",
        "ActionId",
        "E_SnapToRoof",
        "ActionTranslate",
        false,
        "ActionName",
        "Snap objects to roof",
        "ActionShortcut",
        "Ctrl-Alt-D",
        "OnAction",
        function(self, host, source, ...)
          editor.SnapToRoof()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Clear selected object(s)' roof flags (Shift-Alt-D)",
        "RolloverText",
        "Clear selected object(s)' roof flags (Shift-Alt-D)",
        "ActionId",
        "E_ClearRoofFlag",
        "ActionTranslate",
        false,
        "ActionName",
        "Clear objects roof flag",
        "ActionShortcut",
        "Alt-Shift-D",
        "OnAction",
        function(self, host, source, ...)
          editor.ClearRoofFlags()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Toggle whether an obj should hide with its encompassing room. (Alt-H)",
        "RolloverText",
        "Toggle whether an obj should hide with its encompassing room. (Alt-H)",
        "ActionId",
        "E_ToggleDontHideWithRoom",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle don't hide with room flag",
        "ActionShortcut",
        "Alt-H",
        "OnAction",
        function(self, host, source, ...)
          editor.ToggleDontHideWithRoom()
        end,
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Snap selected object(s) onto terrain while preserving their relative positions. (Ctrl-Shift-D)",
        "RolloverText",
        "Snap selected object(s) onto terrain while preserving their relative positions. (Ctrl-Shift-D)",
        "ActionId",
        "E_ResetZRelative",
        "ActionTranslate",
        false,
        "ActionName",
        "Snap objects to terrain (Relative)",
        "ActionShortcut",
        "Ctrl-Shift-D",
        "OnAction",
        function(self, host, source, ...)
          editor.ResetZ(true)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Toggle Force Night (for light objects)",
        "RolloverText",
        "Toggle Force Night (for light objects)",
        "ActionId",
        "Toggle Force Night",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Force Night",
        "ActionIcon",
        "CommonAssets/UI/Menu/ToggleEnvMap.tga",
        "OnAction",
        function(self, host, source, ...)
          EditorForceNight = not EditorForceNight
          MapForEach("map", "LightObject", function(x)
            x:UpdateLight(CurrentLightmodel[1])
          end)
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "Toggle Transparency Cone",
        "RolloverText",
        "Toggle Transparency Cone",
        "ActionId",
        "Toggle Transparency Cone",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Transparency Cone",
        "ActionIcon",
        "CommonAssets/UI/Menu/ToggleEnvMap.tga",
        "OnAction",
        function(self, host, source, ...)
          return ToggleTransparencyCone()
        end,
        "replace_matching_id",
        true
      })
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Replace object(s) with object(s) from other class (Shift-~)",
      "ActionId",
      "E_ReplaceObjects",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "Shift-~",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          local c = selo()
          if c and IsValid(c) then
            local class = WaitInputText(nil, "Type class name(s)", c.class)
            if class then
              editor.ReplaceObjects(editor:GetSel(), class)
            end
          end
        end)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Array (Ctrl-Numpad *)",
      "ActionId",
      "Array",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "Ctrl-Numpad *",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          local sel = editor.GetSel()
          if #sel == 2 then
            local n = WaitInputText(nil, "Number of objects", "3")
            if not n then
              return
            end
            n = tonumber(n)
            if n and 2 < n then
              XEditorUndo:BeginOp({objects = sel})
              local pt = sel[1]:GetVisualPos()
              local vec = sel[2]:GetVisualPos() - pt
              for i = 3, n do
                sel[i] = sel[2]:Clone()
                sel[i]:SetGameFlags(const.gofPermanent)
                sel[i]:SetPos(pt + (i - 1) * vec)
              end
              XEditorUndo:EndOp(sel)
              editor.ChangeSelWithUndoRedo(sel)
            end
          end
        end)
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      " (V)",
      "ActionId",
      "E_ViewSelection",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "V",
      "OnAction",
      function(self, host, source, ...)
        local sel = editor.GetSel()
        local cnt = #sel
        local center = point30
        for i = 1, cnt do
          local bsc = sel[i]:GetBSphere()
          center = center + bsc
        end
        if 0 < cnt then
          center = point(center:x() / cnt, center:y() / cnt, const.InvalidZ)
          center = center:SetZ(terrain.GetHeight(center))
          local selSize = 0
          for i = 1, cnt do
            local bsc, bsr = sel[i]:GetBSphere()
            local dist = bsc:Dist(center) + bsr
            if selSize < dist then
              selSize = dist
            end
          end
          local pos, lookat = cameraMax.GetPosLookAt()
          local vec = pos - lookat
          local distToEye = vec:Dist(point30)
          local scale = selSize * 1000 / distToEye
          if 1000 < scale then
            vec = point(vec:x() * scale / 1000, vec:y() * scale / 1000, vec:z() * scale / 1000)
          end
          pos = center + vec
          cameraMax.SetCamera(pos, center, 0)
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Redo editor operation (Ctrl-Y)",
      "ActionId",
      "E_Redo",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "Ctrl-Y",
      "OnAction",
      function(self, host, source, ...)
        XEditorUndo:UndoRedo("redo")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Disable group selection (Ctrl-Q)",
      "RolloverText",
      "Disable group selection (Ctrl-Q)",
      "ActionId",
      "E_DisableGroupSelection",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/SelectSingleObject.tga",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Ctrl-Q",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return XEditorSelectSingleObjects == 1
      end,
      "OnAction",
      function(self, host, source, ...)
        XEditorSelectSingleObjects = 1 - XEditorSelectSingleObjects
        local statusbar = GetDialog("XEditorStatusbar")
        if statusbar then
          statusbar:ActionsUpdated()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Hide all texts (Alt-Shift-T)",
      "RolloverText",
      "Hide all texts (Alt-Shift-T)",
      "ActionId",
      "E_HideAllTexts",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/HideTexts.tga",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Alt-Shift-T",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return XEditorHideTexts == true
      end,
      "OnAction",
      function(self, host, source, ...)
        XEditorHideTexts = not XEditorHideTexts
        XEditorUpdateHiddenTexts()
        local statusbar = GetDialog("XEditorStatusbar")
        if statusbar then
          statusbar:ActionsUpdated()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Hide code renderables (Alt-Shift-R)",
      "RolloverText",
      "Hide code renderables (Alt-Shift-R)",
      "ActionId",
      "E_HideCodeRenderables",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/HideCodeRenderables.tga",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Alt-Shift-R",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return hr.RenderCodeRenderables == 0
      end,
      "OnAction",
      function(self, host, source, ...)
        hr.RenderCodeRenderables = 1 - hr.RenderCodeRenderables
        local tool = XEditorGetCurrentTool()
        if tool.UsesCodeRenderables or IsKindOf(tool, "XEditorPlacementHelperHost") and tool.placement_helper.UsesCodeRenderables then
          if XEditorIsDefaultTool() then
            tool:SetHelperClass("XSelectObjectsHelper")
          else
            XEditorSetDefaultTool()
          end
        end
        local statusbar = GetDialog("XEditorStatusbar")
        if statusbar then
          statusbar:ActionsUpdated()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Open caves (Alt-Shift-E)",
      "RolloverText",
      "Open caves (Alt-Shift-E)",
      "ActionId",
      "E_OpenCaves",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/CavesView",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Alt-Shift-E",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return CavesOpened
      end,
      "OnAction",
      function(self, host, source, ...)
        EditorSetCavesOpen(not CavesOpened)
      end,
      "__condition",
      function(parent, context)
        return const.CaveTileSize
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Room tools (Alt-R)",
      "RolloverText",
      "Room tools (Alt-R)",
      "ActionId",
      "E_RoomTools",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Editor/Tools/RoomTools.tga",
      "ActionToolbar",
      "EditorStatusbar",
      "ActionShortcut",
      "Alt-R",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return GetDialog("XEditorRoomTools")
      end,
      "OnAction",
      function(self, host, source, ...)
        if GetDialog("XEditorRoomTools") then
          CloseDialog("XEditorRoomTools")
        else
          OpenDialog("XEditorRoomTools")
        end
        local statusbar = GetDialog("XEditorStatusbar")
        if statusbar then
          statusbar:ActionsUpdated()
        end
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      " (Ctrl-Pagedown)",
      "ActionId",
      "E_ResetZ2",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "Ctrl-Pagedown",
      "OnAction",
      function(self, host, source, ...)
        editor.ResetZ()
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Undo editor operation (Ctrl-Z)",
      "ActionId",
      "E_Undo",
      "ActionTranslate",
      false,
      "ActionShortcut",
      "Ctrl-Z",
      "OnAction",
      function(self, host, source, ...)
        XEditorUndo:UndoRedo("undo")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Measure tool (Alt-M)",
      "RolloverText",
      "Measure tool (Alt-M)",
      "ActionId",
      "DE_ToggleMeasure_Old",
      "ActionSortKey",
      "00",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/MeasureTool.tga",
      "ActionShortcut",
      "Alt-M",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return GetDialogMode("XEditor") == "XMeasureTool"
      end,
      "OnAction",
      function(self, host, source, ...)
        SetDialogMode("XEditor", "XMeasureTool")
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Show/Hide the User Actions toolbar (Tab)",
      "ActionId",
      "DE_Toolbar",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Tab",
      "OnAction",
      function(self, host, source, ...)
        if IsEditorActive() then
          XShortcutsTarget:Toggle()
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "Toggle between local and global coordinate systems for helpers (Shift-C)",
      "ActionId",
      "DE_LocalCoordinates",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Shift-C",
      "OnAction",
      function(self, host, source, ...)
        if IsEditorActive() then
          SetLocalCS(not GetLocalCS())
        end
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SelectNorthWall",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl-[",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomSelectWall("North")
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SelectEastWall",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl-]",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomSelectWall("East")
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SelectWestWall",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl-P",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomSelectWall("West")
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SelectSouthWall",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl-'",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomSelectWall("South")
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ClearSelectedWall",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl--",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomClearSelectedWall()
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ResetWallMaterials",
      "ActionTranslate",
      false,
      "ActionIcon",
      "CommonAssets/UI/Menu/default.tga",
      "ActionShortcut",
      "Ctrl-Backspace",
      "OnAction",
      function(self, host, source, ...)
        SelectedRoomResetWallMaterials()
      end,
      "__condition",
      function(parent, context)
        return const.SlabSizeX
      end,
      "replace_matching_id",
      true
    })
  })
})
