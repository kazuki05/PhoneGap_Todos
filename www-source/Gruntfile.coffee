module.exports = (grunt) ->
  grunt.initConfig

    concat:
      dist: {
        src: [
          'bower_components/jquery/jquery.js',
          'bower_components/underscore/underscore.js',
          'bower_components/backbone/backbone.js',
          'bower_components/marionette/lib/backbone.marionette.js',
          'bower_components/mustache/mustache.js',
          'bower_components/json2/json2.js',
          'bower_components/backbone.localStorage/backbone.localStorage.js',
          'bower_components/jquery-tmpl/jquery.tmpl.js'
          ],
        dest: '../www/js/vendor.js'
      }

    templates:
      compile: {
        src: 'templates/',
        dest: '../www/js/templates.js',

        options: {
          namespace: "MUSTACHE"
        }
      }

    coffee:
      compile:
        src: [
            'coffee/app.coffee',
            'coffee/controllers/controller.coffee',
            'coffee/views/app/item.coffee',
            'coffee/models/app.coffee',
            'coffee/**/*.coffee',
            'coffee/init.coffee'
        ],
        dest: '../www/js/application.js'

    sass:
      compile:
        src: ['sass/application.scss'],
        dest: '../www/css/application.css'
      options:
        compass: true

    watch:
      files: [
        'coffee/**',
        'sass/**',
        'templates/**',
        '../www/index.html'
      ],
      tasks: 'default',
      options:
        livereload: true

  grunt.registerTask 'default', ['concat', 'coffee', 'sass', 'templates']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-simple-templates'
