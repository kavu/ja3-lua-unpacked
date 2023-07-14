PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuests_Tasks",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAQuestsClass",
    "Id",
    "idQuestsContent",
    "Margins",
    box(16, 16, 6, 16),
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "GetMouseTarget(self, pt)",
      "func",
      function(self, pt)
        local notes = self.idSelectedQuestContainer
        notes = notes and notes.idNotesScrollArea
        for i, c in ipairs(notes) do
          if c.idSectorIdContainer then
            local sIdContainer = c.idSectorIdContainer
            if sIdContainer:MouseInWindow(pt) then
              local tar, cur = sIdContainer:GetMouseTarget(pt)
              if tar then
                return tar, cur
              end
            end
          end
        end
        local mT, mC = PDAQuestsClass.GetMouseTarget(self, pt)
        if mT then
          return mT, mC
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "quest list",
      "Dock",
      "left",
      "MinWidth",
      394,
      "MaxWidth",
      394
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background_2",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "content",
        "__class",
        "XContextWindow",
        "Id",
        "idQuestListContainer"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idQuestScrollbar",
          "Dock",
          "right",
          "Target",
          "idQuestScroll",
          "AutoHide",
          true,
          "UnscaledWidth",
          15
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "SnappingScrollArea",
          "Id",
          "idQuestScroll",
          "Margins",
          box(8, 5, 8, 10),
          "Dock",
          "box",
          "VScroll",
          "idQuestScrollbar",
          "ShowPartialItems",
          true,
          "LeftThumbScroll",
          false,
          "KeepSelectionOnRespawn",
          true
        }, {
          PlaceObj("XTemplateForEach", {
            "comment",
            "section",
            "array",
            function(parent, context)
              return GetDialog(parent).sections
            end,
            "condition",
            function(parent, context, item, i)
              return #item.Content > 0
            end,
            "__context",
            function(parent, context, item, i, n)
              return item
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "MinHeight",
              42,
              "MaxHeight",
              42
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 8, 0, 8),
                "VAlign",
                "bottom",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAQuestSection"
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "vertical sep",
                  "__class",
                  "XFrame",
                  "Margins",
                  box(3, 2, 0, 0),
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                })
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "IsSelectable(self)",
                "func",
                function(self)
                  return false
                end
              })
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "quest header",
              "array",
              function(parent, context)
                return context.Content
              end,
              "condition",
              function(parent, context, item, i)
                return item.questHeader
              end,
              "run_after",
              function(child, context, item, i, n, last)
                rawset(child, "hidekey", context.HideKey)
                child:SetContext(item)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestHeader"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "IsSelectable(self)",
                  "func",
                  function(self)
                    return true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetSelected(self, selected)",
                  "func",
                  function(self, selected)
                    if self.idButton and selected then
                      self.idButton:OnPress()
                    end
                    self:SetFocus(selected)
                  end
                })
              })
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "EnactHideKey(self, key, value)",
            "func",
            function(self, key, value)
              for i, wnd in ipairs(self) do
                local hidekey = rawget(wnd, "hidekey")
                if hidekey and hidekey == key then
                  wnd:SetVisible(value)
                end
              end
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "selected quest info",
      "Margins",
      box(25, 0, 0, 0),
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "selected_quest"
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idSelectedQuestContainer"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "quest changes observer",
          "__context",
          function(parent, context)
            return gv_Quests
          end,
          "__class",
          "XContextWindow",
          "OnContextUpdate",
          function(self, context, ...)
            self.parent:OnContextUpdate(self.parent.context)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return GetDialog(parent):GetSelectedQuestData()
          end,
          "__condition",
          function(parent, context)
            return context
          end,
          "__class",
          "XContextWindow",
          "Dock",
          "box",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local node = self:ResolveId("node")
            local questId = context.id
            local icon = GetQuestIcon(questId)
            node.idIcon:SetImage(icon)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "MessengerScrollbar",
            "Id",
            "idNotesScroll",
            "Margins",
            box(6, 0, 2, 0),
            "Dock",
            "right",
            "FoldWhenHidden",
            false,
            "Target",
            "idNotesScrollArea",
            "AutoHide",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "info container",
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "header",
              "Dock",
              "top",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {"VAlign", "top"}, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "quest icon",
                  "HAlign",
                  "left",
                  "VAlign",
                  "top"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idIcon",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Image",
                    "UI/PDA/Quest/quest_main_"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Visible",
                    false,
                    "Image",
                    "UI/PDA/Quest/quest_main_"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "green header",
                  "Margins",
                  box(40, 0, 0, 0),
                  "VAlign",
                  "top",
                  "MinHeight",
                  40,
                  "MaxHeight",
                  40,
                  "Background",
                  RGBA(88, 92, 68, 125)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__context",
                    function(parent, context)
                      return context.questHeader.questPreset
                    end,
                    "__class",
                    "XText",
                    "Margins",
                    box(2, 0, 0, 0),
                    "VAlign",
                    "bottom",
                    "TextStyle",
                    "PDAQuestTitleInfo",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      self:SetText(context.DisplayName)
                      return XContextControl.OnContextUpdate(self, context)
                    end,
                    "Translate",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "time",
                    "__class",
                    "XText",
                    "Margins",
                    box(0, 0, 5, 0),
                    "HAlign",
                    "right",
                    "VAlign",
                    "bottom",
                    "TextStyle",
                    "PDAQuestsNoteText",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      if Platform.developer then
                        self:SetText(T({
                          Untranslated("(author: <author>)     <month(t)> <day(t)> <year(t)>"),
                          t = context.earliestTimestamp,
                          author = Untranslated(context.questHeader.questPreset.Author or "<color 255 0 0>Unknown</color>")
                        }))
                      else
                        self:SetText(T({
                          147546503736,
                          "<month(t)> <day(t)> <year(t)>",
                          t = context.earliestTimestamp
                        }))
                      end
                      return XContextControl.OnContextUpdate(self, context)
                    end,
                    "Translate",
                    true
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line below header",
                "Margins",
                box(16, 3, 0, 0),
                "VAlign",
                "top",
                "MinHeight",
                1,
                "MaxHeight",
                1,
                "Background",
                RGBA(88, 92, 68, 255)
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "notes container",
              "__class",
              "XScrollArea",
              "Id",
              "idNotesScrollArea",
              "IdNode",
              false,
              "Dock",
              "box",
              "LayoutMethod",
              "VList",
              "VScroll",
              "idNotesScroll"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "placeholder",
                "Margins",
                box(10, 0, 0, 0),
                "HAlign",
                "left",
                "MinHeight",
                20,
                "MaxHeight",
                20
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "vertical line",
                  "Margins",
                  box(30, 0, 0, 0),
                  "HAlign",
                  "left",
                  "MinWidth",
                  1,
                  "MaxWidth",
                  1,
                  "Background",
                  RGBA(88, 92, 68, 255)
                })
              }),
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.questNotes
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local notePreset = context.preset
                  local questPreset = context.questPreset
                  child.idText:SetText(T({
                    notePreset.Text,
                    questPreset
                  }))
                  if context.state == "completed" then
                    child.idText:SetTextStyle("PDAQuestsNoteTextCompleted")
                    child.idSectorId:SetVisible(false)
                    child.idCompleted:SetVisible(true)
                    child.idSectorIdContainer:SetHandleMouse(false)
                    child.idSectorId:SetText(Untranslated("B9"))
                  elseif context.sectors and #context.sectors > 0 then
                    if #context.sectors > 1 then
                      child.idSectorId:SetText(T(756126901686, "<underline>...</underline>"))
                    else
                      child.idSectorId:SetText(T({
                        933855793737,
                        "<underline><SectorIdColored2(sectorId)></underline>",
                        sectorId = context.sectors[1]
                      }))
                    end
                    child.idUnreadPh:SetText(child.idSectorId.Text)
                  else
                    child.idSectorId:SetText(Untranslated("B9"))
                    child.idSectorId:SetVisible(false)
                    child.idSectorIdContainer:SetHandleMouse(false)
                  end
                  child.idUnread:SetVisible(not context.read)
                  context.read = true
                  SetQuestPropertyRead(questPreset, "nl" .. context.idx)
                  local isLast = i == last
                  child.idBottomSpace:SetVisible(not isLast)
                  if isLast then
                    child.idVertical:SetVAlign("top")
                    local horizontalUpMargin = child.idHorizontal.Margins:miny()
                    child.idVertical:SetMinHeight(horizontalUpMargin + 1)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "HAlign",
                  "left",
                  "MaxWidth",
                  900,
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(10, 0, 0, 0),
                    "HAlign",
                    "right",
                    "VAlign",
                    "top",
                    "MinWidth",
                    30,
                    "MaxWidth",
                    30
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XButton",
                      "Id",
                      "idSectorIdContainer",
                      "IdNode",
                      false,
                      "BorderColor",
                      RGBA(0, 0, 0, 0),
                      "Background",
                      RGBA(0, 0, 0, 0),
                      "MouseCursor",
                      "UI/Cursors/Pda_Hand.tga",
                      "FocusedBorderColor",
                      RGBA(0, 0, 0, 0),
                      "FocusedBackground",
                      RGBA(0, 0, 0, 0),
                      "DisabledBorderColor",
                      RGBA(0, 0, 0, 0),
                      "OnPress",
                      function(self, gamepad)
                        local sector = self:ResolveId("node").context.sectors[1]
                        CreateRealTimeThread(function()
                          local pda = GetDialog("PDADialog")
                          pda:Close()
                          if not gv_SatelliteView then
                            SatelliteToggleActionRun()
                            while not gv_SatelliteView do
                              WaitMsg("StartSatelliteGameplay", 500)
                            end
                            Sleep(1)
                          end
                          SatelliteSetCameraDest(sector)
                        end)
                      end,
                      "RolloverBackground",
                      RGBA(0, 0, 0, 0),
                      "PressedBackground",
                      RGBA(0, 0, 0, 0)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idSectorId",
                        "Margins",
                        box(-20, 0, 5, 0),
                        "HAlign",
                        "right",
                        "OnLayoutComplete",
                        function(self)
                          local b = self.box
                          local node = self:ResolveId("node")
                          local unreadCont = node.idUnreadContainer
                          local pullX = ScaleXY(self.scale, 10, 0)
                          unreadCont:SetBox(b:minx() - pullX, b:miny(), b:sizex(), b:sizey())
                        end,
                        "Clip",
                        "self",
                        "TextStyle",
                        "PDAQuestsNoteSector",
                        "Translate",
                        true,
                        "UnderlineOffset",
                        2
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "DrawWindow(self, clip_box)",
                          "func",
                          function(self, clip_box)
                            return XText.DrawWindow(self, box(0, 0, max_int, max_int))
                          end
                        })
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "PointInWindow(self, pt)",
                        "func",
                        function(self, pt)
                          if XButton.PointInWindow(self, pt) then
                            return true
                          end
                          if not self.enabled then
                            return false
                          end
                          local node = self:ResolveId("node")
                          local sectorIdWin = node.idSectorId
                          if not sectorIdWin.visible then
                            return false
                          end
                          return sectorIdWin:PointInWindow(pt)
                        end
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idCompleted",
                      "Visible",
                      false,
                      "Image",
                      "UI/PDA/Quest/checkmark"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idUnreadContainer",
                    "Dock",
                    "ignore",
                    "LayoutMethod",
                    "HList"
                  }, {
                    PlaceObj("XTemplateTemplate", {
                      "__template",
                      "PDAQuestUnreadIndicator",
                      "Margins",
                      box(0, -5, 0, 0),
                      "VAlign",
                      "top",
                      "MinWidth",
                      10,
                      "MaxWidth",
                      10,
                      "Visible",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idUnreadPh",
                      "HAlign",
                      "right",
                      "Clip",
                      "self",
                      "Visible",
                      false,
                      "TextStyle",
                      "PDAQuestsNoteSector",
                      "Translate",
                      true
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "DrawWindow(self, clip_box)",
                      "func",
                      function(self, clip_box)
                        return XText.DrawWindow(self, box(0, 0, max_int, max_int))
                      end
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idVertical",
                    "HAlign",
                    "left",
                    "MinWidth",
                    1,
                    "MaxWidth",
                    1,
                    "Background",
                    RGBA(88, 92, 68, 255)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idHorizontal",
                    "Margins",
                    box(0, 14, 5, 0),
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "MinWidth",
                    15,
                    "MinHeight",
                    1,
                    "MaxWidth",
                    15,
                    "MaxHeight",
                    1,
                    "Background",
                    RGBA(88, 92, 68, 255)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idText",
                    "HAlign",
                    "right",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "PDAQuestsNoteText",
                    "Translate",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "placeholder",
                    "Id",
                    "idBottomSpace",
                    "Margins",
                    box(10, 0, 0, 0),
                    "Dock",
                    "bottom",
                    "HAlign",
                    "left",
                    "MinHeight",
                    15,
                    "MaxHeight",
                    15
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "vertical line",
                      "Margins",
                      box(30, 0, 0, 0),
                      "HAlign",
                      "left",
                      "MinWidth",
                      1,
                      "MaxWidth",
                      1,
                      "Background",
                      RGBA(88, 92, 68, 255)
                    })
                  })
                })
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SetSelectedQuestAsActive",
      "ActionName",
      T(261552753375, "Set Active"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "A",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        local tabDlg = host.idContent
        local subContentHolder = tabDlg.idSubContent
        local tasksDlg = subContentHolder.idQuestsContent
        local selectedQuest = tasksDlg.selected_quest
        local data = tasksDlg:GetSelectedQuestData()
        if not data then
          return "hidden"
        end
        local isAvailable = data.questHeader.state ~= "completed" and data.questHeader.state ~= "failed"
        if not isAvailable then
          return "disabled"
        end
        local activeQuest = GetActiveQuest()
        return selectedQuest == activeQuest and "disabled" or "enabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local tabDlg = host.idContent
        local subContentHolder = tabDlg.idSubContent
        local tasksDlg = subContentHolder.idQuestsContent
        local selectedQuest = tasksDlg.selected_quest
        if selectedQuest then
          SetActiveQuest(selectedQuest)
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ShowHideCompleted",
      "ActionName",
      T(848609246777, "<ToggleCompletedQuestsActionName()>"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "S",
      "ActionGamepad",
      "RightThumbClick",
      "OnAction",
      function(self, host, source, ...)
        UIShowCompletedQuests = not UIShowCompletedQuests
        ObjModified("quest_list_respawn")
        local pdaDiag = GetDialog("PDADialog")
        if not pdaDiag or pdaDiag.Mode ~= "quests" then
          return
        end
        pdaDiag:ActionsUpdated()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "QuestNotesScrollDown",
      "ActionGamepad",
      "RightThumbDown",
      "OnAction",
      function(self, host, source, ...)
        local scrollArea = self.host:ResolveId("idSelectedQuestContainer"):ResolveId("idNotesScrollArea")
        if scrollArea then
          scrollArea:ScrollDown()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "QuestNotesScrollUp",
      "ActionGamepad",
      "RightThumbUp",
      "OnAction",
      function(self, host, source, ...)
        local scrollArea = self.host:ResolveId("idSelectedQuestContainer"):ResolveId("idNotesScrollArea")
        if scrollArea then
          scrollArea:ScrollUp()
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "observes ^ show/hide completed",
      "__context",
      function(parent, context)
        return "quest_list_respawn"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        local dlg = GetDialog(self)
        dlg:InitQuestData()
      end
    })
  })
})
