  Meteor.startup ->
    # connect the twitter api
    locStream = new Meteor.Stream("loc")

    Twit = new TwitMaker(
      consumer_key: "67Uvyfey1XdYZPiarL7EUA"
      consumer_secret: "JIF7Pj1TSVOVsB1Iz5YctLYq2nEfvF5lp5nOHLdA5M"
      access_token: "882694476-dShPAZyn9Ig4noTktLCZOdhfQnM8HcTpmdX37NLo"
      access_token_secret: "ly2pEodecKdZoEyOghM9q0lzWCIjXMEaAXPswp22Df4"
    )
    mallorca = [
      "2.114868",
      "39.376772",
      "3.647461",
      "39.985538"
    ]
    stream = Twit.stream("statuses/filter",
      locations: mallorca
    )
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

