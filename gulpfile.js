var gulp = require('beverage')(require('gulp'), {
  scripts: {include: {build: 'index.js'}},
  causality: ['build', ['index.coffee']],
  test: {
    watch: ['index.js', 'test/*.coffee']
  },
  sourcegate: [
    {recipe: 'coffeelint',
     preset: 'hal-coffeescript-style-guide',
     module: '!' // the preset is enough
    },
    {recipe: 'jshint'},
    {recipe: 'jscs'}
  ],
  sourceopt: {
    module: false, // this is the module, self-configured
    preset: 'airbnb'
  }
})

gulp.task('dev', 'DEVELOP', [
  'build',
  'build:watch',
  'test:watch'
])
