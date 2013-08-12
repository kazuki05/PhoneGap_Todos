/*
 * grunt-simple-templates
 * https://github.com/jclem/grunt-simple-templates
 *
 * Copyright (c) 2013 Jonathan Clem
 * Licensed under the MIT license.
 */

'use strict';

var fs    = require('fs'),
    path  = require('path');

module.exports = function(grunt) {

  // Please see the Grunt documentation for more information regarding task
  // creation: http://gruntjs.com/creating-tasks

  grunt.registerMultiTask('templates', 'Render templates into JavaScript objects', function() {
    // Merge task-specific and/or target-specific options with these defaults.
    var options = this.options({
      punctuation: '.',
      separator: ', ',
      namespace: 'TEMPLATES',
      extension: "mustache"
    });

    var templateObject = {};

    this.filesSrc.forEach(function(file) {
      grunt.file.recurse(file, function(absPath, rootDir, subdir, filename) {
        if (filename.split('.').pop() === options.extension) {
          var templateKey = filename.split('.')[0];

          if (subdir) {
            templateKey = subdir + "/" + templateKey;
          }

          templateObject[templateKey] = grunt.file.read(absPath);
        }
      });
    });

    grunt.file.write(this.data.dest, "window." + options.namespace + " = " + JSON.stringify(templateObject) + ";\n");
    grunt.log.writeln('File "' + this.data.dest + '" created.');
  });

};
