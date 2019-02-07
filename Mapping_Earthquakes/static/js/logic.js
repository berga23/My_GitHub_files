// Creating a map object
var myMap = L.map("map", {
  center: [30.0000, -30.0000],
  zoom: 2
});

L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
  attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
  maxZoom: 18,
  id: "mapbox.streets-basic",
  accessToken: API_KEY
}).addTo(myMap);

// Saving elements inside queryUrl
var queryUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";


// Requesting to the query URL
d3.json(queryUrl, function(data) {

    earthquakes = data.features;
    for (var i = 0; i < earthquakes.length; i++) {
        var color = "";
        var quakescore = earthquakes[i].properties.mag;
        var latlng = [];
        latlng.push(earthquakes[i].geometry.coordinates[1]);
        latlng.push(earthquakes[i].geometry.coordinates[0]);
        var place = earthquakes[i].properties.place;

        if (quakescore >= 5) {
            color = "darkred";
          }
          else if (quakescore >= 4 && quakescore < 5) {
            color = "darkorange";
          }
          else if (quakescore >= 3 && quakescore < 4) {
            color = "darkgray";
          }
          else if (quakescore >= 2 && quakescore < 3) {
            color = "yellow";
          }
          else if (quakescore >= 1 && quakescore < 2) {
            color = "greenyellow";
          }
          else {
            color = "lightgreen";
          }

        // Formatting
        L.circleMarker(latlng, {
          radius: quakescore * 3.5,
          color: "gray",
          fillOpacity: 0.75,
          fillColor: color

        }).bindPopup("<h3>" + place +
      "</h3><hr><p>" + new Date(earthquakes[i].properties.time) + "</p>").addTo(myMap);

}


})