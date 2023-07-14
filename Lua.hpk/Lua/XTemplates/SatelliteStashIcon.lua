PlaceObj("XTemplate", {
  __is_kind_of = "XMapRollerableContext",
  group = "Zulu Satellite UI",
  id = "SatelliteStashIcon",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XMapRollerableContext",
    "IdNode",
    true,
    "HAlign",
    "center",
    "VAlign",
    "center",
    "ScaleModifier",
    point(2000, 2000),
    "UseClipBox",
    false,
    "HandleMouse",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self.idItemCount:SetText(context:CountItemsInSlot("Inventory"))
      local iconObject = self.context
      local sectorId = iconObject.sector_id
      if not self:GetThread("inventory-sentry") then
        self:CreateThread("inventory-sentry", function()
          while self.window_state ~= "destroying" do
            local dlg = GetDialog("FullscreenGameDialogs")
            if dlg then
              WaitMsg(dlg)
              iconObject:Clear()
              iconObject:SetSectorId(sectorId)
              ObjModified(iconObject)
            end
            local hasSquadHere = AnyPlayerSquadsInSector(sectorId)
            self.idUpperIcon:SetColumn(hasSquadHere and 3 or 2)
            Sleep(100)
          end
        end)
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XButton",
      "IdNode",
      false,
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "Background",
      RGBA(0, 0, 0, 0),
      "ContextUpdateOnOpen",
      false,
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "FocusedBackground",
      RGBA(0, 0, 0, 0),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "OnPress",
      function(self, gamepad)
        local sectorId = self.context.sector_id
        OpenSectorStashUIForSector(sectorId)
      end,
      "RolloverBackground",
      RGBA(0, 0, 0, 0),
      "PressedBackground",
      RGBA(0, 0, 0, 0)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idBase",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "UseClipBox",
        false,
        "Image",
        "UI/Icons/SateliteView/icon_neutral"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idUpperIcon",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "Image",
        "UI/Icons/SateliteView/sa_stash",
        "Columns",
        3,
        "Column",
        2
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idItemCount",
        "Margins",
        box(0, 0, 0, -5),
        "HAlign",
        "right",
        "VAlign",
        "bottom",
        "ScaleModifier",
        point(1500, 1500),
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PartyUISelectedSquad",
        "Text",
        "5"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        if not self.context then
          return
        end
        DoneObject(self.context)
        self.context = false
      end
    })
  })
})
