###
  grunt-breakshots
  https://github.com/EightMedia/grunt-breakshots

  Copyright (c) 2013 J. Tangelder
  Licensed under the MIT license.
###

'use strict'

module.exports = (grunt)->

  path = require('path')

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask 'breakshots', 'Create screenshots of html files per breakpoint', ()->

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options
      cwd: '.'
      ext: 'png'
      pattern: "FILENAME.BREAKPOINT.EXT"
      breakpoints: [240,320,480,640,700,768,1024,1280]

    # Keeps all pages
    pages = []

    # Iterate over all specified file groups.
    @files.forEach (group)->
      # Concat specified files.
      p = group.src
          .filter (filepath)->
            # Warn on and remove invalid source files (if nonull was set).
            if not grunt.file.exists(filepath)
              grunt.log.warn('Source file "' + filepath + '" not found.')
              return false
            true

          .map (filepath)->
            dest: "#{group.dest}/#{path.relative(options.cwd, path.dirname(filepath))}"
            path: filepath

      Array::push.apply pages, p


    # This task is asynchronous.
    done = @async()


    # Get path to phantomjs binary
    phantomjs =
      bin: require('phantomjs').path
      script: 'phantomjs/render.coffee'

    # Process each filepath in-order.
    grunt.util.async.forEachSeries pages,
      (page, next)->
        grunt.util.spawn
            cmd: phantomjs.bin
            args: [
              phantomjs.script,
              options.ext,
              options.breakpoints.join(","),
              options.pattern,
              page.dest,
              page.path]
          , (err, result)->
            if err then done() else next()
      ,
      # All screenshots have been made
      ()->
        done()