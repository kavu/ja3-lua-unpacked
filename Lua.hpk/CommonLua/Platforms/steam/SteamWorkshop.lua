function Steam_PrepareForUpload(ged_socket, mod, params)
  local err
  if mod.steam_id ~= 0 then
    local owned, exists
    local appId = SteamGetAppId()
    local userId = SteamGetUserId64()
    err, owned, exists = AsyncSteamWorkshopUserOwnsItem(userId, appId, mod.steam_id)
    if err then
      return false, T({
        773036833561,
        "Failed looking up Steam Workshop item ownership (<err>)",
        err = Untranslated(err)
      })
    end
    if not exists then
      mod.steam_id = 0
    elseif not owned then
      return false, T(898162117742, "Upload failed - this mod is not owned by your Steam user")
    end
  end
  if mod.steam_id == 0 then
    local item_id, bShowLegalAgreement
    err, item_id, bShowLegalAgreement = AsyncSteamWorkshopCreateItem()
    mod.steam_id = not err and item_id or nil
    params.publish = true
  else
    params.publish = false
  end
  if not err then
    if mod.steam_id == 0 then
      return false, T(484936159811, "Failed generating Steam Workshop item ID for this mod")
    end
  else
    return false, T({
      532854821730,
      "Failed generating Steam Workshop item ID for this mod (<err>)",
      err = Untranslated(err)
    })
  end
  return true
end
function Steam_Upload(ged_socket, mod, params)
  local remove_screenshots = {}
  local update_screenshots = {}
  local add_screenshots = params.screenshots
  local appId = SteamGetAppId()
  local userId = SteamGetUserId64()
  local err, present_screenshots = AsyncSteamWorkshopGetPreviewImages(userId, appId, mod.steam_id)
  if not err and type(present_screenshots) == "table" then
    local add_by_filename = {}
    for i = 1, #add_screenshots do
      local full_path = add_screenshots[i]
      local path, file, ext = SplitPath(full_path)
      add_by_filename[file .. ext] = full_path
    end
    for i = 1, #present_screenshots do
      local entry = present_screenshots[i]
      if string.starts_with(entry.file, ModsScreenshotPrefix) then
        local add_full_path = add_by_filename[entry.file]
        if add_full_path then
          local update_entry = {
            index = entry.index,
            file = add_full_path
          }
          table.insert(update_screenshots, update_entry)
          table.remove_entry(add_screenshots, add_full_path)
        else
          table.insert(remove_screenshots, entry.index)
        end
      end
    end
  end
  local max_image_size = 1048576
  if mod.image then
    local os_image_path = ConvertToOSPath(mod.image)
    if io.exists(os_image_path) then
      local image_size = io.getsize(os_image_path)
      if max_image_size < image_size then
        return false, T({
          452929163591,
          "Preview image file size must be up to 1MB (current one is <FormatSize(filesize,2)>)",
          filesize = image_size
        })
      end
    end
  end
  local new_screenshot_files = table.union(add_screenshots, table.map(update_screenshots, "file"))
  for i, screenshot in ipairs(new_screenshot_files) do
    local os_screenshot_path = ConvertToOSPath(screenshot)
    if io.exists(os_screenshot_path) then
      local screenshot_size = io.getsize(os_screenshot_path)
      if max_image_size < screenshot_size then
        return false, T({
          741444571224,
          "Screenshot <i> file size must be up to 1MB (current one is <FormatSize(filesize,2)>)",
          i = i,
          filesize = screenshot_size
        })
      end
    end
  end
  local err = AsyncSteamWorkshopUpdateItem({
    item_id = mod.steam_id,
    title = mod.title,
    description = mod.description,
    tags = mod:GetTags(),
    content_os_folder = params.os_pack_path,
    image_os_filename = mod.image ~= "" and ConvertToOSPath(mod.image) or "",
    change_note = mod.last_changes,
    publish = params.publish,
    add_screenshots = add_screenshots,
    remove_screenshots = remove_screenshots,
    update_screenshots = update_screenshots
  })
  if err then
    return false, T({
      589249152995,
      "Failed to update Steam workshop item (<err>)",
      err = Untranslated(err)
    })
  else
    return true
  end
end
function DebugCopySteamMods()
  local paths = SteamWorkshopItems()
  local dest = ConvertToOSPath("AppData/Mods")
  printf("Copying %d mods to '%s'...", #paths, dest)
  for _, path in ipairs(paths) do
    local _, id = SplitPath(path)
    printf("\tCopying mod '%s'...", id)
    local err = AsyncUnpack(path .. "\\ModContent.hpk", dest .. "\\" .. id)
    if err then
      print("\t\tError:", err)
    end
  end
end
function DebugDownloadSteamMods(mods, ...)
  if type(mods) ~= "table" then
    mods = {
      mods,
      ...
    }
  end
  CreateRealTimeThread(function(mods)
    local count = 0
    local err_count = 0
    for _, mod_id in ipairs(mods) do
      local err = AsyncSteamWorkshopSubscribeItem(mod_id)
      if err then
        printf("Steam ID %s: %s", mod_id, err)
        err_count = err_count + 1
      else
        printf("Mod with Steam ID %s downloaded successfully", mod_id)
        count = count + 1
      end
    end
    if 0 < err_count then
      printf("%d Steam workshop mods were not downloaded", err_count)
    end
    if 0 < count then
      printf("%d Steam workshop mods successfully downloaded", count)
      printf("You can copy them to be used in a non-steam game version via DebugCopySteamMods()")
    end
  end, mods)
end
function SteamIsWorkshopAvailable()
  return IsSteamAvailable()
end
