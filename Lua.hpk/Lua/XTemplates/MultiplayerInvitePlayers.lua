PlaceObj("XTemplate", {
  group = "Zulu",
  id = "MultiplayerInvitePlayers",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "ZOrder",
    150,
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SelectPlayer(self, element)",
      "func",
      function(self, element)
        local playerData = element.context
        if not playerData then
          return
        end
        self.selected_player = playerData
        element:SetFocus()
        ObjModified(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "InviteSelectedPlayer(self)",
      "func",
      function(self)
        if not self.selected_player or not netSwarmSocket then
          return
        end
        local id = self.selected_player[1]
        local name = self.selected_player[2]
        local thread_name = "InviteSelectedPlayer" .. id
        self:DeleteThread(thread_name)
        self:CreateThread(thread_name, function()
          local err, context = self:InvitePlayer(id, name)
          if err then
            ShowMPLobbyError("invite", err)
          end
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "InvitePlayer(self,id, name)",
      "func",
      function(self, id, name)
        local err, game_id
        local game_type = "CoOp"
        if NetIsHost() and Game and Game.game_type then
          NetLeaveGame()
          DoneGame()
        end
        self.pending_invite = game_type
        err = NetCall("rfnInvite", id, "account", game_type, netGameInfo and netGameInfo.name)
        if err then
          return err
        end
        local ui = GetMultiplayerLobbyDialog()
        ui = ui and ui.idSubMenu
        if not ui then
          return
        end
        local context = {}
        context.multiplayer_invite = "invited"
        context.invited_player = name
        context.invited_player_id = id
        context.game_id = game_id
        ui:SetContext(context, true)
        CloseInvites()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluModalDialog.Open(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      400,
      "MinHeight",
      400,
      "MaxWidth",
      400,
      "MaxHeight",
      400,
      "Background",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(0, 8, 0, 0),
        "HAlign",
        "center",
        "TextStyle",
        "InventoryBackpackTitle",
        "Translate",
        true,
        "Text",
        T(337390292096, "Invite Player")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "Margins",
        box(0, 30, 0, 30),
        "HAlign",
        "center",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "SnappingScrollArea",
          "Id",
          "idList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "Padding",
          box(0, 0, 0, 0),
          "LayoutVSpacing",
          3,
          "BorderColor",
          RGBA(32, 32, 32, 0),
          "Background",
          RGBA(255, 255, 255, 0),
          "HandleMouse",
          false,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "VScroll",
          "idScroll"
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return netSwarmSocket and netSwarmSocket.chat_room_guests or empty_table
            end,
            "condition",
            function(parent, context, item, i)
              return item and 2 < #item and netDisplayName ~= item[2]
            end,
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child:SetButtonText(Untranslated(item[2]))
            end
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "MainMenuButton",
              "OnPress",
              function(self, gamepad)
                GetDialog(self):SelectPlayer(self)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XZuluScroll",
            "Id",
            "idScroll",
            "Margins",
            box(0, 0, 15, 0),
            "Dock",
            "right",
            "HAlign",
            "right",
            "MaxWidth",
            5,
            "MaxHeight",
            50,
            "MouseCursor",
            "UI/Cursors/Hand.tga",
            "Target",
            "idList",
            "Max",
            50,
            "SnapToItems",
            true,
            "AutoHide",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Dock",
          "bottom",
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "LayoutVSpacing",
          30
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "PDACommonButton",
            "Id",
            "idInviteCoOp",
            "DisabledBackground",
            RGBA(130, 128, 120, 255),
            "OnPress",
            function(self, gamepad)
              GetDialog(self):InviteSelectedPlayer()
            end,
            "Text",
            T(918753699044, "Invite")
          }),
          PlaceObj("XTemplateTemplate", {
            "comment",
            "close",
            "__template",
            "PDACommonButton",
            "OnPressEffect",
            "close",
            "Text",
            T(656402173271, "Close")
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Close",
      "ActionShortcut",
      "Escape",
      "OnActionEffect",
      "close"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Invite",
      "ActionShortcut",
      "Enter",
      "OnAction",
      function(self, host, source, ...)
        host:InviteSelectedPlayer()
      end
    })
  })
})
