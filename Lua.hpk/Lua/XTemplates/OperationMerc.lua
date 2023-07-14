PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "OperationMerc",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "HList",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "ChildrenHandleMouse",
    true,
    "FXPress",
    "activityAddPress",
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        local class = self.context.merc.class
        if class ~= "empty" and class ~= "free_space" then
          local data = gv_UnitData[class] or g_Classes[class]
          self.idPortrait:SetImage(data.Portrait)
        end
        if self.context.unavailable and self.context.merc.prof ~= "Militia" then
          self.idPortrait:SetVisible(false)
        end
        self:SetupStyle()
        XButton.Open(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetupStyle(self, rollover)",
      "func",
      function(self, rollover)
        local class = self.context.merc.class
        local is_militia = self.context.merc.prof == "Militia"
        if class == "free_space" then
          return
        end
        local selected = self.selected or rollover
        local noClr = const.PDAUIColors.noClr
        local selectedColored = const.HUDUIColors.selectedColored
        local defaultColor = GameColors.B
        if class ~= "empty" or is_militia then
          self.idMerc:SetImage(selected and "UI/PDA/os_portrait_selection" or "")
          self.idBottomPart:SetBackground(selected and noClr or defaultColor)
          self.idBottomPart:SetBackgroundRectGlowColor(selected and noClr or defaultColor)
          self.idMerc:SetBackground(selected and RGBA(255, 255, 255, 255) or noClr)
          if class ~= "free_space" and not is_militia then
            self.idCost:SetTextStyle(selected and "PDAActivityMercNameCard_Text" or "PDAActivityMercNameCard_Text_Unselected")
            self.idEta:SetTextStyle(selected and "PDAActivityMercNameCard_Text" or "PDAActivityMercNameCard_Text_Unselected")
          end
        end
        if class == "empty" and not is_militia then
          self.idEmptyBack:SetBackground(selected and noClr or GameColors.B)
          self.idMerc:SetImage(selected and "UI/PDA/os_portrait_selection" or "")
          self.idMerc:SetBackground(selected and RGBA(255, 255, 255, 255) or noClr)
        end
        local name = self:ResolveId("idName")
        if name then
          self.idName:SetTextStyle(selected and "PDAActivityMercNameCard" or "PDAActivityMercNameCard_Light")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self.selected = selected
        self:SetupStyle()
        if selected then
          PlayFX("activityMercSelect", "start", self)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetStyle(self, selected)",
      "func",
      function(self, selected)
        return self:SetSelected(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        XButton.OnSetRollover(self, rollover)
        local context = self.context
        if context.merc.prof == "Militia" or context.unavailable then
          return
        end
        if rollover then
          PlayFX("activityMercHover", "start", self)
        end
        self:SetupStyle(rollover)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return context.merc and context.merc.class ~= "empty" and context.merc.class ~= "free_space"
      end,
      "__class",
      "XContextWindow",
      "RolloverText",
      T(738623694504, "<placeholder>"),
      "Id",
      "idContent",
      "LayoutMethod",
      "VList",
      "HandleMouse",
      true,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local merc = self.context.merc
        local text
        local host = GetActionsHost(self, true)
        local dlg = GetDialog(self)
        local dlg_context = dlg.context
        local operation_id = self.context.operation or host.context.operation
        local operation = SectorOperations[operation_id]
        local sector = dlg_context.sector or dlg_context
        local node = self:ResolveId("node")
        node.idAddIcon:SetVisible(false)
        node.idWounds:SetVisible(false)
        local stat, stat_val
        if IsMerc(gv_UnitData[merc.class]) then
          stat, stat_val = operation:GetRelatedStat(merc, sector)
          if stat then
            local prop_meta = table.find_value(UnitPropertiesStats:GetProperties(), "id", stat)
            local stat_name = prop_meta.name
            node.idStat:SetImage("UI/Icons/st_" .. string.lower(stat))
            node.idStatVal:SetText(stat_val)
            node.idStat:SetRolloverTitle(stat_name)
            node.idStat:SetRolloverText(prop_meta.help)
            node.idStatVal:SetRolloverTitle(stat_name)
            node.idStatVal:SetRolloverText(prop_meta.help)
          end
        end
        local prof = dlg_context.profession or context.list_as_prof
        if prof == "Patient" then
          local count = merc:GetStatusEffect("Wounded").stacks or 0
          if 0 < count then
            local effect = CharacterEffectDefs.Wounded
            node.idWounds:SetContext(effect)
            node.idWounds:SetVisible(true)
            node.idWoundsCount:SetText(count == 1 and "" or count)
          end
        end
        if prof == "Student" then
          local teachers = GetOperationProfessionals(sector.Id, "TrainMercs", "Teacher")
          if next(teachers) and teachers[1] and teachers[1][stat] <= merc[stat] or 90 < merc[stat] then
            local icon = "UI/Icons/too_skilled"
            node.idAddIcon:SetVisible(true)
            node.idAddIcon:SetBackground(GameColors.B)
            node.idAddIconImg:SetContext({
              Description = T(602903443457, "Too Skilled")
            })
            node.idAddIconImg:SetImage(icon)
            node.idAddIconImg:SetImageColor(GameColors.J)
            node.idAddIconImg:SetRolloverTemplate("SmallRolloverLine")
            node.idAddIcon:SetRolloverAnchor("right")
          end
          local diff = SectorOperation_StudentStatDiff(sector.Id, merc, teachers)
          local icon = "UI/SectorOperations/training_level_" .. diff
          node.idWounds:SetVisible(true)
          node.idWounds:SetImageScale(point(1000, 1000))
          node.idWounds:SetBackground(GameColors.B)
          node.idWounds:SetContext({
            DisplayName = T(508854975168, "Learning"),
            Description = T(201575967168, "Students learn faster the greater the difference between teacher's and students stats is")
          })
          node.idWounds:SetImage(icon)
          node.idWounds:SetImageColor(GameColors.J)
          node.idWounds:SetHAlign("right")
        end
        if merc.prof == "Militia" then
          node.idAddIcon:SetRolloverTemplate("SmallRolloverLine")
          node.idAddIcon:SetRolloverAnchor("right")
          node.idAddIcon:SetVisible(true)
          node.idAddIcon:SetBackground(GameColors.B)
          local unit_def = UnitDataDefs[merc.class]
          local icon = "UI/PDA/MercPortrait/T_ClassIcon_" .. merc.class .. "_Small"
          node.idAddIconImg:SetContext({
            DisplayName = unit_def.Name,
            Description = ""
          })
          node.idAddIconImg:SetImage(icon)
          node.idAddIcon:SetHAlign("right")
          node.idAddIcon:SetRolloverText(unit_def.Name)
          node.idStat:SetVisible(false)
          node.idCountIcon:SetVisible(1 < merc.count)
          node.idCountText:SetText(Untranslated("x" .. merc.count or 0))
        end
        if operation_id == "RAndR" then
          local effect = UnitTirednessEffect[merc.Tiredness]
          if 0 < merc.Tiredness then
            local effect = CharacterEffectDefs[effect]
            node.idAddIcon:SetVisible(true)
            node.idAddIconImg:SetContext(effect)
            node.idAddIcon:SetBackground(GameColors.B)
            node.idAddIconImg:SetImage(effect.Icon)
          end
          if merc:HasStatusEffect("Wounded") then
            local effect = merc:GetStatusEffect("Wounded")
            local count = effect.stacks or 0
            if 0 < count then
              node.idWounds:SetVisible(true)
              node.idWoundsCount:SetText(count == 1 and "" or count)
              node.idWounds:SetRolloverTitle(effect.DisplayName)
              node.idWounds:SetRolloverText(T({
                effect.Description,
                effect
              }))
            end
          end
        end
        if text and text ~= "" then
          self:ResolveId("idText"):SetText(text)
        end
        if operation_id == "MilitiaTraining" then
          local name = self:ResolveId("idName")
          local militia_context = name:GetContext()
          if militia_context.militia then
            name:SetText(militia_context.Name)
          end
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "HAlign",
        "center",
        "MinHeight",
        134,
        "MaxHeight",
        134,
        "UseClipBox",
        false,
        "HandleMouse",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idMerc",
          "IdNode",
          false,
          "Margins",
          box(0, 20, 0, 0),
          "MinWidth",
          98,
          "MaxWidth",
          98,
          "Background",
          RGBA(255, 255, 255, 0),
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "portrait bg",
            "__class",
            "XImage",
            "Id",
            "idPortraitBG",
            "IdNode",
            false,
            "Margins",
            box(5, 5, 5, 0),
            "HAlign",
            "center",
            "VAlign",
            "top",
            "MinWidth",
            98,
            "MinHeight",
            90,
            "MaxWidth",
            98,
            "MaxHeight",
            90,
            "Image",
            "UI/Hud/portrait_background",
            "ImageFit",
            "stretch"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idPortrait",
              "IdNode",
              false,
              "ZOrder",
              2,
              "Margins",
              box(0, -20, 0, 0),
              "Image",
              "UI/MercsPortraits/unknown",
              "ImageFit",
              "largest",
              "ImageRect",
              box(35, 0, 255, 230)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idSkull",
                "Margins",
                box(0, 0, 2, 2),
                "HAlign",
                "right",
                "VAlign",
                "bottom",
                "Visible",
                false,
                "FoldWhenHidden",
                true,
                "Image",
                "UI/Hud/dead_merc",
                "ImageScale",
                point(600, 600),
                "ImageColor",
                RGBA(218, 104, 8, 255)
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "RolloverTemplate",
                "RolloverGenericOperation",
                "RolloverText",
                T(295550387427, "<Description>"),
                "RolloverTitle",
                T(738866002832, "<DisplayName>"),
                "Id",
                "idWounds",
                "IdNode",
                false,
                "Padding",
                box(2, 2, 2, 2),
                "HAlign",
                "right",
                "VAlign",
                "bottom",
                "Visible",
                false,
                "FoldWhenHidden",
                true,
                "Background",
                RGBA(32, 35, 47, 255),
                "HandleMouse",
                true,
                "Image",
                "UI/Hud/Status effects/wounded",
                "ImageScale",
                point(500, 500)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idWoundsCount",
                  "Margins",
                  box(0, -5, 0, 0),
                  "Padding",
                  box(0, 0, 0, 0),
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "PDAActivityDescriptionWounds",
                  "TextHAlign",
                  "right"
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XSquareWindow",
              "Id",
              "idAddIcon",
              "ZOrder",
              3,
              "HAlign",
              "left",
              "VAlign",
              "bottom",
              "MinWidth",
              28,
              "MinHeight",
              28,
              "MaxWidth",
              28,
              "MaxHeight",
              28,
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "RolloverTemplate",
                "RolloverGenericOperation",
                "RolloverText",
                T(295550387427, "<Description>"),
                "RolloverTitle",
                T(738866002832, "<DisplayName>"),
                "Id",
                "idAddIconImg",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                20,
                "MinHeight",
                20,
                "MaxWidth",
                20,
                "MaxHeight",
                20,
                "FoldWhenHidden",
                true,
                "HandleMouse",
                true,
                "ImageFit",
                "stretch",
                "ContextUpdateOnOpen",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idBottomPart",
            "Margins",
            box(5, 0, 5, 0),
            "Dock",
            "bottom",
            "VAlign",
            "bottom",
            "MinWidth",
            98,
            "MinHeight",
            30,
            "MaxWidth",
            98,
            "MaxHeight",
            30,
            "LayoutMethod",
            "VList",
            "BackgroundRectGlowSize",
            1,
            "BackgroundRectGlowColor",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return gv_UnitData[context.merc.class] or g_Classes[context.merc.class]
              end,
              "__class",
              "XText",
              "Id",
              "idName",
              "Margins",
              box(2, 0, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "bottom",
              "MaxWidth",
              98,
              "Clip",
              false,
              "UseClipBox",
              false,
              "FoldWhenHidden",
              true,
              "HandleMouse",
              false,
              "ChildrenHandleMouse",
              false,
              "TextStyle",
              "PDAActivityMercNameCard_Light",
              "Translate",
              true,
              "Text",
              T(581954270351, "<Nick>"),
              "WordWrap",
              false,
              "Shorten",
              true,
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "OperationProgressBar",
              "Id",
              "idOperationProgressBar",
              "HAlign",
              "center",
              "MinWidth",
              98,
              "MinHeight",
              5,
              "MaxWidth",
              98,
              "MaxHeight",
              5,
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                if not context then
                  self:SetVisible(false)
                  return
                end
                if context.operation == "MilitiaTraining" then
                  if not context.merc.in_progress then
                    self:SetVisible(false)
                    return
                  end
                elseif context.list_as_prof ~= "Patient" then
                  self:SetVisible(false)
                  return
                end
                local merc = gv_UnitData[context.merc.class] or g_Classes[context.merc.class]
                if merc.OperationProfessions and merc.OperationProfessions.Doctor and not merc.OperationProfessions.Patient then
                  self:SetVisible(false)
                  return
                end
                local dlg_context = GetDialog(self).context
                local sector = IsKindOf(dlg_context, "SatelliteSector") and dlg_context or dlg_context.sector
                local progress
                local ctrl = self:ResolveId("idContent")
                local operation_id = ctrl.context.operation or dlg_context.operation
                local operation = SectorOperations[operation_id]
                local max = operation:ProgressCompleteThreshold(merc, sector, "Patient")
                progress = 0 < max and MulDivRound(operation:ProgressCurrent(merc, sector, "Patient") or 0, 100, max)
                if progress and 0 <= progress then
                  self:SetProgress(progress)
                  self:SetVisible(true)
                else
                  self:SetVisible(false)
                end
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "unit count icon",
            "__class",
            "XImage",
            "Id",
            "idCountIcon",
            "IdNode",
            false,
            "ZOrder",
            0,
            "Margins",
            box(0, 0, -32, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "Visible",
            false,
            "DrawOnTop",
            true,
            "Image",
            "UI/PDA/sector_ally",
            "ImageScale",
            point(600, 600)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idCountText",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "HandleMouse",
              false,
              "TextStyle",
              "PDASelectedSquad",
              "Translate",
              true,
              "Text",
              T(329015606733, "x8")
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return gv_UnitData[context.merc.class]
        end,
        "__class",
        "XText",
        "Id",
        "idText",
        "Margins",
        box(2, 0, 0, 0),
        "HAlign",
        "center",
        "MinWidth",
        98,
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "ChildrenHandleMouse",
        false,
        "TextStyle",
        "PDAActivityMercNameCard_Text",
        "Translate",
        true,
        "HideOnEmpty",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "bottom"
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 4, 0, 4)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextImage",
          "RolloverTemplate",
          "RolloverGenericOperation",
          "RolloverText",
          T(295550387427, "<Description>"),
          "RolloverTitle",
          T(738866002832, "<DisplayName>"),
          "Id",
          "idStat",
          "Margins",
          box(5, 0, 0, 0),
          "HAlign",
          "left",
          "MinWidth",
          22,
          "MinHeight",
          22,
          "MaxWidth",
          22,
          "MaxHeight",
          22,
          "UseClipBox",
          false,
          "HandleMouse",
          true,
          "ImageFit",
          "smallest",
          "ImageColor",
          RGBA(130, 128, 120, 255)
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "RolloverTemplate",
          "RolloverGenericOperation",
          "RolloverText",
          T(295550387427, "<Description>"),
          "RolloverTitle",
          T(738866002832, "<DisplayName>"),
          "Id",
          "idStatVal",
          "Margins",
          box(0, 0, 2, 0),
          "HAlign",
          "right",
          "MinWidth",
          98,
          "MaxWidth",
          98,
          "UseClipBox",
          false,
          "TextStyle",
          "PDAActivityMercNameCard_Text",
          "HideOnEmpty",
          true,
          "TextHAlign",
          "right",
          "TextVAlign",
          "bottom"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idEtaLine",
          "Margins",
          box(-10, 0, -10, 0),
          "VAlign",
          "top",
          "MinWidth",
          98,
          "MaxWidth",
          98,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(2, 0, 2, 0),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return gv_UnitData[context.merc.class]
          end,
          "__class",
          "XText",
          "Id",
          "idEta",
          "Margins",
          box(2, 0, 0, 0),
          "Clip",
          false,
          "UseClipBox",
          false,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "ChildrenHandleMouse",
          false,
          "TextStyle",
          "PDAActivityMercNameCard_Text",
          "Translate",
          true,
          "HideOnEmpty",
          true,
          "TextHAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idCostLine",
          "Margins",
          box(-10, 0, -10, 0),
          "VAlign",
          "top",
          "MinWidth",
          98,
          "MaxWidth",
          98,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(2, 0, 2, 0),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return gv_UnitData[context.merc.class]
          end,
          "__class",
          "XText",
          "Id",
          "idCost",
          "Margins",
          box(2, 0, 0, 0),
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "ChildrenHandleMouse",
          false,
          "TextStyle",
          "PDAActivityMercNameCard_Text",
          "Translate",
          true,
          "HideOnEmpty",
          true,
          "TextHAlign",
          "center"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return next(context) and context.merc.class == "empty" and context.merc.prof == "Militia"
      end,
      "__class",
      "XContextWindow",
      "RolloverText",
      T(738623694504, "<placeholder>"),
      "Id",
      "idContent",
      "HandleMouse",
      true,
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idMerc",
        "IdNode",
        false,
        "Margins",
        box(0, 20, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        98,
        "MinHeight",
        114,
        "MaxWidth",
        98,
        "MaxHeight",
        114,
        "Background",
        RGBA(255, 255, 255, 0),
        "HandleMouse",
        true,
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "portrait bg",
          "__class",
          "XImage",
          "Id",
          "idPortraitBG",
          "IdNode",
          false,
          "Margins",
          box(5, 5, 5, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "MinWidth",
          98,
          "MinHeight",
          84,
          "MaxWidth",
          84,
          "MaxHeight",
          90,
          "Image",
          "UI/Hud/portrait_background",
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idBottomPart",
          "Margins",
          box(5, 0, 5, 0),
          "VAlign",
          "bottom",
          "MinHeight",
          28,
          "MaxWidth",
          98,
          "MaxHeight",
          28,
          "LayoutMethod",
          "VList",
          "BackgroundRectGlowSize",
          1,
          "BackgroundRectGlowColor",
          RGBA(32, 35, 47, 255)
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return context.merc.class == "empty" and context.merc.prof ~= "Militia"
      end,
      "__class",
      "XContextWindow",
      "RolloverText",
      T(738623694504, "<placeholder>"),
      "Id",
      "idContent",
      "Margins",
      box(0, 0, 0, 28),
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idEmptyBack",
        "Margins",
        box(0, 20, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        98,
        "MinHeight",
        114,
        "MaxWidth",
        98,
        "MaxHeight",
        114,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idMerc",
          "IdNode",
          false,
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          98,
          "MinHeight",
          114,
          "MaxWidth",
          98,
          "MaxHeight",
          114,
          "Background",
          RGBA(255, 255, 255, 0),
          "HandleMouse",
          true,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idPortraitBG",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            88,
            "MinHeight",
            102,
            "MaxWidth",
            88,
            "MaxHeight",
            102,
            "Background",
            RGBA(32, 35, 47, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idPortrait",
            "IdNode",
            false,
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Image",
            "UI/PDA/T_Icon_Plus_Large",
            "ImageScale",
            point(600, 600),
            "ImageColor",
            RGBA(75, 80, 89, 255)
          })
        })
      })
    })
  })
})
