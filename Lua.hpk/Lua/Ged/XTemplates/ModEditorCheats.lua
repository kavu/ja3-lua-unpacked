PlaceObj("XTemplate", {
  group = "Zulu Dev",
  id = "ModEditorCheats",
  save_in = "GameGed",
  PlaceObj("XTemplateAction", {
    "ActionId",
    "General",
    "ActionTranslate",
    false,
    "ActionName",
    "General",
    "OnActionEffect",
    "popup",
    "OnAction",
    function(self, host, source, ...)
      local effect = self.OnActionEffect
      local param = self.OnActionParam
      if effect == "close" and host and host.window_state ~= "destroying" then
        host:Close(param ~= "" and param or nil, source, ...)
      elseif effect == "mode" and host then
        host:SetMode(param)
      elseif effect == "back" and host then
        SetBackDialogMode(host)
      else
        if effect == "popup" then
          local actions_view = GetParentOfKind(source, "XActionsView")
          if actions_view then
            actions_view:PopupAction(self.ActionId, host, source)
          else
            XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
          end
        else
        end
      end
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestExploration",
      "ActionTranslate",
      false,
      "ActionName",
      "Place Test Units",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatTestExploration")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Teleport",
      "ActionTranslate",
      false,
      "ActionName",
      "Enable Teleport (with ctrl-t) (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "Teleport")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Money",
      "ActionTranslate",
      false,
      "ActionName",
      "Add Money",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatActivate", "CheatGetMoney")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "LevelUp",
      "ActionTranslate",
      false,
      "ActionName",
      "Level Up (selected merc)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatActivate", "CheatLevelUp")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AddAmmo",
      "ActionTranslate",
      false,
      "ActionName",
      "Add All Ammo",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatActivate", "CheatAddAmmo")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AddMerc",
      "ActionTranslate",
      false,
      "ActionName",
      "Add Merc",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GetActionsHost(parent).mercs
        end,
        "__context",
        function(parent, context, item, i, n)
          return context
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.ActionId = item
          child.ActionName = item
          function child:OnAction(host, source)
            host:Op("GedOpTriggerCheat", "root", "CheatAddMerc", item)
          end
        end
      }, {
        PlaceObj("XTemplateAction", {
          "ActionTranslate",
          false
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AddItem",
      "ActionTranslate",
      false,
      "ActionName",
      "Add Item",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GetActionsHost(parent).items
        end,
        "__context",
        function(parent, context, item, i, n)
          return context
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.ActionId = item
          child.ActionName = item
          function child:OnAction(host, source)
            host:Op("GedOpTriggerCheat", "root", "CheatAddItem", item)
          end
        end
      }, {
        PlaceObj("XTemplateAction", {
          "ActionTranslate",
          false
        })
      })
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "Combat",
    "ActionTranslate",
    false,
    "ActionName",
    "Combat",
    "OnActionEffect",
    "popup",
    "OnAction",
    function(self, host, source, ...)
      local effect = self.OnActionEffect
      local param = self.OnActionParam
      if effect == "close" and host and host.window_state ~= "destroying" then
        host:Close(param ~= "" and param or nil, source, ...)
      elseif effect == "mode" and host then
        host:SetMode(param)
      elseif effect == "back" and host then
        SetBackDialogMode(host)
      else
        if effect == "popup" then
          local actions_view = GetParentOfKind(source, "XActionsView")
          if actions_view then
            actions_view:PopupAction(self.ActionId, host, source)
          else
            XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
          end
        else
        end
      end
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GodMode",
      "ActionTranslate",
      false,
      "ActionName",
      "God Mode (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "GodMode", "player1")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "InfiniteAP",
      "ActionTranslate",
      false,
      "ActionName",
      "Infinite AP (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "InfiniteAP", "player1")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AlwaysHit",
      "ActionTranslate",
      false,
      "ActionName",
      "Always Hit (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "AlwaysHit")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AlwaysMiss",
      "ActionTranslate",
      false,
      "ActionName",
      "Always Miss (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "AlwaysMiss")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ShowChanceToHit",
      "ActionTranslate",
      false,
      "ActionName",
      "Show Chance To Hit (toggle)",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatEnable", "ShowCth")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SpawnEnemy",
      "ActionTranslate",
      false,
      "ActionName",
      "Spawn Enemy",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpTriggerCheat", "root", "CheatSpawnEnemy")
      end
    })
  })
})
