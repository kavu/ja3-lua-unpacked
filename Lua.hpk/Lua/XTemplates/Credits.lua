PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "PreGame",
  id = "Credits",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "FadeInTime",
    500,
    "FadeOutTime",
    500,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        self:SetFocus()
        self:AnimatePhotos()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimatePhotos",
      "func",
      function(self, ...)
        if self:IsThreadRunning("images_change") then
          return
        end
        self:CreateThread("images_change", function()
          Sleep(103)
          local time = 500
          local wait = 5000
          local idx = 1
          local images = io.listfiles("UI/Common/", "cr_photo_*", "non recursive")
          table.sort(images)
          local max_img = #images
          self.idImageLeft:SetImage(images[1])
          self.idImageRight:SetImage(images[2])
          self.idImageLeft:SetVisible(true, true)
          self.idImageRight:SetVisible(true, true)
          idx = 3
          if max_img <= idx then
            idx = 1
          end
          while true do
            Sleep(wait + time)
            self.idImageLeft:SetVisible(false)
            self.idImageLeft:AddInterpolation({
              id = "pos",
              type = const.intRect,
              duration = time,
              originalRect = self.idImageLeft.box,
              targetRect = Offset(self.idImageLeft.box, point(-self.idImageLeft.box:sizex(), 0)),
              easing = "Sin in"
            })
            Sleep(time)
            local img = images[idx]
            self.idImageLeft:SetImage(img)
            idx = idx + 1
            img = images[idx]
            self.idImageLeft:SetVisible(true)
            self.idImageLeft:AddInterpolation({
              id = "pos",
              type = const.intRect,
              duration = time,
              originalRect = self.idImageLeft.box,
              targetRect = Offset(self.idImageLeft.box, point(-self.idImageLeft.box:sizex(), 0)),
              flags = const.intfInverse,
              easing = "Sin in"
            })
            Sleep(wait + time)
            self.idImageRight:SetVisible(false)
            self.idImageRight:AddInterpolation({
              id = "pos",
              type = const.intRect,
              duration = time,
              originalRect = self.idImageRight.box,
              targetRect = Offset(self.idImageRight.box, point(self.idImageRight.box:sizex(), 0)),
              easing = "Sin in"
            })
            Sleep(time)
            self.idImageRight:SetImage(img)
            idx = idx + 1
            if max_img <= idx then
              idx = 1
            end
            self.idImageRight:SetVisible(true)
            self.idImageRight:AddInterpolation({
              id = "pos",
              type = const.intRect,
              duration = time,
              originalRect = self.idImageRight.box,
              targetRect = Offset(self.idImageRight.box, point(self.idImageRight.box:sizex(), 0)),
              flags = const.intfInverse,
              easing = "Sin in"
            })
          end
        end)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "bottom image",
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/Common/cr_background",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "logo",
      "__class",
      "XImage",
      "Margins",
      box(0, 50, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "top",
      "ScaleModifier",
      point(500, 500),
      "DrawOnTop",
      true,
      "Image",
      "UI/Common/mm_ja3_logo"
    }),
    PlaceObj("XTemplateWindow", {
      "__parent",
      function(parent, context)
        return GetDialog(parent)
      end,
      "__class",
      "XCreditsWindow",
      "HAlign",
      "center",
      "MinWidth",
      500,
      "MinHeight",
      500,
      "MaxWidth",
      700,
      "OnLayoutComplete",
      function(self)
        local box = self.box
        local miny, maxy = ScaleXY(self.scale, 850, 400)
        miny = box:miny() + miny
        maxy = box:maxy() - maxy
        self.effect_shader_params = {
          BoxMinX = box:minx() * 1000,
          BoxMaxX = box:maxx() * 1000,
          BoxMaxY = maxy * 1000,
          BoxMinY = miny * 1000
        }
        self:SetUIEffectModifierId("CreditsFadeBox")
        self:UpdateUIEffectModifiers()
        self:MoveThread()
      end,
      "MouseScroll",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 150, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1920
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImageLeft",
        "Margins",
        box(65, 0, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Visible",
        false,
        "FadeInTime",
        600,
        "FadeOutTime",
        600,
        "Image",
        "UI/Common/cr_photo_01"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImageRight",
        "Margins",
        box(0, 0, 65, 0),
        "HAlign",
        "right",
        "VAlign",
        "center",
        "Visible",
        false,
        "FadeInTime",
        600,
        "FadeOutTime",
        600,
        "Image",
        "UI/Common/cr_photo_02"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/Common/cr_vignette",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "InventoryActionBarCenter",
      "ZOrder",
      10,
      "Margins",
      box(0, 0, 80, 50),
      "HAlign",
      "right"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Close",
      "ActionName",
      T(572452323663, "EXIT"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "back",
      "OnAction",
      function(self, host, source, ...)
        CloseDialog(host)
      end,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled"
    })
  })
})
