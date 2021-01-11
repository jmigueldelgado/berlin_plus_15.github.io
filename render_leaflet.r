require(osmdata,warn.conflicts=FALSE)
require(sf,warn.conflicts=FALSE)
require(dplyr,warn.conflicts=FALSE)
library(htmlwidgets)


q = getbb('Berlin') %>%
    opq(timeout = 360) %>%
    add_osm_feature(key = 'boundary', value = 'administrative') %>%
    add_osm_feature(key='admin_level',value='4')  %>%
    add_osm_feature(key='name',value='Berlin')

geom=osmdata_sf(q)

geom=geom$osm_multipolygons
berlin=geom %>% st_geometry %>% st_as_sf
berlin_plus_15 = berlin %>% st_transform(25833) %>% st_buffer(15000) %>% st_transform(4326)

coor=st_centroid(berlin) %>% st_coordinates

library(leaflet)

m=leaflet() %>%
  addProviderTiles(providers$OpenStreetMap.Mapnik) %>%
  setView(coor[1,1],coor[1,2], zoom=10) %>%
  addPolygons(data=berlin_plus_15,fillOpacity = 0.5,weight = 6, fillColor = 'purple', color = 'purple')

saveWidget(m, file="index.html")
