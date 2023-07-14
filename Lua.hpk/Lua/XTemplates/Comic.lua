PlaceObj("XTemplate", {
  __content = function(parent, context)
    return parent.idContent
  end,
  __is_kind_of = "XDialog",
  group = "Comic",
  id = "Comic",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Background",
    RGBA(0, 0, 0, 255),
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XAspectWindow",
      "Id",
      "idContent"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "TEXT",
      "Margins",
      box(0, 0, 0, 100),
      "MarginPolicy",
      "FitInSafeArea",
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "MaxWidth",
      1200,
      "Clip",
      false,
      "UseClipBox",
      false,
      "FadeInTime",
      300,
      "FadeOutTime",
      300,
      "TextStyle",
      "OutroComicSubtitles",
      "Translate",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        return ComicOnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        return ComicOnOpen(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        local sounds = self.playing_sounds
        if sounds then
          for i, handle in ipairs(sounds) do
            StopSound(handle)
          end
        end
        return XDialog.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idSkipHint",
      "Margins",
      box(0, 0, 50, 40),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Visible",
      false,
      "DrawOnTop",
      true,
      "HandleMouse",
      false,
      "TextStyle",
      "SkipHint",
      "Translate",
      true
    })
  })
})
