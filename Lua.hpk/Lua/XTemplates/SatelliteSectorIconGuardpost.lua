PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "SatelliteSectorIconGuardpost",
  PlaceObj("XTemplateWindow", {
    "__class",
    "SatelliteSectorIconGuardpostClass",
    "RolloverAnchor",
    "center-top",
    "IdNode",
    true,
    "Margins",
    box(0, 15, 10, 0),
    "HAlign",
    "right",
    "VAlign",
    "top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idShieldContainer",
      "Margins",
      box(60, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "Image",
        "UI/PDA/guardpost_pad",
        "ImageScale",
        point(1500, 1500),
        "FrameBox",
        box(0, 0, 50, 0),
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(40, 0, 40, 2),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        10,
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetGuardpostStrength(context.sector.Id)
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetRolloverText(item.Description)
            child.idShield:SetColumn(item.done and 2 or 1)
            if item.extra then
              child.idShield:SetImage("UI/PDA/guardpost_shield_2")
            else
              child.idShield:SetImage("UI/PDA/guardpost_shield")
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XMapRollerableContext",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverAnchor",
            "center-top",
            "RolloverOffset",
            box(10, 0, 0, 0),
            "IdNode",
            true,
            "UseClipBox",
            false,
            "HandleMouse",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idShield",
              "UseClipBox",
              false,
              "Image",
              "UI/PDA/guardpost_shield",
              "Columns",
              2
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTimer",
      "Margins",
      box(100, 50, 0, 0),
      "HAlign",
      "left",
      "UseClipBox",
      false,
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return context.sector.guardpost_obj
        end,
        "__template",
        "GuardpostSpawnTimerTemplate",
        "FoldWhenHidden",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XMapRollerableContextImage",
      "RolloverTemplate",
      "RolloverGeneric",
      "RolloverAnchor",
      "center-top",
      "Id",
      "idIcon",
      "IdNode",
      false,
      "HAlign",
      "left",
      "ScaleModifier",
      point(1500, 1500),
      "UseClipBox",
      false,
      "HandleMouse",
      true,
      "FXMouseIn",
      "SatelliteBadgeRollover",
      "Image",
      "UI/Icons/SateliteView/icon_enemy"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idInner",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "Image",
        "UI/Icons/SateliteView/guard_post"
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "GetRolloverText(self)",
        "func",
        function(self)
          local sector = self.context.sector
          return GetGuardpostRollover(sector)
        end
      })
    })
  })
})
