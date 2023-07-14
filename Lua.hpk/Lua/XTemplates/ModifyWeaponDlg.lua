PlaceObj("XTemplate", {
  group = "Zulu Weapon Mod",
  id = "ModifyWeaponDlg",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "XCabinet",
    "MouseCursor",
    "UI/Cursors/Cursor.tga",
    "InternalModes",
    "Default",
    "InitialDialogMode",
    "Default",
    "Lightmodel",
    "WeaponModification",
    "SetupScene",
    function(self)
      self.prev_camera = pack_params(GetCamera())
      local map_sizex, map_sizey = terrain.GetMapSize()
      local cabinet_pos = point(const.SlabSizeX * 10, const.SlabSizeY * 10, -const.SlabSizeZ * 20)
      local obj = PrefabContainer:new({
        name = "Any.WeaponModification",
        pos = cabinet_pos
      })
      local cam = obj:GetObjectByType("WeaponModPrefabCameraPos")
      if cam then
        cam:ClearEnumFlags(const.efVisible)
      end
      for i, o in ipairs(obj.objs) do
        if IsValid(o) then
          o:SetGameFlags(const.gofAlwaysRenderable)
        end
      end
      local fakeOriginObject = PlaceObject("FakeOriginObject")
      fakeOriginObject:SetPos(cabinet_pos)
      g_Cabinet = fakeOriginObject
      local defaultAxis = point(1, -460, 4070)
      local defaultAngle = 12600
      rawset(g_Cabinet, "default_rotation_axis", defaultAxis)
      rawset(g_Cabinet, "default_rotation_angle", defaultAngle)
      g_Cabinet:SetAxisAngle(defaultAxis, defaultAngle)
      local weaponInPrefab = obj:GetObjectByType("Weapon_M16A2")
      weaponInPrefab:ClearEnumFlags(const.efVisible)
      obj:SetAngle(16200)
      obj:SetPosRelativeTo(cabinet_pos, weaponInPrefab)
      rawset(self, "prefab", obj)
      local bgPlane = PlaceObject("WeaponModCMTPlane")
      bgPlane:SetColorModifier(0)
      bgPlane:SetAxis(point(0, -4096, 4096))
      bgPlane:SetAngle(10800)
      bgPlane:SetPos(cabinet_pos + point(0, 2000, 0))
      bgPlane:SetScale(500)
      bgPlane:SetGameFlags(const.gofAlwaysRenderable)
      rawset(self, "background", bgPlane)
      table.change(hr, "ModifyWeaponDlg", {
        EnablePostProcVignette = 1,
        CameraTacClampToTerrain = false,
        EnableContourOuter = 0,
        EnableContourInner = 0,
        EnableObjectMarking = 0,
        CameraTacMaxZoom = 880,
        CameraTacMinZoom = 10,
        NearZ = 10,
        EnableScreenSpaceReflections = 0,
        RenderTerrain = 0,
        ObjectLODCapMin = 0
      })
      local cameraInPrefab = obj:GetObjectByType("WeaponModPrefabCameraPos")
      if cameraInPrefab then
        local dist = cameraInPrefab:GetDist2D(cabinet_pos)
        SetCamera(cabinet_pos - point(0, dist, 0), cabinet_pos, "Tac", nil, nil, camera.GetFovX())
        cameraTac.SetZoom(1000)
      else
        print("no WeaponModPrefabCameraPos object in the weapon modification prefab")
      end
    end,
    "RestorePrevScene",
    function(self)
      SetCamera(unpack_params(self.prev_camera))
      table.restore(hr, "ModifyWeaponDlg")
      if IsValid(g_Cabinet) then
        DoneObject(g_Cabinet)
      end
      local prefab = rawget(self, "prefab")
      if prefab then
        prefab:Done()
      end
      local bg = rawget(self, "background")
      if bg then
        DoneObject(bg)
      end
      NetSyncEvent("WeaponModifyDialogDespawn", netUniqueId)
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XCabinetBase.Open(self)
        PlayFX("WeaponModificationOpened", "start")
        NetSyncEvent("WeaponModifyDialogSpawn", netUniqueId)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self, ...)",
      "func",
      function(self, ...)
        self:SetHandleMouse(false)
        self:SetChildrenHandleMouse(false)
        XCabinetBase.Close(self, ...)
        PlayFX("WeaponModificationClosed", "start")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XCameraLockLayer",
      "lock_id",
      "ModifyWeaponDlg"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        local weaponModel = g_Cabinet:GetAttaches()
        if 0 < #weaponModel then
          self.context.weapon:UpdateVisualObj(weaponModel[1])
        end
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XWindow.Open(self)
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idContainer",
      "IdNode",
      false,
      "MouseCursor",
      "UI/Cursors/Cursor.tga"
    }, {
      PlaceObj("XTemplateMode", {
        "comment",
        "required to delay UI spawning during fade",
        "mode",
        "Default"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "ModifyWeaponDlg",
          "Id",
          "idModifyDialog",
          "IdNode",
          true,
          "OnLayoutComplete",
          function(self)
            TutorialHintsState.WeaponMod = true
            TutorialHintVisibilityEvaluate()
          end,
          "Background",
          RGBA(221, 45, 45, 0),
          "HandleMouse",
          true,
          "MouseCursor",
          "UI/Cursors/Cursor.tga"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "shown on the selected spot",
            "__class",
            "XImage",
            "Id",
            "idCircle",
            "Dock",
            "ignore",
            "Image",
            "UI/PDA/T_HUD_SquadIcon_Background",
            "ImageFit",
            "stretch",
            "ImageColor",
            RGBA(195, 189, 172, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context.weapon
            end,
            "__class",
            "XContextWindow",
            "Padding",
            box(80, 60, 80, 60)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "Id",
              "idWeaponMeta",
              "IdNode",
              false,
              "Margins",
              box(0, 0, 0, 10),
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idWeaponName",
                  "HAlign",
                  "left",
                  "HandleMouse",
                  false,
                  "ChildrenHandleMouse",
                  false,
                  "TextStyle",
                  "WeaponModHeader",
                  "Translate",
                  true,
                  "Text",
                  T(269967678534, "<DisplayName>")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "HAlign",
                  "right",
                  "HandleMouse",
                  false,
                  "ChildrenHandleMouse",
                  false,
                  "TextStyle",
                  "WeaponModHeader",
                  "Translate",
                  true,
                  "Text",
                  T(743904662239, "WEAPON SPECS")
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "Margins",
                box(3, -4, 3, 0),
                "VAlign",
                "top",
                "MinHeight",
                2,
                "MaxHeight",
                2,
                "Background",
                RGBA(130, 128, 120, 125)
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 25, 0, 0)
              }, {
                PlaceObj("XTemplateWindow", {
                  "HAlign",
                  "left",
                  "VAlign",
                  "top",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "MaxWidth",
                    500,
                    "HandleMouse",
                    false,
                    "ChildrenHandleMouse",
                    false,
                    "TextStyle",
                    "PDAQuests_EmailDate",
                    "Translate",
                    true,
                    "Text",
                    T(373313884700, "<Description>")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "MaxWidth",
                    500,
                    "HandleMouse",
                    false,
                    "ChildrenHandleMouse",
                    false,
                    "TextStyle",
                    "PDAQuests_EmailText",
                    "Translate",
                    true,
                    "Text",
                    T(778777796412, "<AdditionalWeaponDescription()>")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__context",
                    function(parent, context)
                      return parent:ResolveId("node").context
                    end,
                    "__class",
                    "XContextWindow",
                    "IdNode",
                    true,
                    "Margins",
                    box(3, 20, 0, 0),
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "HList",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local ud = gv_UnitData[context.owner]
                      if ud then
                        self.idPortrait:SetImage(ud.Portrait)
                        if context.slotName == "Inventory" then
                          self.idText:SetText(T({
                            470443632007,
                            "IN <DisplayName>'s<newline>BACKPACK",
                            ud
                          }))
                        else
                          self.idText:SetText(T({
                            636175225313,
                            "EQUIPPED BY<newline><DisplayName>",
                            ud
                          }))
                        end
                      else
                        self.idPortrait:SetImage("")
                        self.idText:SetText(T(567038290582, "IN LOOTED CONTAINER"))
                      end
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idPortraitBG",
                      "IdNode",
                      false,
                      "BorderWidth",
                      2,
                      "HAlign",
                      "center",
                      "VAlign",
                      "top",
                      "BorderColor",
                      RGBA(32, 35, 47, 255),
                      "Image",
                      "UI/Hud/portrait_background"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "UIEffectModifierId",
                        "Default",
                        "Id",
                        "idPortrait",
                        "IdNode",
                        false,
                        "ZOrder",
                        2,
                        "Margins",
                        box(0, -10, 0, 0),
                        "ImageFit",
                        "stretch",
                        "ImageRect",
                        box(36, 0, 264, 246),
                        "ImageScale",
                        point(300, 300)
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Image",
                        "UI/Hud/portrait_effect",
                        "ImageFit",
                        "stretch"
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idText",
                      "Margins",
                      box(13, 0, 0, 0),
                      "HAlign",
                      "left",
                      "VAlign",
                      "bottom",
                      "HandleMouse",
                      false,
                      "ChildrenHandleMouse",
                      false,
                      "TextStyle",
                      "UIDlgTitle",
                      "Translate",
                      true
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContentTemplate",
                  "Id",
                  "idWeaponProps",
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "MinWidth",
                  450,
                  "MouseCursor",
                  "UI/Cursors/Hand.tga"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return context
                    end,
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return GetWeaponModifyProperties(context)
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        child:Setup(item, context)
                        if i ~= 1 then
                          child:SetMargins(box(0, 5, 0, 0))
                        end
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "WeaponModProgressLine",
                        "MouseCursor",
                        "UI/Cursors/Hand.tga"
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "RolloverTemplate",
                      "RolloverGeneric",
                      "RolloverAnchor",
                      "left",
                      "RolloverText",
                      T(226575141159, "<description>"),
                      "RolloverOffset",
                      box(0, 0, 20, 0),
                      "RolloverTitle",
                      T(901937346437, "Armor Penetration"),
                      "IdNode",
                      true,
                      "HAlign",
                      "right"
                    }, {
                      PlaceObj("XTemplateCode", {
                        "run",
                        function(self, parent, context)
                          local preset = Presets.WeaponPropertyDef.Default.PenetrationClass
                          parent:SetRolloverText(preset.description)
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "UpdateValue(self, anyMod)",
                        "func",
                        function(self, anyMod)
                          if not anyMod then
                            self:SetTransparency(0)
                          else
                            self:SetTransparency(155)
                          end
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "SetRollover(self, rollover)",
                        "func",
                        function(self, rollover)
                          XWindow.SetRollover(self, rollover)
                          self.idText:SetRollover(rollover)
                        end
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idText",
                        "Margins",
                        box(0, 0, 10, 0),
                        "TextStyle",
                        "PDAQuests_HeaderBig",
                        "Translate",
                        true,
                        "Text",
                        T(301024350023, "Armor Penetration"),
                        "TextVAlign",
                        "center"
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idValue",
                        "Dock",
                        "right",
                        "MinWidth",
                        214,
                        "MaxWidth",
                        214,
                        "TextStyle",
                        "PDAQuests_HeaderBig",
                        "Translate",
                        true,
                        "TextHAlign",
                        "right"
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "SetRollover(self, rollover)",
                          "func",
                          function(self, rollover)
                            self.parent:SetRollover(rollover)
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "Open(self)",
                          "func",
                          function(self)
                            XText.Open(self)
                            self:SetText(GetArmorClassUIText(self.context.PenetrationClass))
                          end
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "extra stat stuff",
                      "__class",
                      "XText",
                      "Margins",
                      box(0, 20, 0, 0),
                      "HAlign",
                      "right",
                      "VAlign",
                      "top",
                      "MinWidth",
                      400,
                      "MaxWidth",
                      400,
                      "TextStyle",
                      "WeaponModExtraModifications",
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        local modDlg = self:ResolveId("node"):ResolveId("node")
                        self:SetText(modDlg:GetWeaponComponentsCombinedEffects())
                      end,
                      "Translate",
                      true,
                      "TextHAlign",
                      "right"
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "UpdateValue(self, anyChanged)",
                        "func",
                        function(self, anyChanged)
                          if anyChanged then
                            local hasChanges, changes, allData = self:HasValueChanged()
                            if not hasChanges then
                              self:SetTransparency(155)
                            else
                              self:SetTransparency(0)
                              local indices = {}
                              local lines = {}
                              for key, mod in sorted_pairs(allData) do
                                if table.find(changes, key) then
                                  lines[#lines + 1] = Untranslated("<bullet_point> " .. _InternalTranslate(mod.display, mod))
                                  indices[lines[#lines]] = 999
                                else
                                  lines[#lines + 1] = Untranslated("<style WeaponModExtraModificationsTransparent>" .. _InternalTranslate(mod.display, mod) .. "</style>")
                                end
                              end
                              table.sort(lines, function(a, b)
                                local indexA = indices[a] or 0
                                local indexB = indices[b] or 0
                                return indexA < indexB
                              end)
                              self:SetText(table.concat(lines, "\n"))
                            end
                          else
                            self:SetTransparency(0)
                          end
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "HasValueChanged(self)",
                        "func",
                        function(self)
                          local weaponModDlg = self:ResolveId("node"):ResolveId("node")
                          local weapon = weaponModDlg.weaponClone
                          local actualWeapon = weaponModDlg.context.weapon
                          local _, value = weaponModDlg:GetWeaponComponentsCombinedEffects(weapon.components)
                          local _, valActual = weaponModDlg:GetWeaponComponentsCombinedEffects(actualWeapon.components)
                          local differences = {}
                          for key, mod in sorted_pairs(value) do
                            if not valActual[key] or valActual[key].value ~= mod.value then
                              differences[#differences + 1] = key
                            end
                          end
                          return 0 < #differences, differences, value
                        end
                      })
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", nil, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "Id",
                "idModificationResults",
                "VAlign",
                "bottom",
                "MinWidth",
                350,
                "LayoutMethod",
                "VList",
                "LayoutHSpacing",
                20,
                "LayoutVSpacing",
                -5,
                "UseClipBox",
                false
              }, {
                PlaceObj("XTemplateWindow", {
                  "RolloverTemplate",
                  "RolloverGeneric",
                  "RolloverAnchor",
                  "right-center",
                  "RolloverOffset",
                  box(30, 0, 0, 0),
                  "HAlign",
                  "left",
                  "LayoutMethod",
                  "HList",
                  "HandleMouse",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idResourceIndicator",
                    "TextStyle",
                    "WeaponModSubHeader",
                    "OnContextUpdate",
                    function(self, context, ...)
                      local partsPreset = SectorOperationResouces.Parts
                      local value = partsPreset.current(context)
                      self:SetText(T({
                        813074870047,
                        "PARTS <style WeaponModSubHeaderLight><value></style>",
                        value = value
                      }))
                      XContextControl.OnContextUpdate(self, context)
                    end,
                    "Translate",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Margins",
                    box(5, 0, 0, 0),
                    "Image",
                    "UI/SectorOperations/T_Icon_Parts",
                    "ImageScale",
                    point(1300, 1300),
                    "ImageColor",
                    RGBA(130, 128, 120, 255)
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Open(self)",
                    "func",
                    function(self)
                      XWindow.Open(self)
                      local partsDescription = Parts.Description
                      self:SetRolloverText(partsDescription)
                    end
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "Id",
                  "idCondition",
                  "IdNode",
                  true,
                  "Margins",
                  box(0, 1, 0, 0),
                  "LayoutMethod",
                  "VList",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local weaponModDlg = self:ResolveId("node")
                    self.idBar:Setup({
                      bind_to = "Condition",
                      baseValueOverride = weaponModDlg.weaponConditionOnOpen
                    }, context)
                    self.idBar.idText:SetVisible(false)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "TextStyle",
                    "WeaponModSubHeader",
                    "Translate",
                    true,
                    "Text",
                    T(254900537835, "CONDITION")
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "WeaponModProgressLine",
                    "RolloverAnchor",
                    "right-center",
                    "RolloverOffset",
                    box(30, 0, 0, 0),
                    "Id",
                    "idBar",
                    "Margins",
                    box(-4, 0, 0, 0),
                    "HAlign",
                    "left",
                    "MinWidth",
                    0,
                    "MaxWidth",
                    9999,
                    "MouseCursor",
                    "UI/Cursors/Hand.tga"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "UpdateValue(self, ...)",
                      "func",
                      function(self, ...)
                        local val = WeaponModProgressLineClass.UpdateValue(self, ...)
                        if val == 0 then
                          self.idPropVal:SetTextStyle("WeaponModStatChangeBad")
                        else
                          self.idPropVal:SetTextStyle("PDAQuests_HeaderBig")
                        end
                      end
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "Id",
                "idTextAboveButtons",
                "Margins",
                box(0, 0, 0, 100),
                "HAlign",
                "center",
                "VAlign",
                "bottom",
                "LayoutMethod",
                "VList",
                "UseClipBox",
                false,
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local node = self:ResolveId("node")
                  local broken = self.context.Condition == 0
                  node.idBroken:SetVisible(broken)
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idBroken",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "WeaponModStatChangeBadShadow",
                  "Translate",
                  true,
                  "Text",
                  T(611665136114, "WEAPON BROKEN. CAN'T MODIFY")
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return "WeaponModificationWeaponLookingChanged"
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idOtherPlayer",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "WeaponModStatChangeBadShadow",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local otherPlayerLookingAtIt = OtherPlayerLookingAtSameWeapon()
                    self:SetVisible(otherPlayerLookingAtIt)
                  end,
                  "Translate",
                  true,
                  "Text",
                  T(372112743469, "<OtherPlayerName()> IS MODIFYING THIS WEAPON")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idLootedWeapon",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "WeaponModStatChangeBadShadow",
                  "Translate",
                  true,
                  "Text",
                  T(361569353826, "WEAPON NOT IN MERC INVENTORY. CAN'T MODIFY")
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XList",
                "Id",
                "idWeaponParts",
                "IdNode",
                false,
                "BorderWidth",
                0,
                "HAlign",
                "center",
                "VAlign",
                "bottom",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                20,
                "UseClipBox",
                false,
                "Background",
                RGBA(255, 255, 255, 0),
                "BackgroundRectGlowColor",
                RGBA(0, 0, 0, 0),
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "LeftThumbScroll",
                false,
                "SetFocusOnOpen",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "Margins",
              box(0, 35, 0, 0),
              "Dock",
              "bottom",
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "LayoutHSpacing",
              50,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "WeaponModToolbarButton"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "controller observer",
              "__context",
              function(parent, context)
                return "GamepadUIStyleChanged"
              end,
              "__class",
              "XContextWindow",
              "IdNode",
              true,
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "UseClipBox",
              false,
              "Visible",
              false,
              "OnContextUpdate",
              function(self, context, ...)
                local node = self:ResolveId("node")
                node.idToolBar:OnUpdateActions()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "weapon item change observer",
              "__context",
              function(parent, context)
                return false
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idWeaponChangeTrigger",
              "IdNode",
              true,
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "UseClipBox",
              false,
              "Visible",
              false,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = self:ResolveId("node")
                dlg:UpdateWeaponProps()
              end
            })
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionPrev",
            "ActionName",
            T(391006989139, "PREV"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "P",
            "ActionGamepad",
            "LeftShoulder",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              local dlg = host.idModifyDialog
              if not dlg.canEdit then
                return "hidden"
              end
              local allWeps = dlg.allWeapons
              return allWeps and 1 < #allWeps and "enabled" or "hidden"
            end,
            "OnAction",
            function(self, host, source, ...)
              local dlg = host.idModifyDialog
              local selWepIdx = dlg.selectedWeapon
              local allWeps = dlg.allWeapons
              if selWepIdx then
                selWepIdx = selWepIdx - 1
                if selWepIdx < 1 then
                  selWepIdx = #allWeps
                end
                dlg:SetWeapon(selWepIdx, -1)
              end
            end,
            "FXPress",
            "activityButtonPress_ModUIPrev"
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionNext",
            "ActionName",
            T(963186867445, "NEXT"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "N",
            "ActionGamepad",
            "RightShoulder",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              local dlg = host.idModifyDialog
              if not dlg.canEdit then
                return "hidden"
              end
              local allWeps = dlg.allWeapons
              return allWeps and 1 < #allWeps and "enabled" or "hidden"
            end,
            "OnAction",
            function(self, host, source, ...)
              local dlg = host.idModifyDialog
              local selWepIdx = dlg.selectedWeapon
              local allWeps = dlg.allWeapons
              if selWepIdx then
                selWepIdx = selWepIdx + 1
                if selWepIdx > #allWeps then
                  selWepIdx = 1
                end
                dlg:SetWeapon(selWepIdx, 1)
              end
            end,
            "FXPress",
            "activityButtonPress_ModUINext"
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionResetRotation",
            "ActionName",
            T(357676895659, "RESET ROTATION"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "R",
            "ActionGamepad",
            "RightThumbClick",
            "ActionBindable",
            true,
            "OnAction",
            function(self, host, source, ...)
              local defaultAxis = rawget(g_Cabinet, "default_rotation_axis")
              local defaultAngle = rawget(g_Cabinet, "default_rotation_angle")
              g_Cabinet:SetAxisAngle(defaultAxis, defaultAngle, 300)
              local dlg = GetDialog("ModifyWeaponDlg")
              dlg = dlg and dlg.idModifyDialog
              if dlg and dlg.mouseDown then
                dlg.mouseUpWait = true
              end
            end,
            "FXPress",
            "activityButtonPress_ModUIResetRot"
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionClosePanel",
            "ActionName",
            T(749455770321, "CLOSE"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "Escape",
            "ActionGamepad",
            "ButtonB",
            "ActionBindable",
            true,
            "OnAction",
            function(self, host, source, ...)
              CloseDialog("ModifyWeaponDlg")
            end,
            "FXPress",
            "\"none\""
          })
        }),
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            ApplyAspectRatioConstraint()
          end
        })
      })
    })
  })
})
