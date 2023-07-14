PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedImageViewer",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "LayoutMethod",
    "Box",
    "Translate",
    true,
    "Title",
    "File Editor"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ToggleAlpha",
      "ActionName",
      T(982004005762, "Toggle Alpha Only"),
      "ActionMenubar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.show_alpha_only
      end,
      "OnAction",
      function(self, host, source, ...)
        rawset(host, "show_alpha_only", not rawget(host, "show_alpha_only"))
        if host.show_alpha_only then
          host.idFile:AddShaderModifier({
            modifier_type = const.modShader,
            shader_flags = const.modImageCompAlpha
          })
        else
          host.idFile:RemoveModifiers(const.modShader)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idFile",
      "ImageFit",
      "scale-down"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idError",
      "Dock",
      "top",
      "FoldWhenHidden",
      true,
      "TextStyle",
      "GedError",
      "HideOnEmpty",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idTextureInfo",
      "Dock",
      "top",
      "FoldWhenHidden",
      true,
      "HideOnEmpty",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idStreamingInfo",
      "Dock",
      "top",
      "FoldWhenHidden",
      true,
      "HideOnEmpty",
      true
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "read file",
      "run",
      function(self, parent, context)
        local os_path = ConvertToOSPath(context.file_name)
        if not os_path or os_path == "" then
          parent.idError:SetText(string.format("Could not convert %s to os path.", context.file_name))
          parent:SetTitle("File " .. context.file_name)
        else
          parent:SetTitle("File " .. os_path)
        end
        parent:SetTitle("File " .. os_path)
        parent.idFile:SetImage(context.file_name)
        if context.show_alpha_only then
          parent.idFile:AddShaderModifier({
            modifier_type = const.modShader,
            shader_flags = const.modImageCompAlpha
          })
        end
        local texId = ResourceManager.GetResourceID(context.file_name)
        if texId == const.InvalidResourceID then
          parent.idError:SetText(string.format("Image by name %s not found.", context.file_name))
        else
          local metadata = ResourceManager.GetMetadata(texId)
          local format = GetDataFormatName(metadata.Format)
          parent.idTextureInfo:SetText(string.format("ResourceID: %d; Size: %dx%d; Mips: %d; Format: %s", texId, metadata.Width, metadata.Height, metadata.NumLevels, format))
          if not Platform.ged then
            parent:CreateThread("UpdateTextureData", function(self)
              local resource = AsyncGetResource(texId)
              while true do
                self.idStreamingInfo:SetText(string.format("Resident Mips: %d", resource:GetResidentMips()))
                WaitNextFrame(5)
              end
            end, parent)
          end
        end
      end
    })
  })
})
