PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpResultMerc",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(727563685948, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        local nameEdit = self:ResolveId("idMercInfo"):ResolveId("idEditName")
        local nickEdit = self:ResolveId("idMercInfo"):ResolveId("idEditNick")
        if not GetUIStyleGamepad() then
          nameEdit:SetFocus(true)
          nameEdit:SetFocusOrder(point(0, 0))
          nickEdit:SetFocusOrder(point(0, 1))
        else
          nameEdit:SetFocusOrder(false)
          nickEdit:SetFocusOrder(false)
        end
        PDAImpHeaderEnable(self)
        ObjModified(g_ImpTest.final)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return CreateImpTestPortraitContext()
      end,
      "__class",
      "XContextFrame",
      "Id",
      "idMercInfo",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.idEditName:SetText(g_ImpTest.final.name)
        self.idEditNick:SetText(g_ImpTest.final.nick)
        self.idRemPoints:SetText(ImpGetUnassignedStatPoints())
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(16, 12, 12, 12),
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "prev",
          "__template",
          "PDASmallButton",
          "VAlign",
          "center",
          "MinWidth",
          24,
          "MinHeight",
          24,
          "MaxWidth",
          24,
          "MaxHeight",
          24,
          "ScaleModifier",
          point(1000, 1000),
          "OnPress",
          function(self, gamepad)
            local idx = g_ImpTest.final.merc_template.idx
            local imppresets = Presets.UnitDataCompositeDef.IMP
            idx = idx - 1
            if idx < 1 then
              idx = #imppresets
            end
            local preset = imppresets[idx]
            g_ImpTest.final.merc_template = {
              idx = idx,
              id = preset.id
            }
            local node = self:ResolveId("node")
            node.idPortrait:SetContext(preset, true)
          end,
          "FlipX",
          true,
          "CenterImage",
          "UI/PDA/T_Icon_Play"
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(4, 0, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "IdNode",
            false,
            "MinWidth",
            120,
            "MinHeight",
            136,
            "MaxWidth",
            120,
            "MaxHeight",
            136,
            "Image",
            "UI/Hud/portrait_background",
            "ImageFit",
            "stretch"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextImage",
            "Id",
            "idPortrait",
            "MinWidth",
            120,
            "MinHeight",
            136,
            "MaxWidth",
            120,
            "MaxHeight",
            136,
            "Image",
            "UI/MercsPortraits/Igor",
            "ImageFit",
            "largest",
            "ImageRect",
            box(14, 0, 282, 273),
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetImage(context.Portrait)
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "next",
          "__template",
          "PDASmallButton",
          "Margins",
          box(4, 0, 0, 0),
          "VAlign",
          "center",
          "MinWidth",
          24,
          "MinHeight",
          24,
          "MaxWidth",
          24,
          "MaxHeight",
          24,
          "ScaleModifier",
          point(1000, 1000),
          "OnPress",
          function(self, gamepad)
            local idx = g_ImpTest.final.merc_template.idx
            local imppresets = Presets.UnitDataCompositeDef.IMP
            idx = idx + 1
            if idx > #imppresets then
              idx = 1
            end
            local preset = imppresets[idx]
            g_ImpTest.final.merc_template = {
              idx = idx,
              id = preset.id
            }
            local node = self:ResolveId("node")
            node.idPortrait:SetContext(preset, true)
          end,
          "CenterImage",
          "UI/PDA/T_Icon_Play"
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(20, 0, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Image",
            "UI/PDA/imp_panel_2",
            "FrameBox",
            box(5, 5, 5, 5)
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(8, 12, 4, 4),
            "VAlign",
            "center",
            "MinWidth",
            465,
            "MaxWidth",
            465,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            5
          }, {
            PlaceObj("XTemplateWindow", {
              "VAlign",
              "center",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return g_ImpTest.final
                end,
                "__class",
                "XText",
                "Id",
                "idName",
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MinWidth",
                140,
                "MaxWidth",
                140,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPContentTitle",
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetTextStyle(GetDialog(self):CheckMercName() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
                end,
                "Translate",
                true,
                "Text",
                T(980371909346, "Name"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "HAlign",
                "right",
                "VAlign",
                "center",
                "MinWidth",
                324,
                "MinHeight",
                39,
                "MaxWidth",
                324,
                "Image",
                "UI/PDA/imp_bar",
                "FrameBox",
                box(5, 5, 5, 5)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XEdit",
                  "Id",
                  "idEditName",
                  "Margins",
                  box(10, 0, 10, 0),
                  "BorderWidth",
                  0,
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "MinWidth",
                  324,
                  "MaxWidth",
                  324,
                  "Background",
                  RGBA(240, 240, 240, 0),
                  "MouseCursor",
                  "UI/Cursors/Pda_Hand.tga",
                  "FocusOrder",
                  point(0, 0),
                  "FocusedBorderColor",
                  RGBA(240, 240, 240, 0),
                  "FocusedBackground",
                  RGBA(240, 240, 240, 0),
                  "DisabledBorderColor",
                  RGBA(240, 240, 240, 0),
                  "DisabledBackground",
                  RGBA(240, 240, 240, 0),
                  "TextStyle",
                  "PDAIMPEdit",
                  "UserText",
                  true,
                  "UserTextType",
                  "name",
                  "OnTextChanged",
                  function(self)
                    g_ImpTest.final.name = self:GetText()
                    PlayFX("Typing", "start")
                    GetDialog(self):ActionsUpdated()
                    ObjModified(g_ImpTest.final)
                  end,
                  "MaxLen",
                  20,
                  "AutoSelectAll",
                  true,
                  "HintColor",
                  RGBA(240, 240, 240, 0)
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnShortcut(self, shortcut, source, ...)",
                    "func",
                    function(self, shortcut, source, ...)
                      if GetUIStyleGamepad() then
                        return "break"
                      end
                      if shortcut == "Enter" or shortcut == "Tab" or shortcut == "Shift-Tab" then
                        local dir = shortcut == "Shift-Tab" and "prev" or "next"
                        local focus = self:ResolveId("node"):GetRelativeFocus(self.desktop:GetKeyboardFocus():GetFocusOrder(), dir)
                        self:SetFocus(false)
                        if focus then
                          focus:SetFocus()
                        end
                        return "break"
                      elseif shortcut == "Escape" then
                      else
                        return XEdit.OnShortcut(self, shortcut, source)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetFocus(self, old_focus)",
                    "func",
                    function(self, old_focus)
                      if GetUIStyleGamepad() then
                        self:OpenControllerTextInput()
                        self:SetFocus(false)
                      else
                        XEdit.OnSetFocus(self, old_focus)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnKillFocus",
                    "func",
                    function(self, ...)
                      if self:GetText() then
                        g_ImpTest.final.name = self:GetText()
                      end
                      XEdit.OnKillFocus(self)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDoubleClick(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      if GetUIStyleGamepad() then
                        return "break"
                      end
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return g_ImpTest.final
                end,
                "__class",
                "XText",
                "Id",
                "idNick",
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MinWidth",
                140,
                "MaxWidth",
                140,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPContentTitle",
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetTextStyle(GetDialog(self):CheckMercNick() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
                end,
                "Translate",
                true,
                "Text",
                T(235545241609, "Nickname"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "HAlign",
                "right",
                "VAlign",
                "center",
                "MinWidth",
                324,
                "MinHeight",
                39,
                "MaxWidth",
                324,
                "Image",
                "UI/PDA/imp_bar",
                "FrameBox",
                box(5, 5, 5, 5)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XEdit",
                  "Id",
                  "idEditNick",
                  "Margins",
                  box(10, 0, 10, 0),
                  "BorderWidth",
                  0,
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "MinWidth",
                  324,
                  "MaxWidth",
                  324,
                  "Background",
                  RGBA(240, 240, 240, 0),
                  "MouseCursor",
                  "UI/Cursors/Pda_Hand.tga",
                  "FocusOrder",
                  point(0, 1),
                  "FocusedBorderColor",
                  RGBA(240, 240, 240, 0),
                  "FocusedBackground",
                  RGBA(240, 240, 240, 0),
                  "DisabledBorderColor",
                  RGBA(240, 240, 240, 0),
                  "DisabledBackground",
                  RGBA(240, 240, 240, 0),
                  "TextStyle",
                  "PDAIMPEdit",
                  "UserText",
                  true,
                  "UserTextType",
                  "name",
                  "OnTextChanged",
                  function(self)
                    g_ImpTest.final.nick = self:GetText()
                    PlayFX("Typing", "start")
                    GetDialog(self):ActionsUpdated()
                    ObjModified(g_ImpTest.final)
                  end,
                  "MaxLen",
                  8,
                  "AutoSelectAll",
                  true,
                  "HintColor",
                  RGBA(240, 240, 240, 0)
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnShortcut(self, shortcut, source, ...)",
                    "func",
                    function(self, shortcut, source, ...)
                      if GetUIStyleGamepad() then
                        return "break"
                      end
                      if shortcut == "Enter" or shortcut == "Tab" or shortcut == "Shift-Tab" then
                        local dir = shortcut == "Shift-Tab" and "prev" or "next"
                        local focus = self:ResolveId("node"):GetRelativeFocus(self.desktop:GetKeyboardFocus():GetFocusOrder(), dir)
                        self:SetFocus(false)
                        if focus then
                          focus:SetFocus()
                        end
                        return "break"
                      elseif shortcut == "Escape" then
                      else
                        return XEdit.OnShortcut(self, shortcut, source)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnKillFocus",
                    "func",
                    function(self, ...)
                      if self:GetText() then
                        g_ImpTest.final.nick = self:GetText()
                      end
                      XEdit.OnKillFocus(self)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetFocus(self, old_focus)",
                    "func",
                    function(self, old_focus)
                      if GetUIStyleGamepad() then
                        self:OpenControllerTextInput()
                        self:SetFocus(false)
                      else
                        XEdit.OnSetFocus(self, old_focus)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDoubleClick(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      if GetUIStyleGamepad() then
                        return "break"
                      end
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "VAlign",
              "center",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return g_ImpTest.final
                end,
                "__class",
                "XText",
                "Id",
                "idtxtRemPoints",
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MinWidth",
                340,
                "MaxWidth",
                340,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPContentTitle",
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetTextStyle(GetDialog(self):CheckMercStats() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
                end,
                "Translate",
                true,
                "Text",
                T(289079036582, "Attribute Points"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return g_ImpTest.final
                end,
                "__class",
                "XText",
                "Id",
                "idRemPoints",
                "HAlign",
                "right",
                "VAlign",
                "center",
                "MinWidth",
                124,
                "MaxWidth",
                124,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPContentTitle",
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetTextStyle(GetDialog(self):CheckMercStats() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
                end,
                "TextHAlign",
                "right",
                "TextVAlign",
                "center"
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "GamepadUIStyleChanged"
        end,
        "__class",
        "XContextWindow",
        "Id",
        "idControllerSupport",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local nameEdit = self:ResolveId("idEditName")
          local nickEdit = self:ResolveId("idEditNick")
          if not GetUIStyleGamepad() then
            nameEdit:SetFocusOrder(point(0, 0))
            nickEdit:SetFocusOrder(point(0, 1))
          else
            nameEdit:SetFocus(false)
            nickEdit:SetFocus(false)
            nameEdit:SetFocusOrder(false)
            nickEdit:SetFocusOrder(false)
          end
        end
      })
    }),
    PlaceObj("XTemplateMode", {
      "mode",
      "test_result_stats"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return SubContext(context, {
            unit_data = CreateImpMercData(g_ImpTest)
          })
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idStats",
        "MaxWidth",
        670,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "RecalcStatPoints",
          "func",
          function(self, ...)
            local sum = 0
            local list = self.idStatsList
            for _, child in ipairs(list) do
              sum = sum + child.idSlider.Scroll
            end
            local rem = const.Imp.MaxStatPoints - sum
            for _, child in ipairs(list) do
              child.idMin:SetEnabled(child.idSlider.Scroll > child.min)
              child.max_with_rem = Min(child.max, child.idSlider.Scroll + rem)
              child.idMax:SetEnabled(child.idSlider.Scroll < child.max_with_rem)
            end
            local node = self:ResolveId("node")
            local ctrl = node.idMercInfo.idRemPoints
            ctrl:SetText(rem)
            GetDialog(self):ActionsUpdated()
            ObjModified(g_ImpTest.final)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextFrame",
          "IdNode",
          false,
          "Image",
          "UI/PDA/imp_panel",
          "FrameBox",
          box(8, 8, 8, 8)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Margins",
            box(240, 16, 12, 16),
            "Image",
            "UI/PDA/imp_panel_2",
            "FrameBox",
            box(5, 5, 5, 5)
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idStatsList",
            "Margins",
            box(30, 22, 30, 22),
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return context and context.stats
              end,
              "run_after",
              function(child, context, item, i, n, last)
                rawset(child, "stat", item.stat)
                rawset(child, "stat_idx", i)
                local min, max = ImpGetMinMaxStat(child.stat)
                child.idSlider:SetMin(0)
                child.idSlider:SetMax(max)
                child.idSlider.idDisabledZone:SetVisible(0 < min)
                rawset(child, "min", min)
                rawset(child, "max", max)
                rawset(child, "max_with_rem", max)
                local stat = table.find_value(UnitPropertiesStats:GetProperties(), "id", item.stat)
                local statName = stat.name
                child.idStat:SetText(statName)
                child.idSlider:ScrollTo(item.value)
                child.idStat:SetContext(context)
                child.idStat.RolloverTitle = statName
                child.idStat.RolloverText = stat.help
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "MinHeight",
                30,
                "MaxHeight",
                30,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local stat = table.find_value(UnitPropertiesStats:GetProperties(), "id", self.stat)
                  local statName = stat.name
                  self.idStat:SetText(statName)
                  self.idStat:SetContext(context)
                  self.idStat.RolloverTitle = statName
                  self.idStat.RolloverText = stat.help
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "RolloverTemplate",
                  "RolloverGenericYellow",
                  "RolloverAnchor",
                  "center-top",
                  "RolloverText",
                  T(392129244821, "text"),
                  "RolloverTitle",
                  T(806873059629, "title"),
                  "Id",
                  "idStat",
                  "Padding",
                  box(0, 0, 0, 0),
                  "MinWidth",
                  220,
                  "TextStyle",
                  "PDAIMPContentTitle",
                  "Translate",
                  true,
                  "Text",
                  T(980371909346, "Name")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextControl",
                  "IdNode",
                  false,
                  "VAlign",
                  "center",
                  "LayoutMethod",
                  "HList",
                  "RolloverOnFocus",
                  true,
                  "MouseCursor",
                  "UI/Cursors/Pda_Hand.tga"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "SetSelected(self, selected)",
                    "func",
                    function(self, selected)
                      self:SetFocus(selected)
                    end
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDASmallButton",
                    "Id",
                    "idMin",
                    "Margins",
                    box(0, 2, 0, 0),
                    "VAlign",
                    "center",
                    "MinWidth",
                    24,
                    "MinHeight",
                    24,
                    "MaxWidth",
                    24,
                    "MaxHeight",
                    24,
                    "ScaleModifier",
                    point(1000, 1000),
                    "RepeatStart",
                    200,
                    "RepeatInterval",
                    100,
                    "OnPress",
                    function(self, gamepad)
                      local slider = self:ResolveId("node").idSlider
                      local value = slider:GetScroll()
                      slider:ScrollTo(Max(value - 1, 1))
                    end,
                    "FlipX",
                    true,
                    "CenterImage",
                    "UI/PDA/T_Icon_Play"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XScrollThumb",
                    "Id",
                    "idSlider",
                    "VAlign",
                    "center",
                    "MinWidth",
                    364,
                    "MinHeight",
                    28,
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "Horizontal",
                    true
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "ScrollTo(self,value)",
                      "func",
                      function(self, value)
                        local child = self.parent:ResolveId("node")
                        value = Clamp(value, child.min, child.max_with_rem)
                        if self.current_pos then
                          local size = self.content_box:sizex() - self:GetThumbSize()
                          local min_pos = MulDivTrunc(child.min - self.Min, size, self.Max - self.Min + 1)
                          local max_pos = MulDivTrunc(child.max_with_rem - self.Min, size, self.Max - self.Min + 1)
                          if child.max_with_rem == self.Max then
                            max_pos = size
                          end
                          self.current_pos = Clamp(self.current_pos, min_pos, max_pos)
                        end
                        local res = XScrollThumb.ScrollTo(self, value)
                        self.idValue:SetText(self.Scroll)
                        local ctrl_stats = child.parent:ResolveId("node")
                        local context = ctrl_stats:GetContext()
                        context.stats[child.stat_idx].value = self.Scroll
                        ctrl_stats:SetContext(context)
                        local dlg = GetDialog(self)
                        local stats = dlg.idContent.idStats
                        stats:RecalcStatPoints()
                        g_ImpTest.final = g_ImpTest.final or {}
                        g_ImpTest.final.stats = g_ImpTest.final.stats or {}
                        g_ImpTest.final.stats[child.stat_idx].value = self.Scroll
                        dlg:ActionsUpdated()
                        return res
                      end
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XFrame",
                      "ZOrder",
                      0,
                      "Image",
                      "UI/PDA/imp_bar_2",
                      "FrameBox",
                      box(5, 5, 5, 5)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XFrame",
                      "Id",
                      "idDisabledZone",
                      "ZOrder",
                      0,
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "MinWidth",
                      113,
                      "MinHeight",
                      28,
                      "MaxWidth",
                      113,
                      "MaxHeight",
                      28,
                      "Image",
                      "UI/PDA/imp_bar_2_a",
                      "FrameBox",
                      box(5, 5, 5, 5)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idThumb",
                      "IdNode",
                      false,
                      "Padding",
                      box(3, 3, 3, 3),
                      "VAlign",
                      "center",
                      "MouseCursor",
                      "UI/Cursors/Pda_Hand.tga",
                      "Image",
                      "UI/PDA/imp_stat_pad"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idValue",
                        "Padding",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "HandleKeyboard",
                        false,
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "PDAIMPStatSlider"
                      })
                    })
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDASmallButton",
                    "Id",
                    "idMax",
                    "Margins",
                    box(0, 2, 0, 0),
                    "VAlign",
                    "center",
                    "MinWidth",
                    24,
                    "MinHeight",
                    24,
                    "MaxWidth",
                    24,
                    "MaxHeight",
                    24,
                    "ScaleModifier",
                    point(1000, 1000),
                    "RepeatStart",
                    200,
                    "RepeatInterval",
                    100,
                    "OnPress",
                    function(self, gamepad)
                      local slider = self:ResolveId("node").idSlider
                      local value = slider:GetScroll()
                      slider:ScrollTo(Min(value + 1, 100))
                    end,
                    "CenterImage",
                    "UI/PDA/T_Icon_Play"
                  })
                })
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateMode", {
      "mode",
      "test_result_perks"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return SubContext(context, {
            unit_data = CreateImpMercData(g_ImpTest)
          })
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idPerks",
        "MaxWidth",
        670,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextFrame",
          "IdNode",
          false,
          "Image",
          "UI/PDA/imp_panel_perks",
          "FrameBox",
          box(8, 8, 8, 8)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 14, 0, 16),
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return g_ImpTest.final
              end,
              "__class",
              "XText",
              "Id",
              "idPersonalPerk",
              "Margins",
              box(28, 0, 0, 0),
              "Padding",
              box(0, 0, 0, 0),
              "MinWidth",
              250,
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPContentTitle",
              "OnContextUpdate",
              function(self, context, ...)
                self:SetTextStyle(GetDialog(self):CheckMercPerksPersonal() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
              end,
              "Translate",
              true,
              "Text",
              T(960500439279, "Personal perks 1/1")
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(72, 8, 72, 0),
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              46
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "personal perks",
                "array",
                function(parent, context)
                  return ImpGetPersonalPerks()
                end,
                "__context",
                function(parent, context, item, i, n)
                  return context.unit_data
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local perk = CharacterEffectDefs[item]
                  child.idimgPerk:SetImage(perk.Icon)
                  rawset(child, "perk", item)
                  rawset(child, "yellow", true)
                  child:SetRolloverTitle(T({
                    perk.DisplayName,
                    perk
                  }))
                  child:SetRolloverText(T({
                    perk.Description,
                    perk
                  }))
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "RolloverTemplate",
                  "PDAPerkRollover",
                  "RolloverAnchor",
                  "custom",
                  "RolloverOffset",
                  box(0, 0, 0, 10),
                  "IdNode",
                  true,
                  "HandleMouse",
                  true,
                  "MouseCursor",
                  "UI/Cursors/Pda_Hand.tga",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local perk = g_ImpTest.final.perks.personal.perk
                    local selected = self.perk == perk
                    self.idimgPerk:SetTransparency(selected and 0 or 125)
                    self.idimgPerk:SetDesaturation(selected and 0 or 255)
                    self.idBack:SetTransparency(selected and 125 or 200)
                    local text = self:ResolveId("node").idPersonalPerk
                    text:SetText(T({
                      620340048482,
                      "Personal perks <max>/1",
                      max = perk and 1 or 0
                    }))
                    ObjModified(g_ImpTest.final)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idBack",
                    "Background",
                    RGBA(88, 92, 68, 255)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idimgPerk",
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "MinWidth",
                    70,
                    "MinHeight",
                    70,
                    "MaxWidth",
                    70,
                    "MaxHeight",
                    70,
                    "FXMouseIn",
                    "buttonRollover",
                    "FXPress",
                    "buttonPress",
                    "FXPressDisabled",
                    "IactDisabled",
                    "ImageFit",
                    "scale-down"
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      if button == "L" then
                        PlayFX("buttonPress", "start")
                        g_ImpTest.final.perks = g_ImpTest.final.perks or {}
                        local personal = g_ImpTest.final.perks.personal or {}
                        personal = personal.perk == self.perk and {} or {
                          perk = self.perk
                        }
                        g_ImpTest.final.perks.personal = personal
                        local dlg = GetDialog(self)
                        if dlg then
                          dlg:ActionsUpdated()
                        end
                        self:ResolveId("node"):OnContextUpdate()
                        return "break"
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetRollover(self, rollover)",
                    "func",
                    function(self, rollover)
                      if rollover then
                        PlayFX("buttonRollover", "start")
                      end
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "line",
              "__class",
              "XImage",
              "Margins",
              box(28, 8, 28, 6),
              "VAlign",
              "center",
              "Transparency",
              141,
              "Image",
              "UI/PDA/separate_line_vertical",
              "ImageFit",
              "stretch-x"
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return g_ImpTest.final
              end,
              "__class",
              "XText",
              "Id",
              "idTacticalPerk",
              "Margins",
              box(28, 0, 0, 0),
              "Padding",
              box(0, 0, 0, 0),
              "MinWidth",
              250,
              "TextStyle",
              "PDAIMPContentTitle",
              "OnContextUpdate",
              function(self, context, ...)
                self:SetTextStyle(GetDialog(self):CheckMercPerksTactical() and "PDAIMPContentTitle" or "PDAIMPContentTitleRed")
              end,
              "Translate",
              true,
              "Text",
              T(747438157331, "Tactical perks 2/2")
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(72, 8, 72, 0),
              "LayoutMethod",
              "Grid",
              "LayoutHSpacing",
              46,
              "LayoutVSpacing",
              10,
              "UniformColumnWidth",
              true,
              "UniformRowHeight",
              true
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return Presets.CharacterEffectCompositeDef["Perk-Specialization"]
                end,
                "__context",
                function(parent, context, item, i, n)
                  return context.unit_data
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local perk = CharacterEffectDefs[item.id]
                  child.idimgPerk:SetImage(perk.Icon)
                  child:SetGridX(i - (i - 1) / 5 * 5)
                  child:SetGridY((i - 1) / 5 + 1)
                  rawset(child, "perk", perk.id)
                  rawset(child, "yellow", true)
                  child:SetRolloverTitle(T({
                    perk.DisplayName,
                    perk
                  }))
                  child:SetRolloverText(T({
                    perk.Description,
                    perk
                  }))
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "RolloverTemplate",
                  "PDAPerkRollover",
                  "RolloverAnchor",
                  "custom",
                  "RolloverOffset",
                  box(0, 0, 0, 10),
                  "IdNode",
                  true,
                  "HandleMouse",
                  true,
                  "MouseCursor",
                  "UI/Cursors/Pda_Hand.tga",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local tactical = g_ImpTest.final.perks.tactical
                    local selected = self.perk == (tactical[1] and tactical[1].perk or "") or self.perk == (tactical[2] and tactical[2].perk or "")
                    self.idimgPerk:SetTransparency(selected and 0 or 125)
                    self.idimgPerk:SetDesaturation(selected and 0 or 255)
                    self.idBack:SetTransparency(selected and 125 or 200)
                    local text = self:ResolveId("node").idTacticalPerk
                    text:SetText(T({
                      540824911540,
                      "Tactical perks <max>/2",
                      max = #tactical
                    }))
                    ObjModified(g_ImpTest.final)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idBack",
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "MinWidth",
                    72,
                    "MinHeight",
                    72,
                    "MaxWidth",
                    72,
                    "MaxHeight",
                    72,
                    "Background",
                    RGBA(88, 92, 68, 255)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idimgPerk",
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "MinWidth",
                    70,
                    "MinHeight",
                    70,
                    "MaxWidth",
                    70,
                    "MaxHeight",
                    70,
                    "FXMouseIn",
                    "buttonRollover",
                    "FXPress",
                    "buttonPress",
                    "FXPressDisabled",
                    "IactDisabled",
                    "ImageFit",
                    "scale-down"
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      if button == "L" then
                        PlayFX("buttonPress", "start")
                        g_ImpTest.final.perks = g_ImpTest.final.perks or {}
                        local tactical = g_ImpTest.final.perks.tactical or {}
                        if tactical[1] and self.perk == tactical[1].perk then
                          table.remove(tactical, 1)
                        elseif tactical[2] and self.perk == tactical[2].perk then
                          table.remove(tactical, 2)
                        elseif tactical[1] and tactical[2] then
                          tactical[1] = tactical[2]
                          tactical[2] = {
                            perk = self.perk
                          }
                        elseif tactical[1] and not tactical[2] then
                          tactical[2] = {
                            perk = self.perk
                          }
                        else
                          tactical[1] = {
                            perk = self.perk
                          }
                        end
                        g_ImpTest.final.perks.tactical = tactical or {}
                        local dlg = GetDialog(self)
                        if dlg then
                          dlg:ActionsUpdated()
                        end
                        self:ResolveId("node"):OnContextUpdate()
                        return "break"
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetRollover(self, rollover)",
                    "func",
                    function(self, rollover)
                      if rollover then
                        PlayFX("buttonRollover", "start")
                      end
                    end
                  })
                })
              })
            })
          })
        })
      })
    })
  })
})
