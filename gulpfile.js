var gulp = require('beverage')(require('gulp'), {
  scripts: {include: {build: 'index.js'}},
  causality: ['build', ['index.coffee']],
  test: {
    watch: ['index.js', 'test/*.coffee']
  },
  sourcegate: [
    {recipe: 'coffeelint',
     module: 'hal-coffeescript-style-guide',
     prefix: './'},
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
