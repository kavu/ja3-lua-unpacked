PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDAMercArriveSectorPick",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idMain",
    "Background",
    RGBA(30, 30, 35, 115),
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      742,
      "MinHeight",
      370,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      -7
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "header",
        "Dock",
        "top",
        "MinHeight",
        24,
        "MaxHeight",
        24
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(5, 5, 5, 5),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "VAlign",
          "center",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAQuests_HeaderSmall",
          "Translate",
          true,
          "Text",
          T(126059744065, "MERCS HIRED"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "content",
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, -3, 0, 0),
          "Dock",
          "box",
          "Image",
          "UI/PDA/Event/T_Event_Background",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "Padding",
          box(10, 10, 10, 10)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "image on right",
            "Margins",
            box(10, 0, 0, 0),
            "Dock",
            "right"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idSelectedSectorImage",
              "VAlign",
              "top",
              "Image",
              "UI/PDA/ss_b2"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "left content",
            "Dock",
            "left"
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 2, 0, 0),
              "Dock",
              "top"
            }, {
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
                "comment",
                "merc list",
                "Padding",
                box(15, 5, 15, 10),
                "MinWidth",
                400,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "LayoutVSpacing",
                5
              }, {
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return context.mercs
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "HUDMerc",
                    "HAlign",
                    "center"
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idText",
                "Padding",
                box(15, 5, 15, 10),
                "Dock",
                "bottom",
                "TextStyle",
                "PDARolloverText",
                "Translate",
                true,
                "Text",
                T(343415410397, "The new hires will arrive in <newline><em>Grand Chien</em> in <MercArrivalTimeHours()> hours. <newline>Choose a landing spot:<newline>")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XList",
              "Id",
              "idList",
              "IdNode",
              false,
              "Margins",
              box(0, 10, 0, 0),
              "BorderWidth",
              0,
              "Dock",
              "top",
              "LayoutVSpacing",
              5,
              "Background",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "LeftThumbScroll",
              false,
              "SetFocusOnOpen",
              true
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.sectors
                end,
                "__context",
                function(parent, context, item, i, n)
                  return gv_Sectors[item]
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local sectorId = context.Id
                  local sector = gv_Sectors[sectorId]
                  local color, _, _, textColor = GetSectorControlColor(sector.Side)
                  local text = textColor .. sectorId .. "</color>"
                  child.idSectorId:SetText(T({
                    764093693143,
                    "<SectorIdColored(id)>",
                    id = sectorId
                  }))
                  child.idSectorSquare:SetBackground(color)
                  child:SetText(sector.display_name or "")
                  child.idIcon:SetVisible(false)
                  child.idIcon:SetFoldWhenHidden(true)
                  if i == 1 then
                    child:OnSetRollover(true)
                  end
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDACommonButton",
                  "Padding",
                  box(0, 0, 8, 0),
                  "LayoutMethod",
                  "HList",
                  "LayoutHSpacing",
                  0,
                  "OnPress",
                  function(self, gamepad)
                    local sectorId = self.context.Id
                    local node = self:ResolveId("node")
                    for i, m in ipairs(node.context.mercs) do
                      if m.Operation == "Arriving" then
                        NetSyncEvent("SetArrivingMercSector", m.session_id, sectorId)
                      end
                    end
                    local dlg = GetDialog(self)
                    dlg:Close()
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XSquareWindow",
                    "Id",
                    "idSectorSquare",
                    "Margins",
                    box(0, 0, 5, 6),
                    "HAlign",
                    "left",
                    "VAlign",
                    "center",
                    "MinWidth",
                    25,
                    "MaxWidth",
                    30
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idSectorId",
                      "Margins",
                      box(2, 0, 0, 0),
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "Clip",
                      false,
                      "TextStyle",
                      "PDASatelliteRollover_SectorTitle",
                      "Translate",
                      true,
                      "TextHAlign",
                      "center",
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnSetRollover(self, rollover)",
                    "func",
                    function(self, rollover)
                      if not rollover then
                        return
                      end
                      local sectorId = self.context.Id
                      local node = self:ResolveId("node")
                      local sectorIdLower = string.lower(sectorId)
                      local image = "UI/PDA/ss_" .. sectorIdLower
                      node.idSelectedSectorImage:SetImage(image or "UI/PDA/ss_i1")
                    end
                  }),
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
                      self:SetFocus(selected)
                      self:SetImage(selected and "UI/PDA/os_system_buttons_yellow" or "UI/PDA/os_system_buttons")
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "controller selection",
              "__context",
              function(parent, context)
                return "GamepadUIStyleChanged"
              end,
              "__class",
              "XContextWindow",
              "Visible",
              false,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local popup = self:ResolveId("node")
                local list = popup.idList
                if GetUIStyleGamepad() then
                  list:SetInitialSelection(1)
                else
                  list:SetSelection(false)
                end
              end
            })
          })
        })
      })
    })
  })
})
