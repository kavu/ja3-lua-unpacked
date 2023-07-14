PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "PDASquadCreation",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idSquadCreation",
    "Background",
    RGBA(30, 30, 35, 115),
    "GamepadVirtualCursor",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        ZuluModalDialog.Open(self, ...)
        local context = self:GetContext()
        self:SetSelectedLogo(context.image)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      600,
      "MinHeight",
      480,
      "MaxWidth",
      600,
      "MaxHeight",
      480
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
        box(5, 5, 5, 5),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idHeaderText",
          "Margins",
          box(8, 0, 0, 0),
          "VAlign",
          "center",
          "TextStyle",
          "UIDlgTitle",
          "Translate",
          true,
          "Text",
          T(302893776540, "SQUAD LOGO & NAME")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Margins",
        box(0, -2, 0, 0),
        "Padding",
        box(12, 12, 12, 12),
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow"
        }, {
          PlaceObj("XTemplateWindow", {
            "Dock",
            "top",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "IdNode",
              false,
              "Dock",
              "box",
              "MinHeight",
              32,
              "MaxHeight",
              32,
              "Image",
              "UI/PDA/os_background_2",
              "FrameBox",
              box(5, 5, 5, 5)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadName",
                "Padding",
                box(16, 1, 2, 1),
                "Dock",
                "box",
                "VAlign",
                "center",
                "BorderColor",
                RGBA(128, 128, 128, 0),
                "Background",
                RGBA(240, 240, 240, 0),
                "HandleKeyboard",
                false,
                "HandleMouse",
                false,
                "FocusedBorderColor",
                RGBA(0, 0, 0, 0),
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "TextStyle",
                "PDA_SquadNameBig",
                "OnContextUpdate",
                function(self, context, ...)
                  if self.text == "" then
                    local text = context.Name
                    self:SetText(text)
                  end
                end,
                "Translate",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Margins",
            box(0, 12, 0, 0),
            "Padding",
            box(16, 16, 16, 16),
            "Dock",
            "box",
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(5, 5, 5, 5)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "Id",
              "idLogos",
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
                  return g_SquadLogos
                end,
                "item_in_context",
                "logoImagePath",
                "run_after",
                function(child, context, item, i, n, last)
                  child:ResolveId("idLogoImage"):SetImage(item)
                  local dlg = GetDialog(child)
                  local bckg = child:ResolveId("idLogoBackground")
                  local img = child:ResolveId("idLogoImage")
                  if dlg.SelectedLogo == item then
                    bckg:SetBorderWidth(3)
                    img:SetImageColor(GameColors.F)
                  else
                    bckg:SetBorderWidth(0)
                    img:SetImageColor(GameColors.D)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XButton",
                  "OnPress",
                  function(self, gamepad)
                    local context = self:GetContext()
                    local dlg = GetDialog(self)
                    dlg:SetSelectedLogo(context.logoImagePath)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "Id",
                    "idLogoBackground",
                    "MinWidth",
                    84,
                    "MinHeight",
                    96,
                    "MaxWidth",
                    84,
                    "MaxHeight",
                    96,
                    "BorderColor",
                    RGBA(195, 189, 172, 255),
                    "Background",
                    RGBA(32, 35, 47, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextImage",
                      "Id",
                      "idLogoImage",
                      "ImageColor",
                      RGBA(130, 128, 120, 255)
                    })
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetRollover(self, rollover)",
                    "func",
                    function(self, rollover)
                      local dlg = GetDialog(self)
                      local context = self:GetContext()
                      local bckg = self:ResolveId("idLogoBackground")
                      local img = self:ResolveId("idLogoImage")
                      if rollover then
                        bckg:SetBackground(GameColors.L)
                        img:SetImageColor(GameColors.A)
                      else
                        bckg:SetBackground(GameColors.B)
                        img:SetImageColor(context.logoImagePath == dlg.SelectedLogo and GameColors.F or GameColors.D)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDoubleClick(self, pt, button)",
                    "func",
                    function(self, pt, button)
                      InvokeShortcutAction(self, "idClose", GetActionsHost(self, true))
                    end
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 12, 0, 0),
          "Dock",
          "bottom"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XToolBarList",
            "Id",
            "idToolBar",
            "Dock",
            "right",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "LayoutHSpacing",
            20,
            "Background",
            RGBA(255, 255, 255, 0),
            "Toolbar",
            "ActionBar",
            "Show",
            "text",
            "ButtonTemplate",
            "PDACommonButton"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idClose",
              "ActionName",
              T(217933113825, "Close"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "close",
              "OnAction",
              function(self, host, source, ...)
                ObjModified(host:GetContext())
                local effect = self.OnActionEffect
                local param = self.OnActionParam
                if effect == "close" and host and host.window_state ~= "destroying" then
                  host:Close(param ~= "" and param or nil)
                elseif effect == "mode" and host then
                  host:SetMode(param)
                elseif effect == "back" and host then
                  SetBackDialogMode(host)
                else
                  if effect == "popup" then
                    local actions_view = GetParentOfKind(source, "XActionsView")
                    if actions_view then
                      actions_view:PopupAction(self.ActionId, host, source)
                    else
                      XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
                    end
                  else
                  end
                end
              end
            })
          })
        })
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "SelectedLogo",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.SelectedLogo = value
      self:ResolveValue("idLogos"):RespawnContent()
      local squad = self:GetContext()
      NetSyncEvent("SetSquadLogo", squad.UniqueId, value)
    end,
    "Get",
    function(self)
      return self.SelectedLogo
    end
  })
})
