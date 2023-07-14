PlaceObj("XTemplate", {
  __is_kind_of = "XContextControl",
  group = "Zulu",
  id = "RolloverInventoryBase",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextControl",
    "Id",
    "idContent",
    "Padding",
    box(6, 4, 6, 4),
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    5,
    "Background",
    RGBA(52, 55, 61, 255),
    "BackgroundRectGlowSize",
    2,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255),
    "OnContextUpdate",
    function(self, context, ...)
      local control = context.control
      local title = context.RolloverTitle ~= "" and context.RolloverTitle or control:GetRolloverTitle()
      self.idTitle:SetText(title)
      local show = self.idTitle.text ~= ""
      self.idTitle:SetVisible(show)
      local description = context.Description ~= "" and context.Description or ""
      local item = ResolvePropObj(context)
      local hint = item:GetRolloverHint()
      local ctrl_hint = control:GetRolloverHint()
      if description and description ~= "" and hint and hint ~= "" then
        description = description .. [[


]]
      end
      if rawget(self, "idText") then
        self.idText:SetText(description)
      end
      if IsKindOf(ResolvePropObj(context), "MiscItem") then
        ctrl_hint = T(972835609687, "Action")
      end
      self.idItemHint:SetText(hint or "")
      self.idHint:SetText(ctrl_hint or "")
      self.idHint.parent:SetVisible(ctrl_hint and ctrl_hint ~= "")
      local embed = GetParentOfKind(context.control, "XInventoryItemEmbed")
      if embed then
        self.idimgHint:SetVisible(false)
        if embed.ShowOwner then
          local itemOwner = item.owner
          local ud = gv_UnitData[itemOwner]
          if ud then
            self.idTitle:SetText(T({
              185880247892,
              "<name> (<owner>)",
              name = title,
              owner = ud.Nick
            }))
          end
        end
      end
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XContextControl.Open(self, ...)
        local control = self.context.control
        local offset = control and control:GetRolloverOffset()
        if offset and offset ~= box(0, 0, 0, 0) then
          self.parent:SetMargins(self.parent.Margins + offset)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
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
        "Margins",
        box(0, 2, 0, 0),
        "Dock",
        "right",
        "HAlign",
        "right",
        "VAlign",
        "top",
        "MinWidth",
        21,
        "MinHeight",
        21,
        "MaxWidth",
        21,
        "MaxHeight",
        21,
        "UseClipBox",
        false,
        "Background",
        RGBA(69, 73, 81, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Dock",
        "left",
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MaxWidth",
        450,
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "TextStyle",
        "HUDHeaderBig",
        "Translate",
        true,
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      8
    }, {
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -2,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateGroup", {
          "comment",
          "ammo",
          "__condition",
          function(parent, context)
            local cnt = ResolvePropObj(context)
            return IsKindOfClasses(cnt, "Ammo")
          end
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              if not context or not next(context.Modifications or {}) then
                return {}
              end
              local mods = table.ifilter(context.Modifications, function(idx, mod)
                return mod and mod.display_name and mod.display_name ~= ""
              end)
              return mods
            end,
            "condition",
            function(parent, context, item, i)
              if not context or not next(context.Modifications or {}) then
                return false
              end
              local mods = table.ifilter(context.Modifications, function(idx, mod)
                return mod and mod.display_name and mod.display_name ~= ""
              end)
              return next(mods)
            end,
            "run_after",
            function(child, context, item, i, n, last)
              if item and item.display_name and item.display_name ~= "" then
                child:SetNameText(item.display_name)
                if item.mod_add ~= 0 then
                  local add = item.mod_add
                  local meta = g_Classes.Firearm:GetPropertyMetadata(item.target_prop)
                  local scale = GetPropScale(meta.scale)
                  child:SetValueText(Untranslated((0 < add and "+" or "") .. FormatNumberProp(add, scale)))
                elseif 0 < item.mod_mul then
                  child:SetValueText(Untranslated("x" .. FormatNumberProp(item.mod_mul, 1000, 2)))
                end
              end
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XNameValueText",
              "TextStyle",
              "InventoryRolloverProp",
              "TextStyleRight",
              "InventoryRolloverProp"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "FoldWhenHidden",
          true,
          "TextStyle",
          "InventoryRolloverHint",
          "Translate",
          true,
          "HideOnEmpty",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idItemHint",
          "Padding",
          box(5, 0, 15, 0),
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "InventoryRolloverHint",
          "Translate",
          true,
          "HideOnEmpty",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return ResolvePropObj(context)
          end,
          "__condition",
          function(parent, context)
            return IsKindOf(context, "Valuables")
          end,
          "Id",
          "idMoneyValue"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "InventoryRolloverValuableItemName",
            "Translate",
            true,
            "Text",
            T(494488574234, "Value:"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "InventoryRolloverValuableItemValue",
            "Translate",
            true,
            "Text",
            T(770368132801, "<money(Cost)>"),
            "HideOnEmpty",
            true,
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          local cnt = ResolvePropObj(context)
          return context.UnitStat and context.owner or IsKindOfClasses(cnt, "Medicine", "ToolItem", "ItemUpgrade")
        end,
        "__class",
        "XContextWindow",
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(12, 3, 12, 3),
        "MinHeight",
        34,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -3,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "stat",
          "__condition",
          function(parent, context)
            return context.UnitStat and context.owner
          end,
          "__template",
          "RolloverPropTextRight"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              XPropControl.Open(self, ...)
              local unit_id = self:GetContext().owner
              local unit = g_Units[unit_id]
              local unit_data = gv_UnitData[unit_id]
              unit = (gv_SatelliteView or not unit) and unit_data or unit
              if not unit then
                return
              end
              local context = self:GetContext()
              local cnt = ResolvePropObj(context)
              local stat = table.find_value(UnitPropertiesStats:GetProperties(), "id", cnt.UnitStat)
              self.idPropVal:SetNameText(stat.name)
              self.idPropVal:SetValueText(T({
                525167855692,
                "<style PDABrowserFlavorMedium>(<unit>)</style> <value>",
                unit = unit.Nick,
                value = unit[stat.id]
              }))
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "condition",
          "__condition",
          function(parent, context)
            local cnt = ResolvePropObj(context)
            return IsKindOfClasses(cnt, "Medicine", "ToolItem", "ItemUpgrade")
          end,
          "__template",
          "RolloverPropTextRight"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              XPropControl.Open(self, ...)
              local context = self:GetContext()
              local cnt = ResolvePropObj(context)
              self.idPropVal:SetNameText(T(818236076302, "Condition"))
              local condition_percent = cnt:GetConditionPercent()
              if not cnt.Repairable then
                self.idPropVal:SetValueText(T({
                  686202559556,
                  "<percent(condPercent)>",
                  condPercent = condition_percent
                }))
              else
                local text = cnt:GetConditionKeywordNoPrefix()
                self.idPropVal:SetValueText(T({
                  541139041647,
                  "<keyword> (<percent(condPercent)>)",
                  keyword = text,
                  condPercent = condition_percent
                }))
              end
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idimgHint",
        "Margins",
        box(5, 3, 0, -2),
        "MinHeight",
        34,
        "LayoutMethod",
        "HList",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "GamepadUIStyleChanged"
          end,
          "__class",
          "XContextImage",
          "Transparency",
          100,
          "Image",
          "UI/Icons/right_click",
          "ImageScale",
          point(700, 700),
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local img = "UI/Icons/right_click"
            self:SetImageScale(point(700, 700))
            if GetUIStyleGamepad() then
              local btn = g_Classes.ZuluMouseViaGamepad.RightClickButton
              img = GetPlatformSpecificImagePath(btn)
              self:SetImageScale(point(400, 400))
            end
            self:SetImage(img)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "g_RolloverShowMoreInfo"
          end,
          "__class",
          "XText",
          "Id",
          "idHint",
          "Margins",
          box(3, 0, 0, 0),
          "VAlign",
          "center",
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "SatelliteContextMenuKeybind",
          "Translate",
          true,
          "HideOnEmpty",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "locked",
        "__condition",
        function(parent, context)
          local cnt = ResolvePropObj(context)
          return cnt.locked
        end,
        "Margins",
        box(0, -8, 0, 4),
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "Padding",
          box(8, 8, 8, 8),
          "ContextUpdateOnOpen",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idLockedIcon",
            "Dock",
            "left",
            "HAlign",
            "left",
            "ScaleModifier",
            point(700, 700),
            "Image",
            "UI/Inventory/padlock",
            "ImageColor",
            RGBA(191, 67, 77, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLockedText",
            "Margins",
            box(10, 0, 0, 0),
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "RolloverTextItalicRed",
            "Translate",
            true,
            "Text",
            T(911720724899, "You can't move this item")
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        local cnt = ResolvePropObj(context)
        return IsKindOfClasses(cnt, "Ammo") and context.apCost
      end,
      "Id",
      "idAPCostSection",
      "Padding",
      box(5, 1, 8, 1),
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      5,
      "FoldWhenHidden",
      true,
      "Background",
      RGBA(88, 92, 68, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idAPCostText",
        "Margins",
        box(2, 0, 0, 0),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "FoldWhenHidden",
        true,
        "TextStyle",
        "CombatActionRolloverAP",
        "Translate",
        true,
        "HideOnEmpty",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          local reload = CombatActions.Reload
          local unit = Selection[1]
          local ammo = ResolvePropObj(context)
          local apCost, displayCost = reload:GetAPCost(unit, {target = ammo})
          if displayCost then
            apCost = displayCost
          end
          local unitAp = unit:GetUIActionPoints()
          local apCostText = T({
            596435313389,
            "<apn(ap)>",
            ap = apCost
          })
          if not unit:HasAP(apCost) then
            apCostText = "<color DescriptionTextRed>" .. apCostText .. "</color>"
          end
          parent:ResolveId("idAPCostText"):SetText(T({
            686104948652,
            "<style PDARolloverHeaderBeige><apCostText></style> /<apn(unitAp)> AP",
            apCostText = apCostText,
            unitAp = unitAp
          }))
        end
      })
    })
  })
})
