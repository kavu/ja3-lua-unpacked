PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDAMercContractExpirationPopup",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAMercContractExpirationPopupClass",
    "Dock",
    "box",
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "PDACampaignPausingDlg",
      "Dock",
      "ignore"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "changes observer (co-op relevant)",
      "__context",
      function(parent, context)
        return "MercHired"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:RecheckContracts()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idMain",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      615,
      "MaxWidth",
      615,
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
        "MinHeight",
        24,
        "MaxHeight",
        24
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "Title",
          "__class",
          "XText",
          "Padding",
          box(10, 0, 0, 0),
          "Dock",
          "top",
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MinHeight",
          24,
          "MaxHeight",
          24,
          "TextStyle",
          "PDAQuests_HeaderSmall",
          "Translate",
          true,
          "Text",
          T(376468518016, "MERC CONTRACTS")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 0, 8, 0),
        "Padding",
        box(5, 5, 5, 5),
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not context.release and context.expired and #context.expired > 0
          end,
          "__class",
          "XText",
          "Id",
          "idContractExpirationText",
          "Padding",
          box(10, 5, 5, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "PDARolloverTextSmaller",
          "Translate",
          true,
          "Text",
          T(297893520598, "The following mercs' contracts have expired:")
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return context.release and context.expired and #context.expired > 0
          end,
          "__class",
          "XText",
          "Id",
          "idContractExpirationTextReleaseWarning",
          "Padding",
          box(10, 5, 5, 5),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "PDARolloverTextSmaller",
          "Translate",
          true,
          "Text",
          T(237750999161, "The contracts of the following mercs will expire and they will leave Grand Chien:")
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not context.release and context.expired and #context.expired > 0
          end,
          "__class",
          "XText",
          "Padding",
          box(10, 0, 10, 10),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "PDARolloverText_AccentSmaller",
          "Translate",
          true,
          "Text",
          T(876313495572, "Warning: If you choose to close this, the mercs will leave Grand Chien")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(2, 2, 2, 2)
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context.expired and #context.expired > 0
            end,
            "__class",
            "XContextWindow",
            "Margins",
            box(0, -10, 0, 10),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            15
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "LayoutMethod",
              "Grid",
              "LayoutHSpacing",
              15,
              "LayoutVSpacing",
              15
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.expired, 1, #context.expired / 6 * 6
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetGridX(i < 7 and i % 7 or i % 7 + 1)
                  child:SetGridY(i / 7 + 1)
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "HUDMerc",
                  "LevelUpIndicator",
                  false
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              15
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.expired, #context.expired / 6 * 6 + 1
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetGridX(i < 7 and i % 7 or i % 7 + 1)
                  child:SetGridY(i / 7 + 1)
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "HUDMerc",
                  "LevelUpIndicator",
                  false
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return context.expiring and #context.expiring > 0
          end,
          "__class",
          "XText",
          "Padding",
          box(10, 5, 5, 5),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "PDARolloverTextSmaller",
          "Translate",
          true,
          "Text",
          T(347833360085, "The following mercs' contracts will expire within a day:")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(2, 2, 2, 2)
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context.expiring and #context.expiring > 0
            end,
            "__class",
            "XContextWindow",
            "Margins",
            box(0, -10, 0, 10),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            15
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "LayoutMethod",
              "Grid",
              "LayoutHSpacing",
              15,
              "LayoutVSpacing",
              15
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.expiring, 1, #context.expiring / 6 * 6
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetGridX(i < 7 and i % 7 or i % 7 + 1)
                  child:SetGridY(i / 7 + 1)
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "HUDMerc",
                  "LevelUpIndicator",
                  false
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              15
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.expiring, #context.expiring / 6 * 6 + 1
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetGridX(i < 7 and i % 7 or i % 7 + 1)
                  child:SetGridY(i / 7 + 1)
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "HUDMerc",
                  "LevelUpIndicator",
                  false
                })
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "buttons",
        "Margins",
        box(8, 0, 8, 8)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idOtherPlayerText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDAMercChatName",
          "Translate",
          true,
          "Text",
          T(714395621537, "(<red><OtherPlayerName()> is making a decision</red>)")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "RolloverAnchor",
          "center-top",
          "Id",
          "idActionBar",
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
          "idOpenAim",
          "ActionName",
          T(613948586777, "A.I.M."),
          "ActionToolbar",
          "ActionBar",
          "ActionGamepad",
          "ButtonX",
          "OnAction",
          function(self, host, source, ...)
            local pdaDiag = GetDialog("PDADialog")
            local dlg = GetDialog(host)
            local expiredMercs = dlg.context.expired
            local firstExpiredMerc = expiredMercs[1]
            firstExpiredMerc = firstExpiredMerc and firstExpiredMerc.session_id
            local _, idx = table.find_value(GetAIMScreenFilters(), "hire", true)
            CurrentAIMFilter = idx
            if not pdaDiag then
              pdaDiag = OpenDialog("PDADialog", GetInGameInterface(), {
                Mode = "browser",
                select_merc = firstExpiredMerc,
                release_expired = expiredMercs
              })
            else
              pdaDiag:SetMode("browser", {select_merc = firstExpiredMerc, release_expired = expiredMercs})
            end
            dlg:Close()
          end,
          "IgnoreRepeated",
          true,
          "__condition",
          function(parent, context)
            return not context.release
          end
        }),
        PlaceObj("XTemplateAction", {
          "RolloverTemplate",
          "RolloverGeneric",
          "RolloverDisabledText",
          T(948484491340, "Your mercs don't have any valuables to cash-in."),
          "RolloverOffset",
          box(5, 5, 5, 5),
          "ActionId",
          "idCashInValuables",
          "ActionName",
          T(557346805612, "Cash In"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "C",
          "ActionGamepad",
          "ButtonY",
          "ActionState",
          function(self, host)
            local pdaDiag = GetDialog("PDADialog")
            local dlg = GetDialog(host)
            local expiredMercs = dlg.context.expired
            if not expiredMercs then
              return "hidden"
            end
            local allMercs = GetHiredMercIds()
            local totalAmount = 0
            for i, sId in ipairs(allMercs) do
              totalAmount = totalAmount + GetValuablesWorthInMerc(sId)
            end
            if 0 < totalAmount then
              self.RolloverText = T({
                986079781110,
                "Cash in all your valuables for $<amount>.",
                amount = totalAmount
              })
              return "enabled"
            end
            return "disabled"
          end,
          "OnAction",
          function(self, host, source, ...)
            local pdaDiag = GetDialog("PDADialog")
            local dlg = GetDialog(host)
            local expiredMercs = dlg.context.expired
            if not expiredMercs then
              return
            end
            local allMercs = GetHiredMercIds()
            local totalAmount = 0
            for i, sId in ipairs(allMercs) do
              totalAmount = totalAmount + GetValuablesWorthInMerc(sId)
            end
            for i, sId in ipairs(allMercs) do
              CashInMercValuables(sId)
            end
            PlayFX("Cashin", "start")
            CombatLog("important", T({
              889335875426,
              "Cashed in all valuables. Gained <em><money(amount)></em>",
              amount = totalAmount
            }))
            XDestroyRolloverWindow()
          end,
          "IgnoreRepeated",
          true,
          "__condition",
          function(parent, context)
            return not context.release
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(483555494370, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            local dlg = GetDialog(host)
            local ctx = dlg.context
            for i, ud in ipairs(ctx.expired) do
              NetSyncEvent("ReleaseMerc", ud.session_id)
            end
            host:Close()
          end,
          "IgnoreRepeated",
          true,
          "__condition",
          function(parent, context)
            return not context.release
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idOk",
          "ActionName",
          T(283428463616, "OK"),
          "ActionToolbar",
          "ActionBar",
          "ActionGamepad",
          "ButtonX",
          "OnAction",
          function(self, host, source, ...)
            local dlg = GetDialog(host)
            dlg:Close("ok")
          end,
          "IgnoreRepeated",
          true,
          "__condition",
          function(parent, context)
            return context.release
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idCancel",
          "ActionName",
          T(764701650650, "Cancel"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            host:Close()
          end,
          "IgnoreRepeated",
          true,
          "__condition",
          function(parent, context)
            return context.release
          end
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluModalDialog.Open(self)
        if not self.context.control and self.idContactExpirationButtons then
          self.idOtherPlayerText:SetVisible(true)
          self.idOpenAimButton:SetEnabled(false)
          self.idCloseButton:SetEnabled(false)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        ObjModified(gv_Squads)
      end
    })
  })
})
