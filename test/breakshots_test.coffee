'use strict'

grunt = require 'grunt'

###
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
###

exports.breakshots =
  default: (test)->
    test.expect(1)

    # read tmp dir
    actual = []
    grunt.file.recurse 'tmp', (abspath, rootdir, subdir, filename)->
      if subdir
        actual.push "#{subdir}/#{filename}"
      else
        actual.push filename


    # create expected files array
    expected_files_patterns = [
      'subdir-subtest.html.BREAKPOINT.png'
      'subdir-subtest2.html.BREAKPOINT.png'
      'test.html.BREAKPOINT.png'
      'test2.html.BREAKPOINT.png'
    ]

    expected = []
    for f in expected_files_patterns
      expected.push f.replace('BREAKPOINT', breakpoint) for breakpoint in [240,320,480,640,700,768,1024,1280]

    expected.push('subdir-subtest.html')
    expected.push('subdir-subtest2.html')
    expected.push('test.html')
    expected.push('test2.html')

    test.deepEqual actual.sort(), expected.sort(), 'not all expected files are found.'
    test.done()