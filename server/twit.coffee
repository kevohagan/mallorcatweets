  Meteor.startup ->

    #create a new meteor stream to stream stuff from twitter :)
    locStream = new Meteor.Stream("loc")

    # connect the twitter api using the twit module
    Twit = new TwitMaker(
      consumer_key: "67Uvyfey1XdYZPiarL7EUA"
      consumer_secret: "JIF7Pj1TSVOVsB1Iz5YctLYq2nEfvF5lp5nOHLdA5M"
      access_token: "882694476-dShPAZyn9Ig4noTktLCZOdhfQnM8HcTpmdX37NLo"
      access_token_secret: "ly2pEodecKdZoEyOghM9q0lzWCIjXMEaAXPswp22Df4"
    )

    #define the lat/lng coordinates for mallorca (did them manually not great!)
    mallorca = [
      "2.114868",
      "39.376772",
      "3.647461",
      "39.985538"
    ]

    #from the docs of the twit npm module we listend to twitter with location
    stream = Twit.stream("statuses/filter",
      locations: mallorca
    )

    #when we receive info, if it has geo cordinates we stock the tweet
    stream.on "tweet", (tweet) ->
      if tweet.geo
        userName = tweet.user.screen_name
        userTweet = tweet.text
        lat = tweet.geo.coordinates[0]
        lon = tweet.geo.coordinates[1]
        time = tweet.created_at
        text = tweet.text
        img = tweet.user.profile_image_url
        img_url = tweet.user.profile_image_url_https
        console.log userName + " says: " + userTweet + "at " + lat + lon

        #lets emit an update message in the stream pasing it an object with the tweet info
        locStream.emit "update",
          user: userName
          lat: lat
          lon: lon
          time: time
          text: text
          img: img
          img_url: img_url
      return

    return

