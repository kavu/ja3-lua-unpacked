PlaceObj("XTemplate", {
  group = "Zulu Badges",
  id = "InteractableBadge",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "VList",
    "UseClipBox",
    false,
    "Background",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "HAlign",
      "center",
      "Clip",
      false,
      "UseClipBox",
      false,
      "Visible",
      false,
      "FoldWhenHidden",
      true,
      "TextStyle",
      "UIHeaderLabels",
      "Translate",
      true,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "Id",
      "idImage",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "MouseCursor",
      "UI/Cursors/Interact.tga",
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled",
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "OnPress",
      function(self, gamepad)
        if not self.context then
          return
        end
        local unit = UIFindInteractWith(self.context)
        if not unit then
          return
        end
        UIInteractWith(unit, self.context)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetLayoutSpace(self, space_x, space_y, space_width, space_height)",
      "func",
      function(self, space_x, space_y, space_width, space_height)
        local margins_x1, margins_y1, margins_x2, margins_y2 = self:GetEffectiveMargins()
        local box = self.box
        local x, y = box:minx(), box:miny()
        local width = Min(self.measure_width, space_width)
        local height = Min(self.measure_height, space_height)
        x = space_x - width / 2
        local offset = const.Healthbar.BadgeIconsHeight
        local _, scaledOffset = ScaleXY(self.scale, 0, offset)
        offset = scaledOffset
        y = space_y - height - offset
        height = height * 2 + offset
        self:SetBox(x, y, width, height)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        if self.idImage.Image ~= "UI/Hud/iw_loot" then
          return
        end
        local lGetBobInterp = function(b)
          return {
            id = "bob",
            type = const.intRect,
            duration = 1000,
            originalRect = sizebox(b:minx(), b:miny() + 10, b:sizex(), b:sizey()),
            targetRect = b,
            flags = bor(const.intfPingPong, const.intfLooping),
            easing = "Sin in"
          }
        end
        local myBox = self.box
        if rollover then
          if myBox ~= empty_box then
            self:AddInterpolation(lGetBobInterp(myBox))
          elseif not self:GetThread("bob-when-ready") then
            self:CreateThread("bob-when-ready", function()
              WaitNextFrame(1)
              local myBox = self.box
              if myBox ~= empty_box then
                self:AddInterpolation(lGetBobInterp(myBox))
              end
            end)
          end
        else
          self:RemoveModifier("bob")
        end
      end
    })
  })
})
