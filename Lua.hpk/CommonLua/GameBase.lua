function WaitNextFrame(count)
  local persistError = collectgarbage
  local frame = GetRenderFrame() + (count or 1)
  while GetRenderFrame() - frame < 0 do
    WaitMsg("OnRender", 30)
  end
end
function WaitFramesOrSleepAtLeast(frames, ms)
  local end_frame = GetRenderFrame() + (frames or 1)
  local end_time = now() + ms
  while end_frame > GetRenderFrame() or end_time > now() do
    Sleep(1)
  end
end
