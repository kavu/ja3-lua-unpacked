PlaceObj("XTemplate", {
  group = "Zulu",
  id = "XZuluLoadingScreen",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluLoadingScreen",
    "Id",
    "idLoadingScreen",
    "OnLayoutComplete",
    function(self)
      local context = self:GetContext()
      self:Update(context)
    end,
    "DrawOnTop",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if context.loaded then
        self.idStart:SetVisible(true)
        self.idStart:SetEnabled(true)
        self.idLoading:SetVisible(false)
        self:Update(context)
        self:SetFocus()
        self:SetModal()
      end
    end,
    "FocusOnOpen",
    "self"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        local context = self:GetContext()
        if context.loaded then
          self.idStart:Press()
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        local data, sector, sector_id
        local loadingReason = self.context.reason
        if self.context.metadata and self.context.metadata.sector and (loadingReason == "load savegame" or loadingReason == "host game") then
          sector = {}
          sector.Intel = self.context.metadata.intel
          sector.intel_discovered = self.context.metadata.intel_discovered
          sector.GroundSector = self.context.metadata.ground_sector
          sector.Side = self.context.metadata.side
          sector.display_name = T({
            TranslationTable[self.context.metadata.mapName]
          })
          data = self.context.metadata
        elseif self.context and (loadingReason == "quick start" or loadingReason == "enter sector") then
          sector_id = self.context.info_text
          sector = gv_Sectors and gv_Sectors[sector_id] or Game and table.find_value(CampaignPresets[Game.Campaign].Sectors, "Id", sector_id)
          data = {}
          data.sector = sector_id
          data.campaign = Game.Campaign
          data.weather = GetCurrentSectorWeather(sector_id)
          data.tod = Game and Game.Campaign and Game.CampaignTime and CalculateTimeOfDay(Game.CampaignTime)
          data.game_date = Game and Game.CampaignTime
          data.satellite = self.context.id == "idSatelliteView"
          data.lethal_weapons = IsGameRuleActive("LethalWeapons")
        elseif self.context.id == "idSatelliteView" then
          data = {}
          data.satellite = true
          data.campaign = self.context.metadata and self.context.metadata.campaign or Game.Campaign
          sector = false
        else
          sector = false
          data = false
        end
        local img_ext = ""
        if UIL.GetScreenSize():y() >= 2160 and (Platform.desktop or Platform.xbox or Platform.xbox_series_x or Platform.xbox_series_s or Platform.ps5) then
          img_ext = ".4k"
        end
        local img = g_DefaultLoadingScreen
        local campaign_folder, sector_img
        if data and data.campaign then
          campaign_folder = "UI/LoadingScreens/" .. data.campaign .. "/"
          if data.satellite then
            img = GetSatelliteLoadingScreen(campaign_folder, img_ext ~= "") or img
          elseif data.sector and data.campaign then
            sector_img = campaign_folder .. data.sector .. img_ext
            if ResourceManager.GetResourceID(sector_img) ~= const.InvalidResourceID then
              img = sector_img
            end
          end
        end
        self.idImage:SetImage(img)
        self.idOptional:SetVisible(not not next(data))
        local weather, tod, weatherPreset, todPreset
        if next(data) and sector then
          self.idTitle:SetVisible(true)
          self.idSector:SetText(T({
            764093693143,
            "<SectorIdColored(id)>",
            id = data.sector
          }))
          self.idSquareSector:SetBackground(GetSectorControlColor(sector and sector.Side or "player1"))
          if data.satellite then
            self.idMapName:SetText(T(265248539737, "Sat View"))
          else
            self.idMapName:SetText(sector.display_name)
          end
          weather = data.weather
          tod = data and data.campaign and data.game_date and CalculateTimeOfDay(data.game_date)
          if sector.GroundSector then
            tod = "Underground"
            weather = false
          end
          if tod == "Sunrise" then
            tod = false
          end
          if tod == "Sunset" then
            tod = false
          end
          if tod == "Day" then
            tod = false
          end
          local intel = sector.Intel and sector.intel_discovered
          self.idimgWeather:SetVisible(weather)
          self.idWeather:SetVisible(weather)
          self.idWeather.parent:SetVisible(weather)
          if weather then
            weatherPreset = GameStateDefs[weather]
            self.idimgWeather:SetImage(weatherPreset.Icon)
            self.idWeather:SetText(weatherPreset:GetDisplayName())
          end
          todPreset = GameStateDefs[tod]
          self.idimgTOD:SetVisible(tod)
          self.idTOD:SetVisible(tod)
          self.idimgTOD.parent:SetVisible(tod)
          if tod then
            self.idimgTOD:SetImage(todPreset.Icon or GameStateDefs.Day.Icon)
            self.idTOD:SetText(todPreset:GetDisplayName())
          end
          self.idIntel:SetVisible(sector.Intel)
          self.idimgIntel:SetVisible(sector.Intel)
          self.idIntel.parent:SetVisible(sector.Intel)
          if sector.Intel then
            self.idIntel:SetText(intel and T(304425875136, "Intel") or T(706438460476, "No intel"))
            self.idimgIntel:SetImage(intel and "UI/Icons/Hud/recon_open" or "UI/Icons/Hud/recon_close")
          end
        end
        local quests = {}
        if data and data.quest_tracker then
          for _, questData in ipairs(data.quest_tracker) do
            if questData.questVars then
              local notes = {}
              for _, noteTId in ipairs(questData.questNotes) do
                table.insert(notes, T({
                  TranslationTable[noteTId],
                  questData.questVars
                }))
              end
              table.insert(quests, {
                Name = T({
                  TranslationTable[questData.questName],
                  questData.questVars
                }),
                Notes = notes
              })
            else
              local notes = {}
              for _, noteData in ipairs(questData.questNotes) do
                table.insert(notes, Untranslated(noteData))
              end
              table.insert(quests, {
                Name = Untranslated(questData.questName),
                Notes = notes
              })
            end
          end
        elseif next(data) then
          quests = GetAllQuestsForTracker(sector_id)
        end
        self.idQuestNotes:SetVisible(not not next(quests))
        self.idQuestNotes:SetContext(quests)
        if not next(LoadingScreenHints) or not data then
          return
        end
        if self.idHint:GetText() ~= "" then
          return
        end
        local hint
        if self.idHint:GetText() ~= "" then
          hint = self.idHint:GetText()
        else
          local seen_hints = g_LoadingHintsSeen or {}
          local has_night = tod == "Night" or tod == "Underground"
          local has_weather = weather and weather ~= "ClearSky"
          local night_hint = (tod == "Night" or tod == "Underground") and not seen_hints[tod]
          local weather_hint = weather and weather ~= "ClearSky" and not seen_hints[weather]
          if weather_hint then
            hint = T({
              989146922853,
              "<DisplayName> - <description>",
              weatherPreset
            })
            seen_hints[weather] = true
          elseif night_hint then
            hint = T({
              989146922853,
              "<DisplayName> - <description>",
              todPreset
            })
            seen_hints[tod] = true
          else
            local rnd = AsyncRand(100)
            if 50 < rnd or not has_weather and not has_night then
              hint = Presets.LoadingScreenHint.Default[g_LoadingHintsNextIdx or 1]
              g_LoadingHintsNextIdx = (g_LoadingHintsNextIdx or 1) + 1
              if g_LoadingHintsNextIdx > #Presets.LoadingScreenHint.Default then
                g_LoadingHintsNextIdx = 1
              end
              if data and data.lethal_weapons and hint.id == "Downed" then
                hint = Presets.LoadingScreenHint.Default[g_LoadingHintsNextIdx or 1]
                g_LoadingHintsNextIdx = (g_LoadingHintsNextIdx or 1) + 1
                if g_LoadingHintsNextIdx > #Presets.LoadingScreenHint.Default then
                  g_LoadingHintsNextIdx = 1
                end
              end
              hint = hint.text
            elseif has_weather and has_night then
              local rnd = AsyncRand(100)
              hint = 50 < rnd and T({
                989146922853,
                "<DisplayName> - <description>",
                weatherPreset
              }) or T({
                989146922853,
                "<DisplayName> - <description>",
                todPreset
              })
              seen_hints[50 < rnd and weather or tod] = true
            else
              hint = has_weather and T({
                989146922853,
                "<DisplayName> - <description>",
                weatherPreset
              }) or T({
                989146922853,
                "<DisplayName> - <description>",
                todPreset
              })
              seen_hints[weather or tod] = true
            end
          end
        end
        self.idHint:SetText(hint)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Update(self, context)",
      "func",
      function(self, context)
        local id = context.id
        local sector_id = context.sector or context.info_text
        if Platform.developer and g_DbgAutoClickLoadingScreenStart and context.loaded then
          self:DeleteThread("autoclick")
          self:CreateThread("autoclick", function()
            Sleep(g_DbgAutoClickLoadingScreenStart)
            self.idStart:Press()
          end)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XAspectWindow"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImage",
        "IdNode",
        false,
        "MouseCursor",
        "UI/Cursors/Loading.tga",
        "ImageFit",
        "largest"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "Id",
          "idQuestNotes",
          "Margins",
          box(0, 20, 25, 0),
          "BorderWidth",
          2,
          "HAlign",
          "right",
          "VAlign",
          "top",
          "Visible",
          false,
          "BorderColor",
          RGBA(52, 55, 61, 230),
          "Background",
          RGBA(32, 35, 47, 215),
          "BackgroundRectGlowSize",
          1,
          "BackgroundRectGlowColor",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XZuluScroll",
            "Id",
            "idScroll",
            "Dock",
            "right",
            "HAlign",
            "right",
            "MouseCursor",
            "UI/Cursors/Hand.tga",
            "Target",
            "idScrollArea",
            "SnapToItems",
            true,
            "AutoHide",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XScrollArea",
            "Id",
            "idScrollArea",
            "IdNode",
            false,
            "Dock",
            "left",
            "MinWidth",
            360,
            "MaxWidth",
            360,
            "MaxHeight",
            800,
            "LayoutMethod",
            "VList",
            "VScroll",
            "idScroll"
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, -2),
              "Dock",
              "top",
              "MinHeight",
              7,
              "MaxHeight",
              7,
              "Background",
              RGBA(52, 55, 61, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 1, 2, 0),
                "HAlign",
                "right",
                "VAlign",
                "top",
                "MinWidth",
                6,
                "MinHeight",
                6,
                "MaxWidth",
                6,
                "MaxHeight",
                6,
                "Background",
                RGBA(69, 73, 81, 255)
              })
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "quest notes",
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child.idTitle:SetText(item.Name)
                if i == last then
                  child.idSeparator:SetVisible(false)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "quest name",
                  "Padding",
                  box(10, 5, 10, 0),
                  "Dock",
                  "top",
                  "BorderColor",
                  RGBA(52, 55, 61, 230)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Margins",
                    box(0, 0, 5, 0),
                    "Dock",
                    "left",
                    "Image",
                    "UI/PDA/T_Icon_MainQuest",
                    "ImageScale",
                    point(450, 450)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idTitle",
                    "Clip",
                    false,
                    "UseClipBox",
                    false,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAQuestName",
                    "Translate",
                    true
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idNotes",
                  "Margins",
                  box(0, -12, 0, 0),
                  "Padding",
                  box(10, 10, 10, 5),
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "quest objective",
                    "array",
                    function(parent, context)
                      return context.Notes
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child:SetText(item.Text or item)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Clip",
                      false,
                      "UseClipBox",
                      false,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDAQuestTrackerDescr",
                      "Translate",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "separator line",
                      "__class",
                      "XFrame",
                      "Margins",
                      box(0, 5, 0, 5),
                      "FoldWhenHidden",
                      true,
                      "Image",
                      "UI/PDA/separate_line_vertical",
                      "FrameBox",
                      box(5, 0, 5, 0),
                      "SqueezeY",
                      false
                    })
                  }),
                  PlaceObj("XTemplateCode", {
                    "run",
                    function(self, parent, context)
                      local lastLine = parent[#parent]
                      if lastLine then
                        lastLine:SetVisible(false)
                      end
                    end
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "separator line",
                  "Id",
                  "idSeparator",
                  "Margins",
                  box(6, 5, 6, 5),
                  "Dock",
                  "bottom",
                  "MinHeight",
                  1,
                  "MaxHeight",
                  1,
                  "FoldWhenHidden",
                  true,
                  "Background",
                  RGBA(130, 128, 120, 255),
                  "Transparency",
                  77
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "Id",
          "idOptional",
          "IdNode",
          false,
          "Margins",
          box(0, 0, 0, 30),
          "Dock",
          "bottom",
          "MouseCursor",
          "UI/Cursors/Loading.tga"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "IdNode",
            false,
            "Margins",
            box(0, 40, 0, 0),
            "MinHeight",
            154,
            "MaxHeight",
            154,
            "Background",
            RGBA(0, 0, 0, 70),
            "MouseCursor",
            "UI/Cursors/Loading.tga",
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "Image",
            "UI/Inventory/T_Backpack_Slot_Small_2",
            "ImageFit",
            "stretch",
            "ImageRect",
            box(5, 0, 95, 100)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idHint",
              "Padding",
              box(30, 40, 2, 2),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              730,
              "MaxWidth",
              730,
              "TextStyle",
              "LoadingHint",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idStart",
              "Margins",
              box(0, 0, 30, 0),
              "Padding",
              box(5, 0, 5, 0),
              "HAlign",
              "right",
              "VAlign",
              "center",
              "MinWidth",
              154,
              "MinHeight",
              60,
              "MaxHeight",
              60,
              "Visible",
              false,
              "Background",
              RGBA(52, 55, 61, 255),
              "Enabled",
              false,
              "FXMouseIn",
              "buttonRollover",
              "FXPressDisabled",
              "IactDisabled",
              "FocusedBackground",
              RGBA(52, 55, 61, 255),
              "OnPress",
              function(self, gamepad)
                local context = self:GetContext()
                if not self:IsThreadRunning("close loading") or IsInMultiplayerGame() and IsWaitingForPlayerToClick(netUniqueId) then
                  self:DeleteThread("close loading")
                  self:CreateThread("close loading", function()
                    PlayFX("buttonPress", "start")
                    LoadingScreenClose("idLoadedLoadingScreen", "loaded")
                    WaitLoadingScreenClose()
                  end)
                end
              end,
              "RolloverBackground",
              RGBA(215, 159, 80, 255),
              "PressedBackground",
              RGBA(215, 159, 80, 255),
              "TextStyle",
              "LoadingButton",
              "Translate",
              true,
              "Text",
              T(500700649684, "Start")
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "controller hint",
                "__context",
                function(parent, context)
                  return "GamepadUIStyleChanged"
                end,
                "__class",
                "XText",
                "ZOrder",
                0,
                "HAlign",
                "left",
                "VAlign",
                "center",
                "FoldWhenHidden",
                true,
                "TextStyle",
                "HUDHeaderBig",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local gamepad = GetUIStyleGamepad()
                  self:SetVisible(gamepad)
                  self.parent:SetLayoutMethod(gamepad and "HList" or "Box")
                  XText.OnContextUpdate(self, context, ...)
                end,
                "Translate",
                true,
                "Text",
                T(581873934479, "<ButtonA>"),
                "TextVAlign",
                "center"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return not context.loaded
              end,
              "Id",
              "idLoading",
              "Margins",
              box(0, 0, 30, 0),
              "HAlign",
              "right",
              "VAlign",
              "center",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              10,
              "MouseCursor",
              "UI/Cursors/Loading.tga"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idLoadingText",
                "VAlign",
                "center",
                "TextStyle",
                "LoadingAnimText",
                "Translate",
                true,
                "Text",
                T(665087177892, "Loading")
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idLoadingAnim",
                "Image",
                "UI/Hud/radar",
                "Columns",
                24,
                "ImageScale",
                point(800, 800),
                "Animate",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idTitle",
            "Margins",
            box(30, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinHeight",
            54,
            "MaxHeight",
            54,
            "Visible",
            false,
            "Background",
            RGBA(52, 55, 61, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(20, 0, 20, 0),
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              50
            }, {
              PlaceObj("XTemplateWindow", {
                "HAlign",
                "left",
                "VAlign",
                "center",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XSquareWindow",
                  "Id",
                  "idSquareSector",
                  "VAlign",
                  "center",
                  "MinWidth",
                  30,
                  "MinHeight",
                  30,
                  "MaxHeight",
                  30,
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idSector",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Clip",
                    false,
                    "TextStyle",
                    "LoadingSector",
                    "Translate",
                    true,
                    "TextHAlign",
                    "center",
                    "TextVAlign",
                    "center"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idMapName",
                  "MinWidth",
                  350,
                  "TextStyle",
                  "LoadingScreenTitle",
                  "Translate",
                  true
                })
              }),
              PlaceObj("XTemplateWindow", {
                "VAlign",
                "center",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList",
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idimgTOD",
                    "FoldWhenHidden",
                    true,
                    "ImageScale",
                    point(700, 700)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idTOD",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Clip",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "LoadingTitleInfo",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true,
                    "TextHAlign",
                    "center",
                    "TextVAlign",
                    "center"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList",
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idimgWeather",
                    "FoldWhenHidden",
                    true,
                    "ImageScale",
                    point(700, 700)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idWeather",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Clip",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "LoadingTitleInfo",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true,
                    "TextHAlign",
                    "center",
                    "TextVAlign",
                    "center"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList",
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idimgIntel",
                    "FoldWhenHidden",
                    true,
                    "Columns",
                    2,
                    "ImageScale",
                    point(700, 700)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idIntel",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Clip",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "LoadingTitleInfo",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true,
                    "TextHAlign",
                    "center",
                    "TextVAlign",
                    "center"
                  })
                })
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XMuteSounds",
      "AudioGroups",
      set("Ambience", "AmbientLife", "Default")
    })
  })
})
