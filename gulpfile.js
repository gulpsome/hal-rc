var gulp = require('beverage')(require('gulp'), {
  scripts: {include: {build: 'index.js'}},
  buildWatch: ['index.coffee'],
  test: {},
  testWatch: ['index.js', 'test/*.coffee'],
  sourcegate: [
    {recipe: 'coffeelint'},
    {recipe: 'jscs'},
    {recipe: 'jshint'}
  ],
  sourcegateModule: '',
  sourcegatePrefix: 'rc/',
  sourcegatePreset: 'airbnb'
})

gulp.task('dev', 'DEVELOP', [
  'build',
  'build:watch',
  'test:watch'
])
