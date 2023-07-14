PlaceObj("XTemplate", {
  Comment = "character sheet",
  RequireActionSortKeys = true,
  __is_kind_of = "XWindow",
  group = "Zulu PDA",
  id = "PDAAimEvaluation",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return gv_UnitData[GetPlayerMercSquads()[1].units[1]]
    end,
    "__class",
    "PDAAIMEvaluation",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self:ResolveId("idContent"):SetContext(context)
    end,
    "InitialMode",
    "record",
    "InternalModes",
    "record, perks"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        PDAAIMEvaluation.Open(self, ...)
        AddPageToBrowserHistory("evaluation")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "background frame",
      "__class",
      "XImage",
      "IdNode",
      false,
      "Image",
      "UI/PDA/pda_background",
      "ImageFit",
      "stretch"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "window",
        "Margins",
        box(44, 18, 44, 18),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        1660,
        "MinHeight",
        830,
        "MaxWidth",
        1660,
        "MaxHeight",
        830,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Dock",
          "top",
          "MinHeight",
          32,
          "MaxHeight",
          32,
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(3, 5, 3, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Margins",
            box(12, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "TextStyle",
            "PDABrowserTitle",
            "Translate",
            true,
            "Text",
            T(548684733743, "A.I.M. EVALUATION")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Margins",
            box(0, 0, 15, 0),
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "TextStyle",
            "PDABrowserTitleSmall",
            "Translate",
            true,
            "Text",
            T(324205023460, "v.1.1B")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Padding",
          box(16, 14, 16, 4),
          "Dock",
          "box",
          "MinHeight",
          798,
          "MaxHeight",
          798,
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(3, 3, 3, 3)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "content",
            "__class",
            "XContentTemplate",
            "Id",
            "idContent",
            "IdNode",
            false,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 4, 0, 0),
              "Dock",
              "bottom",
              "MinHeight",
              52,
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {"MinWidth", 610}, {
                PlaceObj("XTemplateTemplate", {
                  "__condition",
                  function(parent, context)
                    return not InitialConflictNotStarted()
                  end,
                  "__template",
                  "PDAStartButton",
                  "Margins",
                  box(0, 0, 0, 15),
                  "Dock",
                  "left",
                  "VAlign",
                  "center",
                  "MinWidth",
                  200
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "SetOutsideScale(self, scale)",
                    "func",
                    function(self, scale)
                      local dlg = GetDialog("PDADialog")
                      local screen = dlg.idPDAScreen
                      XWindow.SetOutsideScale(self, screen.scale)
                    end
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "Dock",
                  "right",
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(8, 0, 16, -2),
                    "Padding",
                    box(0, 0, 0, 0),
                    "TextStyle",
                    "PDABrowserFlavor",
                    "Translate",
                    true,
                    "Text",
                    T(276501397506, "Secured connection"),
                    "TextVAlign",
                    "center"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Image",
                    "UI/PDA/Quest/secured"
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XToolBarList",
                "Id",
                "idLevelUpBar",
                "IdNode",
                false,
                "Dock",
                "box",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinHeight",
                48,
                "Background",
                RGBA(255, 255, 255, 0),
                "Toolbar",
                "LevelUpBar",
                "ButtonTemplate",
                "PDACommonButton"
              }, {
                PlaceObj("XTemplateAction", {
                  "comment",
                  "same as perk different condition",
                  "ActionId",
                  "idLevelUpAction",
                  "ActionSortKey",
                  "1000",
                  "ActionName",
                  T(470265902414, "LEVEL UP"),
                  "ActionToolbar",
                  "LevelUpBar",
                  "ActionShortcut",
                  "L",
                  "ActionGamepad",
                  "ButtonY",
                  "ActionButtonTemplate",
                  "PDACommonButtonOrange",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    local context = host:GetContext()
                    if dlg:GetMode() == "record" and context.perkPoints > 0 then
                      return "enabled"
                    else
                      return "hidden"
                    end
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    dlg:SetMode("perks")
                  end,
                  "FXMouseIn",
                  "buttonRollover",
                  "FXPress",
                  "buttonPressGeneric",
                  "FXPressDisabled",
                  "IactDisabled"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XToolBarList",
                "Id",
                "idToolBar",
                "IdNode",
                false,
                "Dock",
                "right",
                "HAlign",
                "right",
                "VAlign",
                "center",
                "LayoutHSpacing",
                16,
                "Background",
                RGBA(255, 255, 255, 0),
                "Toolbar",
                "ActionBar",
                "ButtonTemplate",
                "PDACommonButton"
              }, {
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idPerksAction",
                  "ActionSortKey",
                  "1010",
                  "ActionName",
                  T(294433237069, "Perks"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "P",
                  "ActionGamepad",
                  "ButtonY",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    local context = host:GetContext()
                    if dlg:GetMode() == "record" and context.perkPoints <= 0 then
                      return "enabled"
                    else
                      return "hidden"
                    end
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    dlg:SetMode("perks")
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idPerksConfirmAction",
                  "ActionSortKey",
                  "1020",
                  "ActionName",
                  T(715124601032, "Confirm"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "P",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    local context = host:GetContext()
                    if dlg:GetMode() == "perks" and context.perkPoints > 0 then
                      local perksDlg = dlg:ResolveValue("idPerks")
                      if perksDlg and perksDlg.SelectedPerkIds and 0 < #perksDlg.SelectedPerkIds then
                        return "enabled"
                      else
                        return "disabled"
                      end
                    else
                      return "hidden"
                    end
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    local perksDlg = dlg:ResolveValue("idPerks")
                    perksDlg:ConfirmPerks()
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idPreviousMerc",
                  "ActionSortKey",
                  "1030",
                  "ActionName",
                  T(550449531084, "Previous"),
                  "ActionShortcut",
                  "Shift-Tab",
                  "ActionGamepad",
                  "LeftShoulder",
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    dlg:SelectPrevMerc()
                  end,
                  "FXMouseIn",
                  "activityButtonHover_GatherIntel",
                  "FXPress",
                  "activityButtonPress_GatherIntel",
                  "FXPressDisabled",
                  "activityButtonDisabled_GatherIntel"
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idNextMerc",
                  "ActionSortKey",
                  "1040",
                  "ActionName",
                  T(655064233565, "Next"),
                  "ActionShortcut",
                  "Tab",
                  "ActionGamepad",
                  "RightShoulder",
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    dlg:SelectNextMerc()
                  end,
                  "FXMouseIn",
                  "activityButtonHover_GatherIntel",
                  "FXPress",
                  "activityButtonPress_GatherIntel",
                  "FXPressDisabled",
                  "activityButtonDisabled_GatherIntel"
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idStatsAction",
                  "ActionSortKey",
                  "1050",
                  "ActionName",
                  T(731677990405, "Stats"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "S",
                  "ActionGamepad",
                  "ButtonY",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    return dlg:GetMode() == "perks" and "enabled" or "hidden"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog(host)
                    dlg:SetMode("record")
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idMercsAction",
                  "ActionSortKey",
                  "1060",
                  "ActionName",
                  T(905658355422, "Mercs"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "M",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    return "enabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local popupHost = GetDialog("PDADialog")
                    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                    local mercsWindow = XTemplateSpawn("PDAMercProfiles", popupHost, {})
                    mercsWindow:Open()
                    mercsWindow:SetSelectedMercId(host:GetContext().session_id)
                  end,
                  "__condition",
                  function(parent, context)
                    return false
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idCloseActionPerks",
                  "ActionSortKey",
                  "1070",
                  "ActionName",
                  T(187868415093, "Close"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Escape",
                  "ActionGamepad",
                  "ButtonB",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    return dlg:GetMode() == "perks" and "enabled" or "hidden"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    CreateRealTimeThread(function()
                      if host:GetMode() == "perks" then
                        local perksDlg = host:ResolveId("idPerks")
                        if perksDlg.SelectedPerkIds and #perksDlg.SelectedPerkIds > 0 then
                          local popupHost = GetDialog("PDADialog")
                          popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                          local trainPerks = CreateQuestionBox(popupHost, T(326274240975, "New Perks"), T(615284649013, "Do you want to learn the perks you've selected?"), T(814633909510, "Confirm"), T(6879, "Cancel"))
                          local resp = trainPerks:Wait()
                          if resp == "ok" then
                            perksDlg:ConfirmPerks()
                          end
                        end
                      end
                      local pda = GetDialog("PDADialog")
                      pda:CloseAction(host)
                      return
                    end)
                  end,
                  "FXMouseIn",
                  "buttonRollover",
                  "FXPress",
                  "buttonPress",
                  "FXPressDisabled",
                  "IactDisabled"
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idCloseActionRecord",
                  "ActionSortKey",
                  "1080",
                  "ActionName",
                  T(187868415093, "Close"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Escape",
                  "ActionGamepad",
                  "ButtonB",
                  "ActionState",
                  function(self, host)
                    local dlg = GetDialog(host)
                    return dlg:GetMode() == "record" and "enabled" or "hidden"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    local pda = GetDialog("PDADialog")
                    pda:CloseAction(host)
                  end
                })
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idToggleHistoryAndStats",
              "ActionSortKey",
              "1090",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                local dlg = GetDialog(host)
                return dlg:GetMode() == "record" and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog(host)
                local recordDlg = dlg.idRecord
                if not recordDlg then
                  return
                end
                if recordDlg:GetMode() == "history" then
                  recordDlg:SetMode("stats")
                else
                  recordDlg:SetMode("history")
                end
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idEnlargeMercImage",
              "ActionSortKey",
              "1100",
              "ActionGamepad",
              "RightThumbClick",
              "ActionState",
              function(self, host)
                local dlg = GetDialog(host)
                return dlg:GetMode() == "record" and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog(host)
                local imageButton = dlg.idMercImageBigButton
                if imageButton then
                  imageButton:OnPress()
                end
              end
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "main",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "attributes",
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Padding",
                box(22, 6, 22, 12),
                "Dock",
                "left",
                "MinWidth",
                610,
                "MaxWidth",
                610,
                "Image",
                "UI/PDA/os_background",
                "FrameBox",
                box(3, 3, 3, 3)
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "header",
                  "Padding",
                  box(0, 4, 0, 4),
                  "Dock",
                  "top",
                  "MinHeight",
                  85,
                  "MaxHeight",
                  85,
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "prev",
                    "__template",
                    "PDASmallButton",
                    "IdNode",
                    false,
                    "Margins",
                    box(0, 0, 8, 0),
                    "Dock",
                    "left",
                    "HAlign",
                    "left",
                    "MinWidth",
                    24,
                    "MaxWidth",
                    24,
                    "ScaleModifier",
                    point(1000, 1000),
                    "FXMouseIn",
                    "",
                    "FXPress",
                    "",
                    "FXPressDisabled",
                    "",
                    "OnPress",
                    function(self, gamepad)
                      local dlg = GetDialog(self)
                      local previousAction = dlg:ActionById("idPreviousMerc")
                      dlg:OnAction(previousAction)
                    end,
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "FlipX",
                    true,
                    "CenterImage",
                    "UI/PDA/T_Icon_Play"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "gamepad hint",
                      "__context",
                      function(parent, context)
                        return "GamepadUIStyleChanged"
                      end,
                      "__class",
                      "XText",
                      "Margins",
                      box(-5, -5, 0, 0),
                      "Clip",
                      false,
                      "UseClipBox",
                      false,
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        self:SetVisible(GetUIStyleGamepad())
                        XText.OnContextUpdate(self, context, ...)
                      end,
                      "Translate",
                      true,
                      "Text",
                      T(238402790013, "<LB>")
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "class icon",
                    "__class",
                    "XContextImage",
                    "Margins",
                    box(2, 2, 2, 2),
                    "Dock",
                    "left",
                    "HAlign",
                    "left",
                    "VAlign",
                    "center",
                    "MinWidth",
                    50,
                    "MinHeight",
                    50,
                    "MaxWidth",
                    50,
                    "MaxHeight",
                    50,
                    "ImageFit",
                    "smallest",
                    "ImageColor",
                    RGBA(230, 222, 202, 255),
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      self:SetImage(GetMercSpecIcon(context))
                    end
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Dock",
                    "left",
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "name",
                      "__class",
                      "XText",
                      "Margins",
                      box(0, 6, 0, 0),
                      "TextStyle",
                      "MercNameEvaluation",
                      "Translate",
                      true,
                      "Text",
                      T(562902609255, "<Name>")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Margins",
                      box(0, -6, 0, 0),
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "class info",
                        "__class",
                        "XText",
                        "TextStyle",
                        "PDABrowserSubtitleLight",
                        "Translate",
                        true,
                        "Text",
                        T(749158490275, "<MercSpec()>")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "class info",
                        "__condition",
                        function(parent, context)
                          return GetMercCurrentDailySalary(context.session_id) > 0
                        end,
                        "__class",
                        "XText",
                        "TextStyle",
                        "PDABrowserSubtitle",
                        "Translate",
                        true,
                        "Text",
                        T(459016279300, "/ Daily Salary")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "class info",
                        "__condition",
                        function(parent, context)
                          return GetMercCurrentDailySalary(context.session_id) > 0
                        end,
                        "__class",
                        "XText",
                        "TextStyle",
                        "PDABrowserSubtitleLight",
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          local salary = GetMercCurrentDailySalary(context.session_id)
                          local text = T({
                            418564557177,
                            "<money(salary)>",
                            salary = salary
                          })
                          self:SetText(text)
                        end,
                        "Translate",
                        true
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "level",
                    "ZOrder",
                    10,
                    "Dock",
                    "right",
                    "HAlign",
                    "center",
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Padding",
                      box(0, 0, 0, 0),
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "TextStyle",
                      "PDABrowserBigNumber",
                      "ContextUpdateOnOpen",
                      true,
                      "Translate",
                      true,
                      "Text",
                      T(738913633555, "<MercLevel()>")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Margins",
                      box(0, -10, 0, 0),
                      "Padding",
                      box(0, 0, 0, 0),
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "TextStyle",
                      "PDABrowserSubtitle",
                      "Translate",
                      true,
                      "Text",
                      T(267299905081, "LEVEL")
                    })
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "next",
                    "__template",
                    "PDASmallButton",
                    "IdNode",
                    false,
                    "Margins",
                    box(8, 0, 0, 0),
                    "Dock",
                    "right",
                    "HAlign",
                    "center",
                    "MinWidth",
                    24,
                    "MaxWidth",
                    24,
                    "ScaleModifier",
                    point(1000, 1000),
                    "FXMouseIn",
                    "",
                    "FXPress",
                    "",
                    "FXPressDisabled",
                    "",
                    "OnPress",
                    function(self, gamepad)
                      local dlg = GetDialog(self)
                      local nextAction = dlg:ActionById("idNextMerc")
                      dlg:OnAction(nextAction)
                    end,
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "CenterImage",
                    "UI/PDA/T_Icon_Play"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "gamepad hint",
                      "__context",
                      function(parent, context)
                        return "GamepadUIStyleChanged"
                      end,
                      "__class",
                      "XText",
                      "Margins",
                      box(-5, -5, 0, 0),
                      "Clip",
                      false,
                      "UseClipBox",
                      false,
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        self:SetVisible(GetUIStyleGamepad())
                        XText.OnContextUpdate(self, context, ...)
                      end,
                      "Translate",
                      true,
                      "Text",
                      T(995932052424, "<RB>")
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Dock",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "current status",
                  "__class",
                  "XText",
                  "Dock",
                  "top",
                  "MinHeight",
                  47,
                  "MaxHeight",
                  47,
                  "TextStyle",
                  "PDABrowserTextLight",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local sectorId = gv_Squads[context.Squad].CurrentSector
                    local sector = gv_Sectors[sectorId]
                    local text
                    if sector.conflict then
                      text = T({
                        903359955315,
                        "Engaged in conflict in sector <sectorId>.",
                        sectorId = Untranslated(sectorId)
                      })
                    else
                      local operation = SectorOperations[context.Operation]
                      if operation.id == "Arriving" or operation.id == "Traveling" then
                        text = T({
                          889510996961,
                          "<activity>.",
                          activity = operation.display_name
                        })
                      elseif operation.id == "Idle" then
                        text = T({
                          812039502354,
                          "<activity> in sector <sectorId>.",
                          activity = operation.display_name,
                          sectorId = Untranslated(sectorId)
                        })
                      else
                        local profession = table.find_value(operation.Professions, "id", context.OperationProfession)
                        text = T({
                          748263789018,
                          "<profession> in sector <sectorId>.",
                          profession = profession.display_name,
                          sectorId = Untranslated(sectorId)
                        })
                      end
                    end
                    local wounds = context:GetStatusEffect("Wounded")
                    if wounds then
                      text = text .. T({
                        195711054730,
                        "Has <wounds> wound(s).",
                        wounds = wounds.stacks
                      })
                    end
                    if context.Tiredness ~= 0 then
                      local effect = UnitTirednessEffect[context.Tiredness]
                      text = text .. T({
                        620948893123,
                        " <tiredness>.",
                        tiredness = CharacterEffectDefs[effect].DisplayName
                      })
                    end
                    self:SetText(text)
                    local limit = self.UpdateTimeLimit
                    if limit == 0 or limit <= RealTime() - self.last_update_time then
                      self:SetText(self.Text)
                    elseif not self:GetThread("ContextUpdate") then
                      self:CreateThread("ContextUpdate", function(self)
                        Sleep(self.last_update_time + self.UpdateTimeLimit - RealTime())
                        self:OnContextUpdate()
                      end, self)
                    end
                  end,
                  "Translate",
                  true,
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Dock",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "stat bars",
                  "Dock",
                  "top",
                  "MinHeight",
                  256,
                  "MaxHeight",
                  256,
                  "LayoutMethod",
                  "Grid",
                  "UniformColumnWidth",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(0, 0, 0, 8),
                    "Dock",
                    "top",
                    "TextStyle",
                    "PDABrowserHeader",
                    "Translate",
                    true,
                    "Text",
                    T(769722208341, "Stats")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "attributes",
                    "Margins",
                    box(3, 0, 0, 0),
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    -3
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return UnitPropertiesStats:GetAttributes()
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        child:SetAttribute(item.id)
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "PDAAttributeBar",
                        "HAlign",
                        "left"
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "skills",
                    "Margins",
                    box(0, 5, 0, 0),
                    "Padding",
                    box(18, 0, 0, 0),
                    "GridX",
                    2,
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    -3
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return UnitPropertiesStats:GetSkills()
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        child:SetAttribute(item.id)
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "PDAAttributeBar"
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XFrame",
                    "Margins",
                    box(0, 5, -5, 10),
                    "HAlign",
                    "right",
                    "MinWidth",
                    2,
                    "MaxWidth",
                    2,
                    "GridStretchX",
                    false,
                    "Image",
                    "UI/PDA/separate_line",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "SqueezeX",
                    false
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Dock",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "personal perks",
                  "Dock",
                  "top",
                  "MaxHeight",
                  128,
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "talent",
                    "__condition",
                    function(parent, context)
                      return not IsImpUnit(context)
                    end,
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Margins",
                      box(0, 4, 0, 4),
                      "TextStyle",
                      "PDABrowserNameSmall",
                      "Translate",
                      true,
                      "Text",
                      T(961479643645, "Talent")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Margins",
                      box(0, 0, 8, 4),
                      "LayoutMethod",
                      "HList",
                      "LayoutHSpacing",
                      8,
                      "LayoutVSpacing",
                      8
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                          return context:GetPerks(nil, "sort")
                        end,
                        "condition",
                        function(parent, context, item, i)
                          return item.Tier == "Personal"
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          child:SetPerkId(item.class)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {"__template", "PDAPerk"})
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return not IsImpUnit(context)
                    end,
                    "__class",
                    "XFrame",
                    "Margins",
                    box(0, 4, 8, 4),
                    "Image",
                    "UI/PDA/separate_line",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "SqueezeX",
                    false
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "traits",
                    "Margins",
                    box(0, 0, 8, 4),
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Margins",
                      box(0, 4, 0, 4),
                      "TextStyle",
                      "PDABrowserNameSmall",
                      "Translate",
                      true,
                      "Text",
                      T(861228350946, "Traits")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "LayoutMethod",
                      "HList",
                      "LayoutHSpacing",
                      8,
                      "LayoutVSpacing",
                      8
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                          return context:GetPerks(nil, "sort")
                        end,
                        "condition",
                        function(parent, context, item, i)
                          return not item:IsLevelUp() and item.Tier ~= "Personal"
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          child:SetPerkId(item.class)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {"__template", "PDAPerk"})
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Dock",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "general perks",
                  "Dock",
                  "top",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "TextStyle",
                    "PDABrowserNameSmall",
                    "Translate",
                    true,
                    "Text",
                    T(236089097173, "Perks")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HWrap",
                    "LayoutHSpacing",
                    8,
                    "LayoutVSpacing",
                    8
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return context:GetPerks(nil, "sort")
                      end,
                      "condition",
                      function(parent, context, item, i)
                        return item:IsLevelUp()
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        child:SetPerkId(item.class)
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {"__template", "PDAPerk"})
                    })
                  })
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "record"}, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "image",
                  "__class",
                  "XFrame",
                  "IdNode",
                  false,
                  "Margins",
                  box(16, 0, 16, 0),
                  "Dock",
                  "left",
                  "MinWidth",
                  376,
                  "MaxWidth",
                  376,
                  "Image",
                  "UI/PDA/os_background_2",
                  "FrameBox",
                  box(3, 3, 3, 3)
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDACommonButton",
                    "Id",
                    "idMercImageBigButton",
                    "Margins",
                    box(16, 0, 0, 16),
                    "Padding",
                    box(2, 2, 2, 2),
                    "Dock",
                    "box",
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    24,
                    "MinHeight",
                    24,
                    "MaxWidth",
                    24,
                    "MaxHeight",
                    24,
                    "OnPress",
                    function(self, gamepad)
                      local popupHost = GetDialog("PDADialog")
                      popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                      local mercWindow = XTemplateSpawn("PDAMercImageInspect", popupHost, self:GetContext())
                      mercWindow:Open()
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Image",
                      "UI/PDA/Quest/T_Icon_Plus",
                      "ImageFit",
                      "smallest"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextImage",
                    "MinWidth",
                    376,
                    "MinHeight",
                    730,
                    "MaxWidth",
                    376,
                    "MaxHeight",
                    730,
                    "ImageFit",
                    "largest",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      self:SetImage(context.BigPortrait)
                    end
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "record",
                  "__class",
                  "XDialog",
                  "Id",
                  "idRecord",
                  "Dock",
                  "left",
                  "MinWidth",
                  610,
                  "MaxWidth",
                  610,
                  "LayoutMethod",
                  "Grid",
                  "InitialMode",
                  "history",
                  "InternalModes",
                  "history, stats"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XTextButton",
                    "Id",
                    "idHistoryTab",
                    "Margins",
                    box(0, 0, 0, -2),
                    "Padding",
                    box(16, 0, 16, 0),
                    "MinHeight",
                    46,
                    "MaxHeight",
                    46,
                    "DrawOnTop",
                    true,
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "FXMouseIn",
                    "buttonRollover",
                    "FXPress",
                    "AIMCategoryMercsClick",
                    "OnPress",
                    function(self, gamepad)
                      local record = GetDialog(self)
                      record:SetMode("history")
                    end,
                    "Image",
                    "UI/PDA/Quest/tab_selected",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "TextStyle",
                    "PDABrowserTabSelected",
                    "Translate",
                    true,
                    "Text",
                    T(210141140528, "History")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XTextButton",
                    "Id",
                    "idStatsTab",
                    "Margins",
                    box(0, 0, 0, -2),
                    "Padding",
                    box(16, 0, 16, 0),
                    "MinHeight",
                    46,
                    "MaxHeight",
                    46,
                    "GridX",
                    2,
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "FXMouseIn",
                    "buttonRollover",
                    "FXPress",
                    "AIMCategoryMercsClick",
                    "OnPress",
                    function(self, gamepad)
                      local record = GetDialog(self)
                      record:SetMode("stats")
                    end,
                    "Image",
                    "UI/PDA/Quest/tab_selected",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "TextStyle",
                    "PDABrowserTabSelected",
                    "Translate",
                    true,
                    "Text",
                    T(113987221030, "Statistics")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "gamepad hint",
                    "__context",
                    function(parent, context)
                      return "GamepadUIStyleChanged"
                    end,
                    "__class",
                    "XText",
                    "Margins",
                    box(10, 0, 0, 0),
                    "VAlign",
                    "center",
                    "GridX",
                    3,
                    "ScaleModifier",
                    point(650, 650),
                    "Clip",
                    false,
                    "UseClipBox",
                    false,
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      self:SetVisible(GetUIStyleGamepad())
                      XText.OnContextUpdate(self, context, ...)
                    end,
                    "Translate",
                    true,
                    "Text",
                    T(177313543661, "<ButtonX>")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XFrame",
                    "IdNode",
                    false,
                    "Padding",
                    box(8, 8, 8, 8),
                    "MinWidth",
                    610,
                    "MaxWidth",
                    610,
                    "GridY",
                    2,
                    "GridWidth",
                    4,
                    "Image",
                    "UI/PDA/os_background",
                    "FrameBox",
                    box(3, 3, 3, 3)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContentTemplate",
                      "IdNode",
                      false
                    }, {
                      PlaceObj("XTemplateMode", {"mode", "history"}, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XScrollArea",
                          "Id",
                          "idHistoryRows",
                          "IdNode",
                          false,
                          "Padding",
                          box(8, 4, 8, 8),
                          "HAlign",
                          "left",
                          "VAlign",
                          "top",
                          "MinWidth",
                          460,
                          "MinHeight",
                          672,
                          "MaxWidth",
                          600,
                          "MaxHeight",
                          672,
                          "LayoutMethod",
                          "VList",
                          "VScroll",
                          "idHistoryScroll"
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "TextStyle",
                            "PDABrowserText",
                            "Translate",
                            true,
                            "Text",
                            T(731522640052, [[
Connecting to A.I.M. servers...
Security check... <em>Confirmed!</em>
------------------------------------]])
                          }),
                          PlaceObj("XTemplateForEach", {
                            "comment",
                            "merc history log",
                            "array",
                            function(parent, context)
                              return GetEmploymentHistory(context)
                            end,
                            "condition",
                            function(parent, context, item, i)
                              return EmploymentHistoryLines[item.id]
                            end,
                            "__context",
                            function(parent, context, item, i, n)
                              return item
                            end
                          }, {
                            PlaceObj("XTemplateWindow", {
                              "__class",
                              "XText",
                              "FoldWhenHidden",
                              true,
                              "TextStyle",
                              "PDABrowserTextLight",
                              "ContextUpdateOnOpen",
                              true,
                              "OnContextUpdate",
                              function(self, context, ...)
                                local preset = EmploymentHistoryLines[context.id]
                                if preset then
                                  local text = preset:GetText(context.context)
                                  if text then
                                    text = T({
                                      216000808992,
                                      "<style PDABrowserText>Level <level>: </style>",
                                      level = Untranslated(context.level)
                                    }) .. text
                                    self:SetText(text)
                                  end
                                end
                              end,
                              "Translate",
                              true,
                              "HideOnEmpty",
                              true
                            })
                          })
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "MessengerScrollbar",
                          "Id",
                          "idHistoryScroll",
                          "Margins",
                          box(0, 0, 8, 8),
                          "Dock",
                          "right",
                          "Target",
                          "idHistoryRows",
                          "AutoHide",
                          true
                        }),
                        PlaceObj("XTemplateCode", {
                          "run",
                          function(self, parent, context)
                            local dlg = GetDialog(parent)
                            local historyButton = dlg.idHistoryTab
                            historyButton:SetTextStyle("PDABrowserTabSelected")
                            historyButton:SetDrawOnTop(true)
                            local statsButton = dlg.idStatsTab
                            statsButton:SetTextStyle("PDABrowserTab")
                            statsButton:SetDrawOnTop(false)
                          end
                        })
                      }),
                      PlaceObj("XTemplateMode", {"mode", "stats"}, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XScrollArea",
                          "Id",
                          "idStatsRows",
                          "IdNode",
                          false,
                          "Padding",
                          box(8, 4, 8, 8),
                          "HAlign",
                          "left",
                          "VAlign",
                          "top",
                          "MinWidth",
                          600,
                          "MinHeight",
                          672,
                          "MaxWidth",
                          600,
                          "MaxHeight",
                          672,
                          "LayoutMethod",
                          "VList",
                          "VScroll",
                          "idStatsScroll"
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "TextStyle",
                            "PDABrowserText",
                            "Translate",
                            true,
                            "Text",
                            T(959513065473, [[
Connecting to A.I.M. servers...
Security check... <em>Confirmed!</em>
-----------------------------------------------]])
                          }),
                          PlaceObj("XTemplateForEach", {
                            "array",
                            function(parent, context)
                              return Presets.MercTrackedStat
                            end,
                            "__context",
                            function(parent, context, item, i, n)
                              return SubContext(context, {statGroupIdx = i})
                            end
                          }, {
                            PlaceObj("XTemplateWindow", {
                              "Margins",
                              box(0, 0, 0, 16),
                              "LayoutMethod",
                              "VList",
                              "FoldWhenHidden",
                              true
                            }, {
                              PlaceObj("XTemplateForEach", {
                                "array",
                                function(parent, context)
                                  return Presets.MercTrackedStat[context.statGroupIdx]
                                end,
                                "run_after",
                                function(child, context, item, i, n, last)
                                  child:ResolveId("idName"):SetText(item.name)
                                  child:ResolveId("idValue"):SetText(item:DisplayValue(context))
                                  child:SetVisible(not item.hide)
                                end
                              }, {
                                PlaceObj("XTemplateWindow", {
                                  "IdNode",
                                  true,
                                  "FoldWhenHidden",
                                  true
                                }, {
                                  PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idName",
                                    "Padding",
                                    box(2, 0, 2, 0),
                                    "Dock",
                                    "left",
                                    "TextStyle",
                                    "PDABrowserTextLight",
                                    "Translate",
                                    true
                                  }),
                                  PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idValue",
                                    "Margins",
                                    box(0, 0, 8, 0),
                                    "Padding",
                                    box(2, 0, 2, 0),
                                    "Dock",
                                    "right",
                                    "TextStyle",
                                    "PDABrowserTextLight",
                                    "Translate",
                                    true
                                  })
                                })
                              })
                            })
                          })
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "MessengerScrollbar",
                          "Id",
                          "idStatsScroll",
                          "Margins",
                          box(0, 0, 8, 8),
                          "Dock",
                          "right",
                          "Target",
                          "idStatsRows",
                          "AutoHide",
                          true
                        }),
                        PlaceObj("XTemplateCode", {
                          "run",
                          function(self, parent, context)
                            local dlg = GetDialog(parent)
                            local historyButton = dlg.idHistoryTab
                            historyButton:SetTextStyle("PDABrowserTab")
                            historyButton:SetDrawOnTop(false)
                            local statsButton = dlg.idStatsTab
                            statsButton:SetTextStyle("PDABrowserTabSelected")
                            statsButton:SetDrawOnTop(true)
                          end
                        })
                      })
                    })
                  })
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "perks"}, {
                PlaceObj("XTemplateTemplate", {"__template", "PDAPerks"})
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ScrollDown",
      "ActionSortKey",
      "1000",
      "ActionGamepad",
      "RightThumbDown",
      "OnAction",
      function(self, host, source, ...)
        local area = self.host:ResolveId("idRecord")
        area = area and area:ResolveId("idHistoryRows")
        if area then
          area:ScrollDown()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ScrollUp",
      "ActionSortKey",
      "1000",
      "ActionGamepad",
      "RightThumbUp",
      "OnAction",
      function(self, host, source, ...)
        local area = self.host:ResolveId("idRecord")
        area = area and area:ResolveId("idHistoryRows")
        if area then
          area:ScrollUp()
        end
      end
    })
  })
})
