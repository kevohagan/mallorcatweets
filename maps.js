// Set up a collection to contain player information. On the server,
// it is backed by a MongoDB collection named "players".

Players = new Meteor.Collection("players");

if (Meteor.isClient) {
  GoogleMaps.init(
    {
      'sensor': true
    }, 
    function(){
      var newMap = function(lat, lon){
        return 'new google.maps.LatLng(' + lat + ', ' + lon + ')';
      }

      var berlin = new google.maps.LatLng(52.520816, 13.410186);

      var neighborhoods = [
        new google.maps.LatLng(52.511467, 13.447179),
        new google.maps.LatLng(52.549061, 13.422975),
        new google.maps.LatLng(52.497622, 13.396110),
        new google.maps.LatLng(52.517683, 13.394393)
      ];

      var markers = [];
      var iterator = 0;

      var map;


      var mapOptions = {
        zoom: 12,
        center: berlin
      };

      map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);


      function drop() {
        for (var i = 0; i < neighborhoods.length; i++) {
          setTimeout(function() {
            addMarker();
          }, i * 200);
        }
      }

      drop();

      function addMarker() {
        markers.push(new google.maps.Marker({
          position: neighborhoods[iterator],
          map: map,
          draggable: false,
          animation: google.maps.Animation.DROP
        }));
        iterator++;
      }
    }
  );
}

// On server startup, create some players if the database is empty.
if (Meteor.isServer) {
  Meteor.startup(function () {
    if (Players.find().count() === 0) {
      var names = ["Ada Lovelace",
                   "Grace Hopper",
                   "Marie Curie",
                   "Carl Friedrich Gauss",
                   "Nikola Tesla",
                   "Claude Shannon"];
      for (var i = 0; i < names.length; i++)
        Players.insert({name: names[i], score: Math.floor(Random.fraction()*10)*5});
    }
  });
}
