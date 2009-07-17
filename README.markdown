# JSONPath

JSONPath support for Ruby.

For more information on JSONPath, see [Stefan Goessner's blog entry] [1], or
the [JS and PHP implementations] [2] on Google Code.

## Installing

    gem install bruce-jsonpath --source 'http://gems.github.com'

### Dependencies

JSONPath uses [Treetop] [3] for parsing.

## Completeness

As of 2009-07-17, this implementation passes all tests from the
[JS and PHP implementations] [2] (after modifying the script expressions
for Ruby) -- in addition to its own expanded test suite.

## Usage

Execute JSONPath queries against a Ruby data
structure (as would be parsed from JSON using the `json` or `yajl` gems).

Only one method is needed:

    JSONPath.lookup(hash_or_array, path)

### Features

It supports hash traversal by key:

    JSONPath.lookup({"a" => 1}, '$.a')
    # => [1]
    JSONPath.lookup({"foo" => {"bar baz" => 2}}, "$.foo['bar baz']")
    # => [2]
    
Array traversal by index, including `start:stop:step` slices:

    JSONPath.lookup([1, 2, [3, 4, 5], 6], '$[2][-2:]')
    # => [4, 5]
    
Wildcards:

    JSONPath.lookup({"a" => {"b" => 3, "c" => 2}}, "$.a.*")
    # => [3, 2]
    
Descendant traversal (think `//` in XPath):

    JSONPath.lookup({'e' => 1, 'b' => [{'e' => 3}]}, '$..e')
    # => [1, 3]
    
Peek at the tests for more ideas.
    
#### Experimental Support
    
It has experimental support for JSONPath's script expressions, including
filters.  Since JSONPath uses the underlying language in script expressions,
that means we have access to Ruby (supporting arbitrarily complex traversal).
As in other JSONPath implementations, `@` is replaced by the current node.

    lists = [
      [1, 2, 3, 4],
      [5, 6],
      [7, 8, 9, 10]
    ]
    JSONPath.lookup(lists, "$.*[(@.length - 1)]")
    => [4, 6, 10]

And filters:

    books = [
      {"name" => 'Bruce', "age" => 29},
      {"name" => "Braedyn", "age" => 3},
      {"name" => "Jamis", "age" => 2},
    ]
    JSONPath.lookup(people, "$[?(@['age'] % 2 == 0)].name")
    # => ['Jamis']

For more information, see the the [JSONPath introductory article] [1].

## Contributing and Reporting Issues

The [project] [4] is hosted on [GitHub] [5], where I gladly accept pull
requests.

If you run into any problems, please either (in order of preference) post
something on the [issue tracker] [6], send me a message on GitHub, or email me.

## Copyright

Copyright (c) 2009 Bruce Williams, based on work by Stefan Goessner.
See LICENSE.

[1]: http://goessner.net/articles/JsonPath/
[2]: http://code.google.com/p/jsonpath/
[3]: http://treetop.rubyforge.org/
[4]: http://github.com/bruce/jsonpath
[5]: http://github.com/
[6]: http://github.com/bruce/jsonpath/issues
