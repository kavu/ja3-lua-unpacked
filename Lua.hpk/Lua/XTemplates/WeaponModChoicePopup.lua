PlaceObj("XTemplate", {
  group = "Zulu Weapon Mod",
  id = "WeaponModChoicePopup",
  PlaceObj("XTemplateWindow", {
    "__class",
    "WeaponModChoicePopupClass",
    "Id",
    "idChoicePopup",
    "Margins",
    box(0, 0, 0, 10),
    "BorderWidth",
    0,
    "Background",
    RGBA(0, 0, 0, 0),
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "AnchorType",
    "center-top",
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idComponentChoice",
      "HAlign",
      "left",
      "VAlign",
      "top"
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context
        end,
        "LayoutMethod",
        "VList",
        "HandleMouse",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return false
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idPreview",
          "HAlign",
          "left",
          "MinWidth",
          400,
          "MaxWidth",
          400
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context
            end,
            "__class",
            "XContextWindow",
            "Margins",
            box(0, 0, 0, 10),
            "Padding",
            box(6, 4, 6, 6),
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(52, 55, 61, 255),
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local component = context[1]
              local modifyMode = context.modifyMode
              local node = self:ResolveId("node")
              local popup = self:ResolveId("node"):ResolveId("node")
              local modifyDlg = GetDialog("ModifyWeaponDlg").idModifyDialog
              local description = GetWeaponComponentDescription(component)
              node.idText:SetText(description)
              local container = node.idCostsSection
              local lSpawnCostText = function()
                local costContainer = XTemplateSpawn("XWindow", container)
                costContainer:SetUseClipBox(false)
                costContainer:SetClip(false)
                costContainer:SetPadding(box(7, -2, 7, -2))
                local costText = XTemplateSpawn("XText", costContainer)
                costText:SetUseClipBox(false)
                costText:SetClip(false)
                costText:SetTranslate(true)
                return costContainer, costText
              end
              local canAffordNone = false
              local costs, _, _, canAffordTable = modifyDlg:GetChangesCost(popup.context.slot.SlotType)
              local costCount = 0
              for costType, amount in sorted_pairs(costs) do
                local costPreset = SectorOperationResouces[costType]
                local name = costPreset.name
                local affordable = canAffordTable[costType]
                local color = affordable and GameColors.D or GameColors.F
                if affordable then
                  canAffordNone = false
                end
                local costContainer, costText = lSpawnCostText()
                costText:SetText(T({
                  247376794745,
                  "<name><right><style PDARolloverTextBold><amount></style>",
                  name = name,
                  amount = amount
                }))
                local icon = XTemplateSpawn("XImage", costContainer)
                icon:SetHAlign("right")
                if costType == "Parts" and not affordable then
                  icon:SetImage("UI/Icons/mod_parts_lack")
                else
                  icon:SetImage(costPreset.icon)
                end
                icon:SetImageColor(color)
                icon:SetUseClipBox(false)
                icon:SetClip(false)
                icon:SetDock("right")
                icon:SetImageScale(point(850, 850))
                icon:SetMinWidth(20)
                icon:SetMargins(box(5, 0, 0, 0))
                if not affordable then
                  costContainer:SetBackground(GameColors.I)
                end
                costText:SetTextStyle(affordable and "PDARolloverTextDark" or "PDARolloverTextBigger")
                costCount = costCount + 1
              end
              if costCount == 0 then
                local _, costText = lSpawnCostText()
                costText:SetText(T(693421996481, "<style PDARolloverTextDark>Free</style>"))
              end
              if 0 < #container then
                local first = container[1]
                local pOne = first.Padding
                first:SetPadding(box(pOne:minx(), pOne:miny() + 5, pOne:maxx(), pOne:maxy()))
                local last = container[#container]
                local pLast = last.Padding
                last:SetPadding(box(pLast:minx(), pLast:miny(), pLast:maxx(), pLast:maxy() + 5))
              end
              if component == "" then
                node.idTitle:SetText(T(617720036390, "Empty"))
                node.idDifficultySection:SetVisible(false)
                return
              end
              local name = rawget(component, "name") or component.DisplayName
              node.idTitle:SetText(name)
              local bestMercSkill, bestMerc, difficulty = modifyDlg:GetModificationDifficultyParams(context)
              local difficultyTextLeft = T(983494754916, "Difficulty")
              local difficultyTextRight = T({
                475358187496,
                "<ModificationDifficultyToText(difficulty, mercSkill)>",
                difficulty = difficulty,
                mercSkill = bestMercSkill
              })
              bestMerc = gv_UnitData[bestMerc]
              local skillTextLeft = T({
                478471305383,
                "Mechanical (<mercName>)",
                mercName = bestMerc:GetDisplayName()
              })
              local skillTextRight = Untranslated(bestMercSkill)
              local diffRow = T({
                480414943560,
                "<style PDARolloverTextDark><diffL></style><right><style PDARolloverText><diffR></style>",
                diffL = difficultyTextLeft,
                diffR = difficultyTextRight
              })
              local skillRow = T({
                961539551576,
                "<left><style PDARolloverTextDark><skillL></style><right><style PDARolloverTextBold><skillR></style>",
                skillL = skillTextLeft,
                skillR = skillTextRight
              })
              local textConcat = diffRow .. "<newline>" .. skillRow
              node.idDifficulty:SetText(textConcat)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, 5),
              "Dock",
              "top",
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
                "Background",
                RGBA(69, 73, 81, 255)
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idTitle",
                "Margins",
                box(10, 0, 0, 0),
                "Padding",
                box(0, 0, 0, 0),
                "Dock",
                "left",
                "Clip",
                false,
                "UseClipBox",
                false,
                "FoldWhenHidden",
                true,
                "TextStyle",
                "PDACombatActionHeader",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, 5),
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Padding",
                box(8, 5, 8, 5),
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                5
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idText",
                  "TextStyle",
                  "PDARolloverText",
                  "Translate",
                  true
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idDifficultySection",
              "Margins",
              box(0, 0, 0, 5),
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Padding",
                box(8, 5, 8, 5),
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                5
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idDifficulty",
                  "Translate",
                  true
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idCostsSection",
              "LayoutMethod",
              "VList",
              "Background",
              RGBA(32, 35, 47, 255)
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context.errText
              end,
              "Margins",
              box(0, 5, 0, 0),
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Padding",
                box(8, 5, 8, 5),
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                5
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idErrors",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "TextStyle",
                  "PDARolloverText",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    self:SetText(context.errText)
                  end,
                  "Translate",
                  true
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context.modifyMode
              end,
              "Id",
              "idButtonSection",
              "Margins",
              box(0, 5, 0, 0),
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
              PlaceObj("XTemplateTemplate", {
                "__template",
                "WeaponModToolbarButton",
                "Dock",
                "box",
                "OnPressEffect",
                "action",
                "OnPressParam",
                "actionModify",
                "Text",
                T(168008951549, "Modify")
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "actionModify",
                "ActionShortcut",
                "M",
                "ActionGamepad",
                "ButtonX",
                "ActionState",
                function(self, host)
                  local modifyDlg = host.idModifyDialog
                  host = modifyDlg and modifyDlg:ResolveId("idChoicePopup")
                  local previewWindow = host and host.idPreview
                  if not previewWindow or not previewWindow.context then
                    return "hidden"
                  end
                  local costs, _, affordable = modifyDlg:GetChangesCost(host.context.slot.SlotType)
                  local part = ResolvePropObj(previewWindow.context) or ""
                  local _, __, ___, allowed = modifyDlg:GetModificationDifficultyParams(part)
                  local canModify = modifyDlg:CanModifySlot(host.context.slot, part.id)
                  local notBroken = modifyDlg.context.weapon.Condition ~= 0
                  local otherPlayerNotTouching = not OtherPlayerLookingAtSameWeapon()
                  return affordable and allowed and canModify and notBroken and otherPlayerNotTouching and "enabled" or "disabled"
                end,
                "OnAction",
                function(self, host, source, ...)
                  local modifyDlg = host.idModifyDialog
                  host = modifyDlg and modifyDlg:ResolveId("idChoicePopup")
                  if not modifyDlg or not host.context then
                    return "hidden"
                  end
                  modifyDlg:ApplyChangesSlot(host.context.slot.SlotType)
                  host:Close()
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XList",
          "Id",
          "idList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10,
          "Clip",
          false,
          "UseClipBox",
          false,
          "Background",
          RGBA(255, 255, 255, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "MouseScroll",
          false,
          "LeftThumbScroll",
          false,
          "SetFocusOnOpen",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "empty (disabled for now)",
            "__condition",
            function(parent, context)
              return context.slot.CanBeEmpty
            end,
            "__class",
            "XButton",
            "RolloverAnchor",
            "top",
            "RolloverOffset",
            box(0, 0, 0, 20),
            "RolloverTitle",
            T(594069477550, "Empty"),
            "ZOrder",
            0,
            "HAlign",
            "left",
            "VAlign",
            "top",
            "UseClipBox",
            false,
            "BorderColor",
            RGBA(255, 255, 255, 0),
            "Background",
            RGBA(255, 255, 255, 0),
            "OnContextUpdate",
            function(self, context, ...)
              XContextControl.OnContextUpdate(self, context)
              local weapon = ResolvePropObj(self.context)
              local slot = self.context.slot
              local item = weapon.components[slot.SlotType]
              local selected = item == ""
              self:SetTransparency(selected and 125 or 0)
              rawset(self, "currentlyEquipped", selected)
            end,
            "FXMouseIn",
            "buttonRollover",
            "FXPress",
            "WeaponModificationComponentClick",
            "FXPressDisabled",
            "IactDisabled",
            "FocusedBorderColor",
            RGBA(255, 255, 255, 0),
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "DisabledBorderColor",
            RGBA(255, 255, 255, 0),
            "OnPress",
            function(self, gamepad)
              local itemId = ""
              local currentlyEquipped = rawget(self, "currentlyEquipped")
              if currentlyEquipped then
                itemId = false
              end
              local popup = self:ResolveId("node")
              popup:ModifyPartPreview(itemId, "selected")
            end,
            "RolloverBackground",
            RGBA(255, 255, 255, 0),
            "PressedBackground",
            RGBA(255, 255, 255, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idImage",
              "MinWidth",
              90,
              "MinHeight",
              90,
              "MaxWidth",
              90,
              "MaxHeight",
              90,
              "UseClipBox",
              false,
              "Image",
              "UI/Inventory/T_Backpack_Slot_Small",
              "ImageFit",
              "stretch"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idRollover",
              "MinWidth",
              90,
              "MinHeight",
              90,
              "MaxWidth",
              90,
              "MaxHeight",
              90,
              "UseClipBox",
              false,
              "Visible",
              false,
              "Image",
              "UI/Inventory/T_Backpack_Slot_Small_Hover",
              "ImageFit",
              "stretch"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idIcon",
              "MinWidth",
              90,
              "MinHeight",
              90,
              "MaxWidth",
              90,
              "MaxHeight",
              90,
              "UseClipBox",
              false,
              "Transparency",
              180,
              "Image",
              "UI/Icons/Operations/repair_item",
              "ImageScale",
              point(800, 800),
              "ImageColor",
              RGBA(215, 159, 80, 255)
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                rawset(parent, "itemId", "")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local popup = self:ResolveId("node")
                if rollover then
                  popup:ModifyPartPreview("", "rollover")
                else
                  popup:ModifyPartPreview(false, "rollover")
                end
                XButton.OnSetRollover(self, rollover)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "SetSelected(self, selected)",
              "func",
              function(self, selected)
                self:SetFocus(selected)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable(self)",
              "func",
              function(self)
                return self:GetEnabled()
              end
            })
          }),
          PlaceObj("XTemplateForEach", {
            "comment",
            "slot alternatives",
            "array",
            function(parent, context)
              return context.slot.AvailableComponents
            end,
            "__context",
            function(parent, context, item, i, n)
              return SubContext(context, {
                item = IsKindOf(item, "WeaponColor") and item or WeaponComponents[item]
              })
            end,
            "run_after",
            function(child, context, item, i, n, last)
              local modifyDlg = GetDialog("ModifyWeaponDlg").idModifyDialog
              local costs, _, affordable, affordablePerType = modifyDlg:GetChangesCost(context.slot.SlotType, context.item.id)
              context.affordable = affordable
              local partCost = false
              local hasSpecialCost = false
              for costName, amount in pairs(costs) do
                if costName == "Parts" then
                  partCost = amount
                else
                  hasSpecialCost = costName
                end
              end
              if hasSpecialCost then
                local specialCostPreset = SectorOperationResouces[hasSpecialCost]
                child.idSpecialPartCost:SetVisible(true)
                child.idSpecialPartCost:SetImage(specialCostPreset.icon)
                local canAffordSpecial = affordablePerType[hasSpecialCost]
                local color = canAffordSpecial and GameColors.D or GameColors.I
                child.idSpecialPartCost:SetImageColor(color)
              end
              if partCost then
                child.idPartCostAmount:SetText(partCost)
                child.idPartCost:SetVisible(true)
                local canAffordParts = affordablePerType.Parts
                local color = canAffordParts and GameColors.D or GameColors.I
                child.idPartCostIcon:SetImageColor(color)
                child.idPartCostIcon:SetImage(canAffordParts and "UI/SectorOperations/T_Icon_Parts" or "UI/Icons/mod_parts_lack")
              end
              rawset(child, "itemId", item)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "RolloverOffset",
              box(0, 0, 0, 20),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "UseClipBox",
              false,
              "BorderColor",
              RGBA(255, 255, 255, 0),
              "Background",
              RGBA(255, 255, 255, 0),
              "OnContextUpdate",
              function(self, context, ...)
                XContextControl.OnContextUpdate(self, context)
                local affordable = self.context.affordable
                if affordable then
                  self.idOverlay:SetVisible(false)
                  self.idIcon:SetDesaturation(0)
                  self.idImage:SetDesaturation(0)
                  self:SetTransparency(0)
                else
                  self.idOverlay:SetVisible(true)
                  self.idIcon:SetDesaturation(255)
                  self.idImage:SetDesaturation(255)
                  self:SetTransparency(25)
                end
                local weapon = ResolvePropObj(self.context)
                local slot = self.context.slot
                local item = weapon.components[self.context.item.Slot]
                local selected = item == self.context.item.id
                self:SetTransparency(selected and 125 or 0)
                rawset(self, "currentlyEquipped", selected)
                if IsKindOf(self.context.item, "WeaponColor") then
                  self.idIcon:SetBackground(self.context.item.color)
                else
                  self.idIcon:SetImage(GetWeaponComponentIcon(self.context.item, weapon))
                end
              end,
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "WeaponModificationComponentClick",
              "FXPressDisabled",
              "IactDisabled",
              "FocusedBorderColor",
              RGBA(255, 255, 255, 0),
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "DisabledBorderColor",
              RGBA(255, 255, 255, 0),
              "OnPress",
              function(self, gamepad)
                local itemId = self.context.item and self.context.item.id
                local currentlyEquipped = rawget(self, "currentlyEquipped")
                if currentlyEquipped then
                  itemId = false
                end
                local popup = self:ResolveId("node")
                popup:ModifyPartPreview(itemId, "selected")
              end,
              "RolloverBackground",
              RGBA(255, 255, 255, 0),
              "PressedBackground",
              RGBA(255, 255, 255, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idImage",
                "MinWidth",
                90,
                "MinHeight",
                90,
                "MaxWidth",
                90,
                "MaxHeight",
                90,
                "UseClipBox",
                false,
                "Image",
                "UI/Inventory/T_Backpack_Slot_Small",
                "ImageFit",
                "stretch"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idRollover",
                "MinWidth",
                90,
                "MinHeight",
                90,
                "MaxWidth",
                90,
                "MaxHeight",
                90,
                "UseClipBox",
                false,
                "Visible",
                false,
                "Image",
                "UI/Inventory/T_Backpack_Slot_Small_Hover",
                "ImageFit",
                "stretch"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idIcon",
                "MinWidth",
                90,
                "MinHeight",
                90,
                "MaxWidth",
                90,
                "MaxHeight",
                90,
                "UseClipBox",
                false,
                "ImageFit",
                "stretch"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idSpecialPartCost",
                "Margins",
                box(-5, -5, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "UseClipBox",
                false,
                "Visible",
                false,
                "Image",
                "UI/Icons/Upgrades/parts_placeholder"
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idOverlay",
                "Background",
                RGBA(237, 31, 36, 25)
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idPartCost",
                "Margins",
                box(0, 0, 5, 0),
                "HAlign",
                "right",
                "VAlign",
                "bottom",
                "LayoutMethod",
                "HList",
                "Visible",
                false
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idPartCostAmount",
                  "Margins",
                  box(0, 0, 3, 0),
                  "VAlign",
                  "center",
                  "TextStyle",
                  "PDARolloverTextBold"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idPartCostIcon",
                  "ScaleModifier",
                  point(800, 800),
                  "UseClipBox",
                  false,
                  "Image",
                  "UI/SectorOperations/T_Icon_Parts"
                })
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local popup = self:ResolveId("node")
                  if rollover then
                    popup:ModifyPartPreview(self.context.item and self.context.item.id, "rollover")
                  else
                    popup:ModifyPartPreview(false, "rollover")
                  end
                  XButton.OnSetRollover(self, rollover)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetSelected(self, selected)",
                "func",
                function(self, selected)
                  self:SetFocus(selected)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "IsSelectable(self)",
                "func",
                function(self)
                  return self:GetEnabled()
                end
              })
            })
          })
        })
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
        self:Close()
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
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ModifyPartPreview(self, partId, reason)",
      "func",
      function(self, partId, reason)
        if self.window_state == "destroying" then
          return
        end
        local partPreset = WeaponComponents[partId] or false
        if partId == "" then
          partPreset = partId
        end
        local modifyDlg = GetDialog("ModifyWeaponDlg").idModifyDialog
        local canSelect = true
        if InventoryIsCombatMode() then
          canSelect = false
        end
        if not modifyDlg.canEdit then
          canSelect = false
        end
        if not canSelect and reason == "selected" then
          return
        end
        if canSelect and reason == "rollover" and GetUIStyleGamepad() then
          local ui = table.find_value(self.idList, "itemId", partId)
          if ui and not rawget(ui, "currentlyEquipped") then
            reason = "selected"
          end
        end
        local previewState = self.previewState
        if not previewState then
          previewState = {}
          self.previewState = previewState
        end
        previewState[reason] = partPreset
        local anyReason, topPreview = false, false
        local precedence = {"selected", "rollover"}
        for reason, part in pairs(previewState) do
          if part then
            anyReason = true
            local idx = table.find(precedence, reason)
            local top = table.find(precedence, topPreview)
            if not top or idx > top then
              topPreview = reason
            end
          end
        end
        local partPreviewUI = self.idPreview
        partPreviewUI:SetVisible(anyReason)
        local context = self.idComponentChoice.context
        local weapon = ResolvePropObj(context)
        local slot = context.slot
        local topPreset = previewState[topPreview]
        local noErr, err, errParam = modifyDlg:CanModifySlot(slot, partId)
        local queuedRevert = not not modifyDlg:GetThread("revert_part")
        local isRevert = not topPreset and err ~= "blocked"
        if queuedRevert and not isRevert then
          modifyDlg:DeleteThread("revert_part")
        end
        if err ~= "blocked" then
          if topPreset then
            modifyDlg.weaponClone:SetWeaponComponent(slot.SlotType, topPreset.id or topPreset)
          elseif not queuedRevert then
            modifyDlg:CreateThread("revert_part", function()
              WaitMsg(self, 200)
              RestoreCloneWeaponComponents(modifyDlg.weaponClone, weapon)
            end)
            return
          end
        end
        modifyDlg:UpdateWeaponProps()
        local ui = table.find_value(self.idList, "itemId", partId)
        if ui then
          local previewUIWidth = partPreviewUI.MaxWidth
          local uiX = ui.box:minx() + ui.box:sizex() / 2 - self.box:minx()
          uiX = MulDivRound(uiX, 1000, partPreviewUI.scale:x())
          uiX = uiX - previewUIWidth / 2
          local listSize = self.box:sizex()
          listSize = MulDivRound(listSize, 1000, self.scale:x())
          if uiX < 0 then
            uiX = 0
          elseif listSize < uiX + previewUIWidth then
            uiX = listSize - previewUIWidth
            if previewUIWidth < listSize then
              uiX = uiX - 1
            end
          end
          partPreviewUI:SetMargins(box(uiX, 0, 0, 0))
        end
        local modifyMode = topPreview == "selected" or previewState.rollover == previewState.selected
        local errText = false
        if not noErr and err == "blocked" then
          errText = T({
            742571156312,
            "<BlockedByError(param)>",
            param = errParam
          })
        end
        if InventoryIsCombatMode() then
          modifyMode = false
          errText = T(890566655089, "<error>Can't modify weapons during combat</error>")
        end
        partPreviewUI:SetContext(topPreset and SubContext(topPreset, {modifyMode = modifyMode, errText = errText}))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonB" then
          self:Close()
          return "break"
        end
        return XPopup.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        SetDisableMouseViaGamepad(true, "context-menu")
        WeaponModChoicePopupClass.Open(self)
        self:CreateThread("windows-size-change", function()
          WaitMsg("SystemSize")
          self:Close()
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self)",
      "func",
      function(self)
        SetDisableMouseViaGamepad(false, "context-menu")
        return WeaponModChoicePopupClass.Close(self)
      end
    })
  })
})
