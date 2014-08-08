
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


  #initalize a new google maps
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

  #map center is mallorca
  map.setCenter new google.maps.LatLng(39.6167, 2.9833)



  # Here we listen to the "udpate" message on the stream
  locStream.on "update", (message) ->

    # we format lat/lng pos of tweet for google maps
    latlong = new google.maps.LatLng(message.lat,message.lon)

    # we create a new marker with the lat/lng of tweet + some options
    marker = new google.maps.Marker(
      position: latlong,
      map: map,
      draggable: false
      title : message.text
      animation: google.maps.Animation.DROP
      )

    # we create an info window with the content of the tweet + img (thx to coffescript for clean markup)
    infowindow = new google.maps.InfoWindow(
      content:"<img class='ui avatar image' src='#{message.img}'><span class='ui header'>#{message.text}</span>"
        )

    # we add the click event window open
    google.maps.event.addListener marker, "click", ->
      infowindow.open map, marker


Template.map.events
  'click marker': () ->
    console.log "marker clicked"






# Tweet List - rendering through a client-side collection fed by the stream : Very simple stuff

Tweets = new Meteor.Collection(null)

#listen to the stream and add to the collection,
#same listening as above for the map but inserting in the client side Tweets collection
locStream.on "update", (message) ->
  Tweets.insert
    user: message.user
    lat: message.lat
    lon: message.lon
    time: message.time
    text: message.text
    img: message.img
    img_url: message.img_url
    created_at: new Date()
  return


#Then we declare some helpers for the tweetlist template

Template.tweetList.helpers
  tweets: () ->
    Tweets.find({},{sort : {created_at: -1}})
  moment: () ->
    moment(@time)


Template.tweetList.rendered = () ->
  stroll.bind( '#tweetList', { live: true } );


Template.tweet.created = () ->
  $('.transition').transition "fadeUp"