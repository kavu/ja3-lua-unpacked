PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Common",
  id = "Showcase",
  recreate_after_save = true,
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Dock",
    "box"
  }, {
    PlaceObj("XTemplateLayer", {"layer", "Fade"}),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Close",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        if host.context and host.context.quit_game and not Paltform.developer then
          CreateRealTimeThread(QuitGame)
        else
          host:Close()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Prev",
      "ActionShortcut",
      "Backspace",
      "ActionGamepad",
      "Left",
      "OnAction",
      function(self, host, source, ...)
        host:CameraShowPrev()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Next",
      "ActionShortcut",
      "Space",
      "ActionGamepad",
      "Right",
      "OnAction",
      function(self, host, source, ...)
        host:CameraShowNext()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CameraShowPrev(self)",
      "func",
      function(self)
        if self.current_order > 1 then
          self:CameraShow(self.current_order - 1, 200)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CameraShowNext(self)",
      "func",
      function(self)
        local context = self:GetContext()
        if self.current_order < #GetShowcaseCameras(context) then
          self:CameraShow(self.current_order + 1, 200)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CameraShow(self, order, delay)",
      "func",
      function(self, order, delay)
        local context = self:GetContext()
        local cameras = GetShowcaseCameras(context)
        if #cameras == 0 then
          return
        end
        self:DeleteThread("SwitchCameraButtonThread")
        self:CreateThread("SwitchCameraButtonThread", function()
          Sleep(delay or -1)
          order = Clamp(order, 1, #cameras)
          local old_camera = cameras[self.current_order]
          self.current_order = order
          self:ResolveId("idPrevCamera"):SetEnabled(1 < order)
          self:ResolveId("idNextCamera"):SetEnabled(order < #cameras)
          local camera = cameras[order]
          SwitchToCamera(camera, old_camera, function()
            self:ResolveId("idTitle"):SetText(camera.display_name)
            self:ResolveId("idDescription"):SetText(camera.description)
            if camera.map ~= GetMapName() then
              ChangeMap(camera.map)
            end
          end)
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        local context = self:GetContext()
        local cameras = GetShowcaseCameras(context)
        local old_camera = cameras[self.current_order]
        CameraShowClose(old_camera)
        CloseDialog("Fade")
        if self.context and self.context.main_menu then
          CreateRealTimeThread(function()
            OpenPreGameMainMenu()
          end)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self.current_order = 0
        XDialog.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "bottom",
      "HAlign",
      "center",
      "LayoutMethod",
      "VOverlappingList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idFrameDescription",
        "IdNode",
        false,
        "HAlign",
        "center",
        "MaxWidth",
        800,
        "Image",
        "CommonAssets/UI/rollover_pad",
        "FrameBox",
        box(170, 10, 170, 10)
      }, {
        PlaceObj("XTemplateWindow", {
          "Dock",
          "bottom",
          "MaxWidth",
          1200,
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          60
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idDescription",
          "Padding",
          box(15, 15, 15, 15),
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "MaxWidth",
          700,
          "FocusedBorderColor",
          RGBA(0, 203, 255, 255),
          "TextStyle",
          "UIShowcaseDescription",
          "Translate",
          true,
          "HideOnEmpty",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idFrameTitle",
        "IdNode",
        false,
        "HAlign",
        "center",
        "MinWidth",
        800,
        "MaxWidth",
        1200,
        "Image",
        "CommonAssets/UI/conversation_title_pad",
        "FrameBox",
        box(170, 10, 170, 10)
      }, {
        PlaceObj("XTemplateWindow", {
          "Dock",
          "bottom",
          "MinWidth",
          800,
          "MaxWidth",
          1200,
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          60
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "RolloverText",
            T(960397893118, "Switch to Previous Camera"),
            "Id",
            "idPrevCamera",
            "Padding",
            box(50, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "Background",
            RGBA(0, 0, 0, 0),
            "OnPressEffect",
            "action",
            "OnPress",
            function(self, gamepad)
              local dlg = GetDialog(self)
              dlg:CameraShowPrev()
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0),
            "TextStyle",
            "UIShowcaseButton",
            "Translate",
            true,
            "Text",
            T(903115540821, "Previous")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTitle",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            400,
            "MaxWidth",
            400,
            "FocusedBorderColor",
            RGBA(0, 203, 255, 255),
            "TextStyle",
            "UIShowcaseTitle",
            "Translate",
            true,
            "Text",
            T(979866910351, "Camera Name"),
            "TextHAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "RolloverText",
            T(125695954743, "Switch to Next Camera"),
            "Id",
            "idNextCamera",
            "Padding",
            box(-10, 0, 0, 0),
            "HAlign",
            "right",
            "VAlign",
            "center",
            "Background",
            RGBA(0, 0, 0, 0),
            "OnPressEffect",
            "action",
            "OnPress",
            function(self, gamepad)
              local dlg = GetDialog(self)
              dlg:CameraShowNext()
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0),
            "TextStyle",
            "UIShowcaseButton",
            "Translate",
            true,
            "Text",
            T(239811146752, "Next")
          })
        })
      })
    }),
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        parent:CameraShow(1, -1, context)
      end
    })
  })
})
