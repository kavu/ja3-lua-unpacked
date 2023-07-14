PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedFileEditor",
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
      "Save",
      "ActionName",
      T(987510172530, "Save"),
      "ActionMenubar",
      "main",
      "ActionShortcut",
      "Ctrl-S",
      "OnAction",
      function(self, host, source, ...)
        local err, file = OSEncryptData(host.idFile:GetText(), "")
        err = err or AsyncStringToFile(host.file_name, file)
        host.idError:SetText(err or "")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XMultiLineEdit",
      "Id",
      "idFile",
      "VScroll",
      "idScroll"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XSleekScroll",
      "Id",
      "idScroll",
      "IdNode",
      false,
      "Dock",
      "right",
      "Target",
      "idFile"
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
    PlaceObj("XTemplateCode", {
      "comment",
      "read file",
      "run",
      function(self, parent, context)
        parent:SetTitle("File " .. context.file_name)
        local err, file = AsyncFileToString(context.file_name)
        if not err then
          local err, text = OSDecryptData(file, "")
          if not err then
            file = text
          end
        end
        parent.idError:SetText(err or "")
        parent.idFile:SetText(file or "")
        parent.idFile:SetFocus()
      end
    })
  })
})
