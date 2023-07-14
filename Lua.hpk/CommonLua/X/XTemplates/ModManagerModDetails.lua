PlaceObj("XTemplate", {
  group = "ModManager",
  id = "ModManagerModDetails",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idContentWrapper"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        if GetUIStyleGamepad() then
          self:SetMinHeight(868)
          self:SetMaxHeight(868)
          self:ResolveId("idScrollAreaWrapper"):SetMaxHeight(755)
        end
        XWindow.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "content",
      "__context",
      function(parent, context)
        return GetDialogModeParam(parent)
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idContent",
      "LayoutMethod",
      "VList",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        XContextWindow.OnContextUpdate(self, context, ...)
        local spinner = self:ResolveId("idSpinner")
        spinner:SetVisible(not context.details_retrieved)
        if not context.details_retrieved then
          ModsUIRetrieveModDetails(context)
        end
        local obj = GetDialog(self).context
        self:ResolveId("idTitle"):SetText(context.DisplayName or "")
        local current_rating_win = self:ResolveId("idCurrentRating")
        if context.Rating and current_rating_win then
          for i = 1, context.Rating do
            current_rating_win[i]:SetImage("UI/Mods/rate-orange.tga")
          end
          current_rating_win:SetVisible(true)
          local ratings_total = self:ResolveId("idRatingsTotal")
          ratings_total:SetText("(" .. context.RatingsCount .. ")")
          ratings_total:SetVisible(true)
        end
        local mod_id = context.ModID
        if obj.installed_retrieved then
          local uninstalling = g_UninstallingMods[mod_id]
          local installed = obj.installed[mod_id] and not g_DownloadingMods[mod_id]
          if installed then
            local corrupted, warning, warning_id = context.Corrupted, context.Warning, context.Warning_id
            if corrupted == nil then
              local mod_def = obj.mod_defs[mod_id]
              if mod_def then
                corrupted, warning, warning_id = ModsUIGetModCorruptedStatus(mod_def)
                context.Corrupted, context.Warning, context.Warning_id = corrupted, warning, warning_id
              end
            end
            local warning_label = self:ResolveId("idWarning")
            warning_label:SetText(warning or "")
            warning_label:SetVisible((warning or "") ~= "")
            if not corrupted then
              local enabled = obj.enabled[mod_id]
              local status = self:ResolveId("idStatus")
              if status then
                if status then
                  status:SetVisible(installed)
                end
                status.idTick:SetVisible(enabled)
                status.idEnabled:SetVisible(enabled)
                status.idDisabled:SetVisible(not enabled)
              end
            end
          end
          local install_button = self:ResolveId("idInstall")
          if install_button then
            install_button:SetVisible(not installed)
            install_button:SetEnabled(not g_DownloadingMods[mod_id])
            self:ResolveId("idRemove"):SetVisible(installed and not uninstalling)
          end
          local spinner = self:ResolveId("idInstallSpinner")
          if spinner then
            spinner:SetVisible(g_DownloadingMods[mod_id] or uninstalling)
          end
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "title",
        "__class",
        "XContextWindow",
        "Dock",
        "top",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        10,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local mod_version = context.ModVersion or ""
          if mod_version ~= "" then
            self:ResolveId("idVersionWindow"):SetVisible(true)
            self:ResolveId("idVersion"):SetText("V. " .. mod_version)
          else
            self:ResolveId("idVersionWindow"):SetVisible(false)
          end
          local required_version = context.RequiredVersion
          self:ResolveId("idSuggestedVersionWindow"):SetVisible(required_version and required_version ~= "")
          self:ResolveId("idSuggestedVersion"):SetText(required_version or "")
          local line = self:ResolveId("idGameVersionLine")
          if line then
            line:SetVisible(required_version and required_version ~= "")
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idTitle",
          "VAlign",
          "center",
          "TextStyle",
          "GedTitle"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSuggestedVersionWindow",
          "Dock",
          "right",
          "VAlign",
          "bottom",
          "LayoutMethod",
          "VList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSuggestedVersion",
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "TextHAlign",
            "right",
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idVersionWindow",
          "Dock",
          "right",
          "VAlign",
          "bottom",
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idVersion",
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "TextHAlign",
            "right",
            "TextVAlign",
            "center"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "buttons and rating",
        "__class",
        "XContextWindow",
        "Dock",
        "top",
        "MinHeight",
        50,
        "MaxHeight",
        50,
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20,
        "OnContextUpdate",
        function(self, context, ...)
          self:ResolveId("idFileSizeWindow"):SetVisible(context.FileSize)
          if context.FileSize then
            self:ResolveId("idSize"):SetText(T(10487, "<FormatSize(FileSize, 2)>"))
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idWarning",
          "Padding",
          box(0, 0, 0, 0),
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Translate",
          true
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerLoadingAnim",
          "Id",
          "idInstallSpinner",
          "Dock",
          "box",
          "HAlign",
          "left",
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }),
        PlaceObj("XTemplateGroup", {
          "__condition",
          function(parent, context)
            return not context.Local
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idInstall",
            "LayoutHSpacing",
            6,
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "OnPress",
            function(self, gamepad)
              if not g_ModsBackendObj:IsLoggedIn() then
                local host = GetDialog(self)
                ModsUIOpenLoginPopup(host.idContentWrapper)
              else
                ModsUIInstallMod(self.context)
                self:SetEnabled(false)
              end
            end,
            "Translate",
            true,
            "Text",
            T(485037384930, "INSTALL")
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "SetEnabled(self, enabled)",
              "func",
              function(self, enabled)
                XTextButton.SetEnabled(self, enabled)
                self:SetDesaturation(enabled and 0 or 255)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idRemove",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "Background",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "OnPress",
            function(self, gamepad)
              ModsUIUninstallMod(self.context)
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0),
            "IconColor",
            RGBA(125, 125, 125, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "MinWidth",
            1,
            "MaxWidth",
            1,
            "Visible",
            false,
            "Background",
            RGBA(224, 224, 244, 255)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idFileSizeWindow",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10,
          "Visible",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Padding",
            box(0, 0, 0, 0),
            "VAlign",
            "center",
            "Translate",
            true,
            "Text",
            T(721998459687, "SIZE")
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "file size",
            "__class",
            "XLabel",
            "Id",
            "idSize",
            "Padding",
            box(0, 0, 0, 0),
            "VAlign",
            "center",
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Dock",
          "right",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          20,
          "Visible",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "current rating",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "Id",
              "idCurrentRating",
              "VAlign",
              "center",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              4,
              "Visible",
              false,
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return nil, 1, 5
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "CommonAssets/UI/Icons/outline star",
                  "ImageScale",
                  point(230, 230)
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Id",
              "idRatingsTotal",
              "VAlign",
              "center",
              "Visible",
              false,
              "FoldWhenHidden",
              true
            })
          }),
          PlaceObj("XTemplateGroup", {
            "__condition",
            function(parent, context)
              return not context.Local
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idRate",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "RolloverOnFocus",
              false,
              "RelativeFocusOrder",
              "new-line",
              "OnPress",
              function(self, gamepad)
                local dlg = GetDialog(self)
                if not g_ModsBackendObj:IsLoggedIn() then
                  ModsUIOpenLoginPopup(dlg.idContentWrapper)
                else
                  ModsUIChooseModRating(dlg.idContentWrapper)
                end
              end,
              "Translate",
              true,
              "Text",
              T(449539499567, "RATE")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idFlag",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "RolloverOnFocus",
              false,
              "RelativeFocusOrder",
              "new-line",
              "OnPress",
              function(self, gamepad)
                local dlg = GetDialog(self)
                ModsUIChooseFlagReason(dlg.idContentWrapper)
                dlg:UpdateActionViews(dlg)
              end,
              "Translate",
              true,
              "Text",
              T(593867358064, "REPORT")
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idScrollAreaWrapper"
      }, {
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XScrollArea",
            "Id",
            "idScrollAreaLeft",
            "IdNode",
            false,
            "MinWidth",
            974,
            "MaxWidth",
            974,
            "VScroll",
            "idScrollLeft"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              20,
              "OnContextUpdate",
              function(self, context, ...)
                XContentTemplate.OnContextUpdate(self, context, ...)
                self:SetContentTexts()
              end,
              "RespawnOnDialogMode",
              false
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open",
                "func",
                function(self, ...)
                  XContentTemplate.Open(self, ...)
                  self:SetContentTexts()
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetContentTexts",
                "func",
                function(self, ...)
                  local context = self.context
                  local description = self:ResolveId("idDescription")
                  description:SetText(context.LongDescription or "")
                  description:SetVisible(context.LongDescription)
                  if context.Thumbnail then
                    self:ResolveId("idThumbnail"):SetImage(context.Thumbnail)
                    local thumb_small = self:ResolveId("idThumbSmall")
                    if thumb_small then
                      thumb_small:SetImage(context.Thumbnail)
                    end
                  end
                  local obj = GetDialog(self).context
                  local mod_id = context.ModID
                  if obj.installed_retrieved then
                    local uninstalling = g_UninstallingMods[mod_id]
                    local installed = obj.installed[mod_id] and not g_DownloadingMods[mod_id]
                    if installed then
                      local corrupted, warning, warning_id = context.Corrupted, context.Warning, context.Warning_id
                      if not corrupted then
                        local check_button = self:ResolveId("idEnabled")
                        if check_button then
                          local enabled = obj.enabled[mod_id]
                          check_button:SetCheck(enabled)
                          check_button:SetVisible(not uninstalling)
                          check_button.idEnabled:SetVisible(enabled)
                          check_button.idDisabled:SetVisible(not enabled)
                        end
                      end
                    end
                  end
                end
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "enable button & preview"
              }, {
                PlaceObj("XTemplateWindow", {
                  "Dock",
                  "left",
                  "HAlign",
                  "left",
                  "VAlign",
                  "top"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XCheckButton",
                    "Id",
                    "idEnabled",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "OnPress",
                    function(self, gamepad)
                      ModsUIToggleEnabled(self.context, self)
                    end
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnChange(self, check)",
                      "func",
                      function(self, check)
                        self.idEnabled:SetVisible(check)
                        self.idDisabled:SetVisible(not check)
                      end
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XLabel",
                      "Id",
                      "idEnabled",
                      "Margins",
                      box(20, 0, 0, 0),
                      "Padding",
                      box(0, 0, 0, 0),
                      "Dock",
                      "right",
                      "VAlign",
                      "center",
                      "Visible",
                      false,
                      "FoldWhenHidden",
                      true,
                      "Translate",
                      true,
                      "Text",
                      T(142384930906, "Enabled")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XLabel",
                      "Id",
                      "idDisabled",
                      "Margins",
                      box(20, 0, 0, 0),
                      "Padding",
                      box(0, 0, 0, 0),
                      "Dock",
                      "right",
                      "VAlign",
                      "center",
                      "Visible",
                      false,
                      "FoldWhenHidden",
                      true,
                      "Translate",
                      true,
                      "Text",
                      T(513411835000, "Disabled")
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return context.Thumbnail or next(context.ScreenshotPaths)
                  end,
                  "__class",
                  "XImage",
                  "Id",
                  "idThumbnail",
                  "HAlign",
                  "center",
                  "MinWidth",
                  885,
                  "MinHeight",
                  440,
                  "MaxWidth",
                  885,
                  "MaxHeight",
                  440,
                  "ImageFit",
                  "smallest"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "screenshots",
                    "__condition",
                    function(parent, context)
                      return #(context.ScreenshotPaths or "") > 0
                    end,
                    "__class",
                    "XList",
                    "IdNode",
                    false,
                    "Margins",
                    box(0, 0, 0, 20),
                    "BorderWidth",
                    0,
                    "Padding",
                    box(0, 0, 0, 0),
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "HList",
                    "LayoutHSpacing",
                    15,
                    "Background",
                    RGBA(255, 255, 255, 0),
                    "FocusedBackground",
                    RGBA(235, 235, 235, 0),
                    "ForceInitialSelection",
                    true
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        local t = table.icopy(context.ScreenshotPaths)
                        table.insert(t, 1, context.Thumbnail)
                        return t
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        rawset(child, "image_path", item)
                        child:ResolveId("idLabel"):SetText(tostring(i))
                      end
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XListItem",
                        "BorderColor",
                        RGBA(0, 0, 0, 255),
                        "Background",
                        RGBA(255, 255, 255, 255),
                        "HandleMouse",
                        true
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "OnMouseButtonDown(self, pos, button)",
                          "func",
                          function(self, pos, button)
                            if button == "L" then
                              local self_idx = table.find(self.parent, self)
                              self.parent:SetSelection(self_idx)
                              return "break"
                            end
                            return XImage.OnMouseButtonDown(self, pos, button)
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "SetSelected(self, selected)",
                          "func",
                          function(self, selected)
                            if selected then
                              local preview = GetParentOfKind(self, "XImage")
                              preview:SetImage(self.image_path)
                            end
                          end
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XLabel",
                          "Id",
                          "idLabel"
                        })
                      })
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDescription"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                  "func",
                  function(self, hyperlink, argument, hyperlink_box, pos, button)
                    OpenUrl(argument)
                  end
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XSleekScroll",
            "Id",
            "idScrollLeft",
            "Dock",
            "right",
            "Target",
            "idScrollAreaLeft",
            "AutoHide",
            true
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idScrollDown",
            "ActionGamepad",
            "RightThumbDown",
            "OnAction",
            function(self, host, source, ...)
              local scroll_area = host:ResolveId("idScrollAreaLeft")
              if scroll_area:GetVisible() then
                return scroll_area:OnMouseWheelBack()
              end
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idScrollUp",
            "ActionGamepad",
            "RightThumbUp",
            "OnAction",
            function(self, host, source, ...)
              local scroll_area = host:ResolveId("idScrollAreaLeft")
              if scroll_area:GetVisible() then
                return scroll_area:OnMouseWheelForward()
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 0, 0),
          "Dock",
          "right",
          "MinWidth",
          350,
          "MaxWidth",
          350
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XScrollArea",
            "Id",
            "idScrollAreaRight",
            "IdNode",
            false,
            "VScroll",
            "idScrollRight"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false,
              "Margins",
              box(15, 0, 0, 0),
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              10,
              "OnContextUpdate",
              function(self, context, ...)
                XContentTemplate.OnContextUpdate(self, context, ...)
                self:SetContentTexts()
              end,
              "RespawnOnDialogMode",
              false
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open",
                "func",
                function(self, ...)
                  XContentTemplate.Open(self, ...)
                  self:SetContentTexts()
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetContentTexts",
                "func",
                function(self, ...)
                  local context = self.context
                  local author = context.Author or ""
                  if author ~= "" then
                    self:ResolveId("idAuthor"):SetVisible(true)
                    self:ResolveId("idAuthorName"):SetText(context.Author)
                  else
                    self:ResolveId("idAuthor"):SetVisible(false)
                  end
                  self:ResolveId("idRequirements"):SetVisible(ModsUIGetRequiredMods(context) or context.RequiredDlcs)
                  self:ResolveId("idDlcs"):SetVisible(context.RequiredDlcs)
                  self:ResolveId("idMods"):SetVisible(ModsUIGetRequiredMods(context))
                  self:ResolveId("idTags"):SetVisible(#(context.Tags or "") > 0)
                  self:ResolveId("idChangelog"):SetVisible(context.ChangeLog and 0 < #context.ChangeLog)
                  self:ResolveId("idFileSizeWindow"):SetVisible(context.FileSize)
                  if context.FileSize then
                    self:ResolveId("idSize"):SetText(T(10487, "<FormatSize(FileSize, 2)>"))
                  end
                end
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idAuthor",
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                5,
                "Visible",
                false,
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XLabel",
                  "Padding",
                  box(0, 0, 0, 0),
                  "VAlign",
                  "center",
                  "Translate",
                  true,
                  "Text",
                  T(884358339220, "AUTHOR")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XLabel",
                  "Id",
                  "idAuthorName",
                  "Padding",
                  box(0, 0, 0, 0),
                  "VAlign",
                  "center"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idRequirements",
                "LayoutMethod",
                "VList",
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "dlcs",
                  "Id",
                  "idDlcs",
                  "LayoutMethod",
                  "VList",
                  "LayoutHSpacing",
                  5,
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XLabel",
                    "Translate",
                    true,
                    "Text",
                    T(107096151285, "Required DLC")
                  }),
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return context.RequiredDlcs
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child:SetText(item)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "HandleMouse",
                      false
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "mods",
                  "Id",
                  "idMods",
                  "LayoutMethod",
                  "VList",
                  "LayoutVSpacing",
                  5,
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XLabel",
                    "Translate",
                    true,
                    "Text",
                    T(417466742687, "Required Mods")
                  }),
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return ModsUIGetRequiredMods(context)
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child:SetText(item[1])
                      if item[2] == "hard" then
                        child:SetTextStyle("ModsUIDetailsColumnItemsRed")
                      elseif item[2] == "soft" then
                        child:SetTextStyle("ModsUIDetailsColumnItemsYellow")
                      end
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "HandleMouse",
                      false
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "tags",
                "Id",
                "idTags",
                "LayoutMethod",
                "VList",
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XLabel",
                  "Translate",
                  true,
                  "Text",
                  T(939919076028, "TAGS")
                }),
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return context.Tags
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child:SetText(item)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "HandleMouse",
                    false
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "changelog",
                "Id",
                "idChangelog",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XLabel",
                  "Translate",
                  true,
                  "Text",
                  T(508028372782, "CHANGELOG")
                }),
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return context.ChangeLog
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child.idReleasedVersion:SetText(T({
                      10488,
                      "v<ModVersion> - Released <Released>",
                      ModVersion = Untranslated(item.ModVersion),
                      Released = Untranslated(item.Released)
                    }))
                    child.idDetails:SetText(item.Details)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "IdNode",
                    true,
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idReleasedVersion",
                      "HandleMouse",
                      false,
                      "Translate",
                      true
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idDetails",
                      "HandleMouse",
                      false,
                      "HideOnEmpty",
                      true
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XSleekScroll",
            "Id",
            "idScrollRight",
            "Dock",
            "right",
            "Target",
            "idScrollAreaRight",
            "AutoHide",
            true
          })
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "ModManagerLoadingAnim",
      "Id",
      "idSpinner",
      "FoldWhenHidden",
      true
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "back",
    "ActionName",
    T(389206740263, "BACK"),
    "ActionToolbar",
    "bottommenu",
    "ActionShortcut",
    "Escape",
    "ActionState",
    function(self, host)
      return ModsUIIsPopupShown(host) and "hidden"
    end,
    "OnActionEffect",
    "back",
    "OnAction",
    function(self, host, source, ...)
      if ModsUIIsPopupShown(host) then
        ModsUIClosePopup(host)
        return
      end
      XAction.OnAction(self, host, source)
    end
  }),
  PlaceObj("XTemplateGroup", {
    "__condition",
    function(parent, context)
      return GetUIStyleGamepad()
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "enable",
      "ActionName",
      T(751047175428, "Enable"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        return ModsUIShowItemAction(host, "enabled", false, host.idContent.context.ModID) or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        ModsUIToggleEnabled(GetDialogModeParam(host), host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "disable",
      "ActionName",
      T(121157779258, "Disable"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        return ModsUIShowItemAction(host, "enabled", true, host.idContent.context.ModID) or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        ModsUIToggleEnabled(GetDialogModeParam(host), host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "install",
      "ActionName",
      T(643623067322, "Install"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonX",
      "ActionState",
      function(self, host)
        local mod_id = host.idContent.context.ModID
        if g_DownloadingMods[mod_id] then
          return "disabled"
        end
        return ModsUIShowItemAction(host, "installed", false, mod_id) or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if not g_ModsBackendObj:IsLoggedIn() then
          ModsUIOpenLoginPopup(host.idContentWrapper)
        else
          ModsUIInstallMod(GetDialogModeParam(host))
        end
        host:UpdateActionViews(host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "uninstall",
      "ActionName",
      T(221390800637, "Uninstall"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonX",
      "ActionState",
      function(self, host)
        return ModsUIShowItemAction(host, "installed", true, host.idContent.context.ModID) or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        ModsUIUninstallMod(GetDialogModeParam(host))
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "rate",
      "ActionName",
      T(157897998461, "Rate Mod"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "LeftThumbClick",
      "ActionState",
      function(self, host)
        local context = GetDialogModeParam(host)
        return (context.Local or ModsUIIsPopupShown(host)) and "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if not g_ModsBackendObj:IsLoggedIn() then
          ModsUIOpenLoginPopup(host.idContentWrapper)
        else
          ModsUIChooseModRating(host.idContentWrapper)
        end
        host:UpdateActionViews(host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "flag",
      "ActionName",
      T(644441012576, "Report"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "RightThumbClick",
      "ActionState",
      function(self, host)
        local context = GetDialogModeParam(host)
        return (context.Local or ModsUIIsPopupShown(host)) and "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        ModsUIChooseFlagReason(host.idContentWrapper)
        host:UpdateActionViews(host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "back",
      "ActionName",
      T(574567507933, "Back"),
      "ActionToolbar",
      "ActionBarRight",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "ActionState",
      function(self, host)
        return not ModsUIIsPopupShown(host) or "hidden"
      end,
      "OnActionEffect",
      "back"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "popupflagselect",
      "ActionName",
      T(958743969041, "Select"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonA",
      "ActionState",
      function(self, host)
        local popup = ModsUIIsPopupShown(host)
        return popup ~= "flag" and "hidden"
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "popupflagsubmit",
      "ActionName",
      T(640607102205, "Submit"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "Start",
      "ActionState",
      function(self, host)
        local popup = ModsUIIsPopupShown(host)
        if popup ~= "flag" then
          return "hidden"
        end
        return not host.mode_param.flag_reason and "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        ModsUIFlagMod(host)
        host:UpdateActionViews(host)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "popuprateselect",
      "ActionName",
      T(958743969041, "Select"),
      "ActionToolbar",
      "ActionBarLeft",
      "ActionGamepad",
      "ButtonA",
      "ActionState",
      function(self, host)
        local popup = ModsUIIsPopupShown(host)
        return popup ~= "rate" and "hidden"
      end
    })
  })
})
