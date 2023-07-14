PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAAIMBrowser",
  PlaceObj("XTemplateWindow", {
    "comment",
    "content",
    "__class",
    "PDAAIMBrowser",
    "Id",
    "idBrowserContent",
    "Margins",
    box(50, 0, 50, 0),
    "LayoutMethod",
    "VList",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "HostInParent",
    true,
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        PDAAIMBrowser.Open(self, ...)
        AddPageToBrowserHistory("aim", nil)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not netInGame and not gv_SatelliteView
      end,
      "__class",
      "PDACampaignPausingDlg"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "bkg frame",
      "__class",
      "XImage",
      "Margins",
      box(-50, -1, -50, 0),
      "Dock",
      "box",
      "Image",
      "UI/PDA/pda_background",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(5, 25, 0, 20),
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateWindow", {"Dock", "top"}, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "filters",
          "__context",
          function(parent, context)
            return GetAIMScreenFilters()
          end,
          "Id",
          "idFilters",
          "MinHeight",
          44,
          "MaxHeight",
          44,
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "bg",
            "__class",
            "XFrame",
            "Dock",
            "box",
            "Image",
            "UI/PDA/os_header",
            "FrameBox",
            box(3, 5, 3, 5)
          }),
          PlaceObj("XTemplateForEach", {
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child:SetGridX(i)
              child:SetIcon("UI/Icons/hf_" .. item.nameString)
              rawset(child, "lastIndex", i == last)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Padding",
              box(10, 0, 10, 8),
              "MinWidth",
              170,
              "LayoutMethod",
              "Box",
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "AIMCategoryMercsClick",
              "FXPressDisabled",
              "TabButtonDisabled",
              "DisabledBackground",
              RGBA(255, 255, 255, 255),
              "OnPress",
              function(self, gamepad)
                if self.context.premium and PremiumPopupLogic() then
                  return
                end
                local dlg = GetDialog(self)
                dlg:SetFilter(self.context.id)
              end,
              "Image",
              "UI/PDA/os_header_disable",
              "FrameBox",
              box(3, 5, 3, 5),
              "SqueezeX",
              true,
              "SqueezeY",
              true,
              "TextStyle",
              "Hiring_Filter_Unselected",
              "Translate",
              true,
              "Text",
              T(440475746284, "<name>"),
              "UseXTextControl",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "Id",
                "idCenteredContainer",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                5
              }),
              PlaceObj("XTemplateCode", {
                "run",
                function(self, parent, context)
                  local centeredContainer = parent.idCenteredContainer
                  parent.idIcon:SetParent(centeredContainer)
                  parent.idLabel:SetParent(centeredContainer)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetSelected(self, selected)",
                "func",
                function(self, selected)
                  local enable = selected and "enable" or "disable"
                  local img = "UI/PDA/os_header_" .. enable
                  if self.context.customBG then
                    img = img .. "_" .. self.context.customBG
                  end
                  if self.GridX == 1 then
                    img = img .. "_first"
                  elseif not self.enabled and rawget(self, "lastIndex") then
                    img = img .. "_last_2"
                  end
                  self:SetImage(img)
                  rawset(self, "selected", selected)
                  local paddings = selected and box(0, -3, 0, 0) or empty_box
                  self:SetMargins(paddings)
                  local textStyle = "Hiring_Filter_"
                  if self.context.customBG then
                    textStyle = textStyle .. self.context.customBG .. "_"
                  end
                  textStyle = textStyle .. (selected and "Selected" or "Unselected")
                  self:SetTextStyle(textStyle)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetEnabled(self, enabled)",
                "func",
                function(self, enabled)
                  self.idIcon:SetDesaturation(enabled and 0 or 255)
                  self.idLabel:SetEnabled(enabled)
                  XTextButton.SetEnabled(self, enabled)
                end
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return gv_Squads
                end,
                "__condition",
                function(parent, context)
                  return parent.context.nameString == "hired"
                end,
                "__class",
                "XContextWindow",
                "OnContextUpdate",
                function(self, context, ...)
                  self.parent:OnContextUpdate(self.parent.context)
                end
              })
            })
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
            "HAlign",
            "right",
            "VAlign",
            "top",
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
            T(712245129915, "<LB> <RB> - Change category")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Margins",
          box(0, 0, 15, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "Image",
          "UI/PDA/HazOS"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "content",
        "Dock",
        "box",
        "LayoutMethod",
        "HPanel"
      }, {
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            parent.LayoutMethod = "AimBrowserCustom"
          end
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "bg",
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(3, 3, 3, 3)
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "left part - list",
          "Id",
          "idLeft",
          "Margins",
          box(0, 0, 30, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(20, 20, 0, 0),
            "HAlign",
            "left"
          }, {
            PlaceObj("XTemplateWindow", nil, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "bg",
                "__class",
                "XFrame",
                "Dock",
                "box",
                "Image",
                "UI/PDA/os_background_2",
                "FrameBox",
                box(3, 3, 3, 3)
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(50, 0, 50, 7),
                "Dock",
                "bottom"
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "vertical sep",
                  "__class",
                  "XFrame",
                  "Margins",
                  box(0, 5, 0, 0),
                  "Dock",
                  "top",
                  "VAlign",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAAIMBrowserBanner"
                }),
                PlaceObj("XTemplateWindow", {
                  "Margins",
                  box(0, 5, 0, 0),
                  "Dock",
                  "right",
                  "VAlign",
                  "center",
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "PDAAIMMoneyDisplayLabel",
                    "Translate",
                    true,
                    "Text",
                    T(266087238479, "Bank Account")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__context",
                    function(parent, context)
                      return Game
                    end,
                    "__class",
                    "PDAMoneyText",
                    "Margins",
                    box(30, 0, 0, 0),
                    "VAlign",
                    "center",
                    "TextStyle",
                    "PDAAIMMoneyDisplay",
                    "OnContextUpdate",
                    function(self, context, ...)
                      self:SetMoneyAmount(Game.Money)
                    end,
                    "Translate",
                    true
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idMercList",
                "Margins",
                box(40, 0, 40, 0),
                "Padding",
                box(2, 0, 2, 0),
                "HAlign",
                "left",
                "MinWidth",
                630,
                "GridStretchX",
                false,
                "LayoutMethod",
                "HWrap",
                "LayoutHSpacing",
                40,
                "LayoutVSpacing",
                20,
                "UniformColumnWidth",
                true,
                "UniformRowHeight",
                true,
                "VScroll",
                "idMercScroll",
                "ShowPartialItems",
                true,
                "LeftThumbScroll",
                false
              }, {
                PlaceObj("XTemplateForEach", {
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDASatelliteMercAIM",
                    "HAlign",
                    "left"
                  })
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnShortcut(self, shortcut, source, ...)",
                  "func",
                  function(self, shortcut, source, ...)
                    if shortcut == "RightThumbClick" then
                      self:SetInitialSelection()
                      return "break"
                    end
                    return SnappingScrollArea.OnShortcut(self, shortcut, source, ...)
                  end
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "MessengerScrollbar",
              "Id",
              "idMercScroll",
              "Dock",
              "right",
              "FoldWhenHidden",
              false,
              "Target",
              "idMercList",
              "SnapToItems",
              true,
              "AutoHide",
              true
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Dock",
            "bottom",
            "MinWidth",
            550
          }, {
            PlaceObj("XTemplateTemplate", {
              "__condition",
              function(parent, context)
                return not InitialConflictNotStarted()
              end,
              "__template",
              "PDAStartButton",
              "Margins",
              box(20, 0, 0, 0),
              "VAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(20, 11, 0, 9),
              "HAlign",
              "right",
              "MinHeight",
              36,
              "MaxHeight",
              36,
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              20
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "VAlign",
                "center",
                "OnLayoutComplete",
                function(self)
                  local node = self:ResolveId("node")
                  local startButton = node.idStartButton
                  local intersects = startButton and BoxIntersectsBox(self.box, startButton.box)
                  self:SetVisible(not intersects)
                end,
                "TextStyle",
                "AimCopyrightText",
                "Translate",
                true,
                "Text",
                T(491974676910, "<style AimCopyrightTextC><copyright></style> AIM 2001")
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDALinkButton",
                "Id",
                "idAboutUs",
                "VAlign",
                "center",
                "OnPress",
                function(self, gamepad)
                  CreateMessageBox(self.desktop, T(193416941017, "Error Page"), T(399424889814, "HTTP Error 400. The request URL is invalid."), T({"OK"}))
                end,
                "TextStyle",
                "WebLinkButton_Hiring",
                "Text",
                T(891740393419, "About Us"),
                "ActiveTextStyle",
                "WebLinkButton_Hiring_Heavy"
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDALinkButton",
                "Id",
                "idTermsOfService",
                "VAlign",
                "center",
                "OnPress",
                function(self, gamepad)
                  CreateMessageBox(self.desktop, T(193416941017, "Error Page"), T(548899058407, "HTTP Error 403. You don't have permission to access on this server."), T({"OK"}))
                end,
                "TextStyle",
                "WebLinkButton_Hiring",
                "Text",
                T(111807730937, "Terms of Service"),
                "ActiveTextStyle",
                "WebLinkButton_Hiring_Heavy"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "right - selected merc info, rest of space",
          "Id",
          "idRight"
        }, {
          PlaceObj("XTemplateFunc", {
            "comment",
            "take whole space even when insides dont",
            "name",
            "Measure(self, max_width, max_height)",
            "func",
            function(self, max_width, max_height)
              local width, height = XWindow.Measure(self, max_width, max_height)
              return max_width, max_height
            end
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContentTemplate",
            "Id",
            "idMercData",
            "Margins",
            box(0, 20, 20, 10),
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "RespawnContent(self)",
              "func",
              function(self)
                XContentTemplate.RespawnContent(self)
                local context = self.context
                if not context then
                  return
                end
                local hireStatus = context.HireStatus
                local func = HireStatusToUITextMap[hireStatus]
                func(context, self.idInfoContainer)
                local kia = hireStatus == "Dead"
                local mia = hireStatus == "MIA"
                self.idPortrait:SetImage(context.Portrait)
                self.idPortrait:SetDesaturation((mia or kia) and 255 or 0)
                self.idPortrait:SetTransparency(kia and 25 or 0)
                self.idDead:SetVisible(kia)
                local dlg = GetDialog(self)
                self.idPerksAndInventory:SetVisible(not dlg.show_bio)
                self.idBio:SetVisible(dlg.show_bio)
                local bioText = self.idBioContent.idBioText
                local iconAppend = T(381811065044, "<valign top><image UI/PDA/Event/T_Event_TextIcon 1500><valign bottom>")
                if context.Affiliation ~= "AIM" and not context.Bio then
                  bioText:SetText(iconAppend .. T(448145280145, [[
Warning! This merc is not a member of A.I.M. We are not liable for any damages, loss of limbs, accidental atrocities, or unexpected war crimes that may be caused by using unlicensed mercs. 

 Caution! Use at your own risk!]]))
                else
                  bioText:SetText(iconAppend .. T(606873920225, "<Bio>"))
                end
                local specName = Presets.MercSpecializations.Default
                specName = specName[context.Specialization]
                specName = specName and specName.name
                self.idClassName:SetVisible(not not specName)
                self.idClassName:SetText(specName or Untranslated("placeholder"))
                self.idClassIcon:SetImage(GetMercSpecIcon(context))
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Dock",
              "box",
              "Image",
              "UI/PDA/os_background",
              "FrameBox",
              box(3, 3, 3, 3)
            }),
            PlaceObj("XTemplateWindow", {
              "Padding",
              box(20, 20, 20, 5),
              "Dock",
              "top",
              "LayoutMethod",
              "VPanel"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "portrait holder",
                "Dock",
                "left",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                185,
                "MinHeight",
                215,
                "MaxWidth",
                185,
                "MaxHeight",
                215
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "IdNode",
                  false,
                  "Padding",
                  box(2, 2, 2, 2),
                  "HAlign",
                  "left",
                  "VAlign",
                  "top",
                  "Image",
                  "UI/PDA/os_background_2",
                  "FrameBox",
                  box(3, 3, 3, 3)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Image",
                    "UI/Hud/portrait_background",
                    "ImageFit",
                    "stretch"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idPortrait",
                    "Clip",
                    "parent & self",
                    "ImageFit",
                    "height",
                    "ImageRect",
                    box(36, 0, 264, 251)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idDead",
                    "HAlign",
                    "right",
                    "VAlign",
                    "top",
                    "Image",
                    "UI/Hud/death_ribbon"
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(20, 0, 0, 0),
                "Dock",
                "box",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", nil, {
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idLevelBox",
                    "Dock",
                    "right",
                    "VAlign",
                    "center",
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    -12
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Margins",
                      box(0, -13, 0, 0),
                      "HAlign",
                      "center",
                      "TextStyle",
                      "Hiring_MercLevel",
                      "Translate",
                      true,
                      "Text",
                      T(351463573859, "<MercLevel()>")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "HAlign",
                      "center",
                      "TextStyle",
                      "PDASMLevelTxt",
                      "Translate",
                      true,
                      "Text",
                      T(141041371501, "Level")
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "name and class",
                    "HAlign",
                    "left"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idClassIcon",
                      "Margins",
                      box(0, 0, 10, 0),
                      "Dock",
                      "left",
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "MinWidth",
                      40,
                      "MinHeight",
                      40,
                      "MaxWidth",
                      40,
                      "MaxHeight",
                      40,
                      "ImageFit",
                      "stretch",
                      "ImageColor",
                      RGBA(195, 189, 172, 255)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "Margins",
                      box(0, -10, 0, 0),
                      "VAlign",
                      "center",
                      "LayoutMethod",
                      "VList",
                      "LayoutVSpacing",
                      -8
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "name",
                        "__class",
                        "AutoFitText",
                        "TextStyle",
                        "MercName",
                        "Translate",
                        true,
                        "Text",
                        T(672662514512, "<Name> <MercFlagImage()>"),
                        "TextVAlign",
                        "bottom",
                        "ImageScale",
                        1000,
                        "SafeSpace",
                        70
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idClassName",
                        "TextStyle",
                        "MercSubTitle",
                        "Translate",
                        true
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "vertical sep",
                  "__class",
                  "XFrame",
                  "Margins",
                  box(0, 5, 0, 13),
                  "VAlign",
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
                  "stats",
                  "__context",
                  function(parent, context)
                    return MercStatsItems(context)
                  end,
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "LayoutMethod",
                  "Grid",
                  "LayoutVSpacing",
                  -1,
                  "UniformRowHeight",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XFrame",
                    "Id",
                    "idLineSep",
                    "Margins",
                    box(4, 5, 4, 5),
                    "HAlign",
                    "center",
                    "GridX",
                    2,
                    "GridStretchX",
                    false,
                    "Image",
                    "UI/PDA/separate_line",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "SqueezeX",
                    false
                  }),
                  PlaceObj("XTemplateForEach", {
                    "run_after",
                    function(child, context, item, i, n, last)
                      local columnSize = MulDivRound(#context, 1, 2)
                      local column = (i - 1) / columnSize + 1
                      if column == 2 then
                        column = 3
                      end
                      child.parent.idLineSep:SetGridHeight(columnSize)
                      local row = (i - 1) % columnSize + 1
                      child:SetGridY(row)
                      child:SetGridX(column)
                      child:SetContext(item)
                      child.idName:SetText(item.name)
                      child.idValue:SetText(item.value)
                      local preset = Presets.MercStat.Default[item.id]
                      if not preset then
                        return
                      end
                      child.idIcon:SetImage(preset.Icon)
                      if column == 1 then
                      end
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "RolloverTemplate",
                      "RolloverGeneric",
                      "RolloverAnchor",
                      "center-top",
                      "RolloverText",
                      T(157340803747, "<help>"),
                      "RolloverOffset",
                      box(0, 0, 0, 5),
                      "RolloverTitle",
                      T(976520897583, "<name>"),
                      "IdNode",
                      true
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextImage",
                        "Id",
                        "idIcon",
                        "Margins",
                        box(0, 0, 8, 0),
                        "Dock",
                        "left",
                        "HAlign",
                        "left",
                        "VAlign",
                        "center",
                        "ImageScale",
                        point(350, 350),
                        "ImageColor",
                        RGBA(130, 128, 120, 128)
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idName",
                        "HAlign",
                        "left",
                        "VAlign",
                        "center",
                        "TextStyle",
                        "MercStatName",
                        "Translate",
                        true
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idValue",
                        "Dock",
                        "right",
                        "HAlign",
                        "right",
                        "VAlign",
                        "center",
                        "TextStyle",
                        "MercStatValue"
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnSetRollover(self, rollover)",
                        "func",
                        function(self, rollover)
                          if rollover then
                            PlayFX("buttonRollover", "start")
                          end
                          self.idName:SetTextStyle(rollover and "MercStatNameRollover" or "MercStatName")
                        end
                      })
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idMedicalAndPriceFooter",
              "Margins",
              box(20, 0, 20, 0),
              "Dock",
              "bottom",
              "LayoutMethod",
              "VList",
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "vertical sep",
                "__class",
                "XFrame",
                "Margins",
                box(0, 1, 0, 0),
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idInfoContainer",
                "IdNode",
                true,
                "LayoutMethod",
                "Grid"
              }, {
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idTitleContainer",
                  "Margins",
                  box(0, 0, 10, 0),
                  "Dock",
                  "left",
                  "HAlign",
                  "left",
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idName",
                    "Margins",
                    box(0, 10, 10, 10),
                    "MinWidth",
                    120,
                    "TextStyle",
                    "Hiring_Bio_Header",
                    "Translate",
                    true,
                    "Text",
                    T(295504655111, " ")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XFrame",
                    "Id",
                    "idLineSep",
                    "Margins",
                    box(4, 10, 4, 10),
                    "HAlign",
                    "center",
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
                  "XContextWindow",
                  "Id",
                  "idText",
                  "IdNode",
                  true,
                  "Visible",
                  false,
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "RolloverTemplate",
                    "RolloverGeneric",
                    "RolloverAnchor",
                    "center-top",
                    "RolloverOffset",
                    box(0, 0, 60, 10),
                    "Id",
                    "idValue",
                    "HAlign",
                    "right",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "PDAMercPrice",
                    "Translate",
                    true,
                    "TextVAlign",
                    "center"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "Id",
                  "idPrice1W",
                  "IdNode",
                  true,
                  "FoldWhenHidden",
                  true,
                  "ContextUpdateOnOpen",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "RolloverTemplate",
                    "RolloverGeneric",
                    "RolloverAnchor",
                    "center-top",
                    "RolloverText",
                    T(882683505602, "<MercPriceBioPageRollover()>"),
                    "RolloverOffset",
                    box(0, 0, 60, 10),
                    "RolloverTitle",
                    T(457158173170, "Weekly Cost"),
                    "Id",
                    "idValue",
                    "HAlign",
                    "right",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "PDAMercPrice",
                    "Translate",
                    true,
                    "Text",
                    T(196392143876, "<MercPriceBioPage(7, true)>"),
                    "TextVAlign",
                    "center"
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idPerksAndInventory",
              "Padding",
              box(20, 0, 20, 5),
              "Dock",
              "box",
              "Visible",
              false,
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "vertical sep",
                "__class",
                "XFrame",
                "Margins",
                box(0, 0, 0, 5),
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XScrollArea",
                "Id",
                "idPerkAndInventoryContent",
                "Margins",
                box(0, 4, 0, 5),
                "LayoutMethod",
                "VList",
                "VScroll",
                "idLoadoutScroll"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Margins",
                  box(0, 7, 0, 1),
                  "HAlign",
                  "left",
                  "VAlign",
                  "top",
                  "TextStyle",
                  "Hiring_Bio_Header",
                  "Translate",
                  true,
                  "Text",
                  T(984976462387, "Perks"),
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "perks",
                  "LayoutMethod",
                  "HWrap",
                  "LayoutHSpacing",
                  10,
                  "LayoutVSpacing",
                  10
                }, {
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return context:GetPerks(nil, "sort")
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child:SetPerkId(item.class)
                    end
                  }, {
                    PlaceObj("XTemplateTemplate", {"__template", "PDAPerk"})
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "equipment",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "vertical sep",
                    "__class",
                    "XFrame",
                    "Margins",
                    box(0, 5, 0, 7),
                    "VAlign",
                    "top",
                    "Image",
                    "UI/PDA/separate_line_vertical",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "SqueezeY",
                    false
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(0, 0, 0, 4),
                    "HAlign",
                    "left",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "Hiring_Bio_Header",
                    "Translate",
                    true,
                    "Text",
                    T(550507290667, "Equipment"),
                    "TextVAlign",
                    "center"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HWrap",
                    "LayoutHSpacing",
                    10,
                    "LayoutVSpacing",
                    10
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XInventoryItemEmbed",
                      "Id",
                      "idHead",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "BorderColor",
                      RGBA(60, 63, 68, 255),
                      "Background",
                      RGBA(42, 45, 54, 120),
                      "slot",
                      "Head",
                      "HideWhenEmpty",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XInventoryItemEmbed",
                      "Id",
                      "idTorso",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "BorderColor",
                      RGBA(60, 63, 68, 255),
                      "Background",
                      RGBA(42, 45, 54, 120),
                      "slot",
                      "Torso",
                      "HideWhenEmpty",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XInventoryItemEmbed",
                      "Id",
                      "idLegs",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "BorderColor",
                      RGBA(60, 63, 68, 255),
                      "Background",
                      RGBA(42, 45, 54, 120),
                      "slot",
                      "Legs",
                      "HideWhenEmpty",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XInventoryItemEmbed",
                      "Id",
                      "idWeaponA",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "BorderColor",
                      RGBA(60, 63, 68, 255),
                      "Background",
                      RGBA(42, 45, 54, 120),
                      "slot",
                      "Handheld A",
                      "HideWhenEmpty",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XInventoryItemEmbed",
                      "Id",
                      "idWeaponB",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "BorderColor",
                      RGBA(60, 63, 68, 255),
                      "Background",
                      RGBA(42, 45, 54, 120),
                      "slot",
                      "Handheld B",
                      "HideWhenEmpty",
                      true
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "backpack",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "vertical sep",
                    "__class",
                    "XFrame",
                    "Margins",
                    box(0, 5, 0, 7),
                    "VAlign",
                    "top",
                    "Image",
                    "UI/PDA/separate_line_vertical",
                    "FrameBox",
                    box(3, 3, 3, 3),
                    "SqueezeY",
                    false
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(0, 0, 0, 4),
                    "HAlign",
                    "left",
                    "VAlign",
                    "center",
                    "TextStyle",
                    "Hiring_Bio_Header",
                    "Translate",
                    true,
                    "Text",
                    T(801008989746, "Backpack"),
                    "TextVAlign",
                    "center"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XInventoryItemEmbed",
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "HWrap",
                    "LayoutHSpacing",
                    10,
                    "LayoutVSpacing",
                    10,
                    "BorderColor",
                    RGBA(60, 63, 68, 255),
                    "Background",
                    RGBA(42, 45, 54, 120),
                    "slot",
                    "Inventory",
                    "HideWhenEmpty",
                    true
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "SetVisible(self, visible)",
                      "func",
                      function(self, visible)
                        XInventoryItemEmbed.SetVisible(self, visible)
                        self.parent:SetVisible(visible)
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "MessengerScrollbar",
                  "Id",
                  "idLoadoutScroll",
                  "Margins",
                  box(20, 3, 3, 3),
                  "Dock",
                  "right",
                  "FoldWhenHidden",
                  false,
                  "Target",
                  "node",
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                })
              }),
              PlaceObj("XTemplateWindow", {"IdNode", true})
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idBio",
              "Padding",
              box(20, 0, 20, 5),
              "Dock",
              "box",
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "vertical sep",
                "__class",
                "XFrame",
                "Margins",
                box(0, 0, 0, 5),
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Margins",
                  box(0, 10, 0, 10),
                  "OnLayoutComplete",
                  function(self)
                    if self.context and self.context.Title then
                      self:SetText(T({
                        442425729284,
                        "Bio - <Title>",
                        self.context
                      }))
                    else
                      self:SetText(T(661110761557, "Bio"))
                    end
                  end,
                  "TextStyle",
                  "Hiring_Bio_Header",
                  "Translate",
                  true,
                  "Text",
                  T(642133584014, "BIO - <Title>")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idBioContent",
                  "Margins",
                  box(0, 50, 0, 15),
                  "VScroll",
                  "idBioScroll"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idBioText",
                    "HAlign",
                    "left",
                    "TextStyle",
                    "Hiring_MercBio",
                    "Translate",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "MessengerScrollbar",
                    "Id",
                    "idBioScroll",
                    "Margins",
                    box(20, 3, 3, 3),
                    "Dock",
                    "right",
                    "FoldWhenHidden",
                    false,
                    "Target",
                    "node",
                    "SnapToItems",
                    true,
                    "AutoHide",
                    true
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(20, 0, 20, 10),
            "Dock",
            "bottom",
            "MinHeight",
            36,
            "MaxHeight",
            36
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XToolBarList",
              "Id",
              "idToolBar",
              "HAlign",
              "right",
              "ScaleModifier",
              point(900, 900),
              "LayoutHSpacing",
              18,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "PDACommonButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XToolBarList.RebuildActions(self, ...)
                  if not gv_InitialHiringDone then
                    self.idPDACloseOrBackTab:SetText(T(476547188462, "Start"))
                  end
                  local dismissButton = self.ididDismiss
                  if dismissButton then
                    function dismissButton.GetRolloverAnchor()
                      return "center-top"
                    end
                    dismissButton.GetRolloverDisabledText = empty_func
                    function dismissButton.GetRolloverText()
                      if dismissButton:GetEnabled() then
                        return false
                      end
                      if not gv_SatelliteView then
                        return false
                      end
                      return T(175457184875, "You can't dismiss mercs during an ongoing conflict.")
                    end
                  end
                  local contactButton = self.ididContact
                  if contactButton then
                    local selectedMerc = self:ResolveId("node").selected_merc
                    function contactButton.GetRolloverAnchor()
                      return "center-top"
                    end
                    contactButton.GetRolloverDisabledText = empty_func
                    function contactButton.GetRolloverText()
                      if not selectedMerc then
                        return false
                      end
                      local canContact, disableText = MercCanContact(gv_UnitData[selectedMerc])
                      return disableText
                    end
                  end
                end
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateAction", {
        "RolloverTemplate",
        "RolloverGeneric",
        "RolloverOffset",
        box(0, 0, 0, 8),
        "ActionId",
        "idContact",
        "ActionName",
        T(284104494351, "Contact"),
        "ActionToolbar",
        "ActionBar",
        "ActionGamepad",
        "ButtonY",
        "ActionButtonTemplate",
        "PDACommonButtonBlueSnype",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          local id = content.selected_merc
          if not id then
            return "disabled"
          end
          local enabled = MercCanContact(gv_UnitData[id])
          if not enabled then
            return "hidden"
          end
          if enabled == "disabled" then
            return "disabled"
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          local mercId = content.selected_merc
          StartMercChat(mercId)
        end,
        "FXPress",
        "none"
      }),
      PlaceObj("XTemplateAction", {
        "RolloverTemplate",
        "RolloverGeneric",
        "RolloverOffset",
        box(0, 0, 0, 8),
        "ActionId",
        "idDismiss",
        "ActionName",
        T(163956682203, "Dismiss"),
        "ActionToolbar",
        "ActionBar",
        "ActionButtonTemplate",
        "PDACommonButtonBlueSnype",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          local id = content.selected_merc
          if not id then
            return "hidden"
          end
          local merc = gv_UnitData[id]
          if merc.HireStatus ~= "Hired" then
            return "hidden"
          end
          if not merc.HiredUntil then
            return "hidden"
          end
          local remainingTime = merc.HiredUntil - Game.CampaignTime
          local daysLeft = remainingTime / const.Scale.day
          if daysLeft <= 1 then
            return "hidden"
          end
          if g_Combat then
            return "disabled"
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          local mercId = content.selected_merc
          DismissMerc(mercId)
        end,
        "FXPress",
        "none"
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idSeeBio",
        "ActionName",
        T(529989041592, "See Bio"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "S",
        "ActionGamepad",
        "Start",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          return content.show_bio and "hidden" or "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          content.show_bio = true
          AIMBrowserSection = "bio"
          ObjModified(gv_UnitData[content.selected_merc])
          content.idToolBar:RebuildActions(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idHideBio",
        "ActionName",
        T(872907861571, "Loadout"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "S",
        "ActionGamepad",
        "Start",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          return content.show_bio and "enabled" or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          content.show_bio = false
          AIMBrowserSection = "loadout"
          ObjModified(gv_UnitData[content.selected_merc])
          content.idToolBar:RebuildActions(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idScrollUp",
        "ActionGamepad",
        "RightThumbUp",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") or not content.idMercData then
            return
          end
          local scroll = false
          if content.show_bio then
            scroll = content.idMercData:ResolveId("idBioContent")
          else
            scroll = content.idMercData:ResolveId("idPerkAndInventoryContent")
          end
          if not scroll then
            return
          end
          scroll:ScrollUp()
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idScrollDown",
        "ActionGamepad",
        "RightThumbDown",
        "ActionState",
        function(self, host)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") then
            return
          end
          return "enabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local content = host.idContent
          if not IsKindOf(content, "PDABrowser") then
            return
          end
          content = content.idBrowserContent
          if not IsKindOf(content, "PDAAIMBrowser") or not content.idMercData then
            return
          end
          local scroll = false
          if content.show_bio then
            scroll = content.idMercData:ResolveId("idBioContent")
          else
            scroll = content.idMercData:ResolveId("idPerkAndInventoryContent")
          end
          if not scroll then
            return
          end
          scroll:ScrollDown()
        end
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDAGenericCloseAction"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "aim premium observer",
      "__context",
      function(parent, context)
        return "AIMPremium"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        node.idMercList:RespawnContent()
      end
    })
  })
})
