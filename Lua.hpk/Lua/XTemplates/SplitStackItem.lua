PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SplitStackItem",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "ZOrder",
    10,
    "HAlign",
    "center",
    "VAlign",
    "center"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Ok",
      "ActionName",
      T(116600567829, "OK"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Enter",
      "ActionGamepad",
      "ButtonA",
      "OnAction",
      function(self, host, source, ...)
        local context = host:GetContext()
        local context_wnd = host:ResolveId("idContext")
        local scroll = context_wnd:ResolveId("idSlider")
        local lvalue = context.item.Amount - scroll.Scroll
        local rvalue = scroll.Scroll
        if lvalue ~= 0 and rvalue ~= 0 then
          if context.fnOK then
            context.fnOK(context, rvalue)
          else
            SplitInventoryItem(context.item, rvalue, context.context, context.slot_wnd)
          end
        end
        host:Close()
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "exit",
      "ActionId",
      "Cancel",
      "ActionName",
      T(681743213250, "CANCEL"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "close"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        self:SetModal()
        SetDisableMouseViaGamepad(true, "split")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        XDialog.Close(self, ...)
        SetDisableMouseViaGamepad(false, "split")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "+DPadLeft" or shortcut == "+DPadRight" then
          local children = GetChildrenOfKind(self, "XScrollThumb")
          local context = GetDialog(self):GetContext()
          local amount = children[1].Scroll
          local step = shortcut == "+DPadLeft" and -1 or 1
          local new_amount = amount + step
          local min = children[1]:GetMin()
          local max = children[1]:GetMax()
          if min then
            new_amount = Max(new_amount, min)
          end
          if max then
            new_amount = Min(new_amount, max)
          end
          children[1]:ScrollTo(new_amount)
          self.idContext.idTarget:OnScrollTo(new_amount)
          return "break"
        end
        if XScrollThumb.OnShortcut(self.idContext.idSlider, shortcut, source, ...) == "break" then
          return "break"
        end
        return XDialog.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContext",
      "Padding",
      box(16, 4, 16, 4),
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "Background",
      RGBA(52, 55, 61, 255),
      "OnContextUpdate",
      function(self, context, ...)
        self.idLeft:SetText(context.item.Amount - self.idSlider.Scroll)
        self.idRight:SetText(self.idSlider.Scroll)
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self)
          local slider = self:ResolveId("idSlider")
          local context = self:GetContext()
          local item = context.item
          slider:SetMax(item.Amount - 1)
        end
      }),
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
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
          "PDACombatActionHeader",
          "Translate",
          true,
          "Text",
          T(164149727004, "Split Stack"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(5, 0, 0, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "VAlign",
          "center",
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
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(6, 0, 6, 0),
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTarget",
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnScrollTo(self, value)",
            "func",
            function(self, value)
              local left = self:ResolveId("idLeft")
              local right = self:ResolveId("idRight")
              local slider = self:ResolveId("idSlider")
              local item = slider:GetContext().item
              left:SetText(item.Amount - value)
              right:SetText(value)
            end
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XText",
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
            T(985890900191, "<DPadLeft>"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLeft",
            "VAlign",
            "center",
            "MinWidth",
            40,
            "MaxWidth",
            40,
            "HandleMouse",
            false,
            "TextStyle",
            "InventoryItemsCount",
            "Text",
            "Max",
            "TextHAlign",
            "right"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "Slider",
            "Id",
            "idSlider",
            "Margins",
            box(0, 12, 0, 12),
            "VAlign",
            "center",
            "MinWidth",
            300,
            "MaxWidth",
            300,
            "OnContextUpdate",
            function(self, context, ...)
              local item = context.item
              if item and item.Amount then
                self:SetScroll(DivRound(item.Amount - 1, 2))
              end
              local prop_id = self.BindTo
              local prop_meta = self.prop_meta
              if context and (prop_id ~= "" or prop_meta) then
                if prop_meta then
                  prop_id = prop_meta.id
                  local name = self:ResolveId("idName")
                  if name then
                    name:SetText(prop_meta.name or prop_meta.id)
                  end
                end
                local value = ResolveValue(context, prop_id)
                if value ~= rawget(self, "value") then
                  self.value = value
                  self:OnPropUpdate(context, prop_meta, value)
                end
              end
              XContextControl.OnContextUpdate(self, context)
            end,
            "Target",
            "idTarget",
            "Min",
            1,
            "Max",
            500
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnShortcut(self, shortcut, source, ...)",
              "parent",
              function(parent, context)
                return parent:ResolveId("node")
              end,
              "func",
              function(self, shortcut, source, ...)
                if shortcut == "+DPadLeft" or shortcut == "+DPadRight" then
                  local children = GetChildrenOfKind(self, "XScrollThumb")
                  local context = GetDialog(self):GetContext()
                  local amount = children[1].Scroll
                  local step = shortcut == "+DPadLeft" and -1 or 1
                  local new_amount = amount + step
                  local min = children[1]:GetMin()
                  local max = children[1]:GetMax()
                  if min then
                    new_amount = Max(new_amount, min)
                  end
                  if max then
                    new_amount = Min(new_amount, max)
                  end
                  children[1]:ScrollTo(new_amount)
                  self.idTarget:OnScrollTo(new_amount)
                  return "break"
                end
                return XScrollThumb.OnShortcut(self, shortcut, source, ...)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idRight",
            "VAlign",
            "center",
            "MinWidth",
            40,
            "MaxWidth",
            40,
            "HandleMouse",
            false,
            "TextStyle",
            "InventoryItemsCount",
            "Text",
            "Min"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XText",
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
            T(505001141192, "<DPadRight>"),
            "HideOnEmpty",
            true
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return "GamepadUIStyleChanged"
        end,
        "__template",
        "InventoryActionBarCenter",
        "HAlign",
        "right",
        "VAlign",
        "bottom",
        "OnLayoutComplete",
        function(self)
          local toolbar = self.idToolBar
          toolbar:SetLayoutHSpacing(15)
          local bxZero = box(0, 0, 0, 0)
          local list = toolbar[1]
          for _, btn in ipairs(list) do
            btn.idTxtContainer:SetMargins(bxZero)
            btn.idBtnShortcut:SetPadding(bxZero)
            btn.idBtnText:SetPadding(bxZero)
          end
        end
      })
    })
  })
})
