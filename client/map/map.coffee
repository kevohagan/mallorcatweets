
# Declare the stream client-side

locStream = new Meteor.Stream("loc")


# Map initialization in the template rendered callback


Template.map.rendered = () ->

GoogleMaps.init
  sensor: true #optional
  # key: "MY-GOOGLEMAPS-API-KEY" #optional
  # language: "de" #optional
, ->
  mapOptions =
    zoom: 10
    # mapTypeId: google.maps.MapTypeId.SATELLITE

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  map.setCenter new google.maps.LatLng(39.6167, 2.9833)




  locStream.on "update", (message) ->

    latlong = new google.maps.LatLng(message.lat,message.lon)
    marker = new google.maps.Marker(
      position: latlong,
      map: map,
      draggable: false
      title : message.text
      animation: google.maps.Animation.DROP
      )
    infowindow = new google.maps.InfoWindow(
      content:'<img class="ui avatar image" src="'+message.img+'"><span class="ui header">'+message.text+'</span>'
      )
    google.maps.event.addListener marker, "click", ->
      infowindow.open map, marker


Template.map.events
  'click marker': () ->
    console.log "marker clicked"






# Tweet List - rendering through a client-side collection fed by the stream : Very simple stuff

Tweets = new Meteor.Collection(null)

#listen to the stream and add to the collection
locStream.on "update", (message) ->
  Tweets.insert
    user: message.user
    lat: message.lat
    lon: message.lon
    time: message.time
    text: message.text
    img: message.img
    img_url: message.img_url
  return


Template.tweetList.helpers
  tweets: () ->
    Tweets.find({},{sort : {timestamp: -1}})
  moment: () ->
    moment(@time)
