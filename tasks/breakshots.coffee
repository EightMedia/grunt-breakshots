###
  grunt-breakshots
  https://github.com/EightMedia/grunt-breakshots

  Copyright (c) 2013 J. Tangelder
  Licensed under the MIT license.
###

'use strict'

module.exports = (grunt)->

  path = require 'path'
  jade = require 'jade'
  fs = require 'fs'

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask 'breakshots', 'Create screenshots of html files per breakpoint', ->

    # This task is asynchronous.
    done = @async()

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
            if not grunt.file.exists(filepath) or not grunt.file.isFile(filepath)
              return false
            true

          .map (filepath)->
            filename = path.relative(options.cwd, filepath).replace(/\//g, "-")

            destDir: group.dest
            destPath: path.normalize("#{group.dest}/#{filename}")
            filename: filename
            path: filepath

      Array::push.apply pages, p


    # Get path to phantomjs binary
    phantomjs =
      bin: require('phantomjs').path
      script: path.resolve(__dirname, '../phantomjs/render.coffee')


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
              page.destDir,
              page.filename,
              page.path]
          , (err)->
            if err then done() else next()
      ,
      # All screenshots have been made
      ->
        generateDocuments()
        done()


    # generate documents
    generateDocuments = ()->
      template = path.resolve(__dirname, '../template/template.jade')
      fn = jade.compile fs.readFileSync(template),
        pretty: true
        filename: template

      for item in pages
        item.breakpoints = []
        for size in options.breakpoints
          item.breakpoints.push
            size: size,
            file: options.pattern
              .replace('FILENAME', item.filename)
              .replace('BREAKPOINT', size)
              .replace('EXT', options.ext)

        compiled = fn
          pages: pages,
          item: item
        fs.writeFileSync(item.destPath, compiled, {encoding:'utf8'})