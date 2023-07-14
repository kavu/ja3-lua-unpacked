PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu PDA",
  id = "PDABrowserBanners",
  PlaceObj("XTemplateWindow", {
    "comment",
    "Banners and Command",
    "Dock",
    "bottom",
    "VAlign",
    "center"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        local currentPage = self:ResolveId("node")
        local bannersParent = self:ResolveId("idBanners")
        local shouldExecute = currentPage.Id ~= "" and currentPage.Id
        if not shouldExecute then
          return
        end
        local pageId = currentPage.Id
        local activeBanners, inactiveBanners = RandomizeBanners()
        local totalCount = 1
        for k, v in pairs(activeBanners) do
          if v.Id ~= pageId then
            local curButton = bannersParent[totalCount]
            totalCount = totalCount + 1
            curButton[1]:SetImage(v.Image)
            curButton:SetLinkId(v.Id)
          end
        end
        local inactiveBannerCount = 1
        while totalCount <= 6 do
          local curButton = bannersParent[totalCount]
          curButton[1]:SetImage(inactiveBanners[inactiveBannerCount].Image)
          totalCount = totalCount + 1
          inactiveBannerCount = inactiveBannerCount + 1
          curButton:SetLinkId("Error404")
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Banners",
      "Id",
      "idBanners",
      "IdNode",
      true,
      "Padding",
      box(10, 7, 10, 15),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      18
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDABrowserBanner"
      })
    })
  })
})
