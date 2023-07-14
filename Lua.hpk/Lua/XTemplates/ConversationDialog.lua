PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "ConversationDialog",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      context.em = const.BlueEMColor
      return context
    end,
    "__class",
    "ConversationDialog",
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimPortrait(self, ctrl, hide)",
      "func",
      function(self, ctrl, hide)
        local duration = self:GetAnimDuration()
        local ctrlbox = ctrl.box
        ctrl:AddInterpolation({
          id = "move",
          type = const.intRect,
          duration = duration,
          originalRect = sizebox(ctrlbox:minx() + ctrlbox:sizex(), ctrlbox:miny(), ctrlbox:sizex(), ctrlbox:sizey()),
          targetRect = ctrlbox,
          flags = not hide and const.intfInverse or nil,
          easing = "Sin in"
        })
        ctrl:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
        ctrl:AddInterpolation({
          id = "size",
          type = const.intRect,
          duration = duration,
          originalRect = ctrlbox,
          targetRect = ctrl:CalcZoomedBox(1200),
          flags = not hide and const.intfInverse or nil
        })
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimBackImg(self, hide)",
      "func",
      function(self, hide)
        local duration = self:GetAnimDuration()
        local ctrlbox = self.idDlgBackground.box
        if hide then
          self.idDlgBackground:AddInterpolation({
            id = "show",
            type = const.intAlpha,
            startValue = hide and 255 or 0,
            endValue = hide and 0 or 255,
            duration = duration,
            autoremove = true
          })
          self.idEffect:AddInterpolation({
            id = "show",
            type = const.intAlpha,
            startValue = hide and 255 or 0,
            endValue = hide and 0 or 255,
            duration = duration,
            autoremove = true
          })
        end
        self.idDlgBackground:AddInterpolation({
          id = "size",
          type = const.intRect,
          duration = duration,
          originalRect = ctrlbox,
          targetRect = sizebox(ctrlbox:minx(), ctrlbox:miny(), self.idCharacterMain.box:sizex(), ctrlbox:sizey()),
          flags = not hide and const.intfInverse or nil,
          easing = "Sin in"
        })
        self.idEffect:AddInterpolation({
          id = "size",
          type = const.intRect,
          duration = duration,
          originalRect = ctrlbox,
          targetRect = sizebox(ctrlbox:minx(), ctrlbox:miny(), self.idCharacterMain.box:sizex(), ctrlbox:sizey()),
          flags = not hide and const.intfInverse or nil,
          easing = "Sin in"
        })
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimPhrase(self, hide)",
      "func",
      function(self, hide)
        local duration = self:GetAnimDuration()
        self.idCharacterName:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
        self.idPhrase:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
        self.idCharacterNameHolder:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
        self.idUndertitleImage:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimChoices(self, hide)",
      "func",
      function(self, hide)
        local duration = self:GetAnimDuration()
        if not self.idChoices or self.idChoices.window_state == "destroying" then
          return
        end
        self.idChoices:AddInterpolation({
          id = "show",
          type = const.intAlpha,
          startValue = hide and 255 or 0,
          endValue = hide and 0 or 255,
          duration = duration,
          autoremove = true
        })
        local buttons = {
          1,
          2,
          3,
          11,
          31
        }
        for _, i in ipairs(buttons) do
          local ctrl = self["choice" .. i]
          local ctrlbox = ctrl.box
          ctrl:AddInterpolation({
            id = "show",
            type = const.intRect,
            originalRect = ctrlbox,
            targetRect = sizebox(ctrlbox:minx() - ctrlbox:sizex() / 3, ctrlbox:miny(), ctrlbox:sizex(), ctrlbox:sizey()),
            duration = duration,
            flags = not hide and const.intfInverse or nil
          })
        end
        local buttons = {
          4,
          5,
          6,
          41,
          61
        }
        for _, i in ipairs(buttons) do
          local ctrl = self["choice" .. i]
          local ctrlbox = ctrl.box
          ctrl:AddInterpolation({
            id = "show",
            type = const.intRect,
            originalRect = ctrlbox,
            targetRect = sizebox(ctrlbox:minx() + ctrlbox:sizex() / 3, ctrlbox:miny(), ctrlbox:sizex(), ctrlbox:sizey()),
            duration = duration,
            flags = not hide and const.intfInverse or nil
          })
        end
        local ctrlbox = self.idRhombus.box
        local sized = self.idRhombus:CalcZoomedBox(100)
        self.idRhombus:AddInterpolation({
          id = "show",
          type = const.intRect,
          originalRect = ctrlbox,
          targetRect = self.idRhombus:CalcZoomedBox(500),
          duration = duration,
          flags = not hide and const.intfInverse or nil
        })
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetAnimDuration(self, type)",
      "func",
      function(self, type)
        if type == "rotate" then
          return 100
        end
        return 300
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetAnimStart(self)",
      "func",
      function(self)
        if self.current_linger and self.current_linger.window_state ~= "destroying" then
          return 500 + self.current_linger.time
        end
        return 500
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetCharacter(self, position, unit_template_id, update_active, is_radio_unit)",
      "func",
      function(self, position, unit_template_id, update_active, is_radio_unit)
        local unitTemplate = UnitDataDefs[unit_template_id]
        if not unitTemplate then
          return
        end
        local portrait = unitTemplate:GetProperty("BigPortrait")
        if self.player.conv.DefaultActor == unit_template_id and self.player.conv.DefaultActorPortraitOverride then
          portrait = self.player.conv.DefaultActorPortraitOverride
        end
        local offset = const.ConversationPortraitsCustomOffset[unitTemplate.id] or 0
        local ch_offset = box(-150 + offset, 0, -offset, 0)
        if not self.unit_template_id then
          self.idCharacterMain:SetImage(portrait)
          self.idCharacterMain:SetMargins(ch_offset)
          self:UpdateLayout()
          self.idRadioImage:SetVisible(not not is_radio_unit)
          self.idDlgBackground:SetVisible(false)
          self.idEffect:SetVisible(false)
          self.unit_template_id = unit_template_id
          self:CreateThread(function()
            self:AnimPortrait(self.idCharacterMain)
            Sleep(self:GetAnimDuration())
            self.idDlgBackground:SetVisible(true)
            self:AnimBackImg()
            Sleep(self:GetAnimDuration())
            self.idPhrase:SetVisible(true)
            self.idEffect:SetVisible(true)
            self.idCharacterName:SetVisible(true)
            self.idUndertitleImage:SetVisible(true)
          end)
        elseif self.unit_template_id ~= unit_template_id or update_active then
          local old = self.unit_template_id
          self.unit_template_id = unit_template_id
          self.in_transition = true
          if old then
            self:AnimPortrait(self.idCharacterMain, "hide")
            Sleep(self:GetAnimDuration())
          end
          self.in_transition = false
          self.idCharacterMain:SetImage(portrait)
          self.idCharacterMain:SetMargins(ch_offset)
          self:UpdateLayout()
          self.idRadioImage:SetVisible(not not is_radio_unit)
          self:AnimPortrait(self.idCharacterMain)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "PlayConversationLine(self, text, wait, sound_before, sound_after, sound_type,subline)",
      "func",
      function(self, text, wait, sound_before, sound_after, sound_type, subline)
        if not self.idContent.visible then
          self:SetVisible(true)
          self.idContent:SetVisible(true)
          self:SetFocus()
        end
        if subline then
          subline.idPhrase:SetText(text)
        else
          self.idPhrase:SetText(text)
          self.idPhraseHolder:SetVisible(text ~= "")
        end
        local scroll_area = self.idScrollText
        scroll_area:SetMaxHeight(self.orig_scrollarea_maxheight or scroll_area.MaxHeight)
        scroll_area:SetMargins(self.orig_scrollarea_margins or scroll_area.Margins)
        self:InvalidateLayout()
        self.phrase_start_time = now()
        if GetConvoSyncDataForState(self.player, 1) then
          return
        end
        local sound_handle
        if wait or sound_before or sound_after then
          self.waiting_voiceover = true
          if sound_before then
            local sample = string.gsub(sound_before, "(.%w*)$", "")
            sound_handle = PlaySound(sample, sound_type or "Conversations")
            local sleep = GetSoundDuration(sound_handle) or 1
            WaitMsg(self, sleep)
          end
          if self.waiting_voiceover then
            g_Voice:Play(text, nil, "Conversations", nil, nil, nil, function()
              DelayedCall(350, function()
                if self.waiting_voiceover then
                  Msg(self, "end")
                end
              end)
            end)
            WaitMsg(self)
          end
          if self.waiting_voiceover and sound_after then
            local sample = string.gsub(sound_after, "(.%w*)$", "")
            sound_handle = PlaySound(sample, sound_type or "Conversations")
            local sleep = GetSoundDuration(sound_handle)
            WaitMsg(self, sleep)
          end
          self.waiting_voiceover = false
        else
          g_Voice:Play(text, nil, "Conversations")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ClearKeywords(self, phrase_choices_available)",
      "func",
      function(self, phrase_choices_available)
        self.anim_hide = true
        self:AnimChoices("hide")
        Sleep(self:GetAnimDuration())
        self.anim_hide = false
        for i = 1, 6 do
          local choice = self["choice" .. i]
          choice:SetRolloverText("")
          choice:SetVisible(false, true)
          choice.idText:SetText("")
        end
        local additional = {
          "11",
          "31",
          "41",
          "61"
        }
        for _, i in ipairs(additional) do
          local choice = self["choice" .. i]
          choice:SetRolloverText("")
          choice:SetVisible(false, true)
          choice.idText:SetText("")
        end
        self.has_back_phrase = false
        self.has_goodbye_phrase = false
        self.idChoices:SetVisible(false)
        if phrase_choices_available then
          self:DeleteThread("ShowChoices")
          self:CreateThread("ShowChoices", function()
            if self.waiting_voiceover then
              WaitMsg(self)
            end
            self:AnimChoices()
            self.idChoices:SetVisible(self.unit_template_id, true)
          end)
        end
        self.phrase_choices_available = phrase_choices_available
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "FillKeywords(self, position, keyword_data, nLeft, nRight)",
      "func",
      function(self, position, keyword_data, nLeft, nRight)
        local idxs
        if position == "left" then
          idxs = {
            {2},
            {11, 31},
            {
              1,
              2,
              3
            }
          }
          idxs = idxs[#keyword_data]
        elseif position == "right" then
          idxs = {
            {5},
            {41, 61},
            {
              4,
              5,
              6
            }
          }
          idxs = idxs[#keyword_data]
        elseif position == "right-to-left" then
          idxs = {
            6,
            5,
            4,
            3,
            2,
            1
          }
        else
          idxs = {
            1,
            2,
            3,
            4,
            5,
            6
          }
        end
        local mousePos = terminal.GetMousePos()
        for i, data in ipairs(keyword_data) do
          local selection_idx = idxs[i] or 6
          local choice = self["choice" .. (idxs[i] or 6)]
          local text = data.keyword_text
          choice.idText:SetTextStyle("ConversationChoiceNormal")
          rawset(choice, "StarImage", data.rollover_text and data.rollover_text ~= "")
          choice:SetConversationRolloverText(data.rollover_text or "")
          local state = data.visual_state
          choice:SetText(text)
          rawset(choice.idText, "dimmed", state == "dimmed")
          choice.idText:OnSetRollover(false)
          choice:SetEnabled(state ~= "disabled")
          choice:SetVisible(true)
          choice:SetOnPressParam(data.keyword)
          choice.branch_icon = data.branch_icon or ""
          if data.keyword == "Back" then
            self.has_back_phrase = true
            choice.branch_icon = "conversation_back"
          elseif data.keyword == "Goodbye" then
            self.has_goodbye_phrase = true
            choice.branch_icon = "conversation_goodbye"
          end
          local selection_data = ConversationGetCircleSelectionImage(nLeft, nRight, selection_idx <= 3 and "left" or "right", selection_idx <= 3 and selection_idx or selection_idx - 3)
          choice.selection_image_idx = selection_data and selection_data[1]
          choice.selection_image_flip = selection_data and selection_data[2]
          choice.selection_idx = selection_idx
          if choice:MouseInWindow(mousePos) or self.selected_phrase_idx and self.selected_phrase_idx == (idxs[i] or 6) then
            choice:OnSetRollover(true)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetDebugData(self, data, merc_id, conv_id)",
      "func",
      function(self, data, merc_id, conv_id)
        local btn = rawget(self, "idDebugButton")
        if btn then
          function self.idDebugButton.OnPress(button)
            OpenConversationDebugPopup(button, data, merc_id, conv_id)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "PhraseChoice(self, phrase)",
      "func",
      function(self, phrase)
        if self.window_state == "destroying" then
          return
        end
        if self.player.is_line_paused then
          return
        end
        NetSyncEvent("PhraseChoice", phrase, netUniqueId, self.player.current_phrase_id, self.player.executing_current_phrase_id, self.player.current_node_phrase_id, self.player.current_line_idx, self.player.is_line_paused)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "WaitPhraseChoice(self, meta)",
      "func",
      function(self, meta)
        self.phrase_chosen = false
        local ok = true
        local keyword
        while ok and not keyword do
          ok, keyword = WaitMsg(self)
          if meta == "end" then
            break
          end
        end
        if netInGame and not self:IsUIControllable() then
          if self.current_linger and self.current_linger.window_state ~= "destroying" then
            self.current_linger:delete()
            self.current_linger = false
          end
          for i = 1, 6 do
            local choice = self["choice" .. i]
            local ckeyword = choice.OnPressParam
            choice:SetVisible(false)
            if ckeyword == keyword then
              local linger = XTemplateSpawn("XTextLinger", self)
              linger:Clone(choice.idText)
              linger:Open()
              linger:LingerFor(const.UIButtonStay, choice.FadeOutTime)
              self.current_linger = linger
              break
            end
          end
          self.idChoices:SetVisible(false, true)
        end
        return keyword
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self)
        CreateRealTimeThread(function()
          Pause("conversation-dialog")
          SetCampaignSpeed(0, GetUICampaignPauseReason("Conversation"))
        end)
        self.can_control = self.context and self.context.can_control
        self.radio_conversation = self.context and self.context.radio_conversation
        local cond = self:ResolveId("idOtherPlayerText")
        if not self:IsUIControllable() then
          cond:SetText(T(123871801284, "<OtherPlayerName()> controls this conversation."))
        end
        self.originalConversationStregth = DuckingParams.Conversations.Strength
        ChangeDuckingPreset("Conversations", false, false, false, false, 100000)
        PlayFX("ConversationDialog", "start", self.idParticles, GetLightModelRegion())
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        g_Voice:Stop(0)
        ChangeDuckingPreset("Conversations", false, false, false, false, self.originalConversationStregth)
        PlayFX("ConversationDialog", "end", self.idParticles, GetLightModelRegion())
        local args = {
          ...
        }
        if not self:IsThreadRunning("close") then
          self:CreateThread("close", function()
            self:AnimPortrait(self.idCharacterMain, "hide")
            self:AnimBackImg("hide")
            self:AnimPhrase("hide")
            self:AnimChoices("hide")
            Sleep(self:GetAnimDuration())
            XDialog.Close(self, table.unpack(args))
          end, self, args)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete()",
      "func",
      function()
        Resume("conversation-dialog")
        SetCampaignSpeed(nil, GetUICampaignPauseReason("Conversation"))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if button ~= "L" or not self:IsUIControllable() then
          return
        end
        if self.player.is_line_paused then
          NetSyncEvent("ConversationUnpause", self.player:GetState())
        end
        if not self.phrase_choices_available and self.window_state ~= "destroying" and self.phrase_start_time and now() > self.phrase_start_time + const.UIButtonPressDelay then
          self:PhraseChoice()
          return "break"
        end
        return XDialog.OnMouseButtonDown(self, pos, button)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if self.window_state == "destroying" then
          return
        end
        local indexReplacements = {}
        for i = 1, 6 do
          local ctrl = self["choice" .. i]
          if ctrl:GetVisible() then
            indexReplacements[i] = i
          else
            local ctrlReplace = self["choice" .. tostring(i) .. tostring(1)]
            if ctrlReplace and ctrlReplace:GetVisible() then
              indexReplacements[i] = i * 10 + 1
            else
              indexReplacements[i] = false
            end
          end
        end
        local prev
        if shortcut == "+LeftThumbUpLeft" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[1]
        elseif shortcut == "+LeftThumbLeft" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[2]
        elseif shortcut == "+LeftThumbDownLeft" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[3]
        elseif shortcut == "+LeftThumbUpRight" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[4]
        elseif shortcut == "+LeftThumbRight" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[5]
        elseif shortcut == "+LeftThumbDownRight" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = indexReplacements[6]
        elseif shortcut == "+LeftThumbDown" or shortcut == "+LeftThumbUp" then
          prev = self.selected_phrase_idx
          self.selected_phrase_idx = false
        end
        if GetUIStyleGamepad() then
          if self.selected_phrase_idx then
            self.last_valid_selected_phrase_idx = self.selected_phrase_idx
          end
          local gamepadState = GetActiveGamepadState()
          if gamepadState.LeftThumb == point20 and not prev and not self.selected_phrase_idx and self.last_valid_selected_phrase_idx then
            prev = self.selected_phrase_idx
            self.selected_phrase_idx = self.last_valid_selected_phrase_idx
          end
        end
        if shortcut == "RightThumbUp" then
          local scroll = self.idScrollText
          scroll:ScrollUp()
          return "break"
        elseif shortcut == "RightThumbDown" then
          local scroll = self.idScrollText
          scroll:ScrollDown()
          return "break"
        end
        if prev and prev ~= self.selected_phrase_idx then
          local ctrl = self["choice" .. prev]
          if ctrl:GetVisible() then
            ctrl:SetRollover(false)
            ctrl:OnSetRollover(false)
          end
        end
        if self.selected_phrase_idx then
          local ctrl = self["choice" .. self.selected_phrase_idx]
          if ctrl:GetVisible() then
            ctrl:SetRollover(true)
            if shortcut == "+ButtonA" then
              ctrl:OnPress()
              ctrl:SetRollover(false)
              self.selected_phrase_idx = false
              self.last_valid_selected_phrase_idx = false
              self.idRhombusSel:LockRotation(true)
            end
          else
            ctrl:SetRollover(true)
          end
          return "break"
        end
        local pressA = shortcut == "+ButtonA" and self:IsUIControllable()
        if pressA then
          local phrase = self:ResolveId("idPhrase")
          if phrase:GetThread("effect-shutoff") then
            return "break"
          end
          if phrase:GetThread("effect") then
            return "break"
          end
          if self.player.is_line_paused then
            NetSyncEvent("ConversationUnpause", self.player:GetState())
          end
        end
        local delayPassed = self.phrase_start_time and now() > self.phrase_start_time + const.UIButtonPressDelay
        if not self.phrase_choices_available and delayPassed then
          if GetUIStyleGamepad() then
            if shortcut == "+ButtonA" or shortcut == "+ButtonB" then
              self:PhraseChoice()
              return "break"
            end
          elseif shortcut and string.starts_with(shortcut, "+") then
            self:PhraseChoice()
            return "break"
          end
        end
        if pressA or shortcut == "-ButtonA" then
          return "break"
        end
        return XDialog.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetupBackgroundSizeAndScrolling(self, ctrl)",
      "func",
      function(self, ctrl)
        local dlg = self
        local scroll_area = dlg.idScrollText
        dlg.orig_scrollarea_maxheight = dlg.orig_scrollarea_maxheight or scroll_area.MaxHeight
        dlg.orig_scrollarea_margins = dlg.orig_scrollarea_margins or scroll_area.Margins
        local max_margin_cut_y = 14
        local scroll_range = MulDivRound(scroll_area.scroll_range_y - scroll_area.content_box:sizey(), 1000, ctrl.scale:y())
        if 0 < scroll_range and max_margin_cut_y >= scroll_range then
          local x1, y1, x2, y2 = dlg.orig_scrollarea_margins:xyxy()
          local new_margins = box(x1, y1, x2, y2 - scroll_range / 2)
          if new_margins ~= scroll_area.Margins then
            scroll_area:SetMargins(new_margins)
            scroll_area:SetMaxHeight(dlg.orig_scrollarea_maxheight + scroll_range)
            return
          end
        end
        local back_image = dlg.idDlgBackground
        local char_image = dlg.idCharacterMain
        local text_content = dlg.idTextContent
        local charOffset, verticalOffset = ScaleXY(ctrl.scale, -char_image.Margins:minx(), 4)
        local x = char_image.box:minx() + charOffset
        local y = text_content.box:miny() - verticalOffset
        local width, _ = ScaleXY(ctrl.scale, back_image.MinWidth, 0)
        local height = text_content.box:sizey()
        back_image:SetBox(x, y, width, height)
        back_image:ResolveId("idEffect"):SetBox(x, y, width, height)
        local sbWidth = ScaleXY(self.scale, 7, 240)
        local spcX, spcY = ScaleXY(self.scale, 6, 6)
        local yOffset = self.idPhraseHolder.box:maxy() - y - ScaleXY(self.scale, 8) + spcY
        local sbHeight = height - yOffset - spcY
        dlg.idScrollbar:SetBox(x + width - sbWidth - spcX, y + yOffset, sbWidth, sbHeight)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKbdKeyDown(self, vkey)",
      "func",
      function(self, vkey)
        local dlg = GetDialog(self)
        if dlg and not dlg:IsUIControllable() then
          return
        end
        if not self.phrase_choices_available and self.window_state ~= "destroying" and self.phrase_start_time and now() > self.phrase_start_time + const.UIButtonPressDelay and (vkey == const.vkSpace or vkey == const.vkEnter or vkey == const.vkEsc) then
          if self.player.is_line_paused then
            NetSyncEvent("ConversationUnpause", self.player:GetState())
          end
          self:PhraseChoice()
          return "break"
        end
        if vkey == const.vkEsc then
          return "break"
        end
        return XDialog.OnKbdKeyDown(self, vkey)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "InitiatePhraseRolloverFadeout",
      "func",
      function(self, ...)
        local dlg = GetDialog(self)
        local callback = function(ctrl)
          if ctrl.window_state ~= "destroying" then
            ctrl:ResolveId("idPhraseRollover"):SetText("")
            ctrl:ResolveId("idPhraseRolloverFrame"):UpdateAnimation(false, false, "instant")
          end
        end
        dlg.idPhraseRolloverFrame:SetHandleMouse(true)
        function dlg.idPhraseRolloverFrame:OnMouseButtonDown(pt, button)
          if button == "L" then
            dlg.idPhraseRolloverFrame:SetFadeOutTime(200)
            dlg.idPhraseRolloverFrame:SetHandleMouse(false)
            dlg.idPhraseRolloverFrame.OnSetRollover = nil
            dlg.idPhraseRolloverFrame.OnMouseButtonDown = nil
            dlg:DeleteThread("FadeoutPhraseRollover")
            self:SetVisible(false, false, callback)
            return "break"
          end
        end
        dlg:CreateThread("FadeoutPhraseRollover", function()
          Sleep(5000)
          dlg.idPhraseRolloverFrame:SetFadeOutTime(3000)
          dlg.idPhraseRolloverFrame:SetVisible(false, false, callback)
          function dlg.idPhraseRolloverFrame:OnSetRollover(rollover)
            dlg.idPhraseRolloverFrame:SetFadeOutTime(1500)
            self:SetVisible(rollover, false, not rollover and callback)
          end
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "StopPhraseRolloverFadeout",
      "func",
      function(self, ...)
        local dlg = GetDialog(self)
        dlg.idPhraseRolloverFrame:SetFadeOutTime(200)
        dlg.idPhraseRolloverFrame:SetHandleMouse(false)
        dlg.idPhraseRolloverFrame.OnSetRollover = nil
        dlg.idPhraseRolloverFrame.OnMouseButtonDown = nil
        dlg.idPhraseRolloverFrame:SetVisible(true, "instant")
        dlg.idPhraseRollover:SetText("")
        dlg:DeleteThread("FadeoutPhraseRollover")
      end
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "activate Back or Goodbye keywords",
      "ActionId",
      "Close",
      "ActionName",
      T(963235061832, "Close"),
      "ActionShortcut",
      "Escape",
      "OnAction",
      function(self, host, source, ...)
        if not host:IsUIControllable() then
          return
        end
        if host.has_back_phrase then
          host:PhraseChoice("Back")
        elseif host.has_goodbye_phrase then
          host:PhraseChoice("Goodbye")
        end
      end
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBlurRect",
      "TintColor",
      RGBA(255, 255, 255, 255),
      "BlurRadius",
      10,
      "Desaturation",
      60
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XControl",
      "Id",
      "idContent",
      "IdNode",
      false,
      "Visible",
      false
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "GetMouseTarget(self, pt)",
        "func",
        function(self, pt)
          local scrollbar = self:ResolveId("idScrollbar")
          if scrollbar:MouseInWindow(pt) then
            return scrollbar, scrollbar:GetMouseCursor()
          end
          return XControl.GetMouseTarget(self, pt)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return Platform.developer or IsModEditorOpened()
        end,
        "DrawOnTop",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idDebugButton",
          "Margins",
          box(50, 50, 50, 50),
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "Image",
          "CommonAssets/UI/Ged/help"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "MinWidth",
        1445,
        "MinHeight",
        750,
        "MaxWidth",
        1445,
        "MaxHeight",
        750
      }, {
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "left",
          "VAlign",
          "top",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          50
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idCharacterMain",
            "Margins",
            box(-150, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "MinWidth",
            470,
            "MaxWidth",
            470,
            "MaxHeight",
            750,
            "UseClipBox",
            false,
            "DrawOnTop",
            true,
            "ChildrenHandleMouse",
            false,
            "Image",
            "UI/Mercs/Tex",
            "ImageRect",
            box(0, 0, 2000, 1500),
            "ImageScale",
            point(650, 650)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idGradient",
            "Margins",
            box(-1000, 450, -1000, 0),
            "Dock",
            "box",
            "VAlign",
            "bottom",
            "UseClipBox",
            false,
            "ChildrenHandleMouse",
            false,
            "Image",
            "UI/Conversation/Gradient",
            "ImageFit",
            "stretch-x"
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 0, 60, 40),
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "MinWidth",
            1000,
            "MinHeight",
            535,
            "MaxWidth",
            1000,
            "MaxHeight",
            535,
            "OnLayoutComplete",
            function(self)
              local size = terminal.desktop.box:size()
              self:ResolveId("idParticles"):SetBox(0, 0, size:x(), size:y())
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "Id",
              "idTextContent",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Id",
                  "idEffect",
                  "Transparency",
                  170,
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
                  "XImage",
                  "UIEffectModifierId",
                  "MainMenuMainBar",
                  "Id",
                  "idDlgBackground",
                  "IdNode",
                  false,
                  "HAlign",
                  "left",
                  "VAlign",
                  "center",
                  "MinWidth",
                  1445,
                  "MaxWidth",
                  1445,
                  "OnLayoutComplete",
                  function(self)
                    local dlg = GetDialog(self)
                    dlg:SetupBackgroundSizeAndScrolling(self)
                  end,
                  "Background",
                  RGBA(32, 35, 47, 255),
                  "Transparency",
                  50,
                  "ImageFit",
                  "stretch-y"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XFrame",
                    "IdNode",
                    false,
                    "Margins",
                    box(-8, -15, -8, -5),
                    "HAlign",
                    "right",
                    "VAlign",
                    "top",
                    "UseClipBox",
                    false,
                    "Background",
                    RGBA(195, 189, 172, 255),
                    "FocusedBackground",
                    RGBA(255, 255, 255, 0),
                    "Image",
                    "UI/Conversation/T_Choice_Rollover_Background"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idOtherPlayerText",
                      "UseClipBox",
                      false,
                      "FoldWhenHidden",
                      true,
                      "FadeInTime",
                      200,
                      "FadeOutTime",
                      200,
                      "HandleKeyboard",
                      false,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "ConversationCondition",
                      "Translate",
                      true,
                      "HideOnEmpty",
                      true,
                      "TextHAlign",
                      "right",
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XZuluScroll",
                    "Id",
                    "idScrollbar",
                    "Dock",
                    "ignore",
                    "HAlign",
                    "right",
                    "Background",
                    RGBA(68, 72, 80, 255),
                    "Target",
                    "idScrollText",
                    "AutoHide",
                    true
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idPhraseHolder",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idCharacterNameHolder",
                  "Margins",
                  box(0, -2, 0, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idCharacterName",
                    "Margins",
                    box(0, 0, 0, -20),
                    "FadeInTime",
                    100,
                    "FadeOutTime",
                    100,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "ConversationName",
                    "Translate",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idRadioImage",
                    "Margins",
                    box(-50, -50, 0, 0),
                    "Dock",
                    "left",
                    "MaxHeight",
                    10,
                    "Visible",
                    false,
                    "FadeInTime",
                    100,
                    "FadeOutTime",
                    100,
                    "Image",
                    "UI/Hud/radio",
                    "ImageScale",
                    point(500, 500)
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Id",
                  "idUndertitleImage",
                  "Margins",
                  box(0, 10, 0, 8),
                  "Visible",
                  false,
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(2, 0, 2, 0),
                  "SqueezeY",
                  false
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XScrollArea",
                "Id",
                "idScrollText",
                "IdNode",
                false,
                "Margins",
                box(0, 6, 0, 20),
                "MaxHeight",
                135,
                "OnLayoutComplete",
                function(self)
                  local dlg = GetDialog(self)
                  dlg:SetupBackgroundSizeAndScrolling(self)
                end,
                "LayoutMethod",
                "VList",
                "VScroll",
                "idScrollbar",
                "ScrollInterpolationTime",
                250
              }, {
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    context.em = "<color 196 175 117>"
                    return context
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idPhrase",
                  "Padding",
                  box(2, 0, 2, 2),
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "FadeInTime",
                  100,
                  "FadeOutTime",
                  100,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "ConversationPhrase",
                  "Translate",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idInterjectionContainer",
                  "LayoutMethod",
                  "VList",
                  "LayoutVSpacing",
                  -5,
                  "UseClipBox",
                  false
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "Positioned in parent's OnLayoutComplete",
              "__class",
              "XControl",
              "Id",
              "idParticles",
              "Dock",
              "ignore",
              "HandleKeyboard",
              false,
              "HandleMouse",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, 50),
              "Dock",
              "box",
              "HAlign",
              "left",
              "VAlign",
              "bottom",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Id",
                "idPhraseRolloverFrame",
                "IdNode",
                false,
                "UseClipBox",
                false,
                "Visible",
                false,
                "Background",
                RGBA(27, 31, 45, 255),
                "FadeInTime",
                200,
                "FadeOutTime",
                200,
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "DisabledBackground",
                RGBA(80, 80, 75, 255)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idKeywordRollover",
                  "UseClipBox",
                  false,
                  "FadeOutTime",
                  200,
                  "HandleKeyboard",
                  false,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "ConversationChoiceRollover",
                  "Translate",
                  true,
                  "HideOnEmpty",
                  true,
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idPhraseRollover",
                  "UseClipBox",
                  false,
                  "FadeOutTime",
                  200,
                  "HandleKeyboard",
                  false,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "ConversationChoiceRollover",
                  "Translate",
                  true,
                  "HideOnEmpty",
                  true,
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "UpdateAnimation(self, kwVisible, phVisible, instant)",
                  "func",
                  function(self, kwVisible, phVisible, instant)
                    self:DeleteThread("frame_animation")
                    self:CreateThread("frame_animation", function()
                      if not instant then
                        Sleep(100)
                      end
                      local keywordWnd = self[1]
                      keywordWnd:SetVisible(kwVisible)
                      local phraseWnd = self[2]
                      phraseWnd:SetVisible(phVisible)
                      local bgUnfolded = kwVisible or phVisible
                      if rawget(self, "unfolded") == bgUnfolded then
                        return
                      end
                      rawset(self, "unfolded", bgUnfolded)
                      self:SetVisible(true)
                      local bb = self.box
                      local centerx = bb:Center():x()
                      local dlg = GetDialog(self)
                      local duration = dlg:GetAnimDuration()
                      self:AddInterpolation({
                        id = "size",
                        type = const.intRect,
                        duration = instant and 0 or bgUnfolded and MulDivRound(duration, 70, 100) or MulDivRound(duration, 40, 100),
                        originalRect = bb,
                        targetRect = sizebox(centerx, bb:miny(), 0, bb:sizey()),
                        flags = bgUnfolded and const.intfInverse or nil
                      })
                    end)
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idChoices",
                "HAlign",
                "left",
                "VAlign",
                "bottom",
                "LayoutMethod",
                "VList",
                "Visible",
                false,
                "FadeOutTime",
                300
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetVisible(self, visible)",
                  "func",
                  function(self, visible)
                    XWindow.SetVisible(self, visible)
                    if visible then
                      local node = self:ResolveId("node")
                      local arrow = node.idRhombusSel
                      arrow:SetVisible(false)
                      arrow:StartFollowThread()
                    end
                  end
                }),
                PlaceObj("XTemplateWindow", nil, {
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idRhombus",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "MinWidth",
                    117,
                    "MinHeight",
                    117,
                    "MaxWidth",
                    117,
                    "MaxHeight",
                    117,
                    "DrawOnTop",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idRhombusSel",
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "UseClipBox",
                      false,
                      "Visible",
                      false,
                      "Image",
                      "UI/Conversation/T_Dialogue_Arrow"
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "PointTo(self, angle)",
                        "func",
                        function(self, angle)
                          local old = self:GetAngle()
                          local dlg = GetDialog(self)
                          angle = AngleNormalize(angle)
                          local newAngle = AngleDiff(angle, old)
                          newAngle = old + newAngle
                          self:SetAngle(newAngle)
                          self:AddInterpolation({
                            id = "rotate_arrow",
                            type = const.intRotate,
                            duration = dlg:GetAnimDuration("rotate"),
                            center = self.box:Center(),
                            startAngle = old,
                            endAngle = newAngle,
                            autoremove = true,
                            easing = "Linear"
                          })
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "LockRotation(self, lock)",
                        "func",
                        function(self, lock)
                          rawset(self, "lock", lock)
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "StartFollowThread(self)",
                        "func",
                        function(self)
                          local dlg = GetDialog(self)
                          local rotateTime = dlg:GetAnimDuration("rotate")
                          self:DeleteThread("follow-mouse")
                          local initialAngle = false
                          self:CreateThread("follow-mouse", function()
                            while self.window_state ~= "destroying" do
                              Sleep(rotateTime)
                              local angle
                              if GetUIStyleGamepad() then
                                local state = GetActiveGamepadState()
                                local leftThumbPos = state.LeftThumb
                                angle = AngleNormalize(5400 - CalcOrientation(leftThumbPos))
                              else
                                local mousePos = terminal.GetMousePos()
                                local myCenter = self.box:Center()
                                mousePos = mousePos - myCenter
                                angle = atan(mousePos:y(), mousePos:x()) + 5400
                              end
                              if not rawget(self, "lock") then
                                self:PointTo(angle)
                              end
                              if not initialAngle then
                                initialAngle = angle
                              elseif initialAngle ~= angle and not self.visible then
                                self:SetVisible(true)
                              end
                            end
                          end)
                        end
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "DrawOnTop",
                      true
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Id",
                        "idInnerCircle",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "Image",
                        "UI/Conversation/T_Wheel_InnerCircle"
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Id",
                        "idStoryBranch",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "Visible",
                        false,
                        "Image",
                        "UI/Conversation/conversation_threaten",
                        "DisabledImageColor",
                        RGBA(80, 80, 75, 255)
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idButtonsHolder",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnButtonRollover(self, child, rollover, flip, pos)",
                      "func",
                      function(self, child, rollover, flip, pos)
                        if child.window_state == "destroying" then
                          return
                        end
                        local dlg = GetDialog(self)
                        local context = dlg:GetContext()
                        local rhombus_sel = self:ResolveId("idRhombusSel")
                        rhombus_sel:SetEnabled(child:GetEnabled())
                        local selected = rollover and child.selection_idx
                        rhombus_sel:LockRotation(selected)
                        if selected then
                          rhombus_sel:PointTo(ConversationGetCircleAngle(selected))
                        end
                        local keywordWnd = dlg.idKeywordRollover
                        local phraseWnd = dlg.idPhraseRollover
                        local frameWnd = keywordWnd.parent
                        local text = child:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText
                        local textToShow = rollover and text and text ~= "" and " * " .. text
                        if textToShow then
                          keywordWnd:SetText(textToShow)
                          GetDialog(self):StopPhraseRolloverFadeout()
                        end
                        local keywordVisible = not not textToShow
                        local phraseRolloverText = phraseWnd:GetText()
                        phraseRolloverText = phraseRolloverText and phraseRolloverText ~= ""
                        local phraseVisible = phraseRolloverText and not textToShow
                        frameWnd:UpdateAnimation(keywordVisible, phraseVisible)
                        local branch = self:ResolveId("idStoryBranch")
                        branch:SetVisible(rollover and child.branch_icon and child.branch_icon ~= "")
                        branch:SetEnabled(child:GetEnabled())
                        if child.branch_icon and child.branch_icon ~= "" then
                          branch:SetImage(StoryBranchIcons[child.branch_icon].icon or "")
                          branch:SetTransparency(child.idText.dimmed and 180 or 0)
                        end
                        local controllable = dlg:IsUIControllable()
                        if controllable then
                          local cond = self:ResolveId("idOtherPlayerText")
                          cond:SetText("")
                        end
                        local childIsAdvised = child.OnPressParam == g_CoOpConversationOptionAdvice
                        child:SetRolloverMode(rollover or childIsAdvised)
                      end
                    }),
                    PlaceObj("XTemplateWindow", {"Dock", "left"}, {
                      PlaceObj("XTemplateWindow", {
                        "Dock",
                        "box",
                        "MinWidth",
                        500,
                        "MaxWidth",
                        500,
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        10
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice1",
                          "VAlign",
                          "bottom",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          T(nil),
                          "Align",
                          "left"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, true, 1)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice2",
                          "VAlign",
                          "center",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          T(nil),
                          "Align",
                          "left"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, true, 2)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice3",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "Align",
                          "left"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, true, 3)
                            end
                          })
                        })
                      }),
                      PlaceObj("XTemplateWindow", {
                        "Dock",
                        "box",
                        "VAlign",
                        "center",
                        "MinWidth",
                        500,
                        "MaxWidth",
                        500,
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        10
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice11",
                          "VAlign",
                          "bottom",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          "",
                          "Align",
                          "left"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, true, 1)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice31",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "Align",
                          "left"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, true, 3)
                            end
                          })
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {"Dock", "right"}, {
                      PlaceObj("XTemplateWindow", {
                        "Dock",
                        "box",
                        "MinWidth",
                        500,
                        "MaxWidth",
                        500,
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        10
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice4",
                          "VAlign",
                          "bottom",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          T(nil),
                          "Align",
                          "right"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, false, 4)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice5",
                          "VAlign",
                          "center",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          T(nil),
                          "Align",
                          "right"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, false, 5)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice6",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          T(nil),
                          "Align",
                          "right"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, false, 6)
                            end
                          })
                        })
                      }),
                      PlaceObj("XTemplateWindow", {
                        "Dock",
                        "box",
                        "VAlign",
                        "center",
                        "MinWidth",
                        500,
                        "MaxWidth",
                        500,
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        10
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice41",
                          "VAlign",
                          "bottom",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          "",
                          "Align",
                          "right"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, false, 4)
                            end
                          })
                        }),
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "ActionButtonConversation",
                          "RolloverAnchor",
                          "center-top",
                          "Id",
                          "choice61",
                          "Visible",
                          false,
                          "OnPress",
                          function(self, gamepad)
                            self:OnPressButtonFn()
                          end,
                          "ConversationRolloverText",
                          "",
                          "Align",
                          "right"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnSetRollover(self, rollover)",
                            "func",
                            function(self, rollover)
                              XButton.OnSetRollover(self, rollover)
                              local parent = self:ResolveId("idButtonsHolder")
                              parent:OnButtonRollover(self, rollover, false, 6)
                            end
                          })
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
                "idNextPhrase",
                "IdNode",
                false,
                "Margins",
                box(0, 30, 0, 0),
                "HAlign",
                "center",
                "VAlign",
                "bottom",
                "TextStyle",
                "ConversationNext",
                "Translate",
                true,
                "Text",
                T(645426615525, "<left_click> Next")
              }, {
                PlaceObj("XTemplateCode", {
                  "run",
                  function(self, parent, context)
                    if GetUIStyleGamepad() then
                      parent:SetText(T(103942894433, "<ButtonA> Next"))
                    else
                      parent:SetText(T(240345008948, "<left_click> Next"))
                    end
                  end
                })
              })
            })
          })
        })
      })
    })
  })
})
