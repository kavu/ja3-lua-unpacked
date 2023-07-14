PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "NewGameInviteEntry",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(25, 0, 0, 0),
    "UIEffectModifierId",
    "MainMenuMainBar",
    "MinHeight",
    64,
    "MaxHeight",
    64,
    "LayoutMethod",
    "HList",
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "FXPress",
    "CheckBoxClick",
    "FXPressDisabled",
    "activityAssignSelectDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(128, 128, 128, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBlurRect",
      "Margins",
      box(0, 5, 0, 5),
      "Dock",
      "box",
      "BlurRadius",
      10,
      "Mask",
      "UI/Common/mm_panel",
      "FrameLeft",
      15,
      "FrameRight",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idEffect",
      "Margins",
      box(5, 5, 5, 5),
      "Dock",
      "box",
      "Transparency",
      179,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/screen_effect",
      "ImageScale",
      point(100000, 1000),
      "TileFrame",
      true,
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImg",
      "Dock",
      "box",
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuHighlight",
      "Id",
      "idImgBcgr",
      "Dock",
      "box",
      "Transparency",
      255,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel_selected",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idName",
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      300,
      "MaxWidth",
      300,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntry",
      "Translate",
      true,
      "WordWrap",
      false,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 0, 50, 0),
      "Dock",
      "right",
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      5
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idInvite",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        50,
        "MaxWidth",
        300,
        "HandleKeyboard",
        false,
        "TextStyle",
        "MMOptionEntryValue",
        "Translate",
        true,
        "WordWrap",
        false,
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idCheckmark",
        "Dock",
        "right",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        50,
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "HandleKeyboard",
        false,
        "Image",
        "UI/Hud/checkmark",
        "Columns",
        2
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        self.idInvite:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
        if rollover then
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
          self.idCheckmark:SetImage("UI/Hud/checkmark_rollover")
        else
          self.idImgBcgr:SetTransparency(255, 150)
          self.idCheckmark:SetImage("UI/Hud/checkmark")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "L" then
          if not GetUIStyleGamepad() then
            self.parent:SetFocus(true)
          end
          if self.Id == "idPlayer1" then
            if not Game and NetIsHost() then
              PlayFX("MainMenuButtonClick", "start")
              local column = self.idCheckmark:GetColumn()
              column = column == 1 and 2 or 1
              self.idCheckmark:SetColumn(column)
              UIHostReady(column == 2)
            else
              PlayFX("activityAssignSelectDisabled", "start")
            end
          elseif self.Id == "idPlayer2" then
            if NetIsHost() then
              local context = self.context
              local inviteSent = context and context.multiplayer_invite
              if not inviteSent then
                PlayFX("MainMenuButtonClick", "start")
                local ui = GetMultiplayerLobbyDialog()
                if netGameInfo and netGameInfo.steam_lobby then
                  SteamActivateGameOverlayToInvite(tonumber(netGameInfo.steam_lobby))
                elseif netGameInfo and netGameInfo.console_session_id then
                  if Platform.playstation then
                    PlayStationCreatePlayerInvitationDialog()
                  else
                    ShowMPLobbyError(false, Untranslated("Pending console invitation dialog implementation"))
                  end
                elseif Platform.developer then
                  ShowMPLobbyError(false, Untranslated("Could not open invite overlay. You need to be playing from steam to use this functionality."))
                else
                  ShowMPLobbyError(false, T(290418254503, "Could not open invite overlay."))
                end
              elseif inviteSent == "invited" and context.invited_player_id then
                PlayFX("MainMenuButtonClick", "start")
                UICancelInvite()
              else
                PlayFX("activityAssignSelectDisabled", "start")
              end
            elseif not Game then
              PlayFX("MainMenuButtonClick", "start")
              local column = self.idCheckmark:GetColumn()
              column = column == 1 and 2 or 1
              self.idCheckmark:SetColumn(column)
              local guestReady = column == 2
              local ui = GetMultiplayerLobbyDialog()
              local subMenu = ui and ui.idSubMenu
              local context = subMenu and subMenu.context or {}
              context.guest_ready = guestReady
              subMenu:SetContext(context, true)
              NetSend("rfnPlayerMessage", context.invited_player_id, "guest_ready", guestReady)
            else
              PlayFX("activityAssignSelectDisabled", "start")
            end
          end
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:OnMouseButtonDown(nil, "L")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Name",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idName:SetText(value)
    end,
    "Get",
    function(self)
      return self.idName:GetText()
    end,
    "name",
    T(966826023294, "Name")
  })
})
