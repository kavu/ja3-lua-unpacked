PlaceObj("XTemplate", {
  group = "Comic",
  id = "ComicTest",
  PlaceObj("XTemplateTemplate", {"__template", "Comic"}, {
    PlaceObj("XTemplateThread", {
      "CloseOnFinish",
      true
    }, {
      PlaceObj("XTemplateSlide", {
        "transition",
        "Fade in",
        "transition_time",
        1000
      }, {
        PlaceObj("XTemplateWindow", {
          "Background",
          RGBA(12, 23, 234, 255)
        })
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "a conditional text within a (non-conditional) slide",
        "conditions",
        {
          PlaceObj("CheckExpression", {
            Expression = function(self, obj)
              return not IsEditorActive()
            end
          })
        }
      }, {
        PlaceObj("XTemplateVoice", {
          "TimeAfter",
          500,
          "TimeAdd",
          -1000,
          "Text",
          T(301703508895, [[
This text is visible only when the editor is NOT active.
Press F3 to toggle the editor.]])
        })
      }),
      PlaceObj("XTemplateSlide", {
        "transition",
        "Fade in",
        "transition_time",
        1000
      }, {
        PlaceObj("XTemplateWindow", {
          "Background",
          RGBA(235, 101, 98, 255)
        })
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Text",
        T(408039884025, "Aeons later")
      }),
      PlaceObj("XTemplateVoice", {
        "Text",
        T(505656865593, "Something else happened")
      }),
      PlaceObj("XTemplateConditionList", {
        "comment",
        "a conditional slide",
        "conditions",
        {
          PlaceObj("CheckExpression", {
            Expression = function(self, obj)
              return not IsEditorActive()
            end
          })
        }
      }, {
        PlaceObj("XTemplateSlide", {
          "transition",
          "Push left",
          "transition_time",
          500
        }, {
          PlaceObj("XTemplateWindow", {
            "Background",
            RGBA(70, 120, 130, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(100, 0, 100, 0),
              "HAlign",
              "left",
              "VAlign",
              "bottom",
              "TextStyle",
              "CityName",
              "Text",
              [[
This slide is visible only when the editor is NOT active. 
Press F3 to toggle the editor.]]
            })
          })
        }),
        PlaceObj("XTemplateSleep", {"Time", 2000})
      })
    })
  })
})
