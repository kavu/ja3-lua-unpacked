PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "MPPauseHint",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return CampaignPauseReasons
    end,
    "__class",
    "XDialog",
    "Id",
    "idMPPauseHint",
    "ZOrder",
    99,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local UpdateMsgText = function(msgBox, isSaveReason)
        if isSaveReason then
          msgBox.idText:SetText(T(450754085123, "<OtherPlayerName()> is saving..."))
        else
          msgBox.idText:SetText(T(671328060836, "Game paused by <OtherPlayerName()>"))
        end
      end
      local paused, reason = IsCampaignOrGamePausedByRemotePlayerOnly()
      local isSaveReason = paused and string.match(reason or "", "SavingGame")
      local msg = self.idMsg
      if not not paused == not not msg then
        if msg then
          UpdateMsgText(msg, isSaveReason)
        end
        return
      end
      if paused then
        local insidePDA = GetParentOfKind(self, "PDAClass")
        local satelliteDialog = GetDialog("PDADialogSatellite")
        if satelliteDialog and not insidePDA then
          return
        end
        msg = XTemplateSpawn("ZuluMessageDialogTemplate", self)
        msg:SetId("idMsg")
        UpdateMsgText(msg, isSaveReason)
        msg.idTitle:SetText(T(831917786270, "Pause"))
        msg.idActionBar:SetVisible(false)
        function msg.OnShortcut()
        end
        if self.window_state == "open" then
          msg:Open()
        end
      else
        msg:Close()
      end
      self:SetVisible(paused)
      XContextWindow.OnContextUpdate(self, context, ...)
    end,
    "FocusOnOpen",
    ""
  })
})
