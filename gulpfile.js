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
  sourcegateModule: false, // this is the module, used here for self-config
  sourcegatePrefix: 'rc/',
  sourcegatePreset: 'airbnb'
})

gulp.task('dev', 'DEVELOP', [
  'build',
  'sourcegate:watch',
  'build:watch',
  'test:watch'
])
