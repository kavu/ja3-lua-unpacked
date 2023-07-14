PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "ZuluJoinGamePopup",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idMain",
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      500,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(2, 2, 2, 2)
      }),
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "top",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(18, 5, 0, 0),
          "HAlign",
          "left",
          "MinHeight",
          30,
          "TextStyle",
          "PDARolloverHeader",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 8, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "MinWidth",
          22,
          "MinHeight",
          22,
          "MaxWidth",
          22,
          "MaxHeight",
          22,
          "Background",
          RGBA(78, 82, 91, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 0, 8, 0),
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(8, 8, 8, 8),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "MaxWidth",
            500,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 10, 8, 0),
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(8, 8, 8, 8),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextEditor",
            "Id",
            "idCodeInput",
            "Margins",
            box(0, 5, 0, 0),
            "BorderWidth",
            0,
            "Padding",
            box(0, 0, 0, 0),
            "MinHeight",
            25,
            "Background",
            RGBA(32, 35, 47, 255),
            "FocusedBorderColor",
            RGBA(32, 35, 47, 255),
            "FocusedBackground",
            RGBA(32, 35, 47, 255),
            "TextStyle",
            "TextInputHint",
            "OnTextChanged",
            function(self)
              if string.len(self:GetText()) > 50 then
                return
              end
            end,
            "Multiline",
            false,
            "ConsoleKeyboardDescription",
            T(131295207467, "Enter Game Code"),
            "MaxVisibleLines",
            1,
            "MaxLines",
            1,
            "MaxLen",
            50,
            "AutoSelectAll",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnKillFocus",
              "func",
              function(self, ...)
                XTextEditor.OnKillFocus(self)
                PlayFX("MainMenuButtonClick", "start")
                self:SetTextStyle("PDABrowserTitleSmall")
                if not self:GetText() or self:GetText() == "" then
                  self.hasBeenEdited = false
                  self:SetText(_InternalTranslate(T(953468056938, "TYPE CODE")))
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "EditOperation(self, insert_text, op_type, setcursor_charidx, keep_selection)",
              "func",
              function(self, insert_text, op_type, setcursor_charidx, keep_selection)
                if op_type == "paste" then
                  self:SetText("")
                end
                XTextEditor.EditOperation(self, insert_text, op_type, setcursor_charidx, keep_selection)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetFocus(self)",
              "func",
              function(self)
                XTextEditor.OnSetFocus(self)
                PlayFX("MainMenuButtonClick", "start")
                self:SetTextStyle("CombatTask_Progress")
                if not self.hasBeenEdited then
                  self.hasBeenEdited = true
                  self:SetText("")
                else
                  self:SetCursor(#self.lines, utf8.len(self.lines[#self.lines]))
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "Open",
              "func",
              function(self, ...)
                XTextEditor.Open(self, ...)
                self.hasBeenEdited = false
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBarList",
        "Id",
        "idActionBar",
        "Margins",
        box(0, 8, 0, 8),
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "MinHeight",
        35,
        "MaxHeight",
        35,
        "OnLayoutComplete",
        function(self)
          for _, button in ipairs(self.list) do
            button:SetMouseCursor("UI/Cursors/Hand.tga")
          end
          local width = MulDivRound(self.measure_width, 1000, self.scale:x())
          local textField = self:ResolveId("idText")
          if width > textField.MaxWidth then
            self:ResolveId("idText"):SetMaxWidth(MulDivRound(self.measure_width, 1000, self.scale:x()))
          end
        end,
        "LayoutHSpacing",
        30,
        "LayoutVSpacing",
        10,
        "Background",
        RGBA(255, 255, 255, 0),
        "Toolbar",
        "ActionBar",
        "ButtonTemplate",
        "PDACommonButton"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        ZuluModalDialog.Open(self, ...)
        self.idTitle:SetText(T(863543712370, "Join Game"))
        self.idText:SetText(T(784424071157, "You can use a join code to join a private or public game. The code can be found in the game setup or via the Multiplayer button in the game menu while playing."))
        self.idCodeInput:SetText(_InternalTranslate(T(953468056938, "TYPE CODE")))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        ZuluModalDialog.OnDelete(self)
        local mm = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
        if mm and GetUIStyleGamepad() then
          local list = mm:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
          local currSelIdx = list:GetSelection() and list:GetSelection()[1] or -1
          if list:GetFirstValidItemIdx() ~= currSelIdx then
            list:SelectFirstValidItem()
          end
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idOk",
      "ActionName",
      T(978248601619, "Ok"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Enter",
      "ActionGamepad",
      "ButtonA",
      "OnAction",
      function(self, host, source, ...)
        UIJoinGameByJoinCode(self.host.idCodeInput:GetText())
        self.host:Close()
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idPaste",
      "ActionName",
      T(667549065522, "Paste"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "P",
      "ActionGamepad",
      "ButtonX",
      "OnAction",
      function(self, host, source, ...)
        local pasteT = GetFromClipboard()
        if pasteT and pasteT ~= "" and string.len(pasteT) <= 50 then
          self.host.idCodeInput:SetText("")
          self.host.idCodeInput:SetText(pasteT)
          self.host.idCodeInput.hasBeenEdited = true
        end
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idEnterText",
      "ActionName",
      T(364019189126, "Type Code"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Y",
      "ActionGamepad",
      "ButtonY",
      "OnAction",
      function(self, host, source, ...)
        if GetUIStyleGamepad() then
          if not self.host.idCodeInput.hasBeenEdited then
            self.host.idCodeInput:SetText("")
            self.host.idCodeInput.hasBeenEdited = true
          end
          self.host.idCodeInput:OpenControllerTextInput()
        end
      end,
      "FXPress",
      "MainMenuButtonClick",
      "__condition",
      function(parent, context)
        return GetUIStyleGamepad()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idCancel",
      "ActionName",
      T(876832343501, "Cancel"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        self.host:Close()
      end,
      "FXPress",
      "MainMenuButtonClick"
    })
  })
})
