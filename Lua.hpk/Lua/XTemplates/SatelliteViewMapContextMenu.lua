PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu ContextMenu",
  id = "SatelliteViewMapContextMenu",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return context
    end,
    "__class",
    "ZuluContextMenu",
    "Id",
    "idContextMenu",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    220,
    "LayoutMethod",
    "Box",
    "AnchorType",
    "right"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idContent",
      "IdNode",
      true,
      "VAlign",
      "top",
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "actions",
        "__context",
        function(parent, context)
          return context and context.actions
        end,
        "__condition",
        function(parent, context)
          return context
        end,
        "__class",
        "XContentTemplateList",
        "BorderWidth",
        0,
        "Padding",
        box(0, 4, 0, 4),
        "LayoutVSpacing",
        2,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(255, 255, 255, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0),
        "HandleMouse",
        false,
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "KeepSelectionOnRespawn",
        true
      }, {
        PlaceObj("XTemplateForEach", {
          "run_after",
          function(child, context, item, i, n, last)
            if type(item) ~= "string" then
              child:SetPadding(box(12, 0, 10, 0))
              child:SetText(item.category)
              child:SetTextStyle("PDASectorInfo_Green")
              child:SetHandleMouse(false)
              child:SetBackground(GameColors.A)
              child.header = true
              return
            end
            local action = XShortcutsTarget:ActionById(item)
            child.action = action
            local actionBindingFrom = false
            if item == "idPerks" or item == "actionOpenCharacterContextMenu" then
              actionBindingFrom = "actionOpenCharacter"
            elseif item == "actionLevelUpViewContextMenu" then
              actionBindingFrom = "actionLevelUpView"
            else
              actionBindingFrom = item
            end
            local actionBinding = XShortcutsTarget:ActionById(actionBindingFrom)
            local shortcut = actionBinding.ActionShortcut
            if 0 < #(shortcut or "") then
              shortcut = T({
                137236581706,
                "[<u(key)>] ",
                key = shortcut
              })
            else
              shortcut = ""
            end
            child.idBinding:SetText(shortcut)
            local actionName = action.ActionName
            if item == "actionToggleSatellite" then
              actionName = T(119774168141, "Tactical View")
            end
            child:SetText(actionName)
            local host = GetActionsHost(child, true)
            local actionState = action:ActionState(host)
            action:ActionState(host)
            child:SetVisible(actionState ~= "hidden")
            child:SetEnabled(actionState == "enabled")
            child:SetId(action.ActionId)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "OnPress",
            function(self, gamepad)
              if self.action then
                local host = GetActionsHost(self, true)
                if host then
                  host:OnAction(self.action, self)
                  local cabinet = GetSatelliteDialog()
                  if cabinet then
                    cabinet:RemoveContextMenu()
                  end
                end
              end
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetSatelliteSquadsForContextMenu(parent.parent.parent.context.sector_id)
          end,
          "condition",
          function(parent, context, item, i)
            return not parent.parent.parent.context.unit_id
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            if g_SatelliteUI and g_SatelliteUI.selected_squad == item then
              child:SetEnabled(false)
            end
            child:SetText(T({
              843876025913,
              "Select <SquadName>",
              SquadName = Untranslated(item.Name)
            }))
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "OnPress",
            function(self, gamepad)
              local cabinet = g_SatelliteUI
              if cabinet then
                cabinet:SelectSquad(self.context)
                cabinet:RemoveContextMenu()
              end
            end
          })
        }),
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            local anyVisible = false
            for i, p in ipairs(parent) do
              if p:IsVisible() then
                anyVisible = true
                break
              end
            end
            parent:SetVisible(anyVisible)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "title",
        "Dock",
        "top",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idImage",
          "Dock",
          "top",
          "MinWidth",
          220,
          "MaxWidth",
          220,
          "ImageFit",
          "width"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "control and weather",
          "Dock",
          "bottom"
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idSectorSquare",
            "Margins",
            box(0, 0, 5, 0),
            "Dock",
            "left",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            28,
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idSectorId",
              "Margins",
              box(0, 0, -2, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Clip",
              false,
              "UseClipBox",
              false,
              "TextStyle",
              "PDASatelliteRollover_SectorName",
              "Translate",
              true,
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "weather",
            "__condition",
            function(parent, context)
              return true
            end,
            "Dock",
            "right",
            "HAlign",
            "left",
            "ScaleModifier",
            point(500, 500),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            2
          }, {
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return GetEnvironmentEffects(context.sector_id)
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetImage(context.Icon)
                child:SetRolloverText(context.description)
                child:SetRolloverTitle(context.display_name)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "RolloverTemplate",
                "RolloverGeneric",
                "RolloverAnchor",
                "center-top",
                "RolloverOffset",
                box(10, 10, 10, 10),
                "HandleMouse",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTitle",
            "Margins",
            box(0, 2, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "HandleMouse",
            false,
            "TextStyle",
            "PDASectorInfo_Green",
            "Translate",
            true,
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "RolloverTemplate",
          "RolloverGeneric",
          "RolloverAnchor",
          "center-top",
          "RolloverOffset",
          box(10, 10, 10, 10),
          "Id",
          "idIntel",
          "Dock",
          "bottom",
          "LayoutMethod",
          "HList",
          "FoldWhenHidden",
          true,
          "HandleMouse",
          true,
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idtxtIntel",
            "Margins",
            box(5, 0, 5, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_SectionItem",
            "Translate",
            true,
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "city",
          "Dock",
          "bottom"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "loyalty",
            "__class",
            "XNameValueText",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverAnchor",
            "center-top",
            "RolloverText",
            T(952592503809, "Local Loyalty will affect Operation and service costs in the current Sector."),
            "RolloverOffset",
            box(10, 10, 10, 10),
            "RolloverTitle",
            T(836506718468, "Loyalty"),
            "Id",
            "idLoyalty",
            "Margins",
            box(5, 0, 5, 0),
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_Green",
            "TextStyleRight",
            "PDASectorInfo_ValueLight"
          })
        })
      }),
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          local sector = false
          local unit_id
          if IsKindOf(context, "Context") then
            sector = ResolvePropObj(context)
          else
            sector = gv_Sectors[context.sector_id]
            unit_id = context.unit_id
          end
          if not sector then
            return
          end
          parent.idSectorId:SetText(T({
            764093693143,
            "<SectorIdColored(id)>",
            id = sector.Id
          }))
          local color = GetSectorControlColor(sector.Side)
          parent.idSectorSquare:SetBackground(color)
          parent.idTitle:SetText(sector.display_name)
          parent.idImage:SetImage(sector.image)
          local city_id = sector.City
          parent.idLoyalty:SetVisible(city_id ~= "none")
          if city_id and city_id ~= "none" then
            local city = gv_Cities[city_id]
            parent.idLoyalty:SetNameText(city.DisplayName)
            parent.idLoyalty:SetValueText(T({
              911910307915,
              "<style PDASectorInfo_ValueDark>Loyalty</style> <percent(loyalty)>",
              loyalty = GetCityLoyalty(city_id)
            }))
          end
          local intel = sector.Intel and sector.intel_discovered
          parent.idIntel:SetVisible(intel)
          parent.idtxtIntel:SetText(intel and T(920666659822, "Intel Acquired") or T(595719599586, "Intel Unknown"))
          parent.idIntel:SetRolloverText(intel and T(777876251539, "In Tactical View use the overview mode (<ShortcutButton('actionCamOverview')>) to view intel for this sector.") or T(467902135709, "Use the scouting Operation to gain intel. You may also gain intel from certain quests or characters in the world"))
          parent.idIntel:SetRolloverTitle(T(304425875136, "Intel"))
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:CloseContextMenu()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:CloseContextMenu()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluContextMenu.Open(self)
        self:SetFocus()
        SetDisableMouseViaGamepad(true, "context-menu")
        if not g_SatelliteUI then
          return
        end
        g_SatelliteUI:ShowCursorHint(false)
        ObjModified("satellite_context_menu")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        SetDisableMouseViaGamepad(false, "context-menu")
        if not g_SatelliteUI then
          return
        end
        SetCampaignSpeed(false, GetUICampaignPauseReason("UIContextMenu"))
        ObjModified("satellite_context_menu")
        g_SatelliteUI.context_menu = false
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "Escape" or shortcut == "ButtonB" then
          self:Close()
          return "break"
        end
        return ZuluContextMenu.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CloseContextMenu(self)",
      "func",
      function(self)
        if g_SatelliteUI then
          g_SatelliteUI:RemoveContextMenu()
        else
          self:Close()
        end
      end
    })
  })
})
