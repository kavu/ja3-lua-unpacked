PlaceObj("XTemplate", {
  __is_kind_of = "ZuluModalDialog",
  group = "Zulu PDA",
  id = "PDAMercProfiles",
  PlaceObj("XTemplateWindow", {
    "comment",
    "content frame",
    "__class",
    "ZuluModalDialog",
    "Dock",
    "box",
    "Background",
    RGBA(32, 35, 47, 120)
  }, {
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 96, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "center"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(0, 1, 0, 0),
        "Dock",
        "top",
        "MinHeight",
        32,
        "MaxHeight",
        32,
        "DrawOnTop",
        true,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(5, 5, 5, 5),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 0, 0),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHeaderText",
            "VAlign",
            "bottom",
            "TextStyle",
            "PDABrowserTitle",
            "Translate",
            true,
            "Text",
            T(953212167895, "Merc's Profiles"),
            "TextVAlign",
            "bottom"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(18, 18, 18, 18),
        "Dock",
        "box",
        "LayoutMethod",
        "VList",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, 0, 0, 18),
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "SnappingScrollArea",
            "Id",
            "idMercRows",
            "IdNode",
            false,
            "Padding",
            box(38, 38, 38, 38),
            "MinHeight",
            152,
            "MaxWidth",
            1082,
            "MaxHeight",
            590,
            "Clip",
            false,
            "VScroll",
            "idMercScroll"
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "squad",
              "array",
              function(parent, context)
                return GetPlayerMercSquads()
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "squad row",
                "MinHeight",
                168,
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList",
                  "LayoutHSpacing",
                  20
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "squad icon",
                    "Margins",
                    box(0, 0, 12, 0),
                    "MinWidth",
                    114,
                    "MinHeight",
                    136,
                    "MaxWidth",
                    114,
                    "MaxHeight",
                    136,
                    "LayoutMethod",
                    "VList",
                    "Background",
                    RGBA(32, 35, 47, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextImage",
                      "Margins",
                      box(0, 16, 0, 0),
                      "Dock",
                      "box",
                      "HAlign",
                      "center",
                      "VAlign",
                      "top",
                      "MinWidth",
                      80,
                      "MinHeight",
                      80,
                      "MaxWidth",
                      80,
                      "MaxHeight",
                      80,
                      "ImageFit",
                      "smallest",
                      "ImageColor",
                      RGBA(195, 189, 172, 255),
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        self:SetImage(context.image)
                      end
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "AutoFitText",
                      "Padding",
                      box(4, 2, 2, 4),
                      "Dock",
                      "bottom",
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "MinWidth",
                      100,
                      "MaxWidth",
                      100,
                      "TextStyle",
                      "PDABrowserNameSmall",
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        self:SetText(Untranslated(string.gsub(context.Name, "SQUAD", "")))
                      end,
                      "Translate",
                      true,
                      "TextHAlign",
                      "center",
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "merc",
                    "array",
                    function(parent, context)
                      return context.units
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return gv_UnitData[item]
                    end
                  }, {
                    PlaceObj("XTemplateTemplate", {
                      "__template",
                      "PDAMercProfileButton"
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDoubleClick(self, pos, button)",
                        "func",
                        function(self, pos, button)
                          local dlg = GetDialog(self)
                          local selectAction = dlg:ActionById("idSelectAction")
                          dlg:OnAction(selectAction)
                        end
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Margins",
                  box(0, 8, 0, 0),
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "MessengerScrollbar",
            "Id",
            "idMercScroll",
            "Dock",
            "right",
            "Target",
            "idMercRows",
            "AutoHide",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "Id",
          "idToolBar",
          "IdNode",
          false,
          "Dock",
          "bottom",
          "HAlign",
          "center",
          "LayoutHSpacing",
          32,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBar",
          "ButtonTemplate",
          "PDACommonButton"
        }, {
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idSelectAction",
            "ActionName",
            T(323391783449, "Select"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "S",
            "OnAction",
            function(self, host, source, ...)
              local mercProfiles = GetDialog(host)
              local aimEvaluation = GetDialog("PDADialog"):ResolveId("idContent"):ResolveId("idBrowserContent")
              if mercProfiles.SelectedMercId and mercProfiles.SelectedMercId ~= "" then
                local merc = gv_UnitData[mercProfiles.SelectedMercId]
                aimEvaluation:SelectMerc(merc)
              end
              mercProfiles:Close()
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idCloseAction",
            "ActionName",
            T(520021369621, "Close"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "Escape",
            "OnAction",
            function(self, host, source, ...)
              local dlg = GetDialog(host)
              dlg:Close()
            end
          })
        })
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "MercProfiles",
    "id",
    "SelectedMercId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.SelectedMercId = value
      self:ResolveId("idMercRows"):RespawnContent()
    end,
    "Get",
    function(self)
      return self.SelectedMercId
    end,
    "name",
    T(815456442215, "Selected Merc Id")
  })
})
