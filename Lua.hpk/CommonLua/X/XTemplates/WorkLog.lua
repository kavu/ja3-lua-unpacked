PlaceObj("XTemplate", {
  group = "Common",
  id = "WorkLog",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return {
        time = TimeAtNoon(),
        project = table.get(AccountStorage.WorkLogSubmissions, 1, 2),
        feature = table.get(AccountStorage.WorkLogSubmissions, 1, 3),
        member = GetHGMemberByIP(LocalIPs())
      }
    end,
    "__class",
    "XDarkModeAwareDialog",
    "Margins",
    box(0, 20, 0, 20),
    "BorderWidth",
    2,
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MaxWidth",
    940,
    "BorderColor",
    RGBA(128, 131, 136, 255)
  }, {
    PlaceObj("XTemplateLayer", {
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDarkModeAwareDialog.Open(self, ...)
        self:SetModal()
        rawset(self, "svn_log_cache", {})
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonB" or shortcut == "Escape" then
          self:Close()
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetSVNLogPath(self)",
      "func",
      function(self)
        return ConvertToOSPath("svnSrc/")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetSVNLogMessages(self, enabled)",
      "func",
      function(self, enabled)
        if not enabled then
          return {
            "<color 128 128 255>Check the box above to enable!"
          }
        end
        local member, time = self.context.member, self.context.time
        if not member then
          return {
            "<color 255 0 0>Member autodetection failed!"
          }
        end
        if self.svn_log_cache[time] then
          return self.svn_log_cache[time]
        end
        local svn_id = member.svn_id
        local date_start = os.date("%Y-%m-%d", time)
        local date_end = os.date("%Y-%m-%d", time + 86400)
        local fmt = "svn log --incremental --search=%s -r {%s}:{%s}"
        local cmd = string.format(fmt, svn_id, date_start, date_end)
        local path = self:GetSVNLogPath()
        local err, exitcode, stdout, stderr = AsyncExec(cmd, path, true, true)
        if err or exitcode ~= 0 then
          return {
            "<color 255 0 0>Error reading the SVN logs!"
          }
        end
        if not stdout then
          return {
            "<color 255 255 0>No commits on this day!"
          }
        end
        local lines = stdout:split("\n")
        local separator = string.rep("-", 72)
        local messages, curr_msg, state = {}, {}, "wait_separator"
        for i, line in ipairs(lines) do
          line = line:trim_spaces()
          if line == separator and state == "wait_separator" then
            state = "wait_details"
          elseif line == separator and state == "wait_msg_end" then
            state = "wait_details"
            table.insert(messages, table.concat(curr_msg, "\n"))
            curr_msg = {}
          elseif line:starts_with("r") and state == "wait_details" then
            state = "wait_empty_line"
          elseif line == "" and state == "wait_empty_line" then
            state = "wait_msg_end"
          elseif state == "wait_msg_end" then
            if not line:starts_with("Bug ID:") then
              table.insert(curr_msg, line)
            end
          else
            state = "wait_separator"
          end
        end
        if next(curr_msg) then
          table.insert(messages, table.concat(curr_msg, "\n"))
        end
        if not next(messages) then
          return {
            "<color 255 255 0>No commits on this day!"
          }
        else
          table.reverse(messages)
        end
        self.svn_log_cache[time] = messages
        return messages
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OpenSVNLogDialog(self)",
      "func",
      function(self)
        local path = self:GetSVNLogPath()
        local name = self.context.member.svn_id
        local fmt = "TortoiseProc /command:log /path:. /findstring:%s"
        local cmd = string.format(fmt, name)
        AsyncExec(cmd, path)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XMoveControl",
      "Dock",
      "top",
      "Background",
      RGBA(160, 160, 160, 255),
      "FocusedBackground",
      RGBA(160, 160, 160, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context.member
        end,
        "__class",
        "XText",
        "Margins",
        box(4, 2, 4, 2),
        "Dock",
        "left",
        "TextStyle",
        "GedTitle",
        "Translate",
        true,
        "Text",
        T(522818904935, "Work log for <u(member.name)> (<u(member.id)>)")
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not context.member
        end,
        "__class",
        "XText",
        "Margins",
        box(4, 2, 4, 2),
        "Dock",
        "left",
        "TextStyle",
        "GedTitle",
        "Text",
        "<color 255 0 0>Member autodetection failed - is your VPN connected?"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Padding",
        box(1, 1, 1, 1),
        "Dock",
        "right",
        "VAlign",
        "center",
        "LayoutHSpacing",
        0,
        "Background",
        RGBA(0, 0, 0, 0),
        "OnPressEffect",
        "close",
        "RolloverBackground",
        RGBA(204, 232, 255, 255),
        "PressedBackground",
        RGBA(121, 189, 241, 255),
        "TextStyle",
        "GedTitle",
        "Text",
        "X"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Content container",
      "Padding",
      box(15, 7, 15, 7),
      "Dock",
      "box",
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(255, 255, 255, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "MaxHeight",
        900,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        12,
        "VScroll",
        "idScroll"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "member",
          "__condition",
          function(parent, context)
            return config.WorkLogForOthers
          end,
          "HAlign",
          "left",
          "MinWidth",
          250,
          "MaxWidth",
          250
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Dock",
            "top",
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Member"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XCombo",
            "Id",
            "idMember",
            "Dock",
            "bottom",
            "RelativeFocusOrder",
            "next-in-line",
            "Items",
            function(self)
              return PresetsCombo("HGMember")
            end,
            "ArbitraryValue",
            false,
            "OnValueChanged",
            function(self, value)
              self.context.member_id = value
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "Date",
          "Id",
          "idDate",
          "HAlign",
          "left"
        }, {
          PlaceObj("XTemplateWindow", {
            "Dock",
            "left",
            "HAlign",
            "center",
            "MinWidth",
            250,
            "MaxWidth",
            250
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Dock",
              "top",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Date"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Padding",
              box(0, -2, 0, 0),
              "Dock",
              "left",
              "OnPress",
              function(self, gamepad)
                self.context.time = self.context.time - 86400
                XContextUpdate(self.context)
              end,
              "TextStyle",
              "GedTitle",
              "Text",
              "<<"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(10, 0, 0, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local t = os.date("!*t", context.time)
                local text = (t.wday == 1 or t.wday == 7) and "<color 255 0 0>" or ""
                self:SetText(text .. os.date("%Y-%m-%d %a", context.time))
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Padding",
              box(0, -2, 0, 0),
              "Dock",
              "right",
              "OnPress",
              function(self, gamepad)
                self.context.time = self.context.time + 86400
                XContextUpdate(self.context)
              end,
              "TextStyle",
              "GedTitle",
              "Text",
              ">>"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Margins",
            box(20, 0, 0, 0),
            "VAlign",
            "top",
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Select one project/feature for each day. If you make several submissions for a day only the last sumbission will be taken into account."
          })
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          12
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "main inputs",
            "MinWidth",
            250,
            "MaxWidth",
            250,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            12
          }, {
            PlaceObj("XTemplateWindow", {"comment", "Project"}, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XLabel",
                "Dock",
                "top",
                "FocusedBackground",
                RGBA(255, 255, 255, 255),
                "Text",
                "Project"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XCombo",
                "Id",
                "idProject",
                "RelativeFocusOrder",
                "next-in-line",
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetItems(PresetGroupsCombo("HGProjectFeature", {
                    "Idle",
                    "Vacation",
                    "Sick"
                  }))
                  self:SetValue(self.context.project or "Idle")
                end,
                "ArbitraryValue",
                false,
                "OnValueChanged",
                function(self, value)
                  self.context.project = value or "Idle"
                  XContextUpdate(self.context)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {"comment", "Feature"}, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XLabel",
                "Dock",
                "top",
                "FocusedBackground",
                RGBA(255, 255, 255, 255),
                "Text",
                "Feature"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XCombo",
                "Id",
                "idFeature",
                "RelativeFocusOrder",
                "next-in-line",
                "OnContextUpdate",
                function(self, context, ...)
                  local items = {}
                  ForEachPreset("HGProjectFeature", function(preset, group)
                    if preset.group == self.context.project then
                      local str = preset.id
                      if (preset.Comment or "") ~= "" then
                        str = str .. " - " .. preset.Comment
                      end
                      items[#items + 1] = {
                        id = preset.id,
                        text = str
                      }
                    end
                  end)
                  self:SetItems(items)
                  self:SetValue(self.context.feature or "Other")
                end,
                "DefaultValue",
                "Other",
                "ArbitraryValue",
                false,
                "OnValueChanged",
                function(self, value)
                  self.context.feature = value or "Other"
                  XContextUpdate(self.context)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "stress",
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XLabel",
                "Dock",
                "top",
                "FocusedBackground",
                RGBA(255, 255, 255, 255),
                "Text",
                "Stress"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XCombo",
                "Id",
                "idStress",
                "RelativeFocusOrder",
                "next-in-line",
                "Items",
                function(self)
                  return HGStressLevels
                end,
                "ArbitraryValue",
                false,
                "OnValueChanged",
                function(self, value)
                  self.context.stress = value
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "inline svn log"
          }, {
            PlaceObj("XTemplateWindow", {
              "Dock",
              "top",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XCheckButton",
                "Id",
                "idEnableMessages"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnChange(self, check)",
                  "func",
                  function(self, check)
                    XContextUpdate(self.context)
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XLabel",
                "FocusedBackground",
                RGBA(255, 255, 255, 255),
                "Text",
                "Show SVN Log"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplateScrollArea",
              "Id",
              "idMessagesScrollArea",
              "BorderWidth",
              1,
              "Padding",
              box(2, 2, 2, 2),
              "MinWidth",
              625,
              "MinHeight",
              126,
              "MaxWidth",
              625,
              "MaxHeight",
              126,
              "LayoutMethod",
              "VList",
              "BorderColor",
              RGBA(128, 128, 128, 255),
              "Background",
              RGBA(240, 240, 240, 255),
              "FocusedBorderColor",
              RGBA(128, 128, 128, 255),
              "FocusedBackground",
              RGBA(240, 240, 240, 255),
              "VScroll",
              "idMessagesScroll"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "RespawnContent(self)",
                "func",
                function(self)
                  if self:IsThreadRunning("SVNLog") then
                    self:DeleteThread("SVNLog")
                  end
                  self:CreateThread("SVNLog", function()
                    XContentTemplateScrollArea.RespawnContent(self)
                  end)
                end
              }),
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return GetDialog(parent):GetSVNLogMessages(parent:ResolveId("idEnableMessages"):GetCheck())
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local multiline = false
                  if multiline then
                    item = item:gsub("\n", [[

    ]])
                  else
                    local newline_idx = item:find("\n")
                    if newline_idx then
                      item = item:sub(1, newline_idx - 1) .. "..."
                    end
                  end
                  child:SetText("> " .. item)
                end
              }, {
                PlaceObj("XTemplateWindow", {"__class", "XText"})
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XSleekScroll",
              "Id",
              "idMessagesScroll",
              "Dock",
              "right",
              "Target",
              "idMessagesScrollArea"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {"comment", "comment"}, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Dock",
            "top",
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Comment (type anything here for the record)"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XMultiLineEdit",
            "Id",
            "idComment",
            "RelativeFocusOrder",
            "next-in-line",
            "OnTextChanged",
            function(self)
              self.context.comment = self:GetText()
            end,
            "AllowTabs",
            false,
            "MinVisibleLines",
            3,
            "Plugins",
            {
              "XSpellcheckPlugin"
            }
          })
        }),
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "Dock",
            "top",
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Last submissions<tab 232>Project<tab 372>Feature",
            "WordWrap",
            false
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "WorkLogSubmissions"
            end,
            "__class",
            "XContentTemplateList",
            "MinHeight",
            126,
            "BorderColor",
            RGBA(128, 128, 128, 255),
            "Background",
            RGBA(240, 240, 240, 255),
            "FocusedBorderColor",
            RGBA(128, 128, 128, 255),
            "FocusedBackground",
            RGBA(240, 240, 240, 255)
          }, {
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return AccountStorage.WorkLogSubmissions
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetText(string.format("%s<tab 140>%s<tab 230>%s<tab 370>%s%s%s", os.date("%Y-%m-%d %a", item[1] or os.time()), item[6] or "", item[2] or "", item[3] or "", (item[5] or "") ~= "" and " - " or "", item[5] or ""))
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "WordWrap",
                false
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idError",
          "TextHAlign",
          "right"
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 7, 0, 7)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "close",
            "__class",
            "XTextButton",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "right",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "OnPressEffect",
            "close",
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "Close"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "reports",
            "__class",
            "XTextButton",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "left",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "OnPress",
            function(self, gamepad)
              OpenUrl("http://kvn.haemimontgames.com/index.html")
            end,
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "Open Reports"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "svn log",
            "__condition",
            function(parent, context)
              return context.member
            end,
            "__class",
            "XTextButton",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "left",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "OnPress",
            function(self, gamepad)
              CreateRealTimeThread(function()
                GetDialog(self):OpenSVNLogDialog()
              end)
            end,
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "Open SVN Log"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "submit",
            "__class",
            "XTextButton",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "right",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "OnContextUpdate",
            function(self, context, ...)
              self:SetText(self.Text)
              self:SetEnabled(not not context.member)
              XContextControl.OnContextUpdate(self, context)
            end,
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "OnPress",
            function(self, gamepad)
              local context = self.context
              local err = HGWorkLogSubmit(context.member.id, context.member_id, context.time, context.project, context.feature, context.stress, context.comment)
              context.time = context.time + 1
              if err then
                print("Worklog submit error: " .. (err or ""))
                if err:starts_with("Error saving file") then
                  self:ResolveId("idError"):SetText("<color 255 0 0>Submission failed - please open \\\\bender.haemimontgames.com in Windows Explorer, then try again")
                else
                  self:ResolveId("idError"):SetText("<color 255 0 0>" .. err)
                end
              else
                self:ResolveId("idError"):SetText("<color 0 200 0>Submission ok")
                XContextUpdate("WorkLogSubmissions")
              end
            end,
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "Submit"
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XSleekScroll",
      "Id",
      "idScroll",
      "HAlign",
      "right",
      "Target",
      "idScrollArea",
      "SnapToItems",
      true,
      "AutoHide",
      true
    })
  })
})
