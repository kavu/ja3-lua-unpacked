PlaceObj("XTemplate", {
  group = "Zulu",
  id = "XSetpieceDlg",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XSetpieceDlg",
    "MouseCursor",
    "UI/Cursors/Cursor.tga"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Skip Hint",
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
      "PopupDescriptionTextWhite",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idSubtitle",
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
      "FadeInTime",
      300,
      "FadeOutTime",
      300,
      "TextStyle",
      "OutroComicSubtitles",
      "Translate",
      true
    })
  })
})
