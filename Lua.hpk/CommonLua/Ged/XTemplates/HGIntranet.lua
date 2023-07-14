PlaceObj("XTemplate", {
  group = "GedApps",
  id = "HGIntranet",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateWindow", {
      "Background",
      RGBA(228, 21, 21, 255)
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        local slack_ticket = GetAppCmdLine():match("-slack_ticket=(%S+)")
        if slack_ticket then
          CreateRealTimeThread(function()
            AccountStorage = AccountStorage or {}
            config.SwarmWorld = config.SwarmWorld or "Bacon"
            Sleep(1000)
            local err = NetConnect("intranet-test.haemimontgames.com", 46401, "slack", slack_ticket, "Ged client", false, "Ged connect")
            if err then
              print("Error connecting Ged to Swarm:", err)
            end
          end)
        end
        XWindow.Open(self)
      end
    })
  })
})
