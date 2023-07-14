DefineClass.FaceMovement = {
  __parents = {
    "ParticleBehavior"
  },
  EditorName = "Face: Movement"
}
DefineClass.FacePoint = {
  __parents = {
    "ParticleBehavior"
  },
  properties = {
    {
      id = "center",
      name = "Center",
      editor = "point",
      scale = guim
    }
  },
  center = point30,
  EditorName = "Face: Point"
}
DefineClass.FaceTerrain = {
  __parents = {
    "ParticleBehavior"
  },
  EditorName = "Face: Terrain"
}
DefineClass.FaceDirection = {
  __parents = {
    "ParticleBehavior"
  },
  properties = {
    {
      id = "direction",
      name = "Direction",
      editor = "point",
      scale = guim
    }
  },
  direction = point(0, 0, guim),
  EditorName = "Face: Direction"
}
DefineClass.FaceAlongConstDir = {
  __parents = {
    "ParticleBehavior"
  },
  properties = {
    {
      id = "direction",
      name = "Face along direction",
      editor = "point",
      scale = guim
    }
  },
  direction = point(0, 0, guim),
  EditorName = "Face: Along Const Dir"
}
DefineClass.FaceAlongMovement = {
  __parents = {
    "ParticleBehavior"
  },
  properties = {
    {
      id = "rotate",
      name = "Use rotation",
      editor = "bool"
    }
  },
  rotate = false,
  EditorName = "Face: Along Movement"
}
DefineClass.FaceSphere = {
  __parents = {
    "ParticleBehavior"
  },
  properties = {
    {
      id = "min_phi",
      editor = "number",
      default = 900,
      slider = true,
      min = 0,
      max = 1800,
      scale = 10
    },
    {
      id = "max_phi",
      editor = "number",
      default = 900,
      slider = true,
      min = 0,
      max = 1800,
      scale = 10
    },
    {
      id = "min_theta",
      editor = "number",
      default = 0,
      slider = true,
      min = -1800,
      max = 3600,
      scale = 10
    },
    {
      id = "max_theta",
      editor = "number",
      default = 3600,
      slider = true,
      min = -1800,
      max = 3600,
      scale = 10
    }
  },
  EditorName = "Face: Along Sphere Surface"
}
