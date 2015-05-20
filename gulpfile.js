var gulp = require('beverage')(require('gulp'), {
  scripts: {include: {build: 'index.js'}},
  buildWatch: ['index.coffee'],
  test: {},
  testWatch: ['index.js', 'test/*.coffee'],
  sourcegate: [
    {recipe: 'coffeelint', preset: 'coffeescript-style-guide'},
    {recipe: 'jshint'},
    {recipe: 'jscs'}
  ],
  sourcegateModule: false, // this is the module, self-configured
  sourcegatePrefix: 'rc/',
  sourcegatePreset: 'airbnb'
})

gulp.task('dev', 'DEVELOP', [
  'build',
  'sourcegate:watch',
  'build:watch',
  'test:watch'
])
