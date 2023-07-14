local lResolveBanterActor = function(name, unit_list, playOnce, banterPreset, optionalLineId)
  if name == "current unit" then
    name = "any"
  end
  for i, u in ipairs(unit_list) do
    u = IsKindOf(u, "UnitMarker") and u.objects and u.objects[1] or u
    local is_unit = IsKindOf(u, "Unit")
    if playOnce and is_unit and u.banters_played_lines and table.find(u.banters_played_lines, optionalLineId) then
    elseif name == "<default>" or name == "any" then
      return u
    elseif is_unit and u:IsDead() then
    elseif is_unit and IsSetpieceActor(u) and not u.visible then
    elseif not UnitTarget.Match(nil, name, u, empty_table) then
    elseif not IsValid(u) then
    elseif not u:IsValidPos() then
    else
      return u
    end
  end
  return false
end
local lGetActorsUsedInBanter = function(banterPreset, unit_list, findFirst)
  if banterPreset.isRadio then
    return {}, true
  end
  local used_units, all_lines_satisfied
  for i, l in ipairs(banterPreset.Lines) do
    if l.MultipleTexts then
      used_units = used_units or {}
      if all_lines_satisfied == nil then
        all_lines_satisfied = true
      end
    else
      local optionalLineId = banterPreset.id .. tostring(i)
      local actor = lResolveBanterActor(l.Character, unit_list, l.playOnce, banterPreset, optionalLineId)
      if actor then
        if not findFirst then
          used_units = used_units or {}
          used_units[actor] = l.Character
          table.insert_unique(used_units, actor)
        end
        if all_lines_satisfied == nil then
          all_lines_satisfied = true
        end
      elseif not l.Optional then
        if findFirst then
          return
        end
        all_lines_satisfied = false
        BanterDebugLog(banterPreset.id, "couldn't find an actor for " .. l.Character)
      end
    end
  end
  if findFirst or used_units then
    return used_units, all_lines_satisfied
  end
end
local lBanterToTalkingHeadAdapter = function(id, text, characterId, attachedTemplate)
  local synthNotification = PlaceObj("TalkingHeadNotificationBase")
  synthNotification.id = id
  synthNotification.Lines = {
    {Text = text, Character = characterId}
  }
  if attachedTemplate then
    synthNotification.CustomLogic = attachedTemplate
  end
  PlayTalkingHead(synthNotification)
  return synthNotification
end
DefineClass.BanterFunctionObjectBase = {
  __parents = {
    "PropertyObject"
  }
}
DefineClass.BanterPlayer = {
  __parents = {"Object"},
  preset = false,
  associated_units = false,
  thread = false,
  fallback_actor = false,
  current_line = false,
  current_text_window = false,
  any_actor_override = false,
  active_talking_head = false,
  seed = false,
  id = false,
  started = false,
  done_called = false
}
DefineClass.BanterFloatingText = {
  __parents = {
    "UnitFloatingText"
  },
  TextStyle = "BanterFloatingText",
  interpolate_pos = false,
  interpolate_opacity = false,
  rand_pos = false,
  FadeInTime = 150,
  FadeOutTime = 150,
  MaxWidth = 450,
  HAlign = "left",
  TextHAlign = "center",
  exclusive_by_type = true,
  prevent_overlap = false,
  always_show_on_distance = true
}
MapVar("g_IdToBanter", {})
MapVar("g_NextBanterId", 0)
MapVar("g_ActiveBanters", function()
  return {}
end)
MapVar("g_PlayingBanterEffects", function()
  return {}
end)
GameVar("g_BanterCooldowns", {})
function OnMsg.LoadDynamicData(dynamic_data)
  if not next(g_BanterCooldowns) then
    g_BanterCooldowns = dynamic_data.banterCooldowns or {}
  end
end
if FirstLoad then
  Dbg_BoredBanters = false
end
function OnMsg.BanterStart(banter_preset_id)
  local banter = Banters[banter_preset_id]
  if banter.group == "MercBanters" then
    g_BanterCooldowns.global = RealTime() + const.GlobalMercBanterCooldown
  end
  g_BanterCooldowns[banter_preset_id] = Game.CampaignTime + (banter.cooldown or 0)
