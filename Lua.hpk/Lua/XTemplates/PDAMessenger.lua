PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMessenger",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAMessengerClass",
    "Dock",
    "box",
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionClose",
      "ActionName",
      T(352357046851, "Close"),
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        if IsValidThread(host:GetThread("conversation_thread")) and not host.idClose.enabled then
          return "break"
        end
        if not host.ChildrenHandleMouse then
          return "break"
        end
        if host:GetThread("wait_close") then
          return "break"
        end
        host:CreateThread("wait_close", function()
          host:DeleteThread("idle_wait")
          host:ForcePlayChat("PlayerTerminates")
          Sleep(400)
          if host.pendingActionOnClose then
            host.pendingActionOnClose()
          end
          host:Close()
        end)
        return "break"
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionAdvance",
      "ActionTranslate",
      false,
      "ActionName",
      "Advance (Unused)",
      "ActionState",
      function(self, host)
        return host.canAdvance and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        host:AdvanceConversation()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionOffer",
      "ActionTranslate",
      false,
      "ActionName",
      "Advance",
      "ActionGamepad",
      "ButtonA",
      "ActionState",
      function(self, host)
        if not host.context.MessengerOnline then
          return "disabled"
        end
        local ending_node = MercChatIsEndingNode(host.conversation_type)
        return not (host.conversation_ended or ending_node) and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        host:AdvanceConversation("offer-confirm")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "gamepadMoveDurationRight",
      "ActionGamepad",
      "DPadRight",
      "OnAction",
      function(self, host, source, ...)
        local durInput = host.idDurationInput
        durInput = durInput and durInput.enabled and durInput.idSlider
        if durInput then
          durInput:ScrollTo(durInput.Scroll + 1, 0)
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "gamepadMoveDurationLeft",
      "ActionGamepad",
      "DPadLeft",
      "OnAction",
      function(self, host, source, ...)
        local durInput = host.idDurationInput
        durInput = durInput and durInput.enabled and durInput.idSlider
        if durInput then
          durInput:ScrollTo(durInput.Scroll - 1, 0)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown",
      "func",
      function(self, ...)
        if self.anyKeyClose and self.window_state ~= "destroying" and self.window_state ~= "closing" then
          self:Close()
        end
        return ZuluModalDialog.OnMouseButtonDown(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKbdKeyDown(self, key)",
      "func",
      function(self, key)
        if key == const.vkC and Platform.developer then
          DebugShowMercLineCheatMenu(self.context.session_id)
        end
        if self.anyKeyClose and self.window_state ~= "destroying" and self.window_state ~= "closing" then
          self:Close()
        end
        return ZuluModalDialog.OnKbdKeyDown(self, key)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnXButtonDown(self, ...)",
      "func",
      function(self, ...)
        if self.anyKeyClose and self.window_state ~= "destroying" and self.window_state ~= "closing" then
          self:Close()
        end
        return ZuluModalDialog.OnXButtonDown(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        local pdaDialog = GetDialog("PDADialog")
        if not pdaDialog then
          return
        end
        local host = pdaDialog.idContent and GetActionsHost(pdaDialog.idContent, true) or pdaDialog
        if not host then
          return
        end
        host:ActionsUpdated()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      910,
      "MinHeight",
      595,
      "MaxWidth",
      910,
      "MaxHeight",
      590,
      "Image",
      "UI/PDA/Chat/T_Call_Background",
      "FrameBox",
      box(2, 2, 2, 2)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "header",
        "Dock",
        "top",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        5,
        "Background",
        RGBA(65, 130, 158, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "HAlign",
          "left",
          "VAlign",
          "top",
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(2, 2, 2, 2)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Margins",
            box(4, 4, 4, 4),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            32,
            "MinHeight",
            32,
            "MaxWidth",
            32,
            "MaxHeight",
            32,
            "Image",
            "UI/PDA/snype_logo",
            "ImageFit",
            "stretch",
            "ImageColor",
            RGBA(91, 142, 169, 255)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "VAlign",
          "center",
          "TextStyle",
          "PDAMessengerHeader",
          "Translate",
          true,
          "Text",
          T(255085547679, "snype"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idOtherPlayerText",
          "Margins",
          box(30, 0, 0, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDAMessengerOtherPlayer",
          "Translate",
          true,
          "Text",
          T(341907478094, "Controlled by <OtherPlayerName()>")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idXButton",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "BorderColor",
          RGBA(0, 0, 0, 0),
          "Background",
          RGBA(0, 0, 0, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga",
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "OnPressEffect",
          "action",
          "OnPressParam",
          "actionClose",
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0),
          "TextStyle",
          "PDACommonButtonChatXButton",
          "Text",
          "X"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 8, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "TextStyle",
          "PDACommonButton",
          "Translate",
          true,
          "Text",
          T(888523083513, "<color 249 249 219>v3.02c</color>")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "footer (this needs to be first to be considered for the box)",
        "Margins",
        box(10, 10, 10, 10),
        "Dock",
        "bottom",
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/Chat/line_frame",
          "FrameBox",
          box(3, 3, 3, 3),
          "TransparentCenter",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 5, 0, 4),
          "Dock",
          "box",
          "MinHeight",
          75
        }, {
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context.HireStatus == "Hired"
              end,
              "__class",
              "XText",
              "Padding",
              box(6, 0, 0, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "PDAMercPrice_Hired",
              "Translate",
              true,
              "TextVAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return parent:ResolveId("node")
            end,
            "__class",
            "XContextWindow",
            "Margins",
            box(0, 0, 3, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "Id",
              "idDurationInput",
              "IdNode",
              true,
              "Margins",
              box(15, 0, 15, 0),
              "MinWidth",
              320,
              "FoldWhenHidden",
              true,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local msger = context
                local slider = self.idSlider
                local val = msger.conversation_context.ContractDuration
                if not val then
                  return
                end
                local min = msger.conversation_context.MinDuration
                local max = msger.conversation_context.MaxDuration
                slider:SetMin(min)
                slider:SetMax(max)
                slider:SetScroll(val)
                XContextControl.OnContextUpdate(self, context)
                local moneyAtBeginningOfConv = rawget(self, "money-at-msger-open")
                local canAfford = msger:CanAffordMerc(moneyAtBeginningOfConv)
                self.idLabel:SetText(canAfford and T(970750149040, "Contract Duration") or T(360958515185, "<red>Insufficient funds to hire merc.</red>"))
                self.idLabel:SetTransparency(canAfford and 125 or 0)
              end
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "SetEnabled(self, enabled)",
                "func",
                function(self, enabled)
                  self.idLabel:SetEnabled(enabled)
                  self.idSlider:SetEnabled(enabled)
                  self.idValue:SetEnabled(enabled)
                  self.enabled = enabled
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  rawset(self, "money-at-msger-open", Game.Money)
                  XContextWindow.Open(self)
                end
              }),
              PlaceObj("XTemplateWindow", {
                "Dock",
                "left",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idLabel",
                  "Transparency",
                  125,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "PDACommonButton",
                  "Translate",
                  true,
                  "Text",
                  T(841161275332, "Contract Duration")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "SliderMessenger",
                  "Id",
                  "idSlider",
                  "Margins",
                  box(0, 0, 15, 0),
                  "HAlign",
                  "left",
                  "VAlign",
                  "center",
                  "Target",
                  "node",
                  "Max",
                  10
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
                    box(0, 0, 0, -30),
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
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
                    T(701938343272, "<DPadLeft><DPadRight>")
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idValue",
                "Dock",
                "right",
                "VAlign",
                "center",
                "HandleMouse",
                false,
                "TextStyle",
                "PDACommonButton",
                "OnContextUpdate",
                function(self, context, ...)
                  local msger = context
                  local duration = msger.conversation_context.ContractDuration
                  self:SetText(T({
                    404056356754,
                    "<duration> Days: <HireLengthPrice()>",
                    duration = duration
                  }))
                  XContextControl.OnContextUpdate(self, context)
                end,
                "Translate",
                true
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnScrollTo(self, value)",
                "func",
                function(self, value)
                  local msger = self.context
                  local val = msger.conversation_context.ContractDuration
                  local min = msger.conversation_context.MinDuration
                  local max = msger.conversation_context.MaxDuration
                  msger.conversation_context.ContractDuration = Clamp(value, min, max)
                  Msg("MercChatAnyInput")
                  ObjModified(msger)
                  local messenger = self:ResolveId("node")
                  local inControl = messenger and messenger.controlling_player
                  if inControl then
                    NetEvent("CoOpHireDurationVisualUpdate", value)
                  end
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "ScrollTo(self, x, y)",
                "func",
                function(self, x, y)
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Dock",
            "right",
            "HAlign",
            "right",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Id",
              "idAdvanceSep",
              "Margins",
              box(0, -5, 0, -5),
              "HAlign",
              "left",
              "Image",
              "UI/PDA/Chat/T_Call_Line_Vertical",
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return parent:ResolveId("node")
              end,
              "__class",
              "XTextButton",
              "Id",
              "idAdvance",
              "Margins",
              box(5, 0, 5, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              120,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              5,
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "OnContextUpdate",
              function(self, context, ...)
                local canAfford = context:CanAffordMerc()
                local action = self.action
                self:SetEnabled(canAfford and action:ActionState(GetDialog(self)) == "enabled")
                self:SetText(self.Text)
                XContextControl.OnContextUpdate(self, context)
              end,
              "Enabled",
              false,
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "OnPressEffect",
              "action",
              "OnPressParam",
              "actionOffer",
              "RolloverBackground",
              RGBA(255, 255, 255, 0),
              "PressedBackground",
              RGBA(255, 255, 255, 0),
              "Icon",
              "UI/PDA/Chat/T_Call_Offer",
              "TextStyle",
              "PDACommonButtonChat",
              "Translate",
              true,
              "Text",
              T(936753275494, "Offer")
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "SetVisible(self, visible)",
                "func",
                function(self, visible)
                  XTextButton.SetVisible(self, visible)
                  local node = self:ResolveId("node")
                  node.idAdvanceSep:SetVisible(visible)
                end
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "gamepad hint",
                "__context",
                function(parent, context)
                  return "GamepadUIStyleChanged"
                end,
                "__parent",
                function(parent, context)
                  return parent.idIcon
                end,
                "__class",
                "XText",
                "Margins",
                box(0, 0, -5, -5),
                "HAlign",
                "right",
                "VAlign",
                "bottom",
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
                T(733307953991, "<ButtonASmall>")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(0, -5, 0, -5),
              "HAlign",
              "left",
              "Image",
              "UI/PDA/Chat/T_Call_Line_Vertical",
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idClose",
              "Margins",
              box(5, 0, 5, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              120,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              5,
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "OnPressEffect",
              "action",
              "OnPressParam",
              "actionClose",
              "RolloverBackground",
              RGBA(255, 255, 255, 0),
              "PressedBackground",
              RGBA(255, 255, 255, 0),
              "Icon",
              "UI/PDA/Chat/T_Call_Hang_Up",
              "TextStyle",
              "PDACommonButtonChat",
              "Translate",
              true,
              "Text",
              T(353688964417, "Close")
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "gamepad hint",
                "__context",
                function(parent, context)
                  return "GamepadUIStyleChanged"
                end,
                "__parent",
                function(parent, context)
                  return parent.idIcon
                end,
                "__class",
                "XText",
                "Margins",
                box(0, 0, -5, -5),
                "HAlign",
                "right",
                "VAlign",
                "bottom",
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
                T(339334409687, "<ButtonBSmall>")
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(10, 10, 10, 0),
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 8, 0),
          "Dock",
          "left",
          "MinWidth",
          170,
          "MaxWidth",
          170,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
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
            "MinWidth",
            175,
            "MinHeight",
            200,
            "MaxWidth",
            175,
            "MaxHeight",
            200,
            "Image",
            "UI/PDA/os_background_2"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextImage",
              "Dock",
              "box",
              "Clip",
              "self",
              "Image",
              "UI/Hud/portrait_background",
              "ImageFit",
              "stretch"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idPortrait",
                "Dock",
                "box",
                "Image",
                "UI/MercsPortraits/unknown",
                "ImageFit",
                "height",
                "ImageRect",
                box(36, 0, 264, 246)
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  if self.context and self.context.Portrait then
                    self.idPortrait:SetImage(self.context.Portrait)
                  end
                  XContextImage.Open(self)
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "fluff beneath pic",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Dock",
              "box",
              "Image",
              "UI/PDA/Chat/T_Call_Name",
              "FrameBox",
              box(3, 3, 3, 3)
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "merc name",
              "__class",
              "XText",
              "Margins",
              box(5, 0, 0, 0),
              "VAlign",
              "center",
              "TextStyle",
              "PDAMercChatName",
              "Translate",
              true,
              "Text",
              T(436437814010, "<Nick>"),
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "Dock",
              "right",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Padding",
                box(3, 3, 3, 3),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                32,
                "MinHeight",
                32,
                "MaxWidth",
                32,
                "MaxHeight",
                32,
                "Image",
                "UI/PDA/os_system_buttons",
                "FrameBox",
                box(3, 3, 3, 3),
                "Columns",
                3,
                "Column",
                3
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "Image",
                  "UI/PDA/Chat/T_Call_Icon_Call"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Padding",
                box(5, 5, 5, 5),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                32,
                "MinHeight",
                32,
                "MaxWidth",
                32,
                "MaxHeight",
                32,
                "Image",
                "UI/PDA/os_system_buttons",
                "FrameBox",
                box(3, 3, 3, 3),
                "Columns",
                3
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "Transparency",
                  125,
                  "Image",
                  "UI/PDA/Chat/T_Call_Icon_Video",
                  "Desaturation",
                  255
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "email",
            "LayoutMethod",
            "HList",
            "ChildrenHandleMouse",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "IdNode",
              false,
              "Dock",
              "box",
              "Image",
              "UI/PDA/Chat/line_frame",
              "FrameBox",
              box(3, 3, 3, 3)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(3, 3, 3, 3),
                "HAlign",
                "center",
                "VAlign",
                "center",
                "Enabled",
                false,
                "TextStyle",
                "PDAMercChatEmail",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  if context.snype_nick then
                    self:SetText(context.snype_nick)
                  else
                    self:SetText(T(617146193207, "<Nick>"))
                  end
                  XContextControl.OnContextUpdate(self, context)
                end,
                "Translate",
                true,
                "TextVAlign",
                "center"
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Dock",
            "bottom",
            "HandleKeyboard",
            false,
            "HandleMouse",
            true,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "Image",
            "UI/PDA/Chat/T_Call_Ad_01",
            "ImageFit",
            "smallest"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open",
              "func",
              function(self, ...)
                self.ad = GetRandomMessengerAdBanner()
                self:SetImage(self.ad.Image)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                local host = GetActionsHost(self, true)
                if host then
                  local closeAction = host:ActionById("actionClose")
                  if closeAction then
                    host:OnAction(closeAction, self)
                    function host.pendingActionOnClose()
                      GetPDABrowserDialog():SetMode(self.ad.mode, self.ad.mode_param)
                    end
                  end
                end
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
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
            "__class",
            "MessengerScrollbar",
            "Id",
            "idScroll",
            "Margins",
            box(5, 0, 0, 0),
            "Dock",
            "right",
            "UseClipBox",
            false,
            "Target",
            "idChat"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "PDAMessengerChatLog",
            "Id",
            "idChat",
            "Padding",
            box(10, 2, 10, 5),
            "Dock",
            "box",
            "LayoutMethod",
            "VList",
            "VScroll",
            "idScroll"
          })
        })
      })
    })
  })
})
