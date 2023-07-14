function ReportShaderCompilation(shader)
  if not Platform.developer then
    local eye, look, type, zoom
    if GetMap() ~= "" then
      eye, look, type, zoom = GetCamera()
    end
    NetGossip("shader", shader, eye, look, type, zoom)
  end
end
function ReportAnimDoubleUpdate(info)
  if not Platform.developer then
    local eye, look, type, zoom
    if GetMap() ~= "" then
      eye, look, type, zoom = GetCamera()
    end
    NetGossip("DoubleUpdate", info, eye, look, type, zoom)
  end
end
function OnMsg.NetGameJoined(game_id, unique_id)
  NetGossip("NetGameJoined", netGameAddress)
end
function OnMsg.NetGameLeft(reason)
  NetGossip("NetGameLeft", netGameAddress, reason)
end
function OnMsg.GameDesynced()
  NetGossip("Desync", netGameAddress)
end