end
function PlayBanter(banter_preset_id, associated_units, fallback_actor, any_actor_override, wait_setpiece_end)
  NetUpdateHash("PlayBanter", banter_preset_id)
  CombatLog("debug", "Playing banter " .. banter_preset_id)
  local banter = Banters[banter_preset_id]
  if not banter then
    return
  end
  any_actor_override = any_actor_override and MapGetFirst("map", function(o)
    return table.find(o.Groups, any_actor_override)
  end)
  if banter.isRadio and not fallback_actor then
    for _, unit in ipairs(g_Units) do
      if unit:IsPlayerAlly() and not unit:IsDead() then
        fallback_actor = unit
        break
      end
    end
  end
  local init_members = {
    preset = banter,
    associated_units = associated_units,
    fallback_actor = fallback_actor,
    any_actor_override = any_actor_override,
    id = g_NextBanterId,
    wait_setpiece_end = wait_setpiece_end
  }
  g_NextBanterId = g_NextBanterId + 1
  if banter.banterGroup then
    local banterGroup = banter.banterGroup
    for i = #g_ActiveBanters, 1, -1 do
      local b = g_ActiveBanters[i]
      if b.preset.banterGroup == banterGroup then
        DoneBanter(b)
      end
    end
  end
  NetUpdateHash("PlayBanter_StartPlayer", banter_preset_id)
  local newBanter = BanterPlayer:new(init_members)
  g_ActiveBanters[#g_ActiveBanters + 1] = newBanter
  g_IdToBanter[newBanter.id] = newBanter
  return newBanter
end
function PlayAndWaitBanter(banter_preset_id, associated_units, fallback_actor)
  local player = PlayBanter(banter_preset_id, associated_units, fallback_actor)
  if player and player.thread then
    local ok, finished_banter
    while not ok or finished_banter ~= banter_preset_id do
      ok, finished_banter = WaitMsg("BanterDone", 500)
    end
  end
  return player
end
function EndBanter(unit, exclude, actor_string)
  if not unit then
    return
  end
  for i = #g_ActiveBanters, 1, -1 do
    local b = g_ActiveBanters[i]
    if not exclude or exclude and b ~= exclude and b.associated_units then
      local unitInBanter = table.find(b.associated_units, unit) or table.has_value(b.associated_units, actor_string)
      if unitInBanter then
        DoneBanter(b)
      end
    end
  end
end
OnMsg.UnitDied = EndBanter
function EndAllBanter()
  for i = #g_ActiveBanters, 1, -1 do
    DoneBanter(g_ActiveBanters[i])
  end
end
function SkipBanterFromUI(id)
  for i = #g_ActiveBanters, 1, -1 do
    local b = g_ActiveBanters[i]
    if b.preset.id == id then
      DoneBanter(b, "skip")
    end
  end
end
function IsBanterAvailable(banterDef, context)
  if (not context or type(context) ~= "table" or not rawget(context, "skipConflictCheck")) and GetSectorConflict() and banterDef.disabledInConflict then
    BanterDebugLog(banterDef.id, "because conflict.")
    return false
  end
  if not context or type(context) ~= "table" or not rawget(context, "skip_cooldowns") then
    if banterDef.group == "MercBanters" and g_BanterCooldowns.global and g_BanterCooldowns.global - RealTime() > 0 then
      BanterDebugLog(banterDef.id, "merc banter global cooldown.")
      return false
    end
    if banterDef.Once and g_BanterCooldowns[banterDef.id] then
      BanterDebugLog(banterDef.id, "marked as once per campaign.")
      return false
    end
    if banterDef.cooldown and g_BanterCooldowns[banterDef.id] and 0 < g_BanterCooldowns[banterDef.id] - Game.CampaignTime then
      BanterDebugLog(banterDef.id, "on cooldown.")
      return false
    end
  end
  local conditions = EvalConditionList(banterDef.conditions, banterDef, context)
  if not conditions then
    BanterDebugLog(banterDef.id, "conditions are false.")
    return false
  end
  return true
end
local lInterruptableCommands = {
  "Roam",
  "Visit",
  "RoamSingle",
  "BeingInteracted"
}
local lUnitIdleForBanter = function(u)
  return u.routine ~= "StandStill" and u:IsValidPos() and u.command ~= "IdleSuspicious" and (u.command ~= "BeingInteracted" or not u.being_interacted_with) and (u:IsIdleCommand() and u.command ~= "OverheardConversationHeadTo" or table.find(lInterruptableCommands, u.command))
end
function FilterAvailableBanters(banters, context, units, fallback, findFirst)
  local contextuallyValidUnits
  if context and type(context) == "table" and rawget(context, "require_idle") then
    contextuallyValidUnits = {}
    for i, u in ipairs(units) do
      if lUnitIdleForBanter(u) then
        contextuallyValidUnits[#contextuallyValidUnits + 1] = u
      end
    end
  else
    contextuallyValidUnits = units
  end
  local bantersFiltered, banterActors, list_unplayed
  local banters_defs_param = banters and type(banters[1]) == "table"
  for _, b in ipairs(banters) do
    local banterDef = banters_defs_param and b or Banters[b]
    if banterDef then
      local banter_id = banterDef.id
      local played = g_BanterCooldowns[banter_id]
      if played and list_unplayed then
      elseif IsBanterAvailable(banterDef, context) then
        local actors, all_actors_present = lGetActorsUsedInBanter(banterDef, contextuallyValidUnits, findFirst)
        if all_actors_present or fallback then
          if findFirst then
            return true
          end
          if not bantersFiltered then
            bantersFiltered = {}
            banterActors = {}
          end
          if not played and not list_unplayed then
            list_unplayed = true
            table.iclear(bantersFiltered)
            table.iclear(banterActors)
          end
          local idx = #bantersFiltered + 1
          bantersFiltered[idx] = banter_id
          banterActors[idx] = actors
        else
          BanterDebugLog(banter_id, "because actors missing.")
        end
      end
    end
  end
  if not bantersFiltered then
    return
  end
  if list_unplayed then
    return bantersFiltered, banterActors, "unplayed"
  end
  local filterOutIfOthers = context and type(context) == "table" and rawget(context, "filter_if_other")
  if filterOutIfOthers then
    local idx = table.find(bantersFiltered, filterOutIfOthers)
    if idx and 1 < #bantersFiltered then
      table.remove(bantersFiltered, idx)
      table.remove(banterActors, idx)
    end
  end
  return bantersFiltered, banterActors
end
function ReadDurationFromText(text)
  local wordsPerMinute = 240.0
  local averageWordSize = 5.0
  local words = Min(#text / averageWordSize, CountWords(text))
  local ms = words / wordsPerMinute * 60 * 1500
  return Max(ms, 2000)
end
function BanterPlayer:Init()
  CreateBadgeFromPreset("BanterOffScreen", self)
  self.associated_units = lGetActorsUsedInBanter(self.preset, self.associated_units) or {}
  if self.any_actor_override then
    table.insert(self.associated_units, 1, self.any_actor_override)
  end
  self.seed = InteractionRand(nil, "Banter")
  local anySnypeOrVRLine = false
  for i, l in ipairs(self.preset.Lines) do
    if l.useSnype or l.asVR then
      anySnypeOrVRLine = true
      break
    end
  end
  if self.preset.isRadio or anySnypeOrVRLine then
    self.thread = CreateMapRealTimeThread(self.Run, self)
  else
    self.thread = CreateGameTimeThread(self.Run, self)
  end
end
function BanterPlayer:IsFinished()
  if not self.current_line then
    return false
  end
  return self.current_line > #self.preset.Lines
end
function IsRadioBanterPlaying()
  for i, banter in ipairs(g_ActiveBanters) do
    if banter.started and banter.preset.isRadio then
      return true
    end
  end
  return false
end
function BanterPlayer:IsOtherRadioBanterPlaying()
  for i, banter in ipairs(g_ActiveBanters) do
    if banter ~= self and banter.preset.isRadio then
      return banter
    end
  end
  return false
end
function IsSetpiecePlaying()
  return GameState.setpiece_playing or IsRadioBanterPlaying()
end
function WaitPlayingSetpiece()
  local dlg = GetDialog("XSetpieceDlg")
  if dlg then
    dlg:Wait()
  end
  dlg = GetDialog("RadioBanterDialog")
  if dlg then
    dlg:Wait()
  end
end
function BanterPlayer:Run()
  BanterDebugLog(self.id, "played")
  WaitPlayerControl({
    skip_setpiece = not self.preset.isRadio and not self.wait_setpiece_end
  })
  if self.preset.isRadio then
    local otherRadioBanter = self:IsOtherRadioBanterPlaying()
    while otherRadioBanter and (otherRadioBanter.started or not (otherRadioBanter.id > self.id)) do
      Sleep(1000)
      otherRadioBanter = self:IsOtherRadioBanterPlaying()
    end
  end
  StopVoiceResponses()
  FireNetSyncEventOnHost("BanterStartEvent", self.id, self.preset.id, self.preset.group)
  local fx = self.preset.FX
  if fx then
    PlayFX(fx, "start", self.any_actor_override)
  end
  self.current_line = self.current_line or 1
  while not self:IsFinished() do
    local preset = self.preset
    local nextLine = preset.Lines[self.current_line]
    if nextLine.MultipleTexts then
      local count = 0
      self.seed = BraidRandom(self.seed)
      local forcePlaySubline = false
      if nextLine.AnyOfThese and #nextLine.AnyOfThese == 1 then
        forcePlaySubline = 1
      elseif self.any_actor_override then
        local anyActorArr = {
          self.any_actor_override
        }
        for i, m in ipairs(nextLine.AnyOfThese) do
          local actorName = m.Character
          local found = lResolveBanterActor(actorName, anyActorArr)
          if found then
            forcePlaySubline = i
            break
          end
        end
      end
      if forcePlaySubline then
        local line = nextLine.AnyOfThese[forcePlaySubline]
        line.Optional = true
        line.Voiced = true
        line.playOnce = nextLine.playOnce and "subline1"
        self:PlayBanterLine(line)
      else
        for i, m in random_ipairs(nextLine.AnyOfThese, self.seed) do
          local line = nextLine.AnyOfThese[i]
          line.Optional = true
          line.Voiced = true
          line.playOnce = nextLine.playOnce and "subline" .. tostring(i)
          local played = self:PlayBanterLine(line)
          if played then
            count = count + 1
          end
          if count == nextLine.AnyOfTheseCount then
            break
          end
        end
      end
    else
      self:PlayBanterLine()
    end
    self.current_line = self.current_line + 1
  end
  self.thread = false
  while self.current_text_window and self.current_text_window.window_state ~= "destroying" do
    Sleep(100)
  end
  DoneBanter(self)
end
function NetSyncEvents.BanterStartEvent(banter_id, preset_id, group)
  local banter_player = g_IdToBanter[banter_id]
  if not banter_player then
    return
  end
  banter_player.started = true
  if IsValid(banter_player) and banter_player.preset.isRadio then
    OpenDialog("RadioBanterDialog", GetInGameInterface(), banter_player)
  end
  Msg("BanterStart", preset_id)
end
function NetSyncEvents.BanterLineStartEvent(id, line_idx)
  Msg("BanterLineStart", id, line_idx)
end
function NetSyncEvents.BanterLineDoneEvent(id, line_idx)
  Msg("BanterLineDone", id, line_idx)
end
function GetSoundDurationGameTime(sound)
  local duration = GetSoundDuration(sound)
  if not duration then
    return false
  end
  return duration * GetTimeFactor() / 1000
end
function BanterPlayer:PlayBanterLine(line)
  local preset = self.preset
  local current_line = line or preset.Lines[self.current_line]
  local actor
  if current_line.Optional then
    local actorName = current_line.Character
    actor = lResolveBanterActor(actorName, self.associated_units)
    if not IsValid(actor) then
      do
        local unitFilter = function(u)
          if not u:IsDead() and (u.unitdatadef_id == actorName or u:IsInGroup(actorName)) then
            return u
          end
          return false
        end
        if not gv_SatelliteView then
          if self:IsValidPos() then
            actor = MapGetFirst(self:GetPos(), const.SlabSizeX * 15, "Unit", unitFilter)
          else
            actor = MapGetFirst("map", "Unit", unitFilter)
          end
        end
      end
    end
  else
    actor = lResolveBanterActor(current_line.Character, self.associated_units) or self.fallback_actor
  end
  if not IsValid(actor) then
    if preset.isRadio then
      local actorName = current_line.Character
      if Mercenaries[actorName] then
        local ud = gv_UnitData[actorName]
        if not ud or ud.HireStatus ~= "Hired" then
          return false
        end
      end
    elseif current_line.Optional then
      return false
    else
      print("Banter actor not found - ", current_line.Character, "for banter", self.preset.id)
      return false
    end
  end
  EndBanter(actor, self, self.associated_units[actor] == "any" and "any")
  if current_line.playOnce and IsKindOf(actor, "Unit") then
    local line_id = preset.id .. tostring(self.current_line)
    if type(current_line.playOnce) == "string" then
      line_id = line_id .. current_line.playOnce
    end
    if actor.banters_played_lines then
      if table.find(actor.banters_played_lines, line_id) then
        return false
      end
      table.insert(actor.banters_played_lines, line_id)
    else
      actor.banters_played_lines = {line_id}
    end
  end
  local anim_style = IsKindOf(actor, "Unit") and GetAnimationStyle(actor, current_line.AnimationStyle)
  if anim_style then
    actor:SetCommand("BanterIdle", current_line.AnimationStyle)
    CreateMapRealTimeThread(function(actor)
      WaitMsg("BanterLineDone")
      if actor.command == "BanterIdle" then
        actor:SetCommand("Idle")
      end
    end, actor)
  end
  NetSyncEvent("BanterLineStartEvent", self.preset.id, self.preset.group, self.current_line)
  if current_line.useSnype or current_line.asVR or GetDialog("RadioBanterDialog") then
    DeleteBadgesFromTarget(self)
    local attachedTemplate
    local actorUnitDataDefId = actor and rawget(actor, "unitdatadef_id") or current_line.Character
    if actor and current_line.asVR then
      local id = IsKindOf(actor, "Unit") and actor.id or rawget(actor, "unitdatadef_id") or actor.session_id or actor.id
      attachedTemplate = SpawnPartyAttachedTalkingHeadNotification(id)
    end
    local talkingHeadCharacter = UnitDataDefs[current_line.Character] and current_line.Character or actorUnitDataDefId
    local talkingHeadInstance = lBanterToTalkingHeadAdapter(preset.id .. self.current_line, current_line.Text, talkingHeadCharacter, attachedTemplate)
    self.active_talking_head = talkingHeadInstance
    local notTimedOut, obj
    while obj ~= talkingHeadInstance do
      notTimedOut, obj = WaitMsg("TalkingHeadEnded", 100)
    end
    self.active_talking_head = false
    Sleep(const.BanterBetweenLineTime)
    WaitPlayerControl({skip_setpiece = true})
    NetSyncEvent("BanterLineDoneEvent", self.preset.id, self.preset.group, self.current_line)
    return true
  end
  local line = current_line.Text
  if preset.loggable then
    if preset.isRadio then
      local character = UnitDataDefs[current_line.Character]
      CombatLog(character.id, line)
    elseif IsKindOf(actor, "Unit") then
      local unitDef = UnitDataDefs[actor.unitdatadef_id]
      if unitDef and actor.Name then
        CombatLog(actor.Name, line)
      else
        CombatLog(actor.unitdatadef_id, line)
      end
    else
      CombatLog("short", T({
        237924284463,
        "<line>",
        line = line
      }))
    end
  end
  local soundDuration, soundName
  if current_line.Voiced then
    local seed = IsKindOf(actor, "Unit") and rawget(actor, "session_id")
    soundName = GetVoiceFilename(line, seed and xxhash(seed))
    soundDuration = IsGameTimeThread() and GetSoundDurationGameTime(soundName) or GetSoundDuration(soundName)
  end
  if soundDuration then
    FadeSoundsForVoiceover(true)
    self:SetSound(soundName, IsGameTimeThread() and "BanterGameTime" or "Banter")
  elseif current_line.Voiced then
    soundDuration = ReadDurationFromText(_InternalTranslate(line))
  else
    soundDuration = nil
  end
  local manualFloatingText = soundDuration and "manual"
  local textElement = ShowBanterFloatingText(actor, line, manualFloatingText, current_line.FloatUp)
  self.current_text_window = textElement
  soundDuration = soundDuration or 100
  for waitTime = 100, soundDuration, 100 do
    if IsValid(actor) then
      self:SetPos(actor:GetPos())
    end
    Sleep(100)
  end
  FadeSoundsForVoiceover(false)
  if manualFloatingText and textElement.window_state ~= "destroying" then
    textElement:Close()
  end
  Sleep(const.BanterBetweenLineTime)
  NetSyncEvent("BanterLineDoneEvent", self.preset.id, self.preset.group, self.current_line)
  WaitPlayerControl({skip_setpiece = true})
  return true
end
function ShowBanterFloatingText(actor, line, expire_time, floatUp)
  if CheatEnabled("CombatUIHidden") then
    return
  end
  local dlg = IsSetpiecePlaying() and GetDialog("XSetpieceDlg").idSetpieceUI or EnsureDialog("FloatingTextDialog")
  local textElement = XTemplateSpawn("BanterFloatingText", dlg, actor)
  textElement.interpolate_pos = floatUp
  textElement.interpolate_opacity = floatUp
  if expire_time == "manual" then
    textElement.expire_time = false
  else
    textElement.expire_time = expire_time or Max(ReadDurationFromText(_InternalTranslate(line)), 2000)
  end
  CreateCustomFloatingText(textElement, actor, line, "BanterFloatingText", "Headstatic")
  return textElement
end
function BanterPlayer:delete(fromC, sync)
  Object.delete(self, fromC)
end
function NetSyncEvents.DoneBanter(banter_id, current_line)
  local banter = g_IdToBanter[banter_id]
  if not banter then
    return
  end
  banter.current_line = current_line
  banter:delete(nil, "sync")
end
function DoneBanter(banter, context)
  if banter.done_called then
    return
  end
  banter.done_called = true
  if (not IsAsyncCode() or context == "sync") and banter.thread then
    DeleteThread(banter.thread)
  end
  if context == "sync" then
    banter:delete(nil, context)
    return
  end
  local should_fire = not context and (not netInGame or netUniqueId == 1) or context == "skip"
  local ev_f = not context and FireNetSyncEventOnHost or context == "skip" and NetSyncEvent
  if should_fire and (not g_IdToBanter[banter.id] or banter ~= g_IdToBanter[banter.id]) then
    DebugPrint("g_IdToBanter[banter.id]", g_IdToBanter[banter.id])
    DebugPrint("g_IdToBanter[banter.id].preset.id", g_IdToBanter[banter.id] and g_IdToBanter[banter.id].preset.id)
    DebugPrint("banter.preset.id", banter.preset.id)
    DebugPrint("netUniqueId", netUniqueId)
    DebugPrint("context", context)
    return
  end
  ev_f("DoneBanter", banter.id, banter.current_line)
end
function BanterPlayer:Done()
  if self.thread then
    DeleteThread(self.thread)
  end
  local isFinished = self:IsFinished()
  CreateRealTimeThread(function()
    local dlg = GetDialog("RadioBanterDialog")
    if dlg then
      if not isFinished then
        dlg:Close()
      else
        dlg:AnimatedClose()
      end
    end
    if self.active_talking_head then
      self.active_talking_head:Stop()
      self.active_talking_head = false
    end
    if self.current_text_window and self.current_text_window.window_state ~= "destroying" then
      self.current_text_window:delete()
    end
  end)
  self.current_line = self.current_line or 1
  while not self:IsFinished() do
    Msg("BanterLineStart", self.preset.id, self.preset.group, self.current_line)
    Msg("BanterLineDone", self.preset.id, self.preset.group, self.current_line)
    self.current_line = self.current_line + 1
  end
  Msg("BanterDone", self.preset.id, self.preset.group)
  DeleteBadgesFromTarget(self)
  g_ActiveBanters.lastPlayedTime = GameTime()
  table.remove_value(g_ActiveBanters, self)
  g_IdToBanter[self.id] = nil
  if #g_ActiveBanters <= 0 then
    g_NextBanterId = 0
  end
  FadeSoundsForVoiceover(false)
  NetUpdateHash("BanterDone", self.preset.id)
end
function IsUnitPartOfAnyActiveBanter(unit)
  for i, b in ipairs(g_ActiveBanters) do
    local actors = b.associated_units
    if table.find(actors or empty_table, unit) then
      return true
    end
  end
  return false
end
if Platform.developer then
  function TestRadioBanter()
    PlayBanter("CorazonRadio_CapturedErnie", g_Units, SelectedObj)
  end
end
MapVar("g_VoiceResponses", {})
MapVar("g_voiceRespLastPlayed", false)
MapVar("g_suppressAllUntil", false)
MapVar("g_LastVRPlayed", false)
if FirstLoad then
  gv_VoiceLinesCD = {}
end
GameVar("gv_vrLog", {max_lines = 50})
const.DbgVoiceResponses = const.DbgVoiceResponses or false
local DbgVoiceResponse = function(...)
  if Platform.developer then
    local args = {
      ...
    }
    local line = string.format("[%d] VoiceResponse:", GameTime())
    for _, item in ipairs(args) do
      line = line .. string.format(" %s", IsT(item) and _InternalTranslate(item) or tostring(item))
    end
    gv_vrLog[#gv_vrLog + 1] = line
    while gv_vrLog.max_lines and #gv_vrLog > gv_vrLog.max_lines do
      table.remove(gv_vrLog, 1)
    end
    if const.DbgVoiceResponses then
      CombatLog("debug", line)
      print(line)
    end
  end
end
local HasValidVoiceResponse = function(unitName, eventType)
  local responses = VoiceResponses[unitName]
  if not responses then
    return
  end
  local unit = g_Units[unitName]
  if unit and unit:IsDowned() and eventType ~= "Downed" and eventType ~= "HeavilyWoundedSelection" then
    return
  end
  local lines = responses:ResolveResponses(eventType)
  return lines and 0 < #lines
end
local GetUnitLikedArray = function(unit)
  local squad = unit.Squad and gv_Squads[unit.Squad]
  local other = squad and squad.units or empty_table
  local liked, disliked, general = {}, {}, {}
  for _, other_unit in ipairs(other) do
    local ounit = gv_UnitData[other_unit]
    if unit.session_id ~= other_unit then
      general[#general + 1] = other_unit
      if ounit.Likes and table.find(ounit.Likes, unit.session_id) then
        liked[#liked + 1] = other_unit
      elseif ounit.Dislikes and table.find(ounit.Dislikes, unit.session_id) then
        disliked[#disliked + 1] = other_unit
      end
    end
  end
  return liked, disliked, general
end
local GetUnitLearnToLikeDislike = function(unit)
  local squad = unit.Squad and gv_Squads[unit.Squad]
  local other = squad and squad.units or empty_table
  local toBeLiked, toBeDisliked = {}, {}
  for _, other_unit in ipairs(other) do
    local ounit = gv_UnitData[other_unit]
    if unit.session_id ~= other_unit then
      if ounit.LearnToLike and table.find(ounit.LearnToLike, unit.session_id) and not table.find(ounit.Likes, unit.session_id) and not table.find(ounit.Dislikes, unit.session_id) then
        toBeLiked[#toBeLiked + 1] = other_unit
      end
      if ounit.LearnToDislike and table.find(ounit.LearnToDislike, unit.session_id) and not table.find(ounit.Likes, unit.session_id) and not table.find(ounit.Dislikes, unit.session_id) then
        toBeDisliked[#toBeDisliked + 1] = other_unit
      end
    end
  end
  return toBeLiked, toBeDisliked
end
local PlayVoiceResponseOpponentKilled = function(unit, vrContext)
  if vrContext.CheckForPraise then
    local chance = InteractionRand(100, "Praise")
    local chance_threshold = 50
    if chance >= chance_threshold then
      DbgVoiceResponse("Praise", "didn't play - chance", chance, " > ", chance_threshold)
    end
    if chance < chance_threshold then
      local toBeLiked, toBeDisliked = GetUnitLearnToLikeDislike(unit)
      if next(toBeLiked) then
        local randomChoice = table.rand(toBeLiked, InteractionRand(1000000, "Praise"))
        local idx = table.find(gv_UnitData[randomChoice].LearnToLike, unit.session_id)
        if unit.gender ~= "N/A" and HasValidVoiceResponse(randomChoice, "Praises" .. unit.gender) then
          local becomeLikedChance = InteractionRand(100, "Praise")
          local chance_threshold_becomeLiked = const.LearnToLikeDislike.becomeLikedThreshold
          if becomeLikedChance < chance_threshold_becomeLiked then
            gv_UnitData[randomChoice].Likes = table.copy(gv_UnitData[randomChoice].Likes)
            table.insert(gv_UnitData[randomChoice].Likes, unit.session_id)
            if HasValidVoiceResponse(randomChoice, "LearnToLike" .. idx) then
              PlayVoiceResponse(randomChoice, "LearnToLike" .. idx)
            end
            Msg("BecomeLiked", randomChoice, unit.session_id)
            MoraleModifierEvent("BecomeLiked", g_Units[randomChoice], unit)
            CombatLog("important", T({
              800866942430,
              "<em><observer></em> Likes <em><actor></em>",
              observer = gv_UnitData[randomChoice].Nick,
              actor = unit.Nick
            }))
          else
            CombatLog("debug", T({
              Untranslated("Praise did not cause LearnToLike. Chance <chance>/<threshold>"),
              chance = becomeLikedChance,
              threshold = chance_threshold_becomeLiked
            }))
          end
          PlayVoiceResponse(randomChoice, "Praises" .. unit.gender)
        end
      else
        local liked, disliked, general = GetUnitLikedArray(unit)
        local weights = {
          {2, "General"}
        }
        if next(liked) then
          weights[#weights + 1] = {4, "Buddy"}
        end
        if next(disliked) then
          weights[#weights + 1] = {4, "Dislike"}
        end
        local praiseType = GetWeightedRandom(weights, InteractionRand(1000000, "Praise"))
        if praiseType == "Buddy" then
          local unitPraising, rand = table.rand(liked, InteractionRand(1000000, "Praise"))
          local learnToLikeIndex = table.find(gv_UnitData[unitPraising].LearnToLike, unit.session_id)
          local idx = learnToLikeIndex or table.find(gv_UnitData[unitPraising].Likes, unit.session_id)
          local voice
          if learnToLikeIndex then
            voice = "PraisesLearnToLike" .. idx
          else
            voice = "PraisesBuddy" .. idx
          end
          if HasValidVoiceResponse(unitPraising, voice) then
            PlayVoiceResponse(unitPraising, voice)
          end
        elseif praiseType == "Dislike" then
          local unitPraising, rand = table.rand(disliked, InteractionRand(1000000, "Praise"))
          local learnToDislikeIndex = table.find(gv_UnitData[unitPraising].LearnToDislike, unit.session_id)
          local idx = learnToDislikeIndex or table.find(gv_UnitData[unitPraising].Dislikes, unit.session_id)
          local voice
          if learnToDislikeIndex then
            voice = "PraisesLearnToDislike" .. idx
          else
            voice = "PraisesDislike" .. idx
          end
          if HasValidVoiceResponse(unitPraising, voice) then
            PlayVoiceResponse(unitPraising, voice)
          end
        else
          local unitPraising, rand = table.rand(general, InteractionRand(1000000, "Praise"))
          if unit.gender ~= "N/A" and HasValidVoiceResponse(unitPraising, "Praises" .. unit.gender) then
            PlayVoiceResponse(unitPraising, "Praises" .. unit.gender)
          end
        end
      end
    end
  end
  for _, vrType in ipairs(vrContext) do
    PlayVoiceResponse(unit, vrType)
  end
  PlayVoiceResponse(unit, "OpponentKilled")
end
function PlayVoiceResponseMissHighChance(unit)
  local chance = InteractionRand(100, "Mock")
  local chance_threshold = 50
  if chance >= chance_threshold then
    DbgVoiceResponse("Mock", "didn't play - chance", chance, " > ", chance_threshold)
  end
  if chance < chance_threshold then
    local toBeLiked, toBeDisliked = GetUnitLearnToLikeDislike(unit)
    if next(toBeDisliked) then
      local randomChoice = table.rand(toBeDisliked, InteractionRand(1000000, "Mock"))
      local idx = table.find(gv_UnitData[randomChoice].LearnToDislike, unit.session_id)
      if HasValidVoiceResponse(randomChoice, "MockGeneral") then
        local becomeDislikedChance = InteractionRand(100, "Mock")
        local chance_threshold_becomeDisliked = const.LearnToLikeDislike.becomeDislikedThreshold
        if becomeDislikedChance < chance_threshold_becomeDisliked then
          gv_UnitData[randomChoice].Dislikes = table.copy(gv_UnitData[randomChoice].Dislikes)
          table.insert(gv_UnitData[randomChoice].Dislikes, unit.session_id)
          if HasValidVoiceResponse(randomChoice, "LearnToDislike" .. idx) then
            PlayVoiceResponse(randomChoice, "LearnToDislike" .. idx)
          end
          Msg("BecomeDisliked", randomChoice, unit.session_id)
          MoraleModifierEvent("BecomeDisliked", g_Units[randomChoice], unit)
          CombatLog("short", T({
            327710109480,
            "<em><observer></em> Dislikes <em><actor></em>",
            observer = gv_UnitData[randomChoice].Nick,
            actor = unit.Nick
          }))
        else
          CombatLog("debug", T({
            Untranslated("Mock did not cause dislike. Chance <chance>/<threshold>"),
            chance = becomeDislikedChance,
            threshold = chance_threshold_becomeDisliked
          }))
        end
        PlayVoiceResponse(randomChoice, "MockGeneral")
        return
      end
    else
      local liked, disliked, general = GetUnitLikedArray(unit)
      local weights = {
        {2, "General"}
      }
      if next(liked) then
        weights[#weights + 1] = {4, "Like"}
      end
      if next(disliked) then
        weights[#weights + 1] = {4, "Dislike"}
      end
      local mockType = GetWeightedRandom(weights, InteractionRand(1000000, "Mock"))
      if mockType == "Like" then
        local unitMocking = table.rand(liked, InteractionRand(1000000, "Mock"))
        local learnToLikeIndex = table.find(gv_UnitData[unitMocking].LearnToLike, unit.session_id)
        local idx = learnToLikeIndex or table.find(gv_UnitData[unitMocking].Likes, unit.session_id)
        local voice
        if learnToLikeIndex then
          voice = "MockLearnToLike" .. idx
        else
          voice = "MockLike" .. idx
        end
        if HasValidVoiceResponse(unitMocking, voice) then
          PlayVoiceResponse(unitMocking, voice)
          return
        end
      elseif mockType == "Dislike" then
        local unitMocking = table.rand(disliked, InteractionRand(1000000, "Mock"))
        local learnToDislikeIndex = table.find(gv_UnitData[unitMocking].LearnToDislike, unit.session_id)
        local idx = learnToDislikeIndex or table.find(gv_UnitData[unitMocking].Dislikes, unit.session_id)
        local voice
        if learnToDislikeIndex then
          voice = "MockLearnToDislike" .. idx
        else
          voice = "MockDislike" .. idx
        end
        if HasValidVoiceResponse(unitMocking, voice) then
          PlayVoiceResponse(unitMocking, voice)
          return
        end
      else
        local unitMocking = table.rand(general, InteractionRand(1000000, "Mock"))
        if HasValidVoiceResponse(unitMocking, "MockGeneral") then
          PlayVoiceResponse(unitMocking, "MockGeneral")
          return
        end
      end
    end
  end
  PlayVoiceResponse(unit, "MissHighChance")
end
local PlayVoiceResponseFriendlyFire = function(attacker, target, kill)
  local vrUnit = kill and attacker or target
  local vrTarget = kill and target or attacker
  local vr = kill and "KillFriendlyFire" or "FriendlyFire"
  local likeIndex = table.find(gv_UnitData[vrUnit.session_id].Likes, vrTarget.session_id)
  local learnToLikeIndex = table.find(gv_UnitData[vrUnit.session_id].LearnToLike, vrTarget.session_id)
  local dislikeIndex = table.find(gv_UnitData[vrUnit.session_id].Dislikes, vrTarget.session_id)
  local learnToDislikeIndex = table.find(gv_UnitData[vrUnit.session_id].LearnToDislike, vrTarget.session_id)
  local voice
  if likeIndex and learnToLikeIndex then
    voice = vr .. "LearnToLike" .. learnToLikeIndex
  elseif likeIndex and not learnToLikeIndex then
    voice = vr .. "Buddy" .. likeIndex
  elseif dislikeIndex and learnToDislikeIndex then
    voice = vr .. "LearnToDislike" .. learnToDislikeIndex
  elseif dislikeIndex and not learnToDislikeIndex then
    voice = vr .. "Dislike" .. dislikeIndex
  else
    voice = vr .. "General"
  end
  if HasValidVoiceResponse(vrUnit.session_id, voice) then
    PlayVoiceResponse(vrUnit, voice)
    return
  end
end
local PlayVoiceResponseAIDead = function(target, targetPos)
  local team = target.team and target.team.units or empty_table
  local firstAvailable = false
  local unitsCount = 0
  targetPos = targetPos or IsValid(target) and target:GetPos()
  if not targetPos then
    return
  end
  for _, unit in ipairs(team) do
    if not unit:IsDead() then
      unitsCount = unitsCount + 1
      if unit.species == "Human" and not firstAvailable then
        local unitPos = unit:GetPos()
        local manhDist = abs(targetPos:x() - unitPos:x()) + abs(targetPos:y() - unitPos:y())
        if manhDist <= const.BanterSlabDistance * const.SlabSizeX then
          firstAvailable = unit
        end
      end
    end
  end
  local voice = target.species == "Human" and "AIDeadAlly" or "AIDeadAnimal"
  if firstAvailable and 1 < unitsCount then
    PlayVoiceResponseGroup(firstAvailable, voice)
  elseif unitsCount == 1 then
    DbgVoiceResponse("AIDeadAlly", "didn't play - last enemy left")
  else
    DbgVoiceResponse("AIDeadAlly", "didn't play - no other nearby enemy")
  end
end
function OnMsg.Attack(action, results, attack_args)
  local attacker = attack_args.obj
  local hit_units = table.ifilter(results.hit_objs, function(idx, o)
    return IsValid(o) and IsKindOf(o, "Unit")
  end)
  local target_spot_group = attack_args.target_spot_group or ""
  local attackerIsUnit = IsKindOf(attacker, "Unit")
  if not attacker or not next(hit_units) then
    return
  end
  local killedCount = not (not results.killed_units or table.findfirst(results.killed_units, function(idx, unit)
    return unit:IsPlayerAlly()
  end)) and #results.killed_units or 0
  for _, target in ipairs(hit_units) do
    local spot_group = attack_args.target == target and target_spot_group or ""
    local targetIsAlly = IsKindOf(target, "Unit") and target:IsPlayerAlly()
    local skipKillMsg = not IsKindOf(target, "Unit") or not attackerIsUnit
    local stealth_kill = results.stealth_attack and next(results.killed_units) and table.find(results.killed_units, target)
    local targatDmg = next(results.unit_damage) and results.unit_damage[target] or 0
    local targetIsCivilian = IsKindOf(target, "Unit") and target:IsCivilian()
    if target:IsDead() and (0 < targatDmg or next(results.killed_units)) then
      local vrContext = {}
      if 1 < killedCount then
        table.insert(vrContext, "MultiOpponentKilled")
      end
      if results.melee_attack and not results.stealth_kill and g_Combat and not g_Combat:ShouldEndCombat(results.killed_units) then
        table.insert(vrContext, "OpponentKilledMelee")
      end
      if not targetIsCivilian then
        target.team.tactical_situations_vr.deadUnits = target.team.tactical_situations_vr.deadUnits and target.team.tactical_situations_vr.deadUnits + 1 or 1
        if attackerIsUnit then
          attacker.team.tactical_situations_vr.killedUnits = attacker.team.tactical_situations_vr.killedUnits and attacker.team.tactical_situations_vr.killedUnits + 1 or 1
          PlayVoiceResponseTacticalSituation(table.find(g_Teams, attacker.team), "now")
        end
      end
      if not IsMerc(target) and spot_group ~= "Head" then
        if HasValidVoiceResponse(target.unitdatadef_id, "DramaticDeath") then
          PlayVoiceResponse(target, "DramaticDeath")
        else
          PlayVoiceResponse(target, "AIDeath")
        end
      end
      if attackerIsUnit and attacker:IsPlayerAlly() and not targetIsAlly and spot_group == "Head" and (not g_Combat or not g_Combat:ShouldEndCombat()) then
        table.insert(vrContext, "OpponentKilledHeadshot")
        PlayVoiceResponseAIDead(target)
      end
      if not stealth_kill and (not g_Combat or not g_Combat:ShouldEndCombat()) then
        if target.species ~= "Human" then
          table.insert(vrContext, "OpponentKilledAnimal")
          PlayVoiceResponseAIDead(target)
        end
        local targetPos = IsValid(target) and target:GetPos() or attack_args and attack_args.target_pos
        if targetIsAlly and attackerIsUnit and attacker:IsPlayerAlly() then
          PlayVoiceResponseFriendlyFire(attacker, target, "kill")
        else
          vrContext.CheckForPraise = true
          PlayVoiceResponseAIDead(target, targetPos)
        end
        if not targetIsCivilian then
          PlayVoiceResponseOpponentKilled(attacker, vrContext)
        end
      end
      if not IsMerc(target) and spot_group == "Head" then
        EndBanter(target)
      end
    elseif 0 < targatDmg then
      if targetIsAlly and attackerIsUnit and attacker:IsPlayerAlly() then
        PlayVoiceResponseFriendlyFire(attacker, target)
        target:AddStatusEffect("FriendlyFire")
      else
        if target.wounded_this_turn then
          if attackerIsUnit then
            attacker.team.tactical_situations_vr.woundsInflicted = attacker.team.tactical_situations_vr.woundsInflicted and attacker.team.tactical_situations_vr.woundsInflicted + 1 or 1
            PlayVoiceResponseTacticalSituation(table.find(g_Teams, attacker.team), "now")
          end
          target.team.tactical_situations_vr.woundsReceived = target.team.tactical_situations_vr.woundsReceived and target.team.tactical_situations_vr.woundsReceived + 1 or 1
        end
        if target.villain and not target:IsDefeatedVillain() and target.HitPoints <= MulDivRound(target.MaxHitPoints, 50, 100) then
          PlayVoiceResponse(target, "VillainHurt")
        end
        if target:HasStatusEffect("Flanked") and not target:IsDefeatedVillain() and IsMerc(target) then
          PlayVoiceResponse(target, "SurroundedPain")
        end
      end
    end
  end
end
function OnMsg.DamageDone(attacker, target, damage, hit_desc)
  if not attacker or not target then
    return
  end
  local targetIsUnit = IsKindOf(target, "Unit")
  if not target:IsDead() and targetIsUnit then
    PlayVoiceResponse(target, "Pain")
  end
end
local PlayVoiceResponseUnitDied = function(unit)
  local liked, disliked, general = GetUnitLikedArray(unit)
  if next(liked) then
    local lunit, rand = table.rand(liked, InteractionRand(1000000, "Death"))
    local learnToLikeIndex = table.find(gv_UnitData[lunit].LearnToLike, unit.session_id)
    local idx = learnToLikeIndex or table.find(gv_UnitData[lunit].Likes, unit.session_id)
    local voice
    if learnToLikeIndex then
      voice = "DeathLearnToLike" .. idx
    else
      voice = "DeathBuddy" .. idx
    end
    if HasValidVoiceResponse(lunit, voice) then
      PlayVoiceResponse(lunit, voice)
      return
    end
  end
  if next(disliked) then
    local lunit, rand = table.rand(disliked, InteractionRand(1000000, "Death"))
    local learnToDislikeIndex = table.find(gv_UnitData[lunit].LearnToDislike, unit.session_id)
    local idx = learnToDislikeIndex or table.find(gv_UnitData[lunit].Dislikes, unit.session_id)
    local voice
    if learnToDislikeIndex then
      voice = "DeathLearnToDislike" .. idx
    else
      voice = "DeathDislike" .. idx
    end
    if HasValidVoiceResponse(lunit, voice) then
      PlayVoiceResponse(lunit, voice)
      return
    end
  end
  if next(general) then
    local lunit, rand = table.rand(general, InteractionRand(1000000, "Death"))
    if HasValidVoiceResponse(lunit, "DeathGeneral") then
      PlayVoiceResponse(lunit, "DeathGeneral")
      return
    end
  end
end
function OnMsg.UnitDied(unit)
  if not IsMerc(unit) then
    return
  end
  PlayVoiceResponseUnitDied(unit)
end
function OnMsg.SelectionChange()
  if #Selection < 1 or GetLoadingScreenDialog() or GetSatelliteDialog() or GetDialog("PDADialog") or IsInventoryOpened() then
    return
  end
  local obj = Selection[1]
  if IsKindOf(obj, "Unit") and obj:IsPlayerAlly() then
    if (obj:IsThreatened(nil, "pindown") or obj:IsUnderBombard() or obj:IsUnderTimedTrap()) and PlayVoiceResponse(obj, "ThreatSelection") then
      return
    elseif obj:IsThreatened(nil, "overwatch") and PlayVoiceResponse(obj, "OverwatchSelection") then
      return
    elseif g_Combat and obj:GetStatusEffect("Wounded") and obj:GetStatusEffect("Wounded").stacks >= 4 and PlayVoiceResponse(obj, "HeavilyWoundedSelection") then
      return
    elseif IsNearTrap(obj, "not ally trap") and PlayVoiceResponse(obj, "MineNearbySelection") then
      return
    elseif ClearLOFOnEnemiesCount(obj) > 5 and PlayVoiceResponse(obj, "ManyEnemiesSelection") then
      return
    elseif obj:HasStatusEffect("Hidden") and PlayVoiceResponse(obj, "SelectionStealth") then
      return
    else
      PlayVoiceResponse(obj, "Selection")
    end
  end
end
function ClearLOFOnEnemiesCount(unit)
  local lofToEnemiesCount = 0
  if g_Combat then
    local enemies = GetEnemies(unit)
    for _, enemy in ipairs(enemies) do
      if HasVisibilityTo(unit, enemy) then
        lofToEnemiesCount = lofToEnemiesCount + 1
      end
    end
  end
  return lofToEnemiesCount
end
function IsNearTrap(unit, notAllyTrap)
  local traps = g_Traps
  for _, trap in ipairs(traps) do
    local isBarrel = IsKindOf(trap, "Explosive_Barrel")
    if IsValid(trap) and not trap.done and not trap:IsDead() and trap.discovered_trap and not isBarrel and trap.TriggerType ~= "Timed" and not IsKindOf(trap, "BoobyTrappable") then
      local trapPos = trap:GetPos()
      local dangerRange = 8 * const.SlabSizeX
      local enemySide = notAllyTrap and trap.team_side ~= "player1" and trap.team_side ~= "player2"
      if enemySide and dangerRange > unit:GetDist(trapPos) then
        return true
      end
    end
  end
  return false
end
function OnMsg.EnemySighted(team, enemy)
  if team and team.player_ally and enemy and SelectedObj and not gv_CombatStartFromConversation then
    local vr = enemy.species ~= "Human" and "AnimalFound" or "OpponentFound"
    PlayVoiceResponse(SelectedObj, vr)
  end
end
function OnMsg.EnemySightedExploration(enemy)
  local pov_team = GetPoVTeam()
  if not pov_team or gv_CombatStartFromConversation then
    return
  end
  local units = table.ifilter(pov_team.units, function(idx, unit)
    return HasVisibilityTo(unit, enemy)
  end)
  if #units == 0 then
    return
  end
  local vr = enemy.species ~= "Human" and "AnimalFound" or "OpponentFound"
  PlayVoiceResponse(table.rand(units), vr)
  if gv_CurrentSectorId == "I2" then
    ShowStealthTutorialPopup()
  end
end
function OnMsg.UnitAwarenessChanged(unit)
  local isEnemy
  if unit.team then
    isEnemy = unit.team.side == "enemy1" or unit.team.side == "enemy2" or unit.team.side == "enemyNeutral"
  end
  local isMilitiaUnit = isEnemy and g_Combat and g_Combat.starting_unit and g_Combat.starting_unit.team.side == "ally"
  if not unit:IsAware("pending") then
    return
  end
  local time = AsyncRand(100, 200)
  CreateGameTimeThread(function()
    Sleep(time)
    PlayVoiceResponseGroup(isMilitiaUnit and g_Combat.starting_unit or unit, "BecomeAware")
  end)
end
function OnMsg.OperationCompleted(operation, mercs)
  if operation.id == "Arriving" then
    return
  end
  local voice_merc = table.interaction_rand(mercs, "Operation")
  if voice_merc then
    PlayVoiceResponse(voice_merc, "ActivityFinished")
    local squad = gv_Squads[voice_merc.Squad]
    if squad and squad.vrForActivity then
      squad.vrForActivity[operation.id] = nil
    end
  end
end
function OnMsg.CombatEnd(combat)
  ResolveVoiceResponses("EndOfCombat")
end
function OnMsg.TurnStart(team)
  NetUpdateHash("Banter OnMsg.TurnStart")
  ResetVoiceResponses("OncePerTurn")
  PlayVoiceResponseTacticalSituation(team, "turnStart")
  local currTeam = g_Teams[team] or false
  if currTeam then
    currTeam.tactical_situations_vr = {}
  end
end
function OnMsg.TurnEnded(team)
  PlayVoiceResponseTacticalSituation(team, "turnEnd")
  local currTeam = g_Teams[team] or false
  if currTeam then
    currTeam.tactical_situations_vr = {}
  end
end
function PlayVoiceResponseTacticalSituation(currTeam, event)
  NetUpdateHash("PlayVoiceResponseTacticalSituation", event)
  if g_Combat and not g_Combat:AreEnemiesAware(currTeam) then
    return
  end
  currTeam = g_Teams[currTeam] or false
  local teamUnits = currTeam.units
  local aliveUnitsCount = 0
  for _, unit in ipairs(teamUnits) do
    if not unit:IsDead() and not unit:IsDowned() then
      aliveUnitsCount = aliveUnitsCount + 1
    end
  end
  if aliveUnitsCount <= 1 then
    return
  end
  local vrEvents = {}
  if currTeam.tactical_situations_vr.deadUnits and currTeam.tactical_situations_vr.deadUnits >= 2 or currTeam.tactical_situations_vr.downedUnits and 2 <= currTeam.tactical_situations_vr.downedUnits then
    table.insert(vrEvents, "TacticalLoss")
  end
  if currTeam.tactical_situations_vr.deadUnits and currTeam.tactical_situations_vr.deadUnits == 1 or currTeam.tactical_situations_vr.downedUnits and currTeam.tactical_situations_vr.downedUnits == 1 then
    table.insert(vrEvents, "TacticalRevenge")
  end
  if currTeam.tactical_situations_vr.woundsReceived and 2 <= currTeam.tactical_situations_vr.woundsReceived then
    table.insert(vrEvents, "TacticalCareful")
  end
  if currTeam.tactical_situations_vr.killedUnits and 2 <= currTeam.tactical_situations_vr.killedUnits or currTeam.tactical_situations_vr.downedUnitsByTeam and 2 <= currTeam.tactical_situations_vr.downedUnitsByTeam then
    table.insert(vrEvents, "TacticalKilling")
  end
  if currTeam.tactical_situations_vr.woundsInflicted and 2 <= currTeam.tactical_situations_vr.woundsInflicted then
    table.insert(vrEvents, "TacticalPressing")
  end
  if currTeam.tactical_situations_vr.missedShots and currTeam.tactical_situations_vr.missedShots > 3 then
    table.insert(vrEvents, "TacticalFocus")
  end
  if (not currTeam.tactical_situations_vr.shotsFired or currTeam.tactical_situations_vr.shotsFired and currTeam.tactical_situations_vr.shotsFired == 0) and currTeam.tactical_situations_vr.movementDone then
    table.insert(vrEvents, "TacticalReposition")
  end
  if g_Visibility[currTeam] then
    local oppositeTeam
    if currTeam:IsPlayerControlled() then
      oppositeTeam = {
        "enemy1",
        "enemy2",
        "neutralEnemy"
      }
    else
      oppositeTeam = {"player1", "player2"}
    end
    for _, visUnit in ipairs(g_Visibility[currTeam]) do
      if visUnit.team and table.find(oppositeTeam, visUnit.team.side) and visUnit:IsAware() then
        table.insert(vrEvents, "TacticalTaunt")
        break
      end
    end
  end
  if currTeam:IsPlayerControlled() then
    local firstMerc = currTeam.units and currTeam.units[1]
    local enemies = firstMerc and GetAllEnemyUnits(firstMerc)
    local aliveEnemies = 0
    for _, enemy in ipairs(enemies) do
      if not enemy:IsDead() and not enemy:IsDefeatedVillain() then
        aliveEnemies = aliveEnemies + 1
      end
    end
    if aliveEnemies == 1 then
      table.insert(vrEvents, "TacticalLastEnemy")
    end
  end
  if not next(vrEvents) then
    return
  end
  for _, vrType in ipairs(vrEvents) do
    local validUnitVR = {}
    local leadershipVR = {}
    for _, unit in ipairs(teamUnits) do
      if (HasValidVoiceResponse(unit.session_id, vrType) or not unit:IsMerc()) and not unit:IsDead() and not unit:IsDowned() and not unit:HasStatusEffect("Hidden") then
        table.insert(validUnitVR, unit)
        if unit.Leadership >= const.Combat.LeadershipThresholdVR then
          table.insert(leadershipVR, unit)
        end
      end
    end
    if next(leadershipVR) then
      vrEvents[vrType] = leadershipVR
    elseif next(validUnitVR) then
      vrEvents[vrType] = validUnitVR
    end
  end
  local unitForVR
  if event == "turnStart" then
    if table.find(vrEvents, "TacticalLastEnemy") and next(vrEvents.TacticalLastEnemy) then
      unitForVR = table.rand(vrEvents.TacticalLastEnemy, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponse(unitForVR, "TacticalLastEnemy")
    elseif table.find(vrEvents, "TacticalLoss") and next(vrEvents.TacticalLoss) then
      unitForVR = table.rand(vrEvents.TacticalLoss, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponse(unitForVR, "TacticalLoss")
    elseif table.find(vrEvents, "TacticalRevenge") and next(vrEvents.TacticalRevenge) then
      unitForVR = table.rand(vrEvents.TacticalRevenge, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponseGroup(unitForVR, "TacticalRevenge")
    elseif table.find(vrEvents, "TacticalCareful") and next(vrEvents.TacticalCareful) then
      unitForVR = table.rand(vrEvents.TacticalCareful, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponseGroup(unitForVR, "TacticalCareful")
    elseif table.find(vrEvents, "TacticalTaunt") and next(vrEvents.TacticalTaunt) then
      unitForVR = table.rand(vrEvents.TacticalTaunt, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponse(unitForVR, "TacticalTaunt")
    end
  elseif event == "now" then
    if table.find(vrEvents, "TacticalKilling") and next(vrEvents.TacticalKilling) then
      unitForVR = table.rand(vrEvents.TacticalKilling, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponse(unitForVR, "TacticalKilling")
      currTeam.tactical_situations_vr.killedUnits = 0
      currTeam.tactical_situations_vr.downedUnitsByTeam = 0
    end
    if table.find(vrEvents, "TacticalPressing") and next(vrEvents.TacticalPressing) then
      unitForVR = table.rand(vrEvents.TacticalPressing, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponseGroup(unitForVR, "TacticalPressing")
      currTeam.tactical_situations_vr.woundsInflicted = 0
    end
    if table.find(vrEvents, "TacticalFocus") and next(vrEvents.TacticalFocus) then
      if g_Combat and next(vrEvents.TacticalFocus) and 1 < #vrEvents.TacticalFocus then
        local lastUnit = g_Combat:GetActiveUnit()
        local lastUnitIdx = table.find(vrEvents.TacticalFocus, "session_id", lastUnit and lastUnit.session_id)
        if lastUnitIdx then
          table.remove(vrEvents.TacticalFocus, lastUnitIdx)
        end
      end
      unitForVR = table.rand(vrEvents.TacticalFocus, InteractionRand(1000000, "TacticalSituation"))
      PlayVoiceResponse(unitForVR, "TacticalFocus")
      currTeam.tactical_situations_vr.missedShots = 0
    end
  elseif event == "turnEnd" and not currTeam:IsPlayerControlled() and table.find(vrEvents, "TacticalReposition") and next(vrEvents.TacticalReposition) then
    unitForVR = table.rand(vrEvents.TacticalReposition, InteractionRand(1000000, "TacticalSituation"))
    PlayVoiceResponse(unitForVR, "TacticalReposition")
  end
end
function OnMsg.UnitMovementDone(unit)
  if unit:IsMerc() then
    gv_MercsLastMoveTime[unit.session_id] = GameTime()
  end
  if g_Combat and unit and not unit:IsMerc() then
    unit.team.tactical_situations_vr.movementDone = true
  end
end
MapVar("g_SelectedObjLastActionIsMovement", false)
function OnMsg.SelectedObjChange(obj, prev)
  local shotsByUnits = prev and prev.team.tactical_situations_vr.shotsFiredBy or false
  local unitHasShot = shotsByUnits and shotsByUnits[prev.session_id] or false
  if g_SelectedObjLastActionIsMovement and not unitHasShot and prev then
    PlayVoiceResponse(prev, "TacticalReposition")
  end
  g_SelectedObjLastActionIsMovement = false
end
function OnMsg.CombatActionEnd(unit)
  ResolveVoiceResponses("EndOfCombatAction")
end
function OnMsg.ItemChangeCondition(item, prev, new, inventory_obj)
  if not inventory_obj or not new then
    return
  end
  if not IsKindOf(inventory_obj, "Unit") then
    return
  end
  if inventory_obj:HasStatusEffect("ManningEmplacement") then
    return
  end
  local isMerc = g_Units[inventory_obj.session_id]:IsMerc()
  if new < prev and isMerc then
    local maxCondition = item:GetMaxCondition()
    if item.Repairable and not IsConditionType(prev, maxCondition, "NeedRepair") and IsConditionType(new, maxCondition, "NeedRepair") then
      PlayVoiceResponse(inventory_obj.session_id, "ItemDeteriorates")
      CombatLog("important", T({
        783482293776,
        "<item_name> is in need of repair.",
        item_name = item.DisplayName
      }))
    end
    if not IsConditionType(prev, maxCondition, "Broken") and IsConditionType(new, maxCondition, "Broken") then
      CombatLog("important", T({
        521183153860,
        "<em><item_name></em> used by <merc_name> is <em>Broken</em>",
        item_name = item.DisplayName,
        merc_name = g_Units[inventory_obj.session_id]:GetDisplayName()
      }))
      CreateFloatingText(g_Units[inventory_obj.session_id], T({
        860115014912,
        "<item_name> Broken",
        item_name = item.DisplayName
      }), "FloatingTextMiss")
      if item:IsWeapon() then
        PlayVoiceResponse(inventory_obj.session_id, "WeaponBroken")
      end
    end
  end
end
MapVar("gv_VoiceResponsesQueue", {})
function ResolveVoiceResponses(event_group)
  local voices = gv_VoiceResponsesQueue[event_group]
  if not voices then
    return
  end
  CreateMapRealTimeThread(function()
    for i, voice in ipairs(voices) do
      if voice then
        local duration = PlayVoiceResponseInternal(voice.unit, voice.event_type, "skip_globalcd", "PlayedFromQueue")
        if duration then
          local eventType = voice.event_type
          local preset = VoiceResponseTypes[eventType]
          local suppresses = preset and next(preset.Suppresses) and preset.Suppresses or empty_table
          for j = i, #voices do
            local otherV = voices[j]
            if otherV and table.find(suppresses, otherV.event_type) then
              voices[j] = false
              DbgVoiceResponse(eventType, "didn't play - suppressed", otherV.event_type)
            end
          end
        end
        voices[i] = false
      end
    end
    gv_VoiceResponsesQueue[event_group] = {}
  end)
end
function PlayVoiceResponseGroup(unit, defaultEventType, force)
  local teamUnits = unit.team.units
  if teamUnits and #teamUnits <= 1 then
    return
  end
  if unit.neutral_retaliate and unit.spawner and unit.spawner.Side == "neutral" then
    return
  end
  if IsMerc(unit) then
    PlayVoiceResponse(unit, defaultEventType, force)
    return
  end
  local response_data = VoiceResponseTypes[defaultEventType]
  if not response_data then
    return
  end
  local customGroup = response_data.CustomGroup
  if customGroup and customGroup ~= "" then
    local vrFromGroupCanPlay = false
    for _, event in pairs(VoiceResponseTypes) do
      if event.CustomGroup == customGroup and EvalConditionList(event.PlayConditions) and event.id ~= defaultEventType and not vrFromGroupCanPlay then
        vrFromGroupCanPlay = event.id
      else
      end
    end
    if vrFromGroupCanPlay and HasValidVoiceResponse(unit.VoiceResponseId, vrFromGroupCanPlay) then
      PlayVoiceResponse(unit, vrFromGroupCanPlay, force)
    else
      PlayVoiceResponse(unit, defaultEventType, force)
    end
  else
    PlayVoiceResponse(unit, defaultEventType, force)
  end
end
function PlayVoiceResponse(unit, eventType, force)
  local response_data = VoiceResponseTypes[eventType]
  if not response_data then
    return
  end
  if not (response_data.UseSnype or response_data.Subtitled) or not response_data.EventGroup then
    return PlayVoiceResponseInternal(unit, eventType, force)
  end
  gv_VoiceResponsesQueue[response_data.EventGroup] = gv_VoiceResponsesQueue[response_data.EventGroup] or {}
  table.insert(gv_VoiceResponsesQueue[response_data.EventGroup], {
    event_type = eventType,
    unit = unit,
    force = force
  })
end
MapVar("g_VoiceResponsesEnabled", true)
function PlayVoiceResponseInternal(unit, eventType, force, delayedVR)
  if GetOpenLoadingScreen() or IsSetpiecePlaying() or GetDialog("ConversationDialog") then
    return
  end
  if not g_VoiceResponsesEnabled then
    return
  end
  if IsKindOf(unit, "UnitData") then
    unit = UnitDataDefs[unit.session_id]
  elseif type(unit) == "string" then
    unit = UnitDataDefs[unit]
  end
  if not unit or not IsKindOfClasses(unit, "Unit", "UnitDataCompositeDef") then
    return
  end
  local is_unit = IsKindOfClasses(unit, "Unit")
  if IsMerc(unit) then
    local udata = gv_UnitData[is_unit and unit.session_id or unit.id]
    if udata and not udata:IsLocalPlayerControlled() then
      DbgVoiceResponse(eventType, "Did not play - no local player merc")
      return
    end
  end
  if is_unit and unit:IsNPC() and not HasVisibilityTo(GetPoVTeam(), unit) and unit.team.side ~= "neutral" then
    return
  end
  local response_data = VoiceResponseTypes[eventType]
  local subtitle, snype, cooldown, chanceToPlay, synchGroup, oncePerTurn, oncePerCombat, oncePerGame, usesOtherLines
  if response_data then
    subtitle = response_data.Subtitled
    snype = response_data.UseSnype
    cooldown = response_data.Cooldown
    chanceToPlay = response_data.ChanceToPlay or nil
    synchGroup = response_data.SynchGroup
    oncePerTurn = response_data.OncePerTurn
    oncePerCombat = response_data.OncePerCombat
    oncePerGame = response_data.OncePerGame
    usesOtherLines = response_data.UsesOtherLines
  end
  local suppressAllVR = response_data.SuppressAll
  if #g_ActiveBanters > 0 and not suppressAllVR then
    DbgVoiceResponse(eventType, "didn't play - banter is playing")
    return
  end
  local downedOrPainType = eventType == "Downed" or eventType == "HeavilyWoundedSelection" or eventType == "Pain"
  if IsMerc(unit) and not downedOrPainType then
    local ud = gv_UnitData[is_unit and unit.session_id or unit.id]
    local inControl = not ud or not ud:HasStatusEffect("Berserk") and not ud:HasStatusEffect("Panicked")
    if not inControl then
      DbgVoiceResponse(eventType, "Didn't play - unit is panicked or berserk", unit and unit.Name)
      return
    end
  end
  if is_unit and unit:IsDowned() and not downedOrPainType then
    DbgVoiceResponse(eventType, "Didn't play - downed unit", unit and unit.Name)
    return
  end
  if delayedVR and is_unit and unit:IsIncapacitated() and eventType ~= "Downed" then
    DbgVoiceResponse(eventType, "Didn't play event group - unit is incapacitated.", unit and unit.Name)
    return
  end
  local canUseFallbackVR = (eventType == "AiDeath" or eventType == "Pain") and unit.species == "Human"
  local responses = VoiceResponses[unit.VoiceResponseId ~= "" and unit.VoiceResponseId or is_unit and unit.unitdatadef_id or unit.id]
  local useFallbackVR
  if not responses and not canUseFallbackVR then
    return
  end
  local lines = responses and responses:ResolveResponses(eventType) or empty_table
  lines = 0 < #lines and lines or usesOtherLines and usesOtherLines ~= "" and responses:ResolveResponses(usesOtherLines) or empty_table
  local lines_count = #lines
  if lines_count == 0 and canUseFallbackVR then
    responses = VoiceResponses[unit.FallbackMissingVR]
    useFallbackVR = true
    lines = responses:ResolveResponses(eventType)
    lines = 0 < #lines and lines
    lines_count = #lines
  end
  if lines_count == 0 then
    DbgVoiceResponse(eventType, "Didn't play - no written responses", unit and unit.Name)
    return
  end
  local unitName = unit.unitdatadef_id or unit.id
  local linesWithCD = {}
  if 0 < response_data.PerLineCooldown then
    local linesOnCD = gv_VoiceLinesCD[unitName] and gv_VoiceLinesCD[unitName][eventType]
    if linesOnCD then
      for _, line in pairs(linesOnCD) do
        if not line.gameId or line.gameId ~= Game.id then
          gv_VoiceLinesCD = {}
          break
        end
        if line.playedAt + response_data.PerLineCooldown >= RealTime() then
          linesWithCD[line.lineIdx] = true
        end
      end
    end
  end
  g_VoiceResponses[unitName] = g_VoiceResponses[unitName] or {}
  local lastPlay = g_VoiceResponses[unitName][eventType]
  local unitGroup = unit.group or unit.unitdatadef_id or unit.id
  if IsMerc(unit) then
    unitGroup = "Mercs"
  else
    unitGroup = unit.Affiliation or unit.id
  end
  if synchGroup then
    g_VoiceResponses[unitGroup] = g_VoiceResponses[unitGroup] or {}
    lastPlay = g_VoiceResponses[unitGroup][eventType]
  end
  local lineIdx = -1
  if lines_count == 1 and not linesWithCD[1] then
    lineIdx = 1
  elseif lines_count == 2 then
    local lastPlayedIdx = lastPlay and lastPlay.lineIdx
    if lastPlayedIdx and lastPlayedIdx == 1 and not linesWithCD[2] then
      lineIdx = 2
    elseif not linesWithCD[1] then
      lineIdx = 1
    end
  elseif lastPlay then
    lineIdx = 1 + AsyncRand(lines_count, "VoiceResponseLines")
    local try = 0
    while (lineIdx == lastPlay.lineIdx or linesWithCD[lineIdx]) and try < Max(lines_count, 10) do
      lineIdx = 1 + AsyncRand(lines_count, "VoiceResponseLines")
      try = try + 1
    end
    lineIdx = not linesWithCD[lineIdx] and lineIdx or -1
  else
    local try = 0
    lineIdx = 1 + AsyncRand(lines_count, "VoiceResponseLines")
    while linesWithCD[lineIdx] and try < Max(lines_count, 10) do
      lineIdx = 1 + AsyncRand(lines_count, "VoiceResponseLines")
      try = try + 1
    end
    lineIdx = not linesWithCD[lineIdx] and lineIdx or -1
  end
  if lineIdx == -1 then
    DbgVoiceResponse(eventType, "Didn't play - all lines are on cd", unit and unit.Name)
    return
  end
  local now = RealTime()
  if (type(force) ~= "boolean" or force ~= true) and not suppressAllVR then
    if force ~= "skip_globalcd" then
      local lastPlayedTime = g_voiceRespLastPlayed and g_voiceRespLastPlayed.playedAt + g_voiceRespLastPlayed.duration or 0
      if now - lastPlayedTime < const.GlobalVoiceResponseCooldown and not snype then
        if g_voiceRespLastPlayed.subtitle or not g_voiceRespLastPlayed.subtitle and not subtitle then
          if subtitle or snype then
            DbgVoiceResponse(eventType, "didn't play - global cooldown")
          end
          return
        end
      elseif g_voiceRespLastPlayed then
        local lastIsEnemy = g_voiceRespLastPlayed.playedByEnemy
        local isEnemy = not IsMerc(unit)
        if isEnemy and lastIsEnemy and now - lastPlayedTime < const.Combat.EnemyVrGlobalCd and not snype and (g_voiceRespLastPlayed.subtitle or not g_voiceRespLastPlayed.subtitle and not subtitle) then
          if subtitle or snype then
            DbgVoiceResponse(eventType, "didn't play - global ENEMY cooldown")
          end
          return
        end
      end
    end
    if g_suppressAllUntil and now < g_suppressAllUntil then
      if subtitle or snype then
        DbgVoiceResponse(eventType, "didn't play - global suppress by " .. (g_LastVRPlayed and g_LastVRPlayed.eventType or "Unknown"))
      end
      return
    end
    local lastPlayTime = lastPlay and lastPlay.playedAt
    if lastPlayTime then
      local timePassed = now - (lastPlayTime + lastPlay.duration or 0)
      if timePassed < (cooldown or 1000) then
        if (subtitle or snype) and eventType ~= "BusySatView" then
          DbgVoiceResponse(eventType, "didn't play - cooldown", cooldown, unit.Nick or unit.Name or "???")
        end
        return
      end
    end
    if chanceToPlay and (not force or force == "skip_globalcd") then
      local rand = AsyncRand(100)
      if chanceToPlay < rand then
        DbgVoiceResponse(eventType, "didn't play - chance", rand, ">", chanceToPlay, unit.Nick or unit.Name or "???")
        return
      end
    end
    local recordunit = g_VoiceResponses[unitName][eventType]
    local recordgroup
    if synchGroup then
      recordgroup = g_VoiceResponses[unitGroup][eventType]
    end
    if recordunit and next(recordunit) and (oncePerTurn and recordunit.OncePerTurn or oncePerCombat and recordunit.OncePerCombat) then
      DbgVoiceResponse("didn't play - OncePerTurn/OncePerCombat", eventType, unit.Nick or unit.Name or "???")
      return
    end
    if recordgroup and next(recordgroup) and (oncePerTurn and recordgroup.OncePerTurn or oncePerCombat and recordgroup.OncePerCombat) then
      DbgVoiceResponse(eventType, "didn't play - OncePerTurn/OncePerCombat", unit.Nick or unit.Name or "???")
      return
    end
    if recordunit and oncePerGame and recordunit.OncePerGame then
      DbgVoiceResponse(eventType, "didn't play - OncePerGame", unit.Nick or unit.Name or "???")
      return
    end
  end
  local queued = false
  if g_LastVRPlayed and (not force or force == "skip_globalcd") or suppressAllVR and #g_ActiveBanters > 0 then
    local lastPlayRecord = g_LastVRPlayed
    local currentlyPlaying = lastPlayRecord and lastPlayRecord.playedAtGameTime + lastPlayRecord.duration > GameTime() or suppressAllVR and #g_ActiveBanters > 0
    if currentlyPlaying then
      if lastPlayRecord and not lastPlayRecord.snype and not lastPlayRecord.subtitle and lastPlayRecord.soundStopCallback and not suppressAllVR then
        lastPlayRecord.soundStopCallback()
      elseif not subtitle and not suppressAllVR then
        DbgVoiceResponse(eventType, "didn't play - another VR is playing - ", lastPlayRecord.eventType)
        return
      else
        queued = true
      end
    end
  end
  local line = lines[lineIdx]
  local voice = GetVoiceFilename(line, is_unit and xxhash(rawget(useFallbackVR and UnitDataDefs[unit.FallbackMissingVR] or unit, "session_id")))
  local duration = GetSoundDurationGameTime(voice) or ReadDurationFromText(_InternalTranslate(line))
  if response_data.Suppresses and not force then
    for i, event_type in ipairs(response_data.Suppresses) do
      local suppressedPreset = VoiceResponseTypes[event_type]
      local cooldownFakeRecord = {
        playedAt = now + suppressedPreset.Cooldown - 1000,
        lineIdx = 0,
        duration = duration
      }
      g_VoiceResponses[unitName][event_type] = cooldownFakeRecord
      if synchGroup then
        g_VoiceResponses[unitGroup][event_type] = cooldownFakeRecord
      end
    end
  end
  local soundStopCallback = false
  if subtitle then
    local id = IsKindOf(unit, "Unit") and unit.id or rawget(unit, "unitdatadef_id") or unit.session_id or unit.id
    local attachedTemplate = SpawnPartyAttachedTalkingHeadNotification(id)
    if attachedTemplate or IsValid(unit) then
      local synthLine = PlaceObj("TalkingHeadLine")
      synthLine.Character = rawget(unit, "unitdatadef_id") or id
      synthLine.Text = line
      local synthNotification = PlaceObj("TalkingHeadNotificationBase")
      synthNotification.id = "VoiceResponse" .. eventType .. id
      synthNotification.Lines = {synthLine}
      synthNotification.NoSound = not queued
      synthNotification.ResetTimePlayed = queued and not g_LastVRPlayed
      if attachedTemplate then
        synthNotification.CustomLogic = attachedTemplate
        synthNotification.duration = duration
        synthNotification.SuppressAll = suppressAllVR
      else
        synthNotification.duration = duration
        synthNotification.CustomLogic = "FloatingText"
        synthLine.object = unit
      end
      PlayTalkingHead(synthNotification)
      function soundStopCallback()
        synthNotification:Stop()
      end
      snype = false
    end
  end
  if snype then
    local id = IsKindOf(unit, "Unit") and unit.session_id or unit.id
    local synthLine = PlaceObj("TalkingHeadLine")
    synthLine.Character = rawget(unit, "unitdatadef_id") or id
    synthLine.Text = line
    local synthNotification = PlaceObj("TalkingHeadNotificationBase")
    synthNotification.id = "VoiceResponse" .. eventType .. id
    synthNotification.Lines = {synthLine}
    PlayTalkingHead(synthNotification)
    CombatLog(id, line)
    function soundStopCallback()
      synthNotification:Stop()
    end
  elseif not queued then
    if voice then
      local oldCallback = soundStopCallback
      local sound_type = response_data.SoundType or "Voiceover"
      if sound_type == "Voiceover" then
        local soundHandle = PlaySound(voice, sound_type)
        function soundStopCallback()
          if oldCallback then
            oldCallback()
          end
          SetSoundVolume(soundHandle, -1, 300)
        end
      elseif IsValid(unit) then
        unit:SetSound(voice, sound_type)
        function soundStopCallback()
          if oldCallback then
            oldCallback()
          end
          if IsValid(unit) then
            unit:StopSound(300)
          end
        end
      end
    else
      CombatLog("debug", "Couldn't find voice file " .. eventType .. " from " .. _InternalTranslate(unit.Nick or unit.Name or "???") .. " of line " .. _InternalTranslate(line))
    end
  end
  local lastPlayTime = lastPlay and lastPlay.playedAt
  if const.DbgVoiceResponses then
    DbgVoiceResponse(eventType, lineIdx, _InternalTranslate(unit.Nick or unit.Name or "???"), lastPlayTime and now - lastPlayTime, cooldown)
  end
  local record = {
    playedAt = now,
    playedAtGameTime = GameTime(),
    duration = (duration or 0) + (voice and queued and g_LastVRPlayed and g_LastVRPlayed.duration or 0),
    soundStopCallback = soundStopCallback,
    eventType = eventType,
    lineIdx = lineIdx,
    OncePerTurn = oncePerTurn,
    OncePerCombat = oncePerCombat,
    OncePerGame = oncePerGame,
    subtitle = subtitle,
    snype = snype,
    playedByEnemy = not IsMerc(unit),
    SuppressAll = suppressAllVR
  }
  g_voiceRespLastPlayed = record
  g_VoiceResponses[unitName][eventType] = record
  if 0 < response_data.PerLineCooldown then
    local lineCDRecord = {
      lineIdx = record.lineIdx,
      playedAt = record.playedAt,
      gameId = Game.id
    }
    if not gv_VoiceLinesCD[unitName] then
      gv_VoiceLinesCD[unitName] = {}
    end
    gv_VoiceLinesCD[unitName][eventType] = gv_VoiceLinesCD[unitName][eventType] or {}
    gv_VoiceLinesCD[unitName][eventType][record.lineIdx] = lineCDRecord
  end
  if synchGroup then
    g_VoiceResponses[unitGroup][eventType] = record
  end
  g_LastVRPlayed = record
  if suppressAllVR then
    g_suppressAllUntil = now + duration
  end
  GossipVR(response_data, unitName)
  return duration
end
function ResetVoiceResponses(restriction_type)
  for unit, events in pairs(g_VoiceResponses) do
    for etype, record in pairs(events) do
      if record[restriction_type] then
        record[restriction_type] = nil
      end
    end
  end
  g_voiceRespLastPlayed = false
end
function StopVoiceResponses()
  local timeNow = RealTime()
  for unit, events in pairs(g_VoiceResponses) do
    for etype, record in pairs(events) do
      local stillPlaying = timeNow < record.playedAt + (record.duration or 0)
      if not stillPlaying or record.SuppressAll then
        break
      end
      if record.soundStopCallback then
        record.soundStopCallback()
      end
      record.duration = 0
    end
  end
end
local lBanterGroupsCombo = function()
  return table.keys2(Presets.BanterDef, "sorted", "<default>")
end
function _ENV:SetDefaultBanterMarkerTriggerConditions()
  if not IsKindOf(self, "GridMarker") then
    self = self[1]
  end
  self.TriggerConditions = {
    UnitIsNearbyArea:new({TargetUnit = "any merc"})
  }
  ObjModified(self)
  ObjModified(self.TriggerConditions)
end
DefineClass.BanterMarker = {
  __parents = {"GridMarker"},
  properties = {
    {
      category = "Grid Marker",
      id = "Type",
      name = "Type",
      editor = "dropdownlist",
      items = PresetGroupCombo("GridMarkerType", "Default"),
      default = "Banter",
      no_edit = true
    },
    {
      category = "BanterMarker",
      id = "TriggerChance",
      name = "Chance To Trigger",
      editor = "number",
      default = 50
    },
    {
      category = "BanterMarker",
      id = "BanterGroups",
      name = "Banter Groups",
      editor = "string_list",
      arbitrary_value = true,
      items = PresetGroupsCombo("BanterDef"),
      default = false
    },
    {
      category = "BanterMarker",
      id = "SpecificBanters",
      name = "SpecificBanters",
      help = "Specific Banters to play when interacted with.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      category = "Trigger Logic",
      id = "setDefaultConf",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Set Default BanterM Trg Cond",
          func = "SetDefaultBanterMarkerTriggerConditions"
        }
      }
    }
  },
  AreaWidth = 5,
  AreaHeight = 5,
  Trigger = "activation",
  done = false
}
function BanterMarker:GameInit()
  if not self.TriggerConditions then
    SetDefaultBanterMarkerTriggerConditions(self)
  end
end
function BanterMarker:ExecuteTriggerEffects(context)
  if self.done then
    return
  end
  self.done = true
  local roll = InteractionRand(100, "BanterMarker")
  if roll > self.TriggerChance then
    CombatLog("debug", "BanterMarker triggered, but you were unlucky. " .. tostring(roll) .. "/" .. tostring(self.TriggerChance))
    return
  end
  local contextUnits = context.target_units or empty_table
  local triggerer = contextUnits[1] or Selection[1]
  local unitsAround = MapGet(triggerer, const.SlabSizeX * 15, "Unit")
  local banter = GetRandomBanterFromGroups(self.BanterGroups, unitsAround, context, self.SpecificBanters)
  if banter then
    PlayBanter(banter, unitsAround or {}, triggerer)
  end
end
function GetRandomBanterFromGroups(groups, units, context, specificBanters)
  local banters = {}
  local allBanterGroups = {}
  local unplayedBanterGroups = {}
  for i, group in ipairs(groups) do
    local availableBanters, banterActors, unplayed = FilterAvailableBanters(Presets.BanterDef[group], context, units)
    if availableBanters then
      local groupEntry = {
        group = group,
        banters = availableBanters,
        actors = banterActors
      }
      table.insert(allBanterGroups, groupEntry)
      if unplayed then
        table.insert(unplayedBanterGroups, groupEntry)
      end
    end
  end
  if next(specificBanters) then
    local availableBanters, banterActors, unplayed = FilterAvailableBanters(specificBanters, context, units)
    if availableBanters then
      local groupEntry = {
        group = "SpecificBantersOfGroup",
        banters = availableBanters,
        actors = banterActors
      }
      table.insert(allBanterGroups, groupEntry)
      if unplayed then
        table.insert(unplayedBanterGroups, groupEntry)
      end
    end
  end
  if next(unplayedBanterGroups) then
    allBanterGroups = unplayedBanterGroups
  end
  local idx = InteractionRand(#allBanterGroups, "BanterRandom") + 1
  local randomBanterGroup = allBanterGroups[idx]
  if randomBanterGroup then
    banters = randomBanterGroup.banters
  end
  if #banters == 0 then
    CombatLog("debug", "BanterMarker triggered, but there werent any valid actors.")
    return false
  end
  local idx = InteractionRand(#banters, "BanterRandom") + 1
  return banters[idx], randomBanterGroup.actors[idx]
end
function CheatResetBanterMarkers()
  MapForEach("map", "BanterMarker", function(bant)
    bant.done = false
  end)
end
if FirstLoad then
  g_BanterEditorDebugInfo = false
end
DefineClass.BanterDebugInfo = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "id",
      name = "Banter ID",
      editor = "text",
      default = "ID"
    }
  },
  preset = false
}
function BanterDebugInfo:GetProperties()
  local conversation = Banters[self.id] or empty_table
  local props = table.copy(PropertyObject.GetProperties(self))
  ForEachPreset("Conversation", function(preset)
    preset:ForEachSubObject("BanterFunctionObjectBase", function(obj, parents)
      if table.find(obj.Banters, self.id) then
        local element = {
          id = preset.id .. #props,
          name = ComposePhraseId(parents),
          default = EditorViewAbridged(obj, obj.Banters, "banter"),
          sel_path = GedParentsListToSelection(parents),
          category = "Conversation references",
          editor = "text",
          read_only = true,
          buttons = {
            {
              name = "View",
              func = "ConversationEditorSelect",
              param = {
                preset_id = preset.id,
                sel_path = GedParentsListToSelection(parents)
              }
            }
          }
        }
        table.insert(props, element)
      end
    end)
  end)
  ForEachPreset("QuestsDef", function(preset, group, filter)
    preset:ForEachSubObject("BanterFunctionObjectBase", function(obj, parents)
      if table.find(obj.Banters, self.id) then
        local element = {
          id = preset.id .. #props,
          name = ComposeSubobjectName(parents),
          default = EditorViewAbridged(obj, obj.Banters, "banter"),
          category = "Quests references",
          editor = "text",
          read_only = true,
          buttons = {
            {
              name = "View",
              func = "QuestsEditorSelect",
              param = {
                preset_id = preset.id
              }
            }
          }
        }
        table.insert(props, element)
      end
    end)
  end)
  GatherMarkerScriptingData()
  ForEachDebugMarkerData("banter", self.id, function(marker_info, res_item_info)
    local element = {
      id = "h_" .. marker_info.handle .. "_" .. #props,
      name = marker_info.name,
      default = res_item_info.editor_view_abridged,
      category = marker_info.map and marker_info.map .. " GridMarker references" or "GridMarker references",
      editor = "text",
      read_only = true
    }
    local name = marker_info.map == GetMapName() and "View" or "View on other map"
    element.buttons = {
      {
        name = name,
        func = "GridMarkerEditorSelectDiffMap",
        param = {
          map = marker_info.map
        }
      }
    }
    table.insert(props, element)
  end)
  return props
end
function OnMsg.GedOnEditorSelect(obj, selected, editor)
  if editor and editor.app_template == "BanterEditor" then
    if selected and rawget(obj, "id") then
      local infoobj = BanterDebugInfo:new({
        preset = obj,
        id = obj.id
      })
      g_BanterEditorDebugInfo = infoobj
      editor:BindObj("state", infoobj)
    else
      g_BanterEditorDebugInfo = false
    end
  end
end
DefineClass.OverheardMarker = {
  __parents = {
    "GridMarker",
    "CommandObject",
    "GameDynamicDataObject"
  },
  properties = {
    {
      category = "BanterMarker",
      id = "BanterGroups",
      name = "Banter Groups",
      editor = "string_list",
      arbitrary_value = true,
      items = PresetGroupsCombo("BanterDef"),
      default = false
    },
    {
      category = "BanterMarker",
      id = "SpecificBanters",
      name = "SpecificBanters",
      help = "Specific Banters to play when interacted with.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      category = "BanterMarker",
      id = "ConflictDisable",
      name = "Disabled In Conflict",
      editor = "bool",
      default = true
    }
  },
  AreaWidth = 28,
  AreaHeight = 28,
  Trigger = "activation",
  target_banter = false,
  target_units = false,
  old_target_positions = false,
  target_positions = false,
  waiting_activation = false,
  playing_banter = false
}
function OverheardMarker:GetEditorTypeText()
  return Untranslated("[Overheard]")
end
local lDirections = {
  point(-1, 0),
  point(-1, -1),
  point(0, -1),
  point(1, -1),
  point(1, 0),
  point(1, 1),
  point(0, 1),
  point(-1, 1)
}
local lRadiusDeviation = guim * 2
if FirstLoad then
  g_debugOverheardMarker = false
end
function OverheardMarker:SetDynamicData(data)
  if not data then
    return
  end
  if data.unit_handles then
    local units = {}
    local old_positions = {}
    for i, h in ipairs(data.unit_handles) do
      local obj = HandleToObject[h]
      if not IsKindOf(obj, "Unit") then
        break
      end
      units[i] = obj
      if units[i] and data.old_target_positions[h] then
        old_positions[units[i]] = data.old_target_positions[h]
      end
    end
    if #units ~= #data.unit_handles or #units == 0 then
      return
    end
    self.target_units = units
    self.old_target_positions = old_positions
  end
  self.target_banter = data.target_banter
  self.waiting_activation = data.waiting_activation
  if data.target_banter then
    self:SetCommand("Resume")
  end
end
function OverheardMarker:GetDynamicData(data)
  if not self.target_units then
    return
  end
  local handles = {}
  local old_positions = {}
  for i, u in ipairs(self.target_units) do
    handles[i] = u:GetHandle()
    if self.old_target_positions and self.old_target_positions[u] then
      old_positions[handles[i]] = self.old_target_positions[u]
    end
  end
  if #handles ~= #self.target_units then
    return
  end
  data.unit_handles = handles
  data.target_banter = self.target_banter
  data.waiting_activation = self.waiting_activation
  data.old_target_positions = old_positions
end
function OverheardMarker:GameInit()
  if not self.TriggerConditions then
    self.TriggerConditions = {
      UnitIsNearbyArea:new({TargetUnit = "any merc"})
    }
  end
end
function OverheardMarker:ReleaseUnits()
  if self.target_units then
    for i, u in ipairs(self.target_units) do
      if IsValid(u) and not u:IsDead() and u.command ~= "EnterCombat" and not u.being_interacted_with then
        if not g_Combat and self.old_target_positions and self.old_target_positions[u] then
          u:SetCommandParams("GotoSlab", {move_anim = "Walk"})
          u:SetCommand("GotoSlab", self.old_target_positions[u])
        else
          u:SetCommand("Idle")
        end
      end
    end
  end
end
function OverheardMarker:StopRunning()
  self:ReleaseUnits()
  if self.playing_banter and self.playing_banter ~= true and IsValid(self.playing_banter) then
    DoneBanter(self.playing_banter)
  end
  self.playing_banter = false
  self.waiting_activation = false
  self.target_banter = false
  self.target_units = false
  self.target_positions = false
  self.old_target_positions = false
  Halt()
end
function OverheardMarker:StartRunning()
  if #g_Units == 0 then
    WaitMsg("TeamsUpdated")
  end
  self:ReleaseUnits()
  if not self:IsMarkerEnabled() then
    Sleep(5000)
    self:SetCommand("StartRunning")
    return
  end
  if self.ConflictDisable and IsConflictMode(gv_CurrentSectorId) or g_Combat then
    if g_debugOverheardMarker then
      print("overheard marker started in combat/conflict")
    end
    self:StopRunning()
    return
  end
  local banter, actor = GetRandomBanterFromGroups(self.BanterGroups, g_Units, {require_idle = true}, self.SpecificBanters)
  NetUpdateHash("OverheardMarker:StartRunning()", banter)
  if not banter then
    if g_debugOverheardMarker then
      print("overheard marker didn't find banter to play")
    end
    self:StopRunning()
    return
  end
  self.target_banter = banter
  self.target_units = actor
  if g_debugOverheardMarker then
    print("will play", banter)
  end
  self.command = "Resume"
  self:Resume()
end
function OverheardMarker:VisualizePositions()
  DbgClear()
  local markerPos = self:GetPos()
  for i, direction in ipairs(lDirections) do
    local randomizePos = BraidRandom(RealTime(), guim, lRadiusDeviation)
    local possiblePos = SnapToPassSlab(markerPos + direction * randomizePos)
    local vbox = GetVoxelBBox(possiblePos)
    DbgAddBox(vbox, const.clrRed)
  end
end
function OverheardMarker:Resume()
  local positions = {}
  local oldPositions = {}
  local markerPos = self:GetPos()
  if g_debugOverheardMarker then
    DbgClear()
    DbgAddBox(GetVoxelBBox(markerPos), const.clrGreen)
  end
  local count = #self.target_units
  table.validate(self.target_units)
  self.target_units = table.ifilter(self.target_units, function(_, u)
    return not u:IsDead()
  end)
  if count ~= #self.target_units then
    self:StopRunning()
    return
  end
  local unitsInvalidNow = false
  for i, u in ipairs(self.target_units) do
    if IsPlayerEnemy(u) and u:IsAware() or not lUnitIdleForBanter(u) then
      unitsInvalidNow = true
      self.target_units[i] = false
    end
  end
  if unitsInvalidNow then
    self:StopRunning()
    return
  end
  local markPosCollision = markerPos
  if not markPosCollision:IsValidZ() then
    markPosCollision = markPosCollision:SetTerrainZ()
  end
  markPosCollision = markPosCollision:SetZ(markPosCollision:z() + const.SlabSizeZ / 2)
  local cancel = false
  for i, u in ipairs(self.target_units) do
    local unitPos = false
    local incr = 1
    while not unitPos do
      local direction = lDirections[(i + incr) % #lDirections + 1]
      local randomizePos = BraidRandom(u:GetHandle() + incr, guim, lRadiusDeviation)
      local slabToCheck = markerPos + direction * randomizePos
      if markerPos:IsValidZ() then
        slabToCheck = slabToCheck:SetZ(markerPos:z())
      end
      local possiblePos = SnapToPassSlab(slabToCheck)
      local occupied = not possiblePos or not CanOccupy(u, possiblePos) or table.find(positions, possiblePos)
      if not occupied then
        local possPosCollision = possiblePos
        if not possPosCollision:IsValidZ() then
          possPosCollision = possPosCollision:SetTerrainZ()
        end
        possPosCollision = possPosCollision:SetZ(possPosCollision:z() + const.SlabSizeZ / 2)
        local objectsInTheWay = IntersectObjectsOnSegment(markPosCollision, possPosCollision, const.efVisible)
        if not objectsInTheWay then
          unitPos = possiblePos
          break
        end
      end
      if g_debugOverheardMarker and possiblePos then
        local vbox = GetVoxelBBox(possiblePos)
        DbgAddBox(vbox, const.clrRed)
      end
      incr = incr + 1
      if incr == #lDirections then
        if g_debugOverheardMarker then
          print("Overheard banter couldn't find suitable slab for one of the actors.")
        end
        self:StopRunning()
        return
      end
    end
    positions[i] = unitPos
    oldPositions[u] = self.old_target_positions and self.old_target_positions[u] or u:GetPos()
  end
  self.target_positions = positions
  self.old_target_positions = oldPositions
  for i, u in ipairs(self.target_units) do
    local unitPos = positions[i]
    local facePos = markerPos
    if #self.target_units == 2 then
      facePos = i == 1 and positions[2] or positions[1]
    end
    u:SetCommandParams("OverheardConversationHeadTo", {
      move_anim = u.body_type == "Small animal" and "Run" or "Walk"
    })
    u:SetCommand("OverheardConversationHeadTo", unitPos, facePos, self)
  end
  self:SetCommand("WaitPositioning")
end
function OverheardMarker:AreAllInPosition()
  if g_debugOverheardMarker then
    DbgClear()
  end
  for i, u in ipairs(self.target_units or empty_table) do
    local targetPos = self.target_positions[i]
    if g_debugOverheardMarker then
      local vbox = GetVoxelBBox(targetPos)
      DbgAddBox(vbox, const.clrBlue)
      DbgAddVector(u:GetPos(), targetPos - u:GetPos())
    end
    if not IsValid(u) then
      self:StopRunning()
      return false
    end
    if not targetPos:IsValidZ() then
      targetPos = targetPos:SetTerrainZ()
    end
    local unitVoxelSnapped = SnapToVoxel(u)
    local targetPosSnapped = SnapToVoxel(targetPos)
    if unitVoxelSnapped ~= targetPosSnapped then
      return false
    end
  end
  return true
end
function OverheardMarker:WaitPositioning()
  while true do
    WaitMsg("OverheardConversationPointReached", 3000)
    if self:AreAllInPosition() then
      self.waiting_activation = true
      self:SetCommand("WaitConditions")
    end
  end
end
function OverheardMarker:TriggerThreadProc()
end
function OverheardMarker:WaitConditions()
  local emptyObj = {}
  while IsValid(self) and not self:AwarenessUnitCheck() do
    if not self.waiting_activation then
      self:StopRunning()
      break
    end
    if self.waiting_activation and self:EvaluateTriggerConditions(emptyObj) then
      self.waiting_activation = false
      self:ExecuteTriggerEffects(emptyObj)
      self:StopRunning()
      return
    end
    Sleep(1000)
  end
end
function OverheardMarker:AwarenessUnitCheck()
  if not self.target_units then
    return
  end
  for i, u in ipairs(self.target_units) do
    if not (not g_Combat and IsValid(u)) or IsPlayerEnemy(u) and u:IsAware() then
      self:StopRunning()
      return true
    end
  end
end
function OverheardMarker:ExecuteTriggerEffects()
  WaitMsg("CombatStart", 300)
  if self:AwarenessUnitCheck() then
    return
  end
  local banterDef = Banters[self.target_banter]
  if not banterDef or not IsBanterAvailable(banterDef) then
    return
  end
  self.playing_banter = true
  if #self.target_units == 2 then
    self.target_units[1]:InterruptCommand("OverheardConversation", self.target_units[2]:GetPos(), self)
    self.target_units[2]:InterruptCommand("OverheardConversation", self.target_units[1]:GetPos(), self)
  else
    local myPos = self:GetPos()
    for i, u in ipairs(self.target_units) do
      u:InterruptCommand("OverheardConversation", myPos, self)
    end
  end
  local banterObj = PlayBanter(self.target_banter, self.target_units)
  self.playing_banter = banterObj
  local notTimedOut, preset_id
  while preset_id ~= banterObj.preset.id do
    notTimedOut, preset_id = WaitMsg("BanterDone", 500)
    if not self.playing_banter then
      return
    end
  end
  self.playing_banter = false
  self:StopRunning()
end
function NetSyncEvents.RestartOverheardMarkers()
  CreateGameTimeThread(function()
    Sleep(1000)
    MapForEach("map", "OverheardMarker", function(o)
      if not o.target_banter then
        o:SetCommand("StartRunning")
      end
    end)
  end)
end
function OnMsg.ExplorationStart()
  if GameReplayScheduled then
    return
  end
  if netInGame and not netGameInfo.started then
    return
  end
  NetSyncEvent("RestartOverheardMarkers")
end
function OnMsg.CombatEnd()
  FireNetSyncEventOnHost("RestartOverheardMarkers")
end
function OnMsg.ConflictEnd(sector)
  if gv_CurrentSectorId == sector.Id then
    return
  end
  FireNetSyncEventOnHost("RestartOverheardMarkers")
end
MapVar("g_approachBanterCooldown", {})
MapVar("g_approachBanterPlayed", {})
MapVar("g_lastApproachBanterPlayed", {})
MapVar("g_approachBanterCooldownTime", 30)
function UpdateApproachBanters()
  NetUpdateHash("ApproachBanterCheck_UPDATE", GameTime())
  if g_ActiveBanters and #g_ActiveBanters > 0 then
    return
  end
  for _, unit in ipairs(g_Units) do
    if unit.approach_banters and next(unit.approach_banters) and unit.approach_banters_distance then
      NetUpdateHash("ApproachBanterCheck_HAS", unit.session_id)
      local cooldownId = unit.approach_banters_cooldown_id or unit.session_id
      if not g_approachBanterCooldown[cooldownId] or not (g_approachBanterCooldown[cooldownId] > GameTime()) then
        NetUpdateHash("ApproachBanterCheck_CD", unit.session_id)
        if not IsUnitPartOfAnyActiveBanter(unit) then
          NetUpdateHash("ApproachBanterCheck_BUSY", unit.session_id)
          if not g_lastApproachBanterPlayed or g_lastApproachBanterPlayed.unit ~= unit then
            NetUpdateHash("ApproachBanterCheck_PLAYED", unit.session_id)
            local approachingUnits = {unit}
            local approachDistance = unit.approach_banters_distance * guim
            for _, otherUnit in ipairs(g_Units) do
              if otherUnit ~= unit and IsMerc(otherUnit) and not otherUnit:HasStatusEffect("Hidden") and approachDistance > otherUnit:GetDist(unit) and GetZDifference(unit:GetPos(), otherUnit:GetPos()) < const.SlabSizeZ / 2 then
                approachingUnits[#approachingUnits + 1] = otherUnit
              end
            end
            if #approachingUnits ~= 1 then
              NetUpdateHash("ApproachBanterCheck_APRCH", unit.session_id)
              local ctx = {
                approachingUnits = approachingUnits,
                filter_if_other = unit.last_played_banter_id
              }
              local unitsToUseForBanter = {}
              table.iappend(unitsToUseForBanter, approachingUnits)
              table.iappend(unitsToUseForBanter, g_Units)
              local bantersFiltered, actorsPicked = FilterAvailableBanters(unit.approach_banters, ctx, unitsToUseForBanter)
              if bantersFiltered then
                NetUpdateHash("ApproachBanterCheck_FLTR", unit.session_id)
                local notActorFiltered = {}
                for i, b in ipairs(bantersFiltered) do
                  if table.find(actorsPicked[i], unit) then
                    notActorFiltered[#notActorFiltered + 1] = b
                  end
                end
                bantersFiltered = notActorFiltered
                if unit.approach_banters_cooldown_id then
                  local filteredTwice = {}
                  for i, b in ipairs(bantersFiltered) do
                    local sameAsLast = g_lastApproachBanterPlayed and g_lastApproachBanterPlayed.banter == b
                    if not sameAsLast then
                      filteredTwice[#filteredTwice + 1] = b
                    end
                  end
                  bantersFiltered = filteredTwice
                end
                if #bantersFiltered ~= 0 then
                  local idx = InteractionRand(#bantersFiltered, "ApproachBanter") + 1
                  local banter = bantersFiltered[idx]
                  unit.last_played_banter_id = banter
                  PlayAndWaitBanter(banter, unitsToUseForBanter)
                  g_approachBanterCooldown[cooldownId] = GameTime() + 1000 * g_approachBanterCooldownTime
                  if unit.approach_banters_cooldown_id then
                    g_approachBanterPlayed[banter] = true
                    g_lastApproachBanterPlayed = {banter = banter, unit = unit}
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
function OnMsg.AmbientLifeSpawn()
  g_approachBanterPlayed = {}
end
function GetBantersWithGroupCharacters()
  local group_actors = {}
  local count = 0
  for k, v in sorted_pairs(Banters) do
    for _, line in ipairs(v.Lines) do
      if line.AnyOfThese then
        for _, line in ipairs(line.AnyOfThese) do
          if line.Voiced and not UnitDataDefs[line.Character] then
            group_actors[line.Character] = group_actors[line.Character] or {}
            table.insert(group_actors[line.Character], v)
            StoreErrorSource(v, "unknown character " .. line.Character)
          end
        end
      elseif line.Voiced and not UnitDataDefs[line.Character] then
        group_actors[line.Character] = group_actors[line.Character] or {}
        table.insert(group_actors[line.Character], v)
        StoreErrorSource(v, "unknown character " .. line.Character)
      end
    end
  end
  CopyToClipboard(table.concat(table.keys2(group_actors), "\n"))
  return group_actors
end
function _ENV:RadioBanterTriangleAnimation(vertical)
  local x = vertical and 0 or 1
  local y = vertical and 1 or 0
  self:CreateThread("update-movement", function()
    local lastPos = 0
    while self.window_state ~= "destroying" do
      local pos = AsyncRand(2)
      if pos ~= 0 then
      end
      pos = -1
      local dur = 2500
      pos = pos * AsyncRand(40, 60)
      pos = lastPos + pos
      if pos < -200 or 400 < pos then
        pos = pos - lastPos
        pos = lastPos - pos
      end
      self:AddInterpolation({
        id = "lastPos",
        type = const.intRect,
        originalRect = sizebox(0, 0, 1000, 1000),
        targetRect = sizebox(lastPos * x, lastPos * y, 1000, 1000),
        duration = 0
      })
      self:AddInterpolation({
        id = "move",
        type = const.intRect,
        originalRect = sizebox(lastPos * x, lastPos * y, 1000, 1000),
        targetRect = sizebox(pos * x, pos * y, 1000, 1000),
        duration = dur
      })
      lastPos = pos
      Sleep(dur)
      Sleep(500)
    end
  end)
end
function GetAllPlayedPlayOnceBanters()
  local list = {}
  for banterId, cooldown in pairs(g_BanterCooldowns) do
    local preset = Banters[banterId]
    if preset.Once then
      list[#list + 1] = banterId
    end
  end
  local dedupe = {}
  local units = MapGet("map", "Unit")
  for i, u in ipairs(units) do
    if u.banters_played_lines then
      for i, p in ipairs(u.banters_played_lines) do
        if not dedupe[p] then
          list[#list + 1] = p
          dedupe[p] = true
        end
      end
    end
  end
  return list
end
if FirstLoad then
  g_BanterBeingDebugged = false
end
function DebugSpecificBanter(banter)
  g_BanterBeingDebugged = banter.id
  print("Debugging banter", banter.id)
end
function BanterDebugLog(presetId, text)
  if g_BanterBeingDebugged ~= presetId then
    return
  end
  if text == "played" then
    print("[Banter]", presetId, "played successfully!")
    return
  end
  print("[Banter] ", presetId, " didn't play because: ", text)
end
function EditorTestBanterLine(banter, line)
  local char = line.Character
  if not UnitDataDefs[char] then
    print("Invalid test actor " .. char)
    return
  end
  local selected = Selection and Selection[1]
  if not selected then
    print("Select a unit to test banter")
    return
  end
  local pos
  local positions = GetCombatPath(selected):GetReachableMeleeRangePositions(selected)
  if positions and positions[1] then
    pos = point(point_unpack(positions[1]))
  else
    pos = GetCursorPos()
  end
  CreateMapRealTimeThread(function()
    local unit = SpawnUnit(char, char .. "_banterTest", pos)
    unit.banters = {
      banter.id
    }
    unit:SetSide("neutral")
    local testFinished = false
    function unit:PlayInteractionBanter()
      EndAllBanter()
      local newBanter = BanterPlayer:new({
        preset = banter,
        associated_units = {unit},
        fallback_actor = {selected}
      })
      CreateGameTimeThread(function()
        newBanter.current_line = table.find(banter.Lines, line)
        newBanter:PlayBanterLine()
        testFinished = true
      end)
    end
    while IsValid(unit) and not testFinished do
      Sleep(100)
    end
    unit:delete()
  end)
end
function BanterLineContext()
  return function(obj, prop_meta, parent)
    local extra_annotation = obj.Annotation
    if IsT(extra_annotation) then
      extra_annotation = _InternalTranslate(extra_annotation)
    end
    local is_radio = parent.isRadio
    local voice = ""
    if obj.Voiced then
      voice = "voice:" .. obj.Character .. (is_radio and " radio" or "")
    end
    local comment = parent.Comment
    if 0 < #comment then
      comment = comment .. " "
    end
    if extra_annotation then
      return string.format("section:%s/%s %s %s%s", string.gsub(parent.group, " ", "_"), parent.id, extra_annotation, comment, voice)
    else
      return string.format("section:%s/%s %s%s", string.gsub(parent.group, " ", "_"), parent.id, comment, voice)
    end
  end
end
function BanterLineThinContext()
  return function(obj, prop_meta, parent)
    if TGetID(obj.Text) == 783142211263 then
      ic(obj)
    end
    local extra_annotation = parent.Annotation
    if IsT(extra_annotation) then
      extra_annotation = _InternalTranslate(extra_annotation)
    end
    local voice = ""
    if GetParentTableOfKind(obj, "BanterLine").Voiced then
      voice = " voice:" .. obj.Character
    end
    if extra_annotation then
      return string.format("section:%s/%s %s%s", string.gsub(parent.group, " ", "_"), parent.id, extra_annotation, voice)
    else
      return string.format("section:%s/%s%s", string.gsub(parent.group, " ", "_"), parent.id, voice)
    end
  end
end
DefineConstInt("Default", "BoredBanterCD", 3, 1, "The cooldown between bored banters measured in days.")
DefineConstInt("Default", "BoredBanterMinHiredSince", 2, 1, "The minimum amount of days since which the merc has been hired.")
GameVar("gv_LastBoredBanter", false)
GameVar("gv_MercsLastMoveTime", {})
function NetSyncEvents.Mp_PlayBoredBanter(banter)
  if #g_ActiveBanters == 0 then
    gv_LastBoredBanter = Game.CampaignTime / const.Scale.day
    PlayBanter(banter, g_Units)
  end
end
local BoredBanterCheck = function()
  if ConflictOrSectorEnterTime and ConflictOrSectorEnterTime + 5000 > GameTime() then
    return
  end
  if not Dbg_BoredBanters and gv_LastBoredBanter and Game.CampaignTime / const.Scale.day < gv_LastBoredBanter + const.BoredBanterCD then
    return
  end
  if g_Combat or GetSatelliteDialog() or GetDialog("PDADialog") or IsInventoryOpened() or #g_Units == 0 then
    return
  end
  if gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId].conflict then
    return
  end
  if #g_ActiveBanters ~= 0 or GetDialog("ConversationDialog") then
    return
  end
  if #g_TalkingHeadQueue ~= 0 then
    return
  end
  local now = GameTime()
  local banterConvCD = not Dbg_BoredBanters and 30000 or 5000
  local lastMoveCD = not Dbg_BoredBanters and 5000 or 5000
  if g_ActiveBanters.lastPlayedTime and now < g_ActiveBanters.lastPlayedTime + banterConvCD or g_LastConv and now < g_LastConv + banterConvCD then
    return
  end
  local mainMercs = {}
  local allMercs = {}
  for _, squad in ipairs(g_PlayerSquads) do
    if squad.CurrentSector == gv_CurrentSectorId then
      for _, merc in pairs(squad.units) do
        local unitData = g_Units[merc]
        if unitData then
          local hiredAtDay = (GetMercStateFlag(unitData.session_id, "HiredAt") or Game.CampaignTime) / const.Scale.day
          local hiredSinceDays = Game.CampaignTime / const.Scale.day - hiredAtDay
          local isVeteran = hiredSinceDays >= const.BoredBanterMinHiredSince or Dbg_BoredBanters
          local notMoved
          local lastMovedTime = gv_MercsLastMoveTime[unitData.session_id]
          if lastMovedTime then
            notMoved = now > lastMovedTime + lastMoveCD
          else
            gv_MercsLastMoveTime[unitData.session_id] = GameTime()
            notMoved = false
          end
          if notMoved then
            if isVeteran then
              table.insert(mainMercs, g_Units[merc])
            end
            table.insert(allMercs, g_Units[merc])
          end
        end
      end
    end
  end
  local availableBanters = FilterAvailableBanters(Presets.BanterDef.MercDialogues, nil, mainMercs)
  if availableBanters then
    local banter = table.rand(availableBanters)
    NetSyncEvent("Mp_PlayBoredBanter", banter)
  end
end
MapVar("ConflictOrSectorEnterTime", false)
function OnMsg.ConflictEnd(sector)
  if gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId] == sector then
    ConflictOrSectorEnterTime = GameTime()
  end
end
function OnMsg.OnEnterMapVisual()
  ConflictOrSectorEnterTime = GameTime()
end
MapGameTimeRepeat("BoredBanter", 1000, BoredBanterCheck)
function ResumeFuncs.PlayBanterEffect(stack, context, resume)
  local units = {}
  for i, uHandle in ipairs(resume.units) do
    local u = HandleToObject[uHandle]
    if IsValid(u) then
      units[#units + 1] = u
    end
  end
  local actorOverride = false
  if resume.any_actor_override then
    actorOverride = HandleToObject[resume.any_actor_override]
    actorOverride = IsValid(actorOverride) and actorOverride
  end
  local fallbackUnit = false
  if resume.fallbackUnit then
    fallbackUnit = HandleToObject[resume.fallbackUnit]
    fallbackUnit = IsValid(fallbackUnit) and fallbackUnit
  end
  local init_members = {
    preset = Banters[resume.preset],
    associated_units = units,
    fallback_actor = fallbackUnit,
    any_actor_override = actorOverride,
    id = g_NextBanterId
  }
  g_NextBanterId = g_NextBanterId + 1
  local banterObj = BanterPlayer:new(init_members)
  if IsPoint(resume.player_pos) then
    banterObj:SetPos(resume.player_pos)
  end
  banterObj.current_line = resume.current_line
  g_ActiveBanters[#g_ActiveBanters + 1] = banterObj
  g_IdToBanter[banterObj.id] = banterObj
  NetUpdateHash("ResumeBanter", banterObj.id, banterObj.current_line)
  local notTimedOut, preset_id
  while preset_id ~= banterObj.preset.id do
    notTimedOut, preset_id = WaitMsg("BanterDone", 500)
  end
end
function TestBantersUsage()
  local bantersPreset = {}
  local undefinedBanters = {}
  local unusedBanters = {}
  ForEachPreset("BanterDef", function(banterPreset)
    table.insert(unusedBanters, banterPreset)
    table.insert(bantersPreset, banterPreset)
  end)
  local DoBantersExist = function(banterGroup, searchField, obj, isFromPreset)
    for idx, banter in ipairs(banterGroup) do
      if not table.find(bantersPreset, searchField, banter) then
        if isFromPreset then
          table.insert(undefinedBanters, {
            banter,
            obj[idx]
          })
        else
          table.insert(undefinedBanters, {banter, obj})
        end
      end
    end
  end
  local AreBantersUsed = function(banterGroup, searchField)
    unusedBanters = table.ifilter(unusedBanters, function(idx, banter)
      return not table.find(banterGroup, banter[searchField])
    end)
  end
  for _, markersOnMap in pairs(g_DebugMarkersInfo) do
    for _, marker in ipairs(markersOnMap) do
      if next(marker.BanterGroups) then
        DoBantersExist(marker.BanterGroups, "group", marker)
        AreBantersUsed(marker.BanterGroups, "group")
      end
      if next(marker.SpecificBanters) then
        DoBantersExist(marker.SpecificBanters, "id", marker)
        AreBantersUsed(marker.SpecificBanters, "id")
      end
      if next(marker.BanterTriggerEffects) then
        local bantersList = {}
        for _, banterEffect in ipairs(marker.BanterTriggerEffects) do
          for _, banter in ipairs(banterEffect.Banters) do
            table.insert(bantersList, banter)
          end
        end
        DoBantersExist(bantersList, "id", marker)
        AreBantersUsed(bantersList, "id")
      end
      if next(marker.ApproachedBanters) then
        DoBantersExist(marker.ApproachedBanters, "id", marker)
        AreBantersUsed(marker.ApproachedBanters, "id")
      end
      if marker.ApproachBanterGroup then
        DoBantersExist({
          marker.ApproachBanterGroup
        }, "group", marker)
        AreBantersUsed({
          marker.ApproachBanterGroup
        }, "group")
      end
    end
  end
  local questsPresetBantersInfo = {}
  local questsPresetBanters = {}
  ForEachPreset("QuestsDef", function(questPreset)
    questPreset:ForEachSubObject("BanterFunctionObjectBase", function(effect, parents)
      for _, banter in ipairs(effect.Banters) do
        table.insert_unique(questsPresetBanters, banter)
        table.insert_unique(questsPresetBantersInfo, questPreset)
      end
    end)
  end)
  DoBantersExist(questsPresetBanters, "id", questsPresetBantersInfo, "presets")
  AreBantersUsed(questsPresetBanters, "id")
  local setpiecesPresetBanters = {}
  local setpiecesPresetBantersInfo = {}
  ForEachPreset("SetpiecePrg", function(setpiecePreset)
    setpiecePreset:ForEachSubObject("BanterFunctionObjectBase", function(effect, parents)
      for _, banter in ipairs(effect.Banters) do
        table.insert_unique(setpiecesPresetBanters, banter)
        table.insert_unique(setpiecesPresetBantersInfo, setpiecePreset)
      end
    end)
  end)
  DoBantersExist(setpiecesPresetBanters, "id", setpiecesPresetBantersInfo, "presets")
  AreBantersUsed(setpiecesPresetBanters, "id")
  local guardpostPresetBanters = {}
  local guardpostPresetBantersInfo = {}
  ForEachPreset("GuardpostObjective", function(guardPostPreset)
    guardPostPreset:ForEachSubObject("BanterFunctionObjectBase", function(effect, parents)
      for _, banter in ipairs(effect.Banters) do
        table.insert_unique(guardpostPresetBanters, banter)
        table.insert_unique(guardpostPresetBantersInfo, guardPostPreset)
      end
    end)
  end)
  DoBantersExist(guardpostPresetBanters, "id", guardpostPresetBantersInfo, "presets")
  AreBantersUsed(guardpostPresetBanters, "id")
  local banterGroupsToIgnore = {
    "MercDialogues",
    "Testing",
    "Testing - Banter Test 1",
    "Testing - Banter Test 2",
    "A_System"
  }
  unusedBanters = table.ifilter(unusedBanters, function(idx, banter)
    return not table.find(banterGroupsToIgnore, banter.group)
  end)
  return undefinedBanters, unusedBanters, banterGroupsToIgnore
end
function BanterFXCombo()
  local fxes = {}
  for _, group in ipairs(Presets.BanterDef) do
    for _, banter in ipairs(group) do
      fxes[banter.FX] = true
    end
  end
  return table.keys(fxes, "sorted")
end
function OnMsg.CombatStarting()
  for i = #g_ActiveBanters, 1, -1 do
    local b = g_ActiveBanters[i]
    if b.preset.KillOnAnyActorAware then
      local units = b.associated_units
      for i, unit in ipairs(units) do
        if table.find(b.associated_units, unit) then
          DoneBanter(b)
        else
          local any_actor = b.associated_units[1]
          if b.associated_units[any_actor] == "any" then
            DoneBanter(b)
          end
        end
      end
    end
  end
end
config.FindInvalidInteractionBanters = config.FindInvalidInteractionBanters or LocalStorage and LocalStorage.dlgBugReport and LocalStorage.dlgBugReport.reporter == "Radomir"
if Platform.developer then
  local bantersReported = {}
  function DeveloperCheckUnitInteractionBanters(unit)
    if unit.banters_checked then
      return
    end
    unit.banters_checked = true
    local units = {unit}
    local marker = unit.zone or unit.spawner
    if marker then
      for i, group in ipairs(marker.BanterGroups) do
        local bantersInGroup = Presets.BanterDef[group]
        for i, b in ipairs(bantersInGroup) do
          if CheckInteractionBanterWouldntPlay(b, units) and not bantersReported[b.id] then
            StoreErrorSource(unit, "Interaction banter " .. b.id .. " requires actors that aren't the unit being interacted with.")
            bantersReported[b.id] = true
          end
        end
      end
      for i, b in ipairs(marker.SpecificBanters) do
        if CheckInteractionBanterWouldntPlay(b, units) and not bantersReported[b.id] then
          StoreErrorSource(unit, "Interaction banter " .. b.id .. " requires actors that aren't the unit being interacted with.")
          bantersReported[b.id] = true
        end
      end
    end
    for i, b in ipairs(unit.banters) do
      if CheckInteractionBanterWouldntPlay(b, units) and not bantersReported[b.id] then
        StoreErrorSource(unit, "Interaction banter " .. b.id .. " requires actors that aren't the unit being interacted with.")
        bantersReported[b.id] = true
      end
    end
  end
  function CheckInteractionBanterWouldntPlay(banterPreset, units)
    local id = banterPreset.id
    if string.find(id, "approach") then
      return false
    end
    local matchesOne = false
    for i, l in ipairs(banterPreset.Lines) do
      if not l.Optional and not l.AnyOfThese then
        local found = not not lResolveBanterActor(l.Character, units)
        if not found and g_Classes[l.Character] then
          found = true
        end
        matchesOne = matchesOne or found
        if not found and matchesOne then
          return true
        end
      end
    end
  end
end
local s_DemoBanters = {
  "Banters_Civilians",
  "Banters_Local_Ernie",
  "Banters_Local_Ernie_Triggered",
  "Banters_Militia",
  "MercDialogues",
  "Radio",
  "SharedOverheard_Civilians",
  "SharedOverheard_Enemies",
  "SharedOverheard_Custom"
}
function OnMsg.GatherVoiceBanters(blacklist_banter_voices)
  local all_banter_voices, used_banter_voices = {}, {}
  for _, group_banters in ipairs(Presets.BanterDef or empty_table) do
    for _, banter_def in ipairs(group_banters or empty_table) do
      local used_group = not not table.find(s_DemoBanters, banter_def.group)
      for _, line in ipairs(banter_def.Lines or empty_table) do
        if line.AnyOfThese then
          for _, thin_line in ipairs(line.AnyOfThese) do
            local voice_id = TGetID(thin_line.Text)
            all_banter_voices[voice_id] = true
            if used_group then
              used_banter_voices[voice_id] = true
            end
          end
        else
          local voice_id = TGetID(line.Text)
          all_banter_voices[voice_id] = true
          if used_group then
            used_banter_voices[voice_id] = true
          end
        end
      end
    end
  end
  for voice_id in pairs(all_banter_voices) do
    if not used_banter_voices[voice_id] then
      blacklist_banter_voices[voice_id] = true
    end
  end
end
