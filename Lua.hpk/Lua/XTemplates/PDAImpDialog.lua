PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDAImpDialog",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Background",
    RGBA(215, 159, 80, 255),
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "InitialMode",
    "start_page",
    "InternalModes",
    "start_page,home,login,logout,test,test_result_stats,test_result_perks,error,pet_intro, imp_confirm,imp_confirm_intro, final_confirm, outcome, pswd_reset, title_text, home, gallery, construction"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self.clicked_links = {}
        self.impconfirm = {}
        self.logined = g_ImpTest and g_ImpTest.loggedin and (not netInGame or NetIsHost())
        AddPageToBrowserHistory("imp")
        XDialog.Open(self, ...)
        self:SetFocus()
        ObjModified("right panel")
        ObjModified("left panel")
        ObjModified("imp header")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CanClose()",
      "func",
      function()
        return true
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDialogModeChange(self, mode, dialog)",
      "func",
      function(self, mode, dialog)
        self.logined = g_ImpTest and g_ImpTest.loggedin and (not netInGame or NetIsHost())
        local toolbar = self.idContent.idActionBar
        if mode == "login" or mode == "pswd_reset" or mode == "final_confirm" then
          toolbar:SetMargins(box(0, 10, 0, 0))
          toolbar:SetDock(false)
        else
          toolbar:SetMargins(box(0, 0, 0, 0))
          toolbar:SetDock("bottom")
        end
        if mode == "home" or mode == "imp_confirm" or mode == "imp_confirm_intro" then
          self.idPageTitle:SetText(T(778146627766, "Institute for mercenary profiling"))
        end
        if mode == "login" then
          self.idPageTitle:SetText(T(964519094365, "I.M.P. - Authentication"))
        end
        if mode == "pet_intro" or mode == "test" then
          self.idPageTitle:SetText(T(202272969464, "Personality Evaluation test (P.E.T.)"))
        end
        if mode == "test_result_stats" or mode == "test_result_perks" or mode == "final_confirm" then
          self.idPageTitle:SetText(T(432178756962, "I.M.P. mercenary certificate"))
        end
        if mode == "imp_confirm" or mode == "imp_confirm_intro" then
          self.logined = true
          g_ImpTest.loggedin = true
          ObjModified("header links")
        end
        if (mode == "start_page" or mode == "imp_confirm") and self.logined and self:GotoLastTestPlace() then
          ObjModified("header links")
          return
        end
        if mode == "start_page" then
          self:SetMode("home")
          return
        end
        if mode == "login" and self.logined then
          self:GotoLastTestPlace()
          return
        end
        if mode == "login" then
          self.impconfirm = {}
          self.logined = false
          g_ImpTest.loggedin = false
          ObjModified("header links")
        end
        if mode == "test_result_stats" or mode == "test" then
          ObjModified("header links")
        end
        if mode == "logout" then
          g_ImpTest.confirmed = nil
          g_ImpTest.answers = nil
          g_ImpTest.final = nil
          g_ImpTest.result = nil
          g_ImpTest.last_opened_question = nil
          g_ImpTest.clicked_links = nil
          self.impconfirm = {}
          self.logined = false
          g_ImpTest.loggedin = false
          ObjModified("header links")
          self:SetMode("home")
          return
        end
        ObjModified("pda_url")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetURL(self, mode, mode_param)",
      "func",
      function(self, mode, mode_param)
        if mode == "gallery" then
          return Untranslated("http://www.imp.org/gallery")
        elseif mode == "title_text" then
          if mode_param == "contacts" then
            return Untranslated("http://www.imp.org/contacts")
          else
            return Untranslated("http://www.imp.org/testimonials")
          end
        elseif mode == "construction" then
          return Untranslated("http://www.imp.org/construction")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetMode(self, mode,...)",
      "func",
      function(self, mode, ...)
        if mode ~= self.Mode then
          XDialog.SetMode(self, mode, ...)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GotoLastTestPlace(self)",
      "func",
      function(self)
        if self.logined and (not (g_ImpTest and g_ImpTest.final) or not g_ImpTest.final.created) then
          if g_ImpTest and g_ImpTest.final and g_ImpTest.confirmed then
            self:SetMode("test_result_stats")
            return true
          end
          if not g_ImpTest or not g_ImpTest.last_opened_question then
            self:SetMode("imp_confirm")
            return true
          else
            self:OpenQuestion(g_ImpTest.last_opened_question)
            return true
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonB" or shortcut == "Escape" then
          local host = self.parent
          host = GetDialog(GetDialog(host).parent)
          if host then
            host:CloseAction(host)
          end
          return "break"
        end
        local mode = self:GetMode()
        if mode == "test" or mode == "imp_confirm" or mode == "imp_confirm_intro" or mode == "final_confirm" then
          local list = self.idContent.idAnswers.idList
          if shortcut == "DPadUp" or shortcut == "Up" then
            list:SelPrev()
          end
          if shortcut == "DPadDown" or shortcut == "Down" then
            list:SelNext()
          end
        end
        local actions = self:GetShortcutActions(shortcut)
        for _, action in ipairs(actions) do
          local state = action:ActionState(self)
          if state ~= "disabled" and state ~= "hidden" then
            action:OnAction(self, "gamepad")
            return "break"
          end
        end
        if shortcut == "ButtonY" then
          self:SetMode("login")
          return "break"
        end
        if shortcut == "Start" then
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "StartTest(self)",
      "func",
      function(self)
        g_ImpTest = g_ImpTest or {}
        g_ImpTest.answers = {}
        ResetVisitedHyperlinks(g_ImpTest)
        self:OpenQuestion(1)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OpenQuestion(self, idx)",
      "func",
      function(self, idx)
        if g_ImpTest then
          g_ImpTest.last_opened_question = idx
          VisitHyperlink(g_ImpTest, "Question_" .. tostring(idx))
          if idx == "outcome" then
            GetDialog(self):SetMode("outcome")
          else
            GetDialog(self):SetMode("test")
            self.idContent:SetContext({
              question = idx,
              preset = ImpQuestions["Question" .. idx]
            })
          end
          ObjModified("left panel")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "PrevQuestion(self)",
      "func",
      function(self)
        local idx = g_ImpTest.last_opened_question - 1
        if 0 < idx then
          self:OpenQuestion(idx)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "NextQuestion(self)",
      "func",
      function(self)
        local idx = g_ImpTest.last_opened_question + 1
        if idx <= 10 then
          self:OpenQuestion(idx)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CanFinishMercCreation",
      "func",
      function(self, ...)
        return self:CheckMercName() and self:CheckMercNick() and self:CheckMercStats() and self:CheckMercPerksPersonal() and self:CheckMercPerksTactical()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CanAdvanceToMercPerks",
      "func",
      function(self, ...)
        return self:CheckMercName() and self:CheckMercNick() and self:CheckMercStats()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CheckMercName",
      "func",
      function(self, ...)
        return g_ImpTest and g_ImpTest.final and g_ImpTest.final.name ~= "" and TDevModeGetEnglishText(g_ImpTest.final.name) ~= ""
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CheckMercNick",
      "func",
      function(self, ...)
        return g_ImpTest and g_ImpTest.final and g_ImpTest.final.nick ~= "" and TDevModeGetEnglishText(g_ImpTest.final.nick) ~= ""
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CheckMercStats",
      "func",
      function(self, ...)
        return ImpGetUnassignedStatPoints() == 0
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CheckMercPerksPersonal",
      "func",
      function(self, ...)
        return g_ImpTest.final and g_ImpTest.final.perks and g_ImpTest.final.perks.personal and g_ImpTest.final.perks.personal.perk
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CheckMercPerksTactical",
      "func",
      function(self, ...)
        return g_ImpTest.final and g_ImpTest.final.perks and g_ImpTest.final.perks.tactical and #g_ImpTest.final.perks.tactical == 2
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/PDA/imp_background",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idCloseAction",
      "ActionName",
      T(208185069032, "Close"),
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        local pda = GetDialog("PDADialog")
        pda:CloseAction(host)
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
      "idPrevAnswer",
      "ActionName",
      T(457748418323, "PrevAnswer"),
      "ActionGamepad",
      "DPadDown"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idNextAnswer",
      "ActionName",
      T(623631017672, "NextAnswer"),
      "ActionGamepad",
      "DPadUp"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "VirtualCursorManager",
      "Reason",
      "Imp"
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "MinWidth",
      1076,
      "MaxWidth",
      1076,
      "MaxHeight",
      849
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "header",
          "__context",
          function(parent, context)
            return "imp header"
          end,
          "Id",
          "idHeader",
          "IdNode",
          true,
          "Margins",
          box(0, 4, 0, 0),
          "Dock",
          "top",
          "HAlign",
          "center",
          "VAlign",
          "top",
          "MinWidth",
          1076,
          "MinHeight",
          136,
          "MaxWidth",
          1076,
          "Background",
          RGBA(88, 92, 68, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(26, 0, 26, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "line",
              "Margins",
              box(0, 0, 0, 48),
              "VAlign",
              "bottom",
              "MinHeight",
              2,
              "MaxHeight",
              2,
              "Background",
              RGBA(124, 130, 96, 255)
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "logo",
              "__class",
              "XImage",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Image",
              "UI/PDA/imp_logo"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "update date",
              "__class",
              "XText",
              "Margins",
              box(0, 24, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "TextStyle",
              "PDAIMPHeaderText",
              "Translate",
              true,
              "Text",
              T(364351203998, [[
Last updated
March 16 2001]])
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 24, 0, 0),
              "HAlign",
              "right",
              "VAlign",
              "top",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "visitors",
                "__class",
                "XText",
                "HAlign",
                "right",
                "VAlign",
                "top",
                "TextStyle",
                "PDAIMPHeaderText",
                "Translate",
                true,
                "Text",
                T(526568593337, "Visitors counter")
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "counter",
                "__context",
                function(parent, context)
                  return "imp counter"
                end,
                "__class",
                "XContextImage",
                "Margins",
                box(0, -4, 0, 0),
                "HAlign",
                "right",
                "VAlign",
                "top",
                "Image",
                "UI/PDA/imp_counter",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local val = GetImpMenuCounter()
                  if not val then
                    ImpInitCounter()
                    val = GetImpMenuCounter()
                  end
                  local digits = {}
                  digits[1] = val / 10000
                  val = val - digits[1] * 10000
                  digits[2] = val / 1000
                  val = val - digits[2] * 1000
                  digits[3] = val / 100
                  val = val - digits[3] * 100
                  digits[4] = val / 10
                  digits[5] = val % 10
                  self.idCounter:SetText(table.concat(digits, " "))
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "visitors",
                  "__class",
                  "XText",
                  "Id",
                  "idCounter",
                  "Margins",
                  box(2, 0, 0, 0),
                  "TextStyle",
                  "PDAIMPCounter",
                  "Text",
                  "0 1 2 3 4"
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "links left",
              "__context",
              function(parent, context)
                return "header links"
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idLeftLinks",
              "IdNode",
              true,
              "HAlign",
              "left",
              "VAlign",
              "bottom",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              6,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                local test_completed = g_ImpTest and g_ImpTest.confirmed
                self:ResolveId("idLogIn"):SetEnabled(not dlg.logined and (not test_completed or not g_ImpTest.final.created))
                self:ResolveId("idIntroduction"):SetEnabled(dlg.logined and not test_completed)
                self:ResolveId("idTest"):SetEnabled(dlg.logined and not test_completed)
                self:ResolveId("idProfile"):SetEnabled(dlg.logined and test_completed)
                self:ResolveId("idHome"):SetEnabled(true)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "comment",
                "log in",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idLogIn",
                "LinkId",
                "login",
                "dlg_mode",
                "login",
                "Text",
                T(659488137546, "Log In")
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                22,
                "MaxWidth",
                2,
                "MaxHeight",
                22,
                "Background",
                RGBA(124, 130, 96, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "home",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idHome",
                "LinkId",
                "home",
                "dlg_mode",
                "home",
                "Text",
                T(805144021337, "Home")
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                22,
                "MaxWidth",
                2,
                "MaxHeight",
                22,
                "Background",
                RGBA(124, 130, 96, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "introduction",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idIntroduction",
                "LinkId",
                "introduction",
                "dlg_mode",
                "imp_confirm_intro",
                "Text",
                T(126748905760, "I.M.P.")
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                22,
                "MaxWidth",
                2,
                "MaxHeight",
                22,
                "Background",
                RGBA(124, 130, 96, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "test",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idTest",
                "LinkId",
                "test",
                "Text",
                T(704793011318, "Test")
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnClick(self, dlg)",
                  "func",
                  function(self, dlg)
                    if not g_ImpTest.last_opened_question then
                      GetDialog(self):StartTest()
                    else
                      GetDialog(self):OpenQuestion(g_ImpTest.last_opened_question)
                    end
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                22,
                "MaxWidth",
                2,
                "MaxHeight",
                22,
                "Background",
                RGBA(124, 130, 96, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "profile",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idProfile",
                "LinkId",
                "profile",
                "dlg_mode",
                "test_result_stats",
                "Text",
                T(156322128717, "Profile")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "links right",
              "__context",
              function(parent, context)
                return "header links"
              end,
              "__class",
              "XContextWindow",
              "IdNode",
              true,
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                self.idLogOut:SetEnabled(dlg.logined)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "comment",
                "log out",
                "__template",
                "PDAImpHyperlinkHeader",
                "Id",
                "idLogOut",
                "LinkId",
                "logout",
                "dlg_mode",
                "logout",
                "Text",
                T(761514198458, "Log out")
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnClick(self, dlg)",
                  "func",
                  function(self, dlg)
                    g_ImpTest.loggedin = false
                    dlg:SetMode(self.dlg_mode)
                  end
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "footer",
          "__context",
          function(parent, context)
            return "imp footer"
          end,
          "Id",
          "idFooter",
          "Dock",
          "bottom",
          "VAlign",
          "bottom"
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            20
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "links",
              "HAlign",
              "center",
              "VAlign",
              "top",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              8
            }, {
              PlaceObj("XTemplateTemplate", {
                "comment",
                "rss feed",
                "__template",
                "PDAImpHyperlink",
                "HAlign",
                "center",
                "MinHeight",
                20,
                "LinkId",
                "browse",
                "Text",
                T(212384058717, "RSS Feed"),
                "TextHAlign",
                "center",
                "TextVAlign",
                "center",
                "ErrParam",
                "Error404"
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                20,
                "MaxWidth",
                2,
                "MaxHeight",
                20,
                "Background",
                RGBA(76, 62, 255, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "service",
                "__template",
                "PDAImpHyperlink",
                "HAlign",
                "center",
                "MinHeight",
                20,
                "LinkId",
                "service",
                "Text",
                T(821269390672, "Services"),
                "TextHAlign",
                "center",
                "TextVAlign",
                "center",
                "ErrParam",
                "Error408"
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                20,
                "MaxWidth",
                2,
                "MaxHeight",
                20,
                "Background",
                RGBA(76, 62, 255, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "search",
                "__template",
                "PDAImpHyperlink",
                "HAlign",
                "center",
                "MinHeight",
                20,
                "OnContextUpdate",
                function(self, context, ...)
                  XContextWindow.OnContextUpdate(self, context)
                  local dlg = GetDialog(self)
                  local pdaBrowser = GetPDABrowserDialog()
                  if HyperlinkVisited(pdaBrowser, self:GetProperty("LinkId")) then
                    self.idLink:SetTextStyle("PDAIMPHyperLinkClicked")
                    self.idLink:OnSetRollover(true)
                  end
                end,
                "LinkId",
                "search",
                "Text",
                T(111393156310, "Search"),
                "TextHAlign",
                "center",
                "TextVAlign",
                "center",
                "ErrParam",
                "Error500"
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                20,
                "MaxWidth",
                2,
                "MaxHeight",
                20,
                "Background",
                RGBA(76, 62, 255, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "help",
                "__template",
                "PDAImpHyperlink",
                "HAlign",
                "center",
                "MinHeight",
                20,
                "LinkId",
                "help",
                "Text",
                T(296296892071, "Help"),
                "TextHAlign",
                "center",
                "TextVAlign",
                "center",
                "ErrParam",
                "UnderConstruction"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnClick(self, dlg)",
                  "func",
                  function(self, dlg)
                    dlg:SetMode("construction")
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                20,
                "MaxWidth",
                2,
                "MaxHeight",
                20,
                "Background",
                RGBA(76, 62, 255, 255)
              }),
              PlaceObj("XTemplateTemplate", {
                "comment",
                "contacts",
                "__template",
                "PDAImpHyperlink",
                "HAlign",
                "center",
                "MinHeight",
                20,
                "LinkId",
                "contacts",
                "Text",
                T(687237737248, "Contacts"),
                "TextHAlign",
                "center",
                "TextVAlign",
                "center"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnClick(self, dlg)",
                  "func",
                  function(self, dlg)
                    dlg:SetMode("title_text", "contacts")
                  end
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "IdNode",
          false,
          "HAlign",
          "center",
          "MinWidth",
          1076,
          "MaxWidth",
          1076
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPageTitle",
            "HAlign",
            "center",
            "VAlign",
            "top",
            "MinWidth",
            56,
            "MinHeight",
            56,
            "TextStyle",
            "PDAIMPPageTitle",
            "Translate",
            true,
            "Text",
            T(589427374438, "Institute for mercenary profiling"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 56, 0, 8)
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "left",
              "__context",
              function(parent, context)
                return "left panel"
              end,
              "__class",
              "XContentTemplate",
              "Id",
              "idLeft",
              "IdNode",
              false,
              "Dock",
              "left",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              180,
              "MinHeight",
              560,
              "MaxWidth",
              180,
              "Background",
              RGBA(230, 222, 202, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(20, 20, 0, 0),
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateMode", {
                  "mode",
                  "test,outcome"
                }, {
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return {
                        1,
                        2,
                        3,
                        4,
                        5,
                        6,
                        7,
                        8,
                        9,
                        10
                      }
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      local hyperlink = Untranslated("<h OpenQuestion " .. i .. " IMP>")
                      child.idText:SetText(T({
                        604647005264,
                        "<underline><hl>Question</underline></h> <style PDAIMPHyperLinkSuffix>(<idx>)</style>",
                        hl = hyperlink,
                        idx = i
                      }))
                      child.idText:SetTextStyle(i == g_ImpTest.last_opened_question and "PDAIMPHyperLinkSelected" or HyperlinkVisited(g_ImpTest, "Question_" .. tostring(i)) and "PDAIMPHyperLinkClicked" or "PDAIMPHyperLink")
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "IdNode",
                      true,
                      "LayoutMethod",
                      "HList",
                      "MouseCursor",
                      "UI/Cursors/Pda_Hand.tga"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "Margins",
                        box(5, 0, 0, 0),
                        "LayoutMethod",
                        "VList"
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XText",
                          "Id",
                          "idText",
                          "MouseCursor",
                          "UI/Cursors/Pda_Hand.tga",
                          "FXMouseIn",
                          "buttonRollover",
                          "FXPress",
                          "buttonPress",
                          "FXPressDisabled",
                          "IactDisabled",
                          "TextStyle",
                          "PDAIMPHyperLink",
                          "Translate",
                          true,
                          "Text",
                          T(277259125133, "Question")
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                            "func",
                            function(self, hyperlink, argument, hyperlink_box, pos, button)
                              if hyperlink == "OpenQuestion" then
                                GetDialog(self):OpenQuestion(argument)
                              end
                            end
                          })
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "IdNode",
                    true,
                    "LayoutMethod",
                    "HList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Margins",
                      box(5, 0, 0, 0),
                      "LayoutMethod",
                      "VList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idText",
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "FXMouseIn",
                        "buttonRollover",
                        "FXPress",
                        "buttonPress",
                        "FXPressDisabled",
                        "IactDisabled",
                        "TextStyle",
                        "PDAIMPHyperLink",
                        "Translate",
                        true,
                        "Text",
                        T(701534057921, "Question")
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "OnMouseButtonDown(self, pos, button)",
                          "func",
                          function(self, pos, button)
                            GetDialog(self):OpenQuestion("outcome")
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "Open",
                          "func",
                          function(self, ...)
                            self:SetText(T(177052366651, "<underline>Outcome</underline>"))
                            self:SetTextStyle(g_ImpTest.last_opened_question == "outcome" and "PDAIMPHyperLinkSelected" or HyperlinkVisited(g_ImpTest, "Question_outcome") and "PDAIMPHyperLinkClicked" or "PDAIMPHyperLink")
                          end
                        })
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateMode", {
                  "mode",
                  "home,login,logout,test_result_stats,test_result_perks,error,pswd_reset,pet_intro, imp_confirm,imp_confirm_intro, final_confirm, title_text, home, gallery, construction"
                }, {
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return ImpLeftPageLinks()
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child.idLink:SetLinkId(item.link_id)
                      child.idLink:SetText(item.text)
                      local dlg = GetDialog(child)
                      child.idLink.idLink:SetTextStyle(dlg.clicked_links and dlg.clicked_links[item.link_id] and "PDAIMPHyperLinkClicked" or "PDAIMPHyperLink")
                      if item.error then
                        child.idLink:SetErrParam(item.error)
                      end
                      if item.link_id == "mercs" then
                        function child.idLink.OnClick(this, dlg)
                          dlg:SetMode("title_text", "words")
                        end
                      end
                      if item.link_id == "gallery" then
                        function child.idLink.OnClick(this, dlg)
                          dlg:SetMode("gallery")
                        end
                      end
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "IdNode",
                      true,
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Image",
                        "UI/PDA/hm_circle",
                        "ImageScale",
                        point(600, 600),
                        "ImageColor",
                        RGBA(0, 0, 0, 255)
                      }),
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "PDAImpHyperlink",
                        "Id",
                        "idLink",
                        "Margins",
                        box(5, 0, 0, 0)
                      })
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(10, 0, 10, 20),
                "Dock",
                "box",
                "HAlign",
                "left",
                "VAlign",
                "bottom",
                "TextStyle",
                "PDAIMPCopyrightText",
                "Translate",
                true,
                "Text",
                T(236432374390, "<copyright> IMP Corp 2001")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "right",
              "__context",
              function(parent, context)
                return "right panel"
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idRight",
              "IdNode",
              true,
              "Dock",
              "right",
              "HAlign",
              "right",
              "VAlign",
              "top",
              "MinWidth",
              180,
              "MinHeight",
              560,
              "MaxWidth",
              180,
              "LayoutMethod",
              "VList",
              "Background",
              RGBA(230, 222, 202, 255),
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                XContextWindow.OnContextUpdate(self, context, ...)
                local hyperlink = Untranslated("<h OpenMonthMerc month_merc IMP underline>")
                self.idText:SetText(T({
                  225920505057,
                  "<hl><underline>A.I.M. merc of the month<underline></h>",
                  hl = hyperlink
                }))
                self.idDots:SetText(T({
                  312104275561,
                  "<hl><underline>...<underline></h>",
                  hl = hyperlink
                }))
                local dlg = GetDialog(self)
                self.idText:SetTextStyle(dlg.clicked_links.month_merc and "PDAIMPHyperLinkClicked" or "PDAIMPHyperLink")
                local data = ImpMercOfTheMonth()
                if data then
                  self.idPortrait:SetImage(data.Portrait)
                  self.idName:SetText(data.Name)
                  self.idBio:SetText(data.Bio)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idText",
                "Margins",
                box(16, 20, 16, 0),
                "Dock",
                "top",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                140,
                "MaxWidth",
                140,
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "TextStyle",
                "PDAIMPHyperLink",
                "Translate",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                  "func",
                  function(self, hyperlink, argument, hyperlink_box, pos, button)
                    if hyperlink == "OpenMonthMerc" then
                      PlayFX("buttonPress", "start")
                      self:SetTextStyle("PDAIMPHyperLinkClicked")
                      local dlg = GetDialog(self)
                      dlg.clicked_links[argument] = true
                      OpenAIMAndSelectMerc(g_ImpTest.month_merc)
                    end
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(16, 0, 16, 0),
                "Dock",
                "top",
                "HAlign",
                "left"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idPortraitBG",
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
                  "XImage",
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
                  "stretch",
                  "ImageRect",
                  box(36, 0, 264, 251)
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idName",
                "Margins",
                box(16, 10, 16, 0),
                "Dock",
                "top",
                "MinWidth",
                140,
                "MaxWidth",
                140,
                "TextStyle",
                "PDAIMPMercName",
                "Translate",
                true
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDots",
                "Margins",
                box(16, -10, 16, 16),
                "Padding",
                box(4, 2, 2, 2),
                "Dock",
                "bottom",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                140,
                "MaxWidth",
                140,
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "FXMouseIn",
                "buttonRollover",
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "TextStyle",
                "PDAIMPHyperLink",
                "Translate",
                true,
                "Text",
                T(804387271590, "...")
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                  "func",
                  function(self, hyperlink, argument, hyperlink_box, pos, button)
                    if hyperlink == "OpenMonthMerc" then
                      PlayFX("buttonPress", "start")
                      self:SetTextStyle("PDAIMPHyperLinkClicked")
                      local dlg = GetDialog(self)
                      dlg.clicked_links[argument] = true
                      OpenAIMAndSelectMerc(g_ImpTest.month_merc)
                    end
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idBio",
                "Margins",
                box(16, 5, 16, 0),
                "Dock",
                "top",
                "VAlign",
                "top",
                "MinWidth",
                140,
                "MinHeight",
                276,
                "MaxWidth",
                140,
                "MaxHeight",
                276,
                "OnLayoutComplete",
                function(self)
                  local old_height = self.content_box:maxy() - self.content_box:miny()
                  local line_height = self.font_height + self.font_linespace
                  local new_height = floatfloor(old_height / line_height) * line_height
                  if (0.0 + old_height) / line_height % 1 <= 0.9 then
                    local cb = self.content_box
                    self.content_box = box(cb:minx(), cb:miny(), cb:maxx(), cb:miny() + new_height)
                  end
                end,
                "TextStyle",
                "PDAIMPMercBio",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "center",
              "__class",
              "XContentTemplate",
              "Id",
              "idContent",
              "Margins",
              box(8, 0, 8, 0),
              "HAlign",
              "center",
              "VAlign",
              "top",
              "MinWidth",
              700,
              "MinHeight",
              560,
              "MaxWidth",
              700,
              "LayoutMethod",
              "VList",
              "OnContextUpdate",
              function(self, context, ...)
                XContentTemplate.OnContextUpdate(self, context, ...)
                local dlg = GetDialog(self)
                if dlg:GetMode() == "test" then
                  dlg.mode_param = Untranslated("Question" .. context.question)
                  ObjModified("pda_url")
                end
              end
            }, {
              PlaceObj("XTemplateMode", {"mode", "test"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpAnswers",
                  "HeaderButtonId",
                  "idTest"
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idStartOver",
                  "ActionName",
                  T(640196796709, "Start Over"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "LeftThumbClick",
                  "OnAction",
                  function(self, host, source, ...)
                    host:StartTest()
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idSkip",
                  "ActionName",
                  T(808369493896, "Skip"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "ButtonY",
                  "ActionState",
                  function(self, host)
                    local context = host.idContent:GetContext()
                    local idx = context and context.question or 0
                    return idx ~= 10 and "enabled" or "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    host:OpenQuestion("outcome")
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idPrev",
                  "ActionName",
                  T(549570728431, "Prev"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "LeftTrigger",
                  "ActionState",
                  function(self, host)
                    local context = host.idContent:GetContext()
                    local idx = context and context.question or 0
                    return 1 < idx and "enabled" or "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    host:PrevQuestion()
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idNext",
                  "ActionName",
                  T(655064233565, "Next"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "RightTrigger",
                  "ActionState",
                  function(self, host)
                    local context = host.idContent:GetContext()
                    local idx = context and context.question or 0
                    return idx < 10 and "enabled" or "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    host:NextQuestion()
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idFinish",
                  "ActionName",
                  T(426594514812, "Finish"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "RightTrigger",
                  "ActionState",
                  function(self, host)
                    local context = host and host.idContent:GetContext()
                    local idx = context and context.question or 0
                    return 10 <= idx and "enabled" or "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    host:OpenQuestion("outcome")
                  end
                })
              }),
              PlaceObj("XTemplateMode", {
                "mode",
                "test_result_stats"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return CreateImpTestResultContext()
                  end,
                  "__template",
                  "PDAImpResultMerc",
                  "HeaderButtonId",
                  "idProfile"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "perks",
                  "ActionId",
                  "idPerks",
                  "ActionName",
                  T(655064233565, "Next"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "ButtonY",
                  "ActionState",
                  function(self, host)
                    return GetDialog(self.host):CanAdvanceToMercPerks() and "enabled" or "disabled"
                  end,
                  "OnActionEffect",
                  "mode",
                  "OnActionParam",
                  "test_result_perks"
                })
              }),
              PlaceObj("XTemplateMode", {
                "mode",
                "test_result_perks"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return CreateImpTestResultContext()
                  end,
                  "__template",
                  "PDAImpResultMerc",
                  "HeaderButtonId",
                  "idProfile"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "stats",
                  "ActionId",
                  "idStats",
                  "ActionName",
                  T(549570728431, "Prev"),
                  "ActionToolbar",
                  "ActionBar",
                  "OnActionEffect",
                  "mode",
                  "OnActionParam",
                  "test_result_stats"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "done",
                  "ActionId",
                  "idDone",
                  "ActionName",
                  T(131832481511, "Done"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "ActionState",
                  function(self, host)
                    return GetDialog(self.host):CanFinishMercCreation() and "enabled" or "disabled"
                  end,
                  "OnActionEffect",
                  "mode",
                  "OnActionParam",
                  "final_confirm"
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "home"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpStartPage",
                  "HeaderButtonId",
                  "idHome"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idOK",
                  "ActionName",
                  T(175732041340, "OK"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Enter",
                  "ActionGamepad",
                  "Start",
                  "ActionState",
                  function(self, host)
                    if g_ImpTest and g_ImpTest.final and g_ImpTest.final.created then
                      return "hidden"
                    else
                      return "enabled"
                    end
                  end,
                  "OnActionEffect",
                  "mode",
                  "OnActionParam",
                  "login"
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "login"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpLogIn",
                  "HeaderButtonId",
                  "idLogIn"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idOK",
                  "ActionName",
                  T(175732041340, "OK"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Enter",
                  "ActionGamepad",
                  "Start",
                  "OnActionEffect",
                  "mode",
                  "OnActionParam",
                  "imp_confirm",
                  "OnAction",
                  function(self, host, source, ...)
                    local ctrl = host.idContent.idLogInInfo
                    local text = ctrl.idEditPswd:GetText()
                    local passCheck = string.lower(text) == string.lower(const.Imp.TestPswd)
                    local netCheck = not netInGame or NetIsHost()
                    if netCheck and passCheck then
                      host:SetMode("imp_confirm")
                      g_ImpTest.loggedin = true
                    else
                      local presets = not passCheck and Presets.IMPErrorPswdTexts.Default or Presets.IMPErrorNetClientTexts.Default
                      local count = #presets
                      local login_err_idx = (g_ImpTest.login_err_idx or 0) + 1
                      if count < login_err_idx then
                        login_err_idx = 1
                      end
                      g_ImpTest.login_err_idx = login_err_idx
                      ctrl.idError:SetText(presets[login_err_idx].text)
                      ctrl.idError:SetVisible(true)
                    end
                  end
                })
              }),
              PlaceObj("XTemplateMode", {
                "mode",
                "imp_confirm,imp_confirm_intro"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpConfirm",
                  "HeaderButtonId",
                  "idIntroduction"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idOK",
                  "ActionName",
                  T(655064233565, "Next"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "ActionState",
                  function(self, host)
                    return (host.impconfirm.next or host.impconfirm.skip) and "enabled" or "disabled"
                  end,
                  "OnActionParam",
                  "pet_intro",
                  "OnAction",
                  function(self, host, source, ...)
                    if host.impconfirm.next then
                      host:SetMode("pet_intro")
                    elseif host.impconfirm.skip then
                      g_ImpTest.confirmed = true
                      host:SetMode("test_result_stats")
                    end
                  end
                })
              }),
              PlaceObj("XTemplateMode", {
                "mode",
                "final_confirm"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpFinalConfirm",
                  "HeaderButtonId",
                  "idProfile"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "done",
                  "ActionId",
                  "idSelect",
                  "ActionName",
                  T(993621221616, "Select"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "ActionState",
                  function(self, host)
                    return (not (not (host.impconfirm.confirm and CanPay(const.Imp.CertificateCost)) or g_ImpTest.final.created) or host.impconfirm.back) and "enabled" or "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    if host.impconfirm.confirm and CanPay(const.Imp.CertificateCost) then
                      local merc_id = g_ImpTest.final.merc_template.id
                      g_ImpTest.final.created = true
                      g_ImpTest.loggedin = false
                      SetCustomFilteredUserTexts({
                        g_ImpTest.final.name,
                        g_ImpTest.final.nick
                      })
                      NetSyncEvent("HireIMPMerc", g_ImpTest, merc_id, const.Imp.CertificateCost)
                      OpenAIMAndSelectMerc()
                    elseif host.impconfirm.back then
                      host:SetMode("test_result_stats")
                    end
                  end
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "pet_intro"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpPETIntro",
                  "HeaderButtonId",
                  "idTest"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idTest",
                  "ActionName",
                  T(728933977679, "Test"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "OnAction",
                  function(self, host, source, ...)
                    host:StartTest()
                  end
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "outcome"}, {
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return CreateImpTestResultContext()
                  end,
                  "__template",
                  "PDAImpOutcome",
                  "HeaderButtonId",
                  "idTest"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "back",
                  "ActionId",
                  "idBack",
                  "ActionName",
                  T(351426544644, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "OnAction",
                  function(self, host, source, ...)
                    GetDialog(host):OpenQuestion(10)
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "confirm",
                  "ActionId",
                  "idConfirm",
                  "ActionName",
                  T(524975808890, "Confirm"),
                  "ActionToolbar",
                  "ActionBar",
                  "OnAction",
                  function(self, host, source, ...)
                    g_ImpTest.confirmed = true
                    host:SetMode("test_result_stats")
                  end
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "title_text"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpText",
                  "HeaderButtonId",
                  "idHome"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idBack",
                  "ActionName",
                  T(351426544644, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "OnActionEffect",
                  "back"
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "pswd_reset"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpPswdReset",
                  "HeaderButtonId",
                  "idLogIn"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idBack",
                  "ActionName",
                  T(351426544644, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "OnActionEffect",
                  "back"
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "gallery"}, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpGallery",
                  "HeaderButtonId",
                  "idHome"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idBack",
                  "ActionName",
                  T(467176861358, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "OnActionEffect",
                  "back"
                })
              }),
              PlaceObj("XTemplateMode", {
                "mode",
                "construction"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAImpErrorConstruction",
                  "HeaderButtonId",
                  "idHome"
                }),
                PlaceObj("XTemplateAction", {
                  "comment",
                  "ok",
                  "ActionId",
                  "idBack",
                  "ActionName",
                  T(971938007854, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionGamepad",
                  "Start",
                  "OnActionEffect",
                  "back"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return "action bar"
                end,
                "__class",
                "XToolBarList",
                "Id",
                "idActionBar",
                "ZOrder",
                3,
                "Dock",
                "bottom",
                "HAlign",
                "center",
                "VAlign",
                "bottom",
                "LayoutHSpacing",
                20,
                "DrawOnTop",
                true,
                "Background",
                RGBA(255, 255, 255, 0),
                "Toolbar",
                "ActionBar",
                "Show",
                "text",
                "ButtonTemplate",
                "PDACommonButtonIMP"
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return not InitialConflictNotStarted()
      end,
      "__template",
      "PDAStartButton",
      "Dock",
      "box",
      "VAlign",
      "bottom",
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
    PlaceObj("XTemplateTemplate", {
      "__template",
      "PDABrowserBanners"
    })
  })
})
