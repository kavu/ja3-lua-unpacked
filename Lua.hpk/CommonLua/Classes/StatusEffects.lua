DefineClass.StatusEffect = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      category = "Status Effect",
      id = "IsCompatible",
      editor = "expression",
      params = "self, owner, ..."
    },
    {
      category = "Status Effect",
      id = "OnAdd",
      editor = "func",
      params = "self, owner, ..."
    },
    {
      category = "Status Effect",
      id = "OnRemove",
      editor = "func",
      params = "self, owner, ..."
    },
    {
      category = "Status Effect Limit",
      id = "StackLimit",
      name = "Stack limit",
      editor = "number",
      default = 0,
      min = 0,
      no_edit = function(self)
        return not self.HasLimit
      end,
      dont_save = function(self)
        return not self.HasLimit
      end,
      help = "When the Stack limit count is reached, OnStackLimitReached() is called"
    },
    {
      category = "Status Effect Limit",
      id = "StackLimitCounter",
      name = "Stack limit counter",
      editor = "expression",
      default = function(self, owner)
        return self.id
      end,
      no_edit = function(self)
        return self.StackLimit == 0
      end,
      dont_save = function(self)
        return self.StackLimit == 0
      end,
      help = "Returns the name of the limit counter used to count the StatusEffects. For example different StatusEffects can share the same counter."
    },
    {
      category = "Status Effect Limit",
      id = "OnStackLimitReached",
      editor = "func",
      params = "self, owner, ...",
      no_edit = function(self)
        return self.StackLimit == 0
      end,
      dont_save = function(self)
        return self.StackLimit == 0
      end
    },
    {
      category = "Status Effect Expiration",
      id = "Expiration",
      name = "Auto expire",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return not self.HasExpiration
      end,
      dont_save = function(self)
        return not self.HasExpiration
      end
    },
    {
      category = "Status Effect Expiration",
      id = "ExpirationTime",
      name = "Expiration time",
      editor = "number",
      default = 480000,
      scale = "h",
      min = 0,
      no_edit = function(self)
        return not self.Expiration
      end,
      dont_save = function(self)
        return not self.Expiration
      end
    },
    {
      category = "Status Effect Expiration",
      id = "ExpirationRandom",
      name = "Expiration random",
      editor = "number",
      default = 0,
      scale = "h",
      min = 0,
      no_edit = function(self)
        return not self.Expiration
      end,
      dont_save = function(self)
        return not self.Expiration
      end,
      help = "Expiration time + random(Expiration random)"
    },
    {
      category = "Status Effect Expiration",
      id = "ExpirationLimits",
      name = "Expiration Limits (ms)",
      editor = "range",
      default = false,
      no_edit = function(self)
        return not self.Expiration
      end,
      dont_save = true,
      read_only = true
    },
    {
      category = "Status Effect Expiration",
      id = "OnExpire",
      editor = "func",
      params = "self, owner",
      no_edit = function(self)
        return not self.Expiration
      end,
      dont_save = function(self)
        return not self.Expiration
      end
    }
  },
  StoreAsTable = true,
  HasLimit = true,
  HasExpiration = true,
  Instance = false,
  expiration_time = false
}
local find = table.find
local find_value = table.find_value
local remove_value = table.remove_value
function StatusEffect:GetExpirationLimits()
  return range(self.ExpirationTime, self.ExpirationTime + self.ExpirationRandom)
end
function StatusEffect:IsCompatible(owner)
  return true
end
function StatusEffect:OnAdd(owner)
end
function StatusEffect:OnRemove(owner)
end
function StatusEffect:OnStackLimitReached(owner, ...)
end
function StatusEffect:OnExpire(owner)
  owner:RemoveStatusEffect(self, "expire")
end
function StatusEffect:PostLoad()
  self.__index = self
