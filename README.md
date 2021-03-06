# canvas_exporting

<!-- [![Build Status](https://travis-ci.org/bastengao/highcharts_exporting.svg?branch=master)](#https://travis-ci.org/bastengao/highcharts_exporting)
[![Code Climate](https://codeclimate.com/github/bastengao/highcharts_exporting/badges/gpa.svg)](https://codeclimate.com/github/bastengao/highcharts_exporting)
[![Test Coverage](https://codeclimate.com/github/bastengao/highcharts_exporting/badges/coverage.svg)](https://codeclimate.com/github/bastengao/highcharts_exporting)
[![Gem Version](https://badge.fury.io/rb/highcharts_exporting.svg)](http://badge.fury.io/rb/highcharts_exporting)
-->

Controller action to allow export of CanvasJS chart to png/jpg file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'canvas_exporting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canvas_exporting

## Usage

Add `canvas_controller.rb` and add route `post 'canvas/export'`.

```ruby
class CanvasController < ApplicationController
  include CanvasExporting::Exporter

end
```

Config url `/canvas/export` for canvas exporting.

OR

Using curl:

Curl::Easy.http_post("http://localhost:3000/canvas/export",<br>
                          Curl::PostField.content('options', options_JSON.to_s),<br>
                          Curl::PostField.content('type', 'image/png'),<br>
                          Curl::PostField.content('callback', cb_js_filename),<br>
                          Curl::PostField.content('width', '400'),<br>
                          Curl::PostField.content('outputpath', path_to_image_file),<br>
                          Curl::PostField.content('filename', image_filename)
                          )<br>

## References

https://github.com/bastengao/highcharts_exporting


## Contributing

1. Fork it ( https://github.com/notch8/canvas_exporting/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
