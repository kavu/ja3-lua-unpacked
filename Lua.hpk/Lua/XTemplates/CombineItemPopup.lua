PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "CombineItemPopup",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idMain",
    "Background",
    RGBA(30, 30, 35, 115),
    "GamepadVirtualCursor",
    true
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
          true,
          "Text",
          T(471218052023, "COMBINE ITEMS")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          8
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context.item
            end,
            "__class",
            "XInventoryItemEmbed",
            "LayoutMethod",
            "HList",
            "BorderColor",
            RGBA(32, 35, 47, 255),
            "Background",
            RGBA(42, 45, 54, 120),
            "square_size",
            90,
            "ShowOwner",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "VAlign",
            "center",
            "TextStyle",
            "Hiring_MercLevel",
            "Translate",
            true,
            "Text",
            T(427405118822, "+")
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return false
            end,
            "__class",
            "RespawningButton",
            "Id",
            "idCombineOptions",
            "Background",
            RGBA(0, 0, 0, 0),
            "ChildrenHandleMouse",
            true,
            "FXMouseIn",
            "buttonRollover",
            "FXPress",
            "buttonPress",
            "FXPressDisabled",
            "IactDisabled",
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0),
            "RespawnOnContext",
            false,
            "RespawnOnDialogMode",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Inventory/T_Backpack_Slot_Small_Hover",
              "ImageFit",
              "stretch"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XInventoryItemEmbed",
              "LayoutMethod",
              "HList",
              "BorderColor",
              RGBA(32, 35, 47, 255),
              "Background",
              RGBA(42, 45, 54, 120),
              "square_size",
              90,
              "ShowOwner",
              true
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                if button ~= "L" then
                  return
                end
                local node = self:ResolveId("node")
                local context = node.context
                local options = InventoryGetTargetsRecipe(context.item, context.unit)
                local choice = XTemplateSpawn("CombineItemPopupItemChoice", terminal.desktop, options)
                choice:SetZOrder(999)
                choice:SetAnchor(self.box)
                choice:Open()
                terminal.desktop:SetModalWindow(choice)
                function choice.OnDelete()
                  if choice.result and node.window_state ~= "destroying" then
                    procall(node.SetChosenCombination, node, choice.result)
                  end
                end
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "VAlign",
            "center",
            "TextStyle",
            "Hiring_MercLevel",
            "Translate",
            true,
            "Text",
            T(313214069515, "=")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContentTemplate",
            "Id",
            "idResult",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XInventoryItemEmbed",
              "LayoutMethod",
              "HList",
              "BorderColor",
              RGBA(32, 35, 47, 255),
              "Background",
              RGBA(42, 45, 54, 120),
              "square_size",
              90
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSliderContainer",
          "Margins",
          box(0, 10, 0, 0),
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idCombineCount",
            "Margins",
            box(0, 0, 16, 0),
            "Dock",
            "right",
            "VAlign",
            "center",
            "MinWidth",
            30,
            "TextStyle",
            "PDARolloverText",
            "TextHAlign",
            "right"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "Slider",
            "Id",
            "idSlider",
            "Margins",
            box(20, 10, 10, 10),
            "VAlign",
            "center",
            "Target",
            "idSliderContainer",
            "Min",
            1,
            "Max",
            1
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnScrollTo(self, value)",
            "func",
            function(self, value)
              local slider = self:ResolveId("idSlider")
              local node = self:ResolveId("node")
              node.idCombineCount:SetText(value)
            end
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
            "Dock",
            "left",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
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
            T(199239787895, "<LB> <RB>")
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "Margins",
        box(8, 5, 8, 8),
        "Padding",
        box(8, 8, 8, 8),
        "Background",
        RGBA(32, 35, 47, 255),
        "TextStyle",
        "PDARolloverText",
        "Translate",
        true,
        "HideOnEmpty",
        true
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
        "LayoutHSpacing",
        30,
        "Background",
        RGBA(255, 255, 255, 0),
        "Toolbar",
        "ActionBar",
        "ButtonTemplate",
        "PDACommonButton"
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Assemble",
        "ActionName",
        T(657879215259, "Confirm"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "A",
        "ActionGamepad",
        "ButtonY",
        "ActionState",
        function(self, host)
          return host.combination and host.can_combine and "enabled" or "disabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          local node = host
          local context = node.context
          local item = context.item
          local recipe_data = host.combination
          local recipe = recipe_data.recipe
          local cd = recipe_data.container_data
          CombineItemsLocal(recipe, context.unit, item, context.context, cd.item, cd.container, host.idSlider.Scroll)
          host:Close()
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Close",
        "ActionName",
        T(424422676665, "Close"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "OnAction",
        function(self, host, source, ...)
          local node = host
          node:Close()
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetChosenCombination(self, data)",
      "func",
      function(self, data)
        local secondItem = data.container_data and data.container_data.item
        self.idCombineOptions:SetContext(secondItem)
        self.idCombineOptions:RespawnContent()
        local resultItems = data.recipe and data.recipe.ResultItems
        local itemsConverted = {}
        for i, recipeItem in ipairs(resultItems) do
          local itemId = recipeItem.item
          itemId = TransformItemId(itemId)
          local class = g_Classes[itemId]
          local fakeItem = class:new({id = -1})
          itemsConverted[#itemsConverted + 1] = fakeItem
        end
        self.idResult:SetContext(itemsConverted)
        self.idResult:RespawnContent()
        local maxSkill, mercMaxskill, skill_type = InventoryCombineItemMaxSkilled(self.context.unit, data.recipe)
        local operator_ud = gv_UnitData[mercMaxskill]
        local difficulty = data.recipe.Difficulty
        local combineText = T({
          710966137412,
          [[
<style PDARolloverTextDark>Mechanical stat required:</style><right><style PDARolloverText><difficulty></style>
<left><style PDARolloverTextDark><merc_name> (<skilltype>)</style><right><style PDARolloverText><u(mercSkill)></style>]],
          merc_name = operator_ud.Nick,
          difficulty = difficulty,
          mercSkill = maxSkill,
          skilltype = table.find_value(UnitPropertiesStats:GetProperties(), "id", skill_type).name
        })
        self.idText:SetText(combineText)
        local canCombine = maxSkill >= difficulty
        self.combination = data
        self.can_combine = canCombine
        self.idActionBar:OnUpdateActions()
        local ingredients = InventoryGetIngredientsForRecipe(data.recipe, self.context.unit)
        local timesCanCombine = false
        for i, ingr in ipairs(ingredients) do
          local totalData = ingr.total_data
          if not timesCanCombine or timesCanCombine > #totalData then
            timesCanCombine = #totalData
          end
        end
        self.idSliderContainer:SetVisible(1 < timesCanCombine)
        self.idSlider:SetMax(timesCanCombine)
        self.idSlider:SetScroll(1)
        self.idCombineCount:SetText(1)
      end
    })
  })
})
