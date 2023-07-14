if Platform.ged then
  GedPropEditors.accuracy_chart = "GedPropAccuracyChart"
  DefineClass.GedPropAccuracyChart = {
    __parents = {
      "GedPropEditor"
    }
  }
  function GedPropAccuracyChart:Init()
    XTemplateSpawn("AccuracyChart", self)
  end
  function GedPropAccuracyChart:UpdateValue()
    local values = self.panel:Obj(self.obj)
    local prop_defs = self.panel:Obj("SelectedObject|props")
    local props_cont = {}
    for i = 1, #prop_defs do
      local id = prop_defs[i].id
      if values[id] ~= nil then
        props_cont[id] = values[id]
      else
        props_cont[id] = prop_defs[i].default
      end
    end
    self.idDrawChart:SetContext(props_cont)
    GedPropEditor.UpdateValue(self)
  end
  GedPropEditors.directions_set = "GedPropDirectionsSet"
  DefineClass.GedPropDirectionsSet = {
    __parents = {"GedPropSet"},
    items = {
      {text = "N", value = "North"},
      {text = "W", value = "West"},
      {text = "E", value = "East"},
      {text = "S", value = "South"}
    }
  }
  local h_list_items = {West = true, East = true}
  function GedPropDirectionsSet:UpdateValue()
    self.idContainer:DeleteChildren()
    self.idContainer:SetLayoutMethod("VList")
    self.idContainer:SetHAlign("left")
    for _, item in ipairs(self.items) do
      local h_list = h_list_items[item.value]
      if h_list and not self:HasMember("idHListCont") then
        XWindow:new({
          Id = "idHListCont",
          LayoutMethod = "HList",
          LayoutHSpacing = 10
        }, self.idContainer)
      end
      local button = self:CreateButton(item, h_list and self.idHListCont)
      button:SetHAlign("center")
    end
    GedPropEditor.UpdateValue(self)
  end
end
DefineClass.PropertyDefAccuracyChart = {
  __parents = {
    "PropertyDef"
  },
  properties = {
    {
      category = "Browse",
      id = "default",
      name = "Default value",
      editor = "text",
      default = ""
    }
  },
  editor = "accuracy_chart",
  EditorName = "Accuracy chart",
  EditorSubmenu = "Extras"
}
function GetRangeAccuracy_Ref(props_cont, distance, unit, action)
  local effective_range_acc = 100
  local point_blank_acc = 100
  local weapon_range
  if unit and action then
    weapon_range = action:GetMaxAimRange(unit, props_cont)
  end
  weapon_range = weapon_range or props_cont.WeaponRange or props_cont:GetProperty("WeaponRange")
  distance = 1.0 * distance / const.SlabSizeX
  local y0 = 1.0 * point_blank_acc
  local xm, ym = 0.5 * weapon_range, 1.0 * effective_range_acc
  local xr = 1.0 * weapon_range
  local a, b, c = 0, 0, 0
  if distance <= xm then
    return effective_range_acc
  else
    a = -ym / ((xm - xr) * (xm - xr))
    b = -2 * a * xm
    c = -a * xr * xr - b * xr
  end
  return round(a * distance * distance + b * distance + c, 1)
end
function GetRangeAccuracy(props_cont, distance, unit, action)
  local effective_range_acc = 100
  local point_blank_acc = 100
  local weapon_range
  if unit and action then
    weapon_range = action:GetMaxAimRange(unit, props_cont)
  end
  weapon_range = weapon_range or props_cont.WeaponRange or props_cont:GetProperty("WeaponRange")
  local y0 = point_blank_acc
  local xm, ym = weapon_range / 2, effective_range_acc
  local xr = weapon_range
  local a, b, c = 0, 0, 0
  if xm >= distance / const.SlabSizeX then
    return effective_range_acc
  else
    a = MulDivRound(-ym, const.SlabSizeX, (xm - xr) * (xm - xr))
    b = MulDivRound(-2 * a, xm, const.SlabSizeX)
    c = MulDivRound(-a, xr * xr, const.SlabSizeX) - b * xr
  end
  local part = MulDivRound(MulDivRound(a, distance, const.SlabSizeX), distance, const.SlabSizeX * const.SlabSizeX)
  return part + MulDivRound(b, distance, const.SlabSizeX) + c
end
