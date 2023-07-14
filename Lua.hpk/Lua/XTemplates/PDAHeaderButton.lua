PlaceObj("XTemplate", {
  __is_kind_of = "XSelectableTextButton",
  group = "Zulu PDA",
  id = "PDAHeaderButton",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "pda_tab"
    end,
    "__class",
    "XSelectableTextButton",
    "LayoutMethod",
    "Box",
    "OnContextUpdate",
    function(self, context, ...)
      self:SetHandleMouse(not g_ZuluMessagePopup)
      local dlg = GetDialog(self)
      local mode = dlg:GetMode()
      if #(mode or "") == 0 then
        mode = dlg.InitialMode
      end
      local isSelected
      if dlg.loading_mode then
        isSelected = dlg.loading_mode == self.GoToTab
      else
        isSelected = mode == self.GoToTab
      end
      self:SetSelected(isSelected)
      self:SetText(self.Text)
      XContextControl.OnContextUpdate(self, context)
    end,
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "OnPress",
    function(self, gamepad)
      local tab = self.GoToTab
      if tab == "" then
        return
      end
      local dlg = GetDialog(self)
      dlg:SetMode(tab)
      ObjModified("pda_tab")
    end,
    "Image",
    "UI/PDA/T_PDA_TabButton",
    "FrameBox",
    box(5, 5, 5, 5),
    "TextStyle",
    "HeaderButton",
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateState(self)",
      "func",
      function(self)
        XSelectableTextButton.UpdateState(self)
        local state = self.cosmetic_state
        if state == "selected" then
          self:SetColumnsUse("ccccc")
          self:SetTextStyle("HeaderButton_Selected")
        else
          self:SetColumnsUse("abcca")
          self:SetTextStyle("HeaderButton")
        end
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "PDA",
    "id",
    "GoToTab",
    "editor",
    "text",
    "translate",
    false,
    "name",
    T(733344557098, "GoToTab")
  })
})
