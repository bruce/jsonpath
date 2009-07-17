# JSONPath

JSONPath support for Ruby, useful as a drop-in addition to the ubiquitous JSON
gem.

## Synopsis

This adds a simple method for executing JSONPath queries against a raw JSON
string or a supported Ruby data structure.

    JSON.path('{"a": 1}', '$.a')
    # => [1]

    JSON.path({"a" => 1}, '$.a')
    # => [1]

## Copyright

Copyright (c) 2009 Bruce Williams. See LICENSE for details.