end
DefineClass.StatusEffectsObject = {
  __parents = {"Object"},
  status_effects = false,
  status_effects_can_remove = true,
  status_effects_limits = false
}
local table = table
local empty_table = empty_table
function StatusEffectsObject:AddStatusEffect(effect, ...)
  if not effect:IsCompatible(self, ...) then
    return
  end
  local limit = effect.StackLimit
  if 0 < limit then
    local status_effects_limits = self.status_effects_limits
    if not status_effects_limits then
      status_effects_limits = {}
      self.status_effects_limits = status_effects_limits
    end
    local counter = effect:StackLimitCounter() or false
    local count = status_effects_limits[counter] or 0
    if limit == 1 then
      if count ~= 0 then
        return effect:OnStackLimitReached(self, ...)
      end
      status_effects_limits[counter] = effect
    else
      if limit <= count then
        return effect:OnStackLimitReached(self, ...)
      end
      status_effects_limits[counter] = count + 1
    end
  end
  self:RefreshExpiration(effect)
  local status_effects = self.status_effects
  if not status_effects then
    status_effects = {}
    self.status_effects = status_effects
  end
  status_effects[#status_effects + 1] = effect
  effect:OnAdd(self, ...)
  return effect
end
function StatusEffectsObject:RefreshExpiration(effect)
  if effect.Expiration then
    effect.expiration_time = GameTime() + effect.ExpirationTime + InteractionRand(effect.ExpirationRandom, "status_effect", self)
  end
end
function StatusEffectsObject:RemoveStatusEffect(effect, ...)
  local n = remove_value(self.status_effects, effect)
  if not n then
    return
  end
  local limit = effect.StackLimit
  if 0 < limit then
    local status_effects_limits = self.status_effects_limits
    local counter = effect:StackLimitCounter() or false
    if status_effects_limits then
      local count = status_effects_limits[counter] or 1
      if limit == 1 or count == 1 then
        status_effects_limits[counter] = nil
      else
        status_effects_limits[counter] = count - 1
      end
    end
  end
  effect:OnRemove(self, ...)
end
function StatusEffectsObject:GetModalStatusEffect(counter)
  local status_effects_limits = self.status_effects_limits
  local effect = status_effects_limits and status_effects_limits[counter or false] or false
  return effect
end
function StatusEffectsObject:FirstEffectByCounter(counter)
  local status_effects_limits = self.status_effects_limits
  local effect = status_effects_limits and status_effects_limits[counter or false] or false
  if not effect then
    return
  end
  if type(effect) == "table" then
    return effect
  end
  for _, effect in ipairs(self.status_effects or empty_table) do
    if effect.StackLimit > 1 and effect:StackLimitCounter() == counter then
      return effect
    end
  end
end
function StatusEffectsObject:ExpireStatusEffects(time)
  time = time or GameTime()
  local expired_effects
  local status_effects = self.status_effects or empty_table
  for _, effect in ipairs(status_effects) do
    if effect and (effect.expiration_time or time) - time < 0 then
      expired_effects = expired_effects or {}
      expired_effects[#expired_effects + 1] = effect
    end
  end
  if not expired_effects then
    return
  end
  for i, effect in ipairs(expired_effects) do
    if i == 1 or find(status_effects, effect) then
      effect:OnExpire(self)
      effect.expiration_time = nil
    end
  end
end
function StatusEffectsObject:FirstEffectById(id)
  return find_value(self.status_effects, "id", id)
end
function StatusEffectsObject:FirstEffectByGroup(group)
  return group and find_value(self.status_effects, "group", group)
end
function StatusEffectsObject:FirstEffectByIdClass(id, class)
  for i, effect in ipairs(self.status_effects) do
    if effect.id == id and IsKindOf(effect, class) then
      return effect, i
    end
  end
end
function StatusEffectsObject:ForEachEffectByClass(class, func, ...)
  local can_remove = self.status_effects_can_remove
  self.status_effects_can_remove = false
  local res
  for _, effect in ipairs(self.status_effects or empty_table) do
    if IsKindOf(effect, class) then
      res = func(effect, ...)
      if res then
        break
      end
    end
  end
  if can_remove then
    self.status_effects_can_remove = nil
  end
  return res
end
function StatusEffectsObject:ChooseStatusEffect(none_chance, list, templates)
  if not list or #list == 0 or 0 < none_chance and none_chance > InteractionRand(100, "status_effect", self) then
    return
  end
  local cons = list[1]
  if type(cons) == "string" then
    if #list == 1 then
      if not templates or templates[cons] then
        return cons
      end
    else
      local weight = 0
      for _, cons in ipairs(list) do
        if not templates or templates[cons] then
          weight = weight + 1
        end
      end
      weight = InteractionRand(weight, "status_effect", self)
      for _, cons in ipairs(list) do
        if not templates or templates[cons] then
          weight = weight - 1
          if weight < 0 then
            return cons
          end
        end
      end
    end
  elseif #list == 1 then
    if not templates or templates[cons.effect] then
      return cons.effect
    end
  else
    local weight = 0
    for _, cons in ipairs(list) do
      if not templates or templates[cons.effect] then
        weight = weight + cons.weight
      end
    end
    weight = InteractionRand(weight, "status_effect", self)
    for _, cons in ipairs(list) do
      if not templates or templates[cons.effect] then
        weight = weight - cons.weight
        if weight < 0 then
          return cons.effect
        end
      end
    end
  end
end
