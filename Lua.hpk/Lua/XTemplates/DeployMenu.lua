PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu ContextMenu",
  id = "DeployMenu",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idDeployMenu",
    "IdNode",
    true,
    "Visible",
    false,
    "FoldWhenHidden",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idContent",
      "BorderWidth",
      1,
      "VAlign",
      "top",
      "MinWidth",
      174,
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      1,
      "BackgroundRectGlowColor",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return SubContext(context, {
            "CornerIntelRespawn"
          })
        end,
        "__class",
        "XContentTemplateList",
        "IdNode",
        false,
        "Margins",
        box(0, 10, 0, 10),
        "BorderWidth",
        0,
        "UseClipBox",
        false,
        "Background",
        RGBA(255, 255, 255, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0),
        "HandleMouse",
        false,
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "LeftThumbScroll",
        false,
        "SetFocusOnOpen",
        true,
        "KeepSelectionOnRespawn",
        true
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ContextMenuButton",
          "Id",
          "idOnOffButton",
          "MinHeight",
          28,
          "MaxHeight",
          28,
          "OnContextUpdate",
          function(self, context, ...)
            local sector = gv_Sectors[gv_CurrentSectorId]
            if sector and not sector.intel_discovered then
              self:SetText(T(769503976054, "No Intel"))
              self.idOnOff:SetVisible(false)
            end
          end,
          "OnPressEffect",
          "action",
          "OnPress",
          function(self, gamepad)
            gv_DeploymentShowIntelUI = not gv_DeploymentShowIntelUI
            UpdateDeploymentUIIntelBadges()
          end,
          "Text",
          T(681328009294, "Tags")
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "gv_DeploymentShowIntelUI"
            end,
            "__class",
            "XText",
            "Id",
            "idOnOff",
            "Dock",
            "right",
            "HAlign",
            "right",
            "MinWidth",
            40,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "SatelliteContextMenuTextBold",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetText(gv_DeploymentShowIntelUI and T(818751046757, "ON") or T(470426548424, "OFF"))
            end,
            "Translate",
            true,
            "Text",
            T(470426548424, "OFF")
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
            "Id",
            "idGamepad",
            "Margins",
            box(-15, -3, 0, 0),
            "Dock",
            "left",
            "VAlign",
            "center",
            "ScaleModifier",
            point(800, 800),
            "Clip",
            false,
            "UseClipBox",
            false,
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "GamepadHint",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local sector = gv_Sectors[gv_CurrentSectorId]
              local hasIntel = sector and sector.intel_discovered
              self:SetVisible(GetUIStyleGamepad() and hasIntel)
            end,
            "Translate",
            true,
            "Text",
            T(444757356610, "<ButtonX>")
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              self:base_OnSetRollover(rollover)
              self.idOnOff:SetRollover(rollover)
              local node = self:ResolveId("node")
              if node.window_state == "destroying" then
                return
              end
              node.idRolloverPart:SetVisible(rollover)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable()",
            "func",
            function()
              return false
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "separator line",
          "__class",
          "XFrame",
          "Margins",
          box(17, 10, 17, 10),
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(5, 0, 5, 0),
          "SqueezeY",
          false
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable()",
            "func",
            function()
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetAvailableDeploymentMarkers()
          end,
          "condition",
          function(parent, context, item, i)
            return true
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetText(GetDeploymentPOIName(item))
            function child.OnPress()
              SnapCameraToObj(item, "force")
            end
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetFocus(self)",
              "func",
              function(self)
                if GetUIStyleGamepad() then
                  self:OnPress()
                end
                XTextButton.OnSetFocus(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnShortcut(self, shortcut, source, ...)",
              "func",
              function(self, shortcut, source, ...)
                if shortcut == "ButtonA" or shortcut == "-ButtonA" or shortcut == "+ButtonA" then
                  return
                end
                return XTextButton.OnShortcut(self, shortcut, source, ...)
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "separator line",
          "__context",
          function(parent, context)
            return GetDeploymentUIPOIs()
          end,
          "__condition",
          function(parent, context)
            return #(context or empty_table) > 0
          end,
          "__class",
          "XFrame",
          "Margins",
          box(18, 10, 18, 10),
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(5, 0, 5, 0),
          "SqueezeY",
          false
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable()",
            "func",
            function()
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetDeploymentUIPOIs()
          end,
          "condition",
          function(parent, context, item, i)
            return not IsKindOf(item, "ImplicitIntelMarker") or not item.DontShowInList
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetText(GetDeploymentPOIName(item))
            function child.OnPress()
              SnapCameraToObj(item, "force")
            end
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetFocus(self)",
              "func",
              function(self)
                if GetUIStyleGamepad() then
                  self:OnPress()
                end
                XTextButton.OnSetFocus(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnShortcut(self, shortcut, source, ...)",
              "func",
              function(self, shortcut, source, ...)
                if shortcut == "ButtonA" or shortcut == "-ButtonA" or shortcut == "+ButtonA" then
                  return
                end
                return XTextButton.OnShortcut(self, shortcut, source, ...)
              end
            })
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, gamepadId)",
          "func",
          function(self, shortcut, source, gamepadId)
            if source == "keyboard" and not gamepadId then
              return
            end
            if shortcut == "ButtonX" then
              local node = self:ResolveId("node")
              local button = node.idOnOffButton
              if button then
                button:OnPress()
              end
              return "break"
            end
            return XList.OnShortcut(self, shortcut, source, gamepadId)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "title",
        "__class",
        "XContentTemplate",
        "Dock",
        "top",
        "MinHeight",
        40,
        "MaxHeight",
        40,
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(10, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "SatelliteContextMenuDate",
          "Translate",
          true,
          "Text",
          T(758649482420, "<date()>")
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not gv_SatelliteView
          end,
          "HAlign",
          "right",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          -5
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return GetEnvironmentEffects()
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
              "RolloverAnchorId",
              "node",
              "RolloverOffset",
              box(0, 0, 25, 5),
              "Margins",
              box(0, 3, 8, 3),
              "HandleMouse",
              true,
              "ImageFit",
              "height"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "separator line",
          "__class",
          "XFrame",
          "Margins",
          box(2, 0, 2, 0),
          "VAlign",
          "bottom",
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(5, 0, 5, 0),
          "SqueezeY",
          false
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idRolloverPart",
      "Margins",
      box(0, 0, -1, 0),
      "BorderWidth",
      1,
      "Padding",
      box(15, 10, 15, 10),
      "Dock",
      "ignore",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      310,
      "MinHeight",
      10,
      "MaxWidth",
      310,
      "LayoutMethod",
      "VList",
      "Visible",
      false,
      "Background",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(10, 0, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "TextStyle",
        "PDA_SquadNameBig",
        "Translate",
        true,
        "Text",
        T(833184721972, "Intel")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(10, 0, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "TextStyle",
        "SatelliteContextMenuKeybind",
        "Translate",
        true,
        "Text",
        T(543887468878, "When you have gained intel for a sector you will get additional information about locations in the tactical view and can see special objects such as machine gun emplacements and spotlights. You can gain Intel by doing tasks or the scouting operation.")
      }),
      PlaceObj("XTemplateFunc", {
        "comment",
        "puts the rollover part above or below the first item",
        "name",
        "UpdateLayout(self)",
        "func",
        function(self)
          if not self.layout_update then
            return
          end
          local node = self:ResolveId("node")
          local content = node.idContent
          local width = self.measure_width
          local height = self.measure_height
          local x = content.box:minx() - width + 1
          local y = content.box:miny()
          if height > content.box:sizey() then
            y = y - height + content.box:sizey()
          end
          self:SetBox(x, y, width, height)
          XWindow.UpdateLayout(self)
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "overview mode observer",
      "__context",
      function(parent, context)
        return "CameraTacOverviewModeChanged"
      end,
      "__class",
      "XContextWindow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local isInOverview = cameraTac.GetIsInOverview()
        self.parent:SetVisible(isInOverview)
        if isInOverview then
          ObjModified("CornerIntelRespawn")
        end
      end
    })
  })
})
