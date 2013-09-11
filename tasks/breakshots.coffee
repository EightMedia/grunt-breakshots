###
  grunt-breakshots
  https://github.com/EightMedia/grunt-breakshots

  Copyright (c) 2013 J. Tangelder
  Licensed under the MIT license.
###

path = require 'path'
jade = require 'jade'
fs = require 'fs'

module.exports = (grunt)->
  
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask 'breakshots', 'Create screenshots of html files per breakpoint', ->

    # This task is asynchronous.
    done = @async()

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options
      cwd: '.'
      url: 'http://localhost:8000/'
      ext: 'png'
      breakpoints: [320,480,640,768,1024,1200]

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
            filepath = path.relative(options.cwd, filepath)
            filename = filepath.split(path.sep).join(".")
            
            url: options.url + filepath,
            filename: filename,
            dest: path.normalize("#{group.dest}/#{filename}")
      
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
              page.dest,
              page.url]
          , (err)->
            if err 
              console.error err
              done() 
            else 
              console.log "Rendered #{page.filename}"
              next()
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
            file: item.filename

        compiled = fn
          pages: pages,
          options: options,
          item: item
        fs.writeFileSync("#{item.dest}.html", compiled, {encoding:'utf8'})
        
        console.log "Generated #{item.dest}.html"
