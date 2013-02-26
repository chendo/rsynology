# RSynology

This gems lets you interact the Synology DSM via their API.

## Installation

Add this line to your application's Gemfile:

    gem 'rsynology'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rsynology

## Usage

```ruby
require 'rsynology'
client = RSynology::Client.new("https://<DSM host>:5001/", verify_ssl: false)
client.login!("username", "password")
pp client.endpoints['SYNO.SurveillanceStation.Event'].query

{"events"=>
  [{"camera_id"=>2,
    "event_size"=>3.739612579345703,
    "frame_count"=>114,
    "start_time"=>2013-02-26 22:02:16 +1100,
    "stop_time"=>2013-02-26 22:02:30 +1100,
    "video_codec"=>"MJPEG",
    "id"=>24823,
    "mode"=>1,
    "status"=>0},
   {"camera_id"=>2,
    "event_size"=>3.819374084472656,
    "frame_count"=>117,
    "start_time"=>2013-02-26 22:02:02 +1100,
    "stop_time"=>2013-02-26 22:02:16 +1100,
    "video_codec"=>"MJPEG",
    "id"=>24822,
    "mode"=>1,
    "status"=>0}],
 "offset"=>0,
 "total"=>11523}
 ```

 ## Status

 ### Implemented APIs

 * SYNO.API.Auth
 * SYNO.SurveillanceStation.Event

 Adding new APIs is pretty trivial. See either `auth.rb` or `surveillence_station_event.rb` in `lib/rsynology/client/`. Pull requests welcome!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT! See `LICENSE.txt`
