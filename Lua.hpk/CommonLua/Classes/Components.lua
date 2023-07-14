local not_attached = function(obj)
  return not obj:GetParent()
end
DefineClass.ComponentAttach = {
  __parents = {"CObject"},
  flags = {cofComponentAttach = true},
  properties = {
    {
      category = "Child",
      id = "AttachOffset",
      name = "Attached Offset",
      editor = "point",
      default = point30,
      no_edit = not_attached,
      dont_save = true
    },
    {
      category = "Child",
      id = "AttachAxis",
      name = "Attached Axis",
      editor = "point",
      default = axis_z,
      no_edit = not_attached,
      dont_save = true
    },
    {
      category = "Child",
      id = "AttachAngle",
      name = "Attached Angle",
      editor = "number",
      default = 0,
      no_edit = not_attached,
      dont_save = true,
      min = -10800,
      max = 10800,
      slider = true,
      scale = "deg"
    },
    {
      category = "Child",
      id = "AttachSpotName",
      name = "Attached At",
      editor = "text",
      default = "",
      no_edit = not_attached,
      dont_save = true,
      read_only = true
    },
    {
      category = "Child",
      id = "Parent",
      name = "Attached To",
      editor = "object",
      default = false,
      no_edit = not_attached,
      dont_save = true,
      read_only = true
    },
    {
      category = "Child",
      id = "TopmostParent",
      name = "Topmost Parent",
      editor = "object",
      default = false,
      no_edit = not_attached,
      dont_save = true,
      read_only = true
    },
    {
      category = "Child",
      id = "AngleLocal",
      name = "Local Angle",
      editor = "number",
      default = 0,
      no_edit = not_attached,
      dont_save = true,
      min = -10800,
      max = 10800,
      slider = true,
      scale = "deg"
    },
    {
      category = "Child",
      id = "AxisLocal",
      name = "Local Axis",
      editor = "point",
      default = axis_z,
      no_edit = not_attached,
      dont_save = true
    }
  }
}
ComponentAttach.SetAngleLocal = CObject.SetAngle
ComponentAttach.SetAxisLocal = CObject.SetAxis
DefineClass.StripComponentAttachProperties = {
  __parents = {
    "ComponentAttach"
  },
  properties = {
    {
      id = "AttachOffset"
    },
    {id = "AttachAxis"},
    {
      id = "AttachAngle"
    },
    {
      id = "AttachSpotName"
    },
    {id = "Parent"}
  }
}
function ComponentAttach:GetAttachSpotName()
  local parent = self:GetParent()
  return parent and parent:GetSpotName(self:GetAttachSpot())
end
DefineClass.ComponentCustomData = {
  __parents = {"CObject"},
  flags = {cofComponentCustomData = true},
  GetCustomData = _GetCustomData,
  SetCustomData = _SetCustomData,
  GetCustomString = _GetCustomString,
  SetCustomString = _SetCustomString
}
if Platform.developer then
  function OnMsg.ClassesPreprocess(classdefs)
    for name, class in pairs(classdefs) do
      if table.find(class.__parents, "ComponentCustomData") and not class.CustomDataType then
        class.CustomDataType = name
      end
    end
  end
end
function SpecialOrientationItems()
  local SpecialOrientationNames = {
    "soTerrain",
    "soTerrainLarge",
    "soFacing",
    "soFacingY",
    "soFacingVertical",
    "soVelocity",
    "soZOffset",
    "soTerrainPitch",
    "soTerrainPitchLarge"
  }
  table.sort(SpecialOrientationNames)
  local items = {}
  for i, name in ipairs(SpecialOrientationNames) do
    items[i] = {
      text = name,
      value = const[name]
    }
  end
  table.insert(items, 1, {
    text = "",
    value = const.soNone
  })
  return items
end
DefineClass.ComponentExtraTransform = {
  __parents = {"CObject"},
  flags = {cofComponentExtraTransform = true},
  properties = {
    {
      id = "SpecialOrientation",
      name = "Special Orientation",
      editor = "choice",
      default = const.soNone,
      items = SpecialOrientationItems
    }
  }
}
DefineClass.ComponentInterpolation = {
  __parents = {"CObject"},
  flags = {cofComponentInterpolation = true}
}
DefineClass.ComponentCurvature = {
  __parents = {"CObject"},
  flags = {cofComponentCurvature = true}
}
DefineClass.ComponentAnim = {
  __parents = {"CObject"},
  flags = {cofComponentAnim = true}
}
