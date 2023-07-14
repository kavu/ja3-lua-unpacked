PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Common",
  id = "AnimMetadataEditorTimeline",
  recreate_after_save = true,
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idAnimMetadataEditorTimeline",
    "Padding",
    box(0, 50, 0, 40),
    "Dock",
    "box",
    "HAlign",
    "center",
    "VAlign",
    "bottom",
    "MinWidth",
    1000,
    "MinHeight",
    130,
    "LayoutMethod",
    "HList",
    "UseClipBox",
    false,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "VAlign",
      "bottom",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 5, 0),
        "VAlign",
        "center",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idAnimationName",
          "Margins",
          box(0, 0, 0, 5),
          "TextStyle",
          "AnimMetadataEditorTimeline",
          "TextHAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "center",
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idPlay",
            "Margins",
            box(0, 0, 5, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MaxWidth",
            30,
            "MaxHeight",
            30,
            "OnPress",
            function(self, gamepad)
              GedOpAnimMetadataEditorPlay(self, GetAnimationMomentsEditorObject())
            end,
            "Image",
            "CommonAssets/UI/Ged/play"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idStop",
            "Margins",
            box(0, 0, 5, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MaxWidth",
            30,
            "MaxHeight",
            30,
            "GridX",
            2,
            "LayoutMethod",
            "None",
            "OnPress",
            function(self, gamepad)
              GedOpAnimMetadataEditorStop(self, GetAnimationMomentsEditorObject())
            end,
            "Image",
            "CommonAssets/UI/Ged/pause"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XToggleButton",
            "Id",
            "idLoop",
            "Margins",
            box(0, 0, 5, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MaxWidth",
            30,
            "MaxHeight",
            30,
            "GridX",
            3,
            "LayoutMethod",
            "None",
            "OnPress",
            function(self, gamepad)
              GedOpAnimationMomentsEditorToggleLoop(self, GetAnimationMomentsEditorObject())
            end,
            "Image",
            "CommonAssets/UI/Ged/undo"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idTimeline",
        "IdNode",
        true,
        "Margins",
        box(5, 0, 5, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MinWidth",
        1000,
        "MinHeight",
        60,
        "MaxHeight",
        60,
        "GridX",
        4,
        "LayoutMethod",
        "None",
        "BorderColor",
        RGBA(0, 255, 246, 255),
        "Background",
        RGBA(0, 0, 0, 255),
        "HandleMouse",
        true
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "DrawContent(self)",
          "func",
          function(self)
            local obj = GetAnimationMomentsEditorObject()
            if not IsValid(obj) or not IsValidEntity(obj:GetEntity()) then
              return
            end
            local dragging = AnimMetadataEditorTimelineSelectedControl and AnimMetadataEditorTimelineSelectedControl.dragging
            local frame = obj:GetFrame()
            if dragging then
              local time = AnimMetadataEditorTimelineSelectedControl.moment.Time
              frame = obj:GetModifiedTime(time)
            else
              self:DrawLine(frame, RGB(0, 255, 0))
            end
            local dlg = self.parent.parent
            local button_text = string.format("+New moment (%s)", FormatTimeline(frame, 3))
            dlg:UpdateControl(frame, button_text, dlg:ResolveId("idMoment-NewMoment"), "above timeline")
            local enabled = dlg:GetEnabledMomentTypes()
            local moment_controls = dlg:GetMomentControls()
            table.sort(moment_controls, function(a, b)
              return a.moment.Time < b.moment.Time
            end)
            for index, control in ipairs(moment_controls) do
              local moment = control.moment
              if enabled[moment.Type] then
                local time, text = dlg:GetMomentTime(moment)
                self:DrawLine(time, RGB(255, 0, 0))
                dlg:UpdateControl(time, text, control, index % 2 == 1)
              end
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            if button ~= "L" then
              return
            end
            AnimMetadataEditorTimelineDragging = true
            self:UpdateFrame(pos)
            return "break"
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonUp(self, pos, button)",
          "func",
          function(self, pos, button)
            if button ~= "L" then
              return
            end
            if not AnimMetadataEditorTimelineDragging then
              return
            end
            self:UpdateFrame(pos)
            AnimMetadataEditorTimelineDragging = false
            self.parent.parent:CreateNewMomentControl()
            local timeline = GetDialog("AnimMetadataEditorTimeline")
            if timeline then
              timeline:DeselectMoment()
            end
            return "break"
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMousePos(self, pos)",
          "func",
          function(self, pos)
            if not AnimMetadataEditorTimelineDragging then
              return
            end
            DeleteThread(AnimMetadataEditorTimelineDragging)
            AnimMetadataEditorTimelineDragging = CreateMapRealTimeThread(function()
              self:DrawContent()
              self:UpdateFrame(pos, "delayed moments binding")
            end)
            return "break"
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "UpdateFrame(self, pos, delayed_moments_binding)",
          "func",
          function(self, pos, delayed_moments_binding)
            local frame = self:GetFrame(pos)
            if frame then
              local obj = GetAnimationMomentsEditorObject()
              obj:SetFrame(frame, delayed_moments_binding)
              GedObjectModified(obj)
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "MoveFrame(self, time)",
          "func",
          function(self, time)
            local obj = GetAnimationMomentsEditorObject()
            if AnimMetadataEditorTimelineSelectedControl then
              local moment = AnimMetadataEditorTimelineSelectedControl.moment
              obj:SetFrame(obj:GetModifiedTime(moment.Time))
              local duration = obj:GetAbsoluteTime(obj.anim_duration)
              moment.Time = Clamp(obj:GetAbsoluteTime(obj.Frame) + time, 0, duration - 1)
              obj:SetFrame(obj:GetModifiedTime(moment.Time))
            else
              obj:SetFrame(obj:GetAbsoluteTime(obj.Frame) + time)
            end
            GedObjectModified(obj)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "DrawLine(self, frame, color)",
          "func",
          function(self, frame, color)
            local obj = GetAnimationMomentsEditorObject()
            if not obj then
              return
            end
            local duration = Max(obj.anim_duration, 1)
            local b = self.box
            local width = b:sizex()
            local column = b:minx() + width * frame / duration
            UIL.DrawLine(point(column, b:miny()), point(column, b:maxy()), color)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "GetFrame(self, pos)",
          "func",
          function(self, pos)
            local obj = GetAnimationMomentsEditorObject()
            if not obj then
              return
            end
            local duration = obj.anim_duration
            if duration <= 0 then
              return
            end
            local control = AnimMetadataEditorTimelineSelectedControl
            local box = self.box
            local width = box:sizex()
            local column = pos:x() - box:minx()
            if not control or not control.dragging then
              column = Clamp(column, 0, width)
            end
            return MulDivTrunc(duration, column, width)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idDuration",
        "Margins",
        box(5, 0, 5, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MinWidth",
        50,
        "MaxHeight",
        30,
        "GridX",
        5,
        "LayoutMethod",
        "None",
        "TextStyle",
        "AnimMetadataEditorTimeline",
        "Text",
        "Duration",
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "GridX",
      6,
      "GridStretchX",
      false,
      "GridStretchY",
      false,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "HAlign",
        "center",
        "MinWidth",
        50,
        "MaxHeight",
        20,
        "LayoutMethod",
        "None",
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "AnimMetadataEditorTimeline",
        "Text",
        "Preview Speed",
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToggleButton",
        "Id",
        "idSpeed100",
        "BorderWidth",
        1,
        "HAlign",
        "center",
        "MinWidth",
        50,
        "Background",
        RGBA(134, 134, 134, 255),
        "OnPress",
        function(self, gamepad)
          GedOpAnimationMomentsEditorToggleSpeed(self, 100)
          self:SetToggled(true)
          self:ResolveId("idSpeed50"):SetToggled(false)
          self:ResolveId("idSpeed20"):SetToggled(false)
          self:ResolveId("idSpeed10"):SetToggled(false)
        end,
        "RolloverBackground",
        RGBA(178, 178, 178, 255),
        "PressedBackground",
        RGBA(172, 172, 172, 255),
        "Text",
        "100%",
        "Toggled",
        true,
        "ToggledBackground",
        RGBA(204, 204, 204, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToggleButton",
        "Id",
        "idSpeed50",
        "BorderWidth",
        1,
        "HAlign",
        "center",
        "MinWidth",
        50,
        "Background",
        RGBA(134, 134, 134, 255),
        "OnPress",
        function(self, gamepad)
          GedOpAnimationMomentsEditorToggleSpeed(self, 50)
          self:SetToggled(true)
          self:ResolveId("idSpeed100"):SetToggled(false)
          self:ResolveId("idSpeed20"):SetToggled(false)
          self:ResolveId("idSpeed10"):SetToggled(false)
        end,
        "RolloverBackground",
        RGBA(178, 178, 178, 255),
        "PressedBackground",
        RGBA(172, 172, 172, 255),
        "Text",
        "50%",
        "ToggledBackground",
        RGBA(204, 204, 204, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToggleButton",
        "Id",
        "idSpeed20",
        "BorderWidth",
        1,
        "HAlign",
        "center",
        "MinWidth",
        50,
        "Background",
        RGBA(134, 134, 134, 255),
        "OnPress",
        function(self, gamepad)
          GedOpAnimationMomentsEditorToggleSpeed(self, 20)
          self:SetToggled(true)
          self:ResolveId("idSpeed100"):SetToggled(false)
          self:ResolveId("idSpeed50"):SetToggled(false)
          self:ResolveId("idSpeed10"):SetToggled(false)
        end,
        "RolloverBackground",
        RGBA(178, 178, 178, 255),
        "PressedBackground",
        RGBA(172, 172, 172, 255),
        "Text",
        "20%",
        "ToggledBackground",
        RGBA(204, 204, 204, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToggleButton",
        "Id",
        "idSpeed10",
        "BorderWidth",
        1,
        "HAlign",
        "center",
        "MinWidth",
        50,
        "Background",
        RGBA(134, 134, 134, 255),
        "OnPress",
        function(self, gamepad)
          GedOpAnimationMomentsEditorToggleSpeed(self, 10)
          self:SetToggled(true)
          self:ResolveId("idSpeed100"):SetToggled(false)
          self:ResolveId("idSpeed50"):SetToggled(false)
          self:ResolveId("idSpeed20"):SetToggled(false)
        end,
        "RolloverBackground",
        RGBA(178, 178, 178, 255),
        "PressedBackground",
        RGBA(172, 172, 172, 255),
        "Text",
        "10%",
        "ToggledBackground",
        RGBA(204, 204, 204, 255)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idFilters",
      "Margins",
      box(10, 0, 10, 0),
      "BorderWidth",
      1,
      "Padding",
      box(5, 2, 5, 2),
      "GridX",
      6,
      "GridStretchX",
      false,
      "GridStretchY",
      false,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "Background",
      RGBA(128, 128, 128, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "HAlign",
        "center",
        "MinWidth",
        50,
        "MaxHeight",
        20,
        "LayoutMethod",
        "None",
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "AnimMetadataEditorTimeline",
        "Text",
        "Moments Filter",
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CreateNewMomentControl(self)",
      "func",
      function(self)
        local obj = GetAnimationMomentsEditorObject()
        local id = "idMoment-NewMoment"
        local control = rawget(self, id)
        if not control then
          control = XTextButton:new({Id = id}, self)
          self:InitControl(control)
          function control.OnMouseButtonDown(this, pos, button)
            if button == "L" then
              CreateRealTimeThread(function()
                local time = obj:GetProperty("Frame")
                local moments = ActionMomentNamesCombo()
                local moment = WaitListChoice(terminal.desktop, moments, "Select Moment Type", 1, nil, "free_input")
                if moment then
                  self:OnNewMoment(moment, time)
                end
              end)
              return "break"
            end
          end
        end
        self:UpdateControl(obj.Frame, "+New Moment", control, "above timeline")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "DeleteNewMomentControl(self)",
      "func",
      function(self)
        local control = self:ResolveId("idMoment-NewMoment")
        if control then
          control:delete()
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CreateMomentControls(self, ...)",
      "func",
      function(self, ...)
        local obj = GetAnimationMomentsEditorObject()
        if not obj then
          return
        end
        for i = #self, 1, -1 do
          local control = self[i]
          if string.match(control.Id, "^idMoment-") then
            control:delete()
          end
        end
        local control = XText:new({
          Id = "idMoment-CurrentMoment"
        }, self)
        control:SetTextStyle(self.idDuration:GetTextStyle())
        control:SetDock("ignore")
        self:UpdateControl(obj.Frame, FormatTimeline(obj.Frame), control, "above timeline")
        if obj.anim_speed == 0 then
          self:CreateNewMomentControl()
        end
        local visible_types = self:GetEnabledMomentTypes()
        local moment_types = {}
        local moments = obj:GetAnimMoments()
        table.sortby_field(moments, "Time")
        for index, moment in ipairs(moments) do
          moment_types[moment.Type] = true
          local visible = visible_types[moment.Type]
          if visible == nil or visible == true then
            local control = XTextButton:new({
              Id = "idMoment",
              moment = moment,
              offset = 0,
              dragging = false,
              update_thread = false
            }, self)
            self:InitControl(control)
            local time, text = self:GetMomentTime(moment)
            self:UpdateControl(time, text, control, index % 2 == 1)
            function control.OnMouseButtonDown(this, pos, button)
              if button == "L" then
                self:DeselectMoment()
                AnimMetadataEditorTimelineSelectedControl = this
                this:SetBackground(RGBA(38, 146, 227, 255))
                local frame = self.idTimeline:GetFrame(pos)
                local time = obj:GetAbsoluteTime(frame)
                AnimMetadataEditorTimelineSelectedControl.offset = time - this.moment.Time
                AnimMetadataEditorTimelineSelectedControl.dragging = true
                this.moment.AnimRevision = obj.AnimRevision
                self:DeleteNewMomentControl()
                return "break"
              elseif button == "R" then
                CreateRealTimeThread(function()
                  if terminal.IsKeyPressed(const.vkControl) then
                    local actors = ActorFXClassCombo()
                    table.remove_value(actors, "any")
                    local actor = WaitListChoice(terminal.desktop, actors, "Select Actor", 1, nil, "free_input")
                    if actor then
                      moment.Actor = actor
                    end
                  else
                    local actions = ActionFXClassCombo()
                    table.remove_value(actions, "any")
                    local fx = WaitListChoice(terminal.desktop, actions, "Select FX", 1, nil, "free_input")
                    if fx then
                      moment.FX = fx
                    end
                  end
                end)
                return "break"
              end
            end
            function control.OnMouseButtonUp(this, pos, button)
              if button ~= "L" then
                return
              end
              if not AnimMetadataEditorTimelineSelectedControl then
                return
              end
              DeleteThread(AnimMetadataEditorTimelineSelectedControl.update_thread)
              local dragging = AnimMetadataEditorTimelineSelectedControl
              local moment = dragging.moment
              local frame = self.idTimeline:GetFrame(pos)
              local time = obj:GetAbsoluteTime(frame)
              local duration = obj:GetAbsoluteTime(obj.anim_duration)
              moment.Time = Clamp(time - dragging.offset, 0, duration - 1)
              table.sortby_field(moments, "Time")
              dragging.update_thread = false
              dragging.dragging = false
              AnimationMomentsEditorBindObjects(obj)
              self:CreateNewMomentControl()
              obj:SetFrame(obj:GetModifiedTime(moment.Time))
              return "break"
            end
            function control.OnMousePos(this, pos)
              if not AnimMetadataEditorTimelineSelectedControl then
                return
              end
              if not AnimMetadataEditorTimelineSelectedControl.dragging then
                return
              end
              local dragging = AnimMetadataEditorTimelineSelectedControl
              local moment = dragging.moment
              local frame = self.idTimeline:GetFrame(pos)
              local time = obj:GetAbsoluteTime(frame)
              local duration = obj:GetAbsoluteTime(obj.anim_duration)
              moment.Time = Clamp(time - dragging.offset, 0, duration - 1)
              if not dragging.update_thread then
                dragging.update_thread = CreateRealTimeThread(function()
                  obj:SetFrame(obj:GetModifiedTime(moment.Time), "delayed moments binding")
                  table.sortby_field(moments, "Time")
                  dragging.update_thread = false
                end)
              end
              return "break"
            end
            function control.OnMouseButtonDoubleClick(this, pos, button)
              if button ~= "L" then
                return
              end
              this.moment.AnimRevision = obj.AnimRevision
              obj:SetFrame(obj:GetModifiedTime(self:GetMomentTime(this.moment)))
              return "break"
            end
          end
        end
        local parent = self:ResolveId("idFilters")
        for i = #parent, 1, -1 do
          local control = parent[i]
          if IsKindOf(control, "XCheckButton") then
            control:delete()
          end
        end
        parent:SetVisible(next(moment_types))
        for _, moment_type in ipairs(table.keys2(moment_types, "sorted")) do
          local check = XCheckButton:new({moment_type = moment_type}, parent)
          check:SetCheck(true)
          if visible_types[moment_type] ~= nil then
            check:SetCheck(visible_types[moment_type])
          end
          check:SetText(moment_type)
          function check.OnChange(check, value)
            self:CreateMomentControls()
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetMomentControls(self)",
      "func",
      function(self)
        local moment_controls = {}
        for _, control in ipairs(self) do
          if control.Id == "idMoment" then
            table.insert(moment_controls, control)
          end
        end
        return moment_controls
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetEnabledMomentTypes(self)",
      "func",
      function(self)
        local enabled = {}
        for _, control in ipairs(self:ResolveId("idFilters")) do
          if control.moment_type then
            enabled[control.moment_type] = control:GetCheck()
          end
        end
        return enabled
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "InitControl(self, control)",
      "func",
      function(self, control)
        control:SetTextStyle(self.idDuration:GetTextStyle())
        control:SetDock("ignore")
        control:SetBackground(RGBA(128, 128, 128, 255))
        control:SetRolloverBackground(RGBA(192, 192, 192, 255))
        control:SetImage("CommonAssets/UI/round-frame-20.tga")
        control:SetImageScale(point(500, 500))
        control:SetFrameBox(box(9, 9, 9, 9))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateControl(self, time, text, control, above_timeline)",
      "func",
      function(self, time, text, control, above_timeline)
        if not control then
          return
        end
        local tw, th = control:Measure(1000000, 1000000)
        local b = self.idTimeline.box
        local width = b:sizex()
        local duration = GetAnimationMomentsEditorObject().anim_duration
        local column = b:minx() + width * time / Max(1, duration)
        local y = above_timeline and b:miny() - 5 - th or b:maxy() + 5
        if control.Id == "idMoment-NewMoment" then
          y = y - control.box:sizey() - 5
        end
        control:SetBox(column - tw / 2, y, tw, th)
        local l, u, r, b = control.Padding:xyxy()
        local x1, y1, x2, y2 = control.box:xyxy()
        control:SetBox(x1 - l, y1 - u, x2 - x1 + l + r, y2 - y1 + u + b)
        control:SetText(text)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "DeleteMoment(self,moment)",
      "func",
      function(self, moment)
        local obj = GetAnimationMomentsEditorObject()
        local moments = obj:GetAnimMoments()
        table.remove_entry(moments, moment)
        self:CreateMomentControls()
        AnimationMomentsEditorBindObjects(obj)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "DeselectMoment(self)",
      "func",
      function(self)
        if AnimMetadataEditorTimelineSelectedControl then
          AnimMetadataEditorTimelineSelectedControl:SetBackground(RGBA(128, 128, 128, 255))
          AnimMetadataEditorTimelineSelectedControl = false
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SelectMoment(self, control)",
      "func",
      function(self, control)
        AnimMetadataEditorTimelineSelectedControl = control
        control:SetBackground(RGBA(38, 146, 227, 255))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnNewMoment(self, moment, time)",
      "func",
      function(self, moment, time)
        local obj = GetAnimationMomentsEditorObject()
        local entity, anim, anim_preset = GetOrCreateAnimMetadata(obj)
        local ent_speed = GetStateSpeedModifier(entity, GetStateIdx(anim))
        local absolute_time = MulDivTrunc(time, ent_speed, const.AnimSpeedScale)
        local new_moment = AnimMoment:new({
          Type = moment,
          Time = absolute_time,
          AnimRevision = obj.AnimRevision,
          parent = anim_preset
        })
        anim_preset.Moments = anim_preset.Moments or {}
        table.insert_sorted(anim_preset.Moments, new_moment, "Time")
        UpdateParentTable(new_moment, anim_preset)
        AnimationMomentsEditorBindObjects(obj)
        self:CreateMomentControls()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetMomentTime(self, moment)",
      "func",
      function(self, moment)
        local obj = GetAnimationMomentsEditorObject()
        local time = obj:GetModifiedTime(moment.Time)
        local text = string.format("%s %s", moment.Type, FormatTimeline(time))
        return time, text
      end
    })
  }),
  PlaceObj("XTemplateFunc", {
    "name",
    "OnMouseButtonDown(self, pos, button)",
    "func",
    function(self, pos, button)
      local timeline = GetDialog("AnimMetadataEditorTimeline")
      if not timeline then
        return "continue"
      end
      local moment_controls = timeline:GetMomentControls()
      for _, control in ipairs(moment_controls) do
        if pos:InBox(control.box) then
          return control:OnMouseButtonDown(pos, button)
        end
      end
    end
  }),
  PlaceObj("XTemplateFunc", {
    "name",
    "OnMousePos(self, pos)",
    "func",
    function(self, pos)
      if AnimMetadataEditorTimelineDragging then
        local timeline = GetDialog("AnimMetadataEditorTimeline")
        if not timeline then
          return "continue"
        end
        return timeline.idTimeline:OnMousePos(pos)
      elseif AnimMetadataEditorTimelineSelectedControl then
        return AnimMetadataEditorTimelineSelectedControl:OnMousePos(pos)
      end
    end
  }),
  PlaceObj("XTemplateFunc", {
    "name",
    "OnMouseButtonUp(self, pos, button)",
    "func",
    function(self, pos, button)
      if AnimMetadataEditorTimelineSelectedControl and AnimMetadataEditorTimelineSelectedControl.dragging then
        return AnimMetadataEditorTimelineSelectedControl:OnMouseButtonUp(pos, button)
      end
      if AnimMetadataEditorTimelineDragging then
        local timeline = GetDialog("AnimMetadataEditorTimeline")
        if not timeline then
          return "continue"
        end
        return timeline.idTimeline:OnMouseButtonUp(pos, button)
      end
    end
  }),
  PlaceObj("XTemplateFunc", {
    "name",
    "OnShortcut(self, shortcut, source, ...)",
    "func",
    function(self, shortcut, source, ...)
      if not AnimationMomentsEditor then
        return
      end
      local timeline = GetDialog("AnimMetadataEditorTimeline")
      if not timeline then
        return "continue"
      end
      if AnimMetadataEditorTimelineSelectedControl then
        if shortcut == "Delete" then
          timeline:DeleteMoment(AnimMetadataEditorTimelineSelectedControl.moment)
          AnimMetadataEditorTimelineSelectedControl = false
          return "break"
        elseif shortcut == "Escape" then
          timeline:DeselectMoment()
          return "break"
        end
      end
      if shortcut == "Left" then
        local obj = GetAnimationMomentsEditorObject()
        if obj.anim_speed == 0 then
          local time = terminal.IsKeyPressed(const.vkControl) and 100 or 1
          timeline.idTimeline:MoveFrame(-time)
        end
        return "break"
      elseif shortcut == "Right" then
        local obj = GetAnimationMomentsEditorObject()
        if obj.anim_speed == 0 then
          local time = terminal.IsKeyPressed(const.vkControl) and 100 or 1
          timeline.idTimeline:MoveFrame(time)
        end
        return "break"
      elseif shortcut == "Up" or shortcut == "Down" then
        local obj = GetAnimationMomentsEditorObject()
        local frame = obj:GetFrame()
        local moment_controls = timeline:GetMomentControls()
        if shortcut == "Up" then
          for _, control in ipairs(moment_controls) do
            local moment_frame = control.moment.Time
            local time = obj:GetAbsoluteTime(moment_frame)
            if frame < time then
              obj:SetFrame(obj:GetModifiedTime(moment_frame))
              timeline:SelectMoment(control)
              break
            end
          end
        else
          for i = #moment_controls, 1, -1 do
            local control = moment_controls[i]
            local moment_frame = control.moment.Time
            local time = obj:GetAbsoluteTime(moment_frame)
            if frame > time then
              obj:SetFrame(obj:GetModifiedTime(moment_frame))
              timeline:SelectMoment(control)
              break
            end
          end
        end
        return "break"
      end
      if shortcut == "Space" and not AnimMetadataEditorTimelineDragging then
        local obj = GetAnimationMomentsEditorObject()
        if obj.anim_speed == 0 then
          GedOpAnimMetadataEditorPlay(self, GetAnimationMomentsEditorObject())
        else
          GedOpAnimMetadataEditorStop(self, GetAnimationMomentsEditorObject())
        end
        return "break"
      end
    end
  })
})
