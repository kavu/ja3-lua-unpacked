DefineClass.SoundDummy = {
  __parents = {
    "ComponentAttach",
    "FXObject"
  },
  flags = {
    cofComponentSound = true,
    efVisible = false,
    efWalkable = false,
    efCollision = false,
    efApplyToGrids = false
  },
  entity = ""
}
DefineClass.SoundDummyOwner = {
  __parents = {
    "Object",
    "ComponentAttach"
  },
  snd_dummy = false
}
function SoundDummyOwner:PlayDummySound(id, fade_time)
  if not self.snd_dummy then
    self.snd_dummy = PlaceObject("SoundDummy")
    self:Attach(self.snd_dummy, self:GetSpotBeginIndex("Origin"))
  end
  self.snd_dummy:SetSound(id, 1000, fade_time)
end
function SoundDummyOwner:StopDummySound(fade_time)
  if IsValid(self.snd_dummy) then
    self.snd_dummy:StopSound(fade_time)
  end
end
