###
  grunt-breakshots
  https://github.com/EightMedia/grunt-breakshots

  Copyright (c) 2013 J. Tangelder
  Licensed under the MIT license.
###

'use strict'

module.exports = (grunt)->

  # Project configuration.
  grunt.initConfig
    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ['tmp']
      
    # simple node server
    connect:
      docs:
        options:
          base: "test/fixtures"
          hostname: "0.0.0.0"
          port: 8000

    # Configuration to be run (and then tested).
    breakshots:
      main:
        options:
          cwd: 'test/fixtures/'
          url: 'http://localhost:8000/'
        files:
          'tmp/': ['test/fixtures/**/*']

    # Unit tests.
    nodeunit:
      tests: ['test/*_test.coffee']


  # Actually load this plugin's task(s).
  grunt.loadTasks 'tasks'

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  # Whenever the "default" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask 'default', ['connect','clean', 'breakshots', 'nodeunit']