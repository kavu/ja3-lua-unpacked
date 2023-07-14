if FirstLoad then
  GedXTemplatePreviewObject = false
  GedXTemplateEditorId = 0
end
DefineClass("GedPreview", "XDialog")
local OpenPreview = function(template)
  local preview = OpenDialog("GedPreview")
  XTemplateSpawn(template.id, preview)
  for _, win in ipairs(preview) do
    win:Open()
  end
end
local ClosePreview = function()
  CloseDialog("GedPreview")
end
local GedOpenXTemplatePreview = function(template, ged_id, live_preview)
  sprocall(ClosePreview)
  if not template.id then
    return
  end
  sprocall(OpenPreview, template)
  if GetDialog("GedPreview") and #GetDialog("GedPreview") > 0 then
    if live_preview then
      GedXTemplatePreviewObject = template
    else
      GedXTemplatePreviewObject = false
    end
    GedXTemplateEditorId = ged_id
  end
end
local function SendXTemplateActionStates(ged)
  if not ged then
    for _, ged in pairs(GedConnections) do
      if ged.app_template == "XTemplateEditor" then
        SendXTemplateActionStates(ged)
      end
    end
    return
  end
  ged:Send("rfnApp", "SetActionToggled", "LivePreviewXTemplate", GedXTemplateEditorId == ged.ged_id and GedXTemplatePreviewObject and true)
  ged:Send("rfnApp", "SetActionToggled", "PreviewXTemplate", GedXTemplateEditorId == ged.ged_id and not GedXTemplatePreviewObject or false)
end
local GedCloseXTemplatePreview = function()
  CloseDialog("GedPreview")
  GedXTemplatePreviewObject = false
  GedXTemplateEditorId = 0
  SendXTemplateActionStates()
end
function OnMsg.GedClosing(ged_id)
  if GedXTemplateEditorId == ged_id then
    GedCloseXTemplatePreview()
  end
end
function OnMsg.ObjModified(obj)
  local preview = GetDialog("GedPreview")
  if GedXTemplatePreviewObject == obj and preview then
    preview:DeleteThread("update")
    preview:CreateThread("update", function()
      GedOpenXTemplatePreview(obj, GedXTemplateEditorId, true)
    end)
  end
end
function GedOpPreviewXTemplate(socket, obj, live_preview)
  if GetDialog("GedPreview") and #GetDialog("GedPreview") > 0 and live_preview == (GedXTemplatePreviewObject == obj) then
    GedCloseXTemplatePreview()
  else
    GedOpenXTemplatePreview(obj, socket.ged_id, live_preview)
  end
  SendXTemplateActionStates(socket)
end
