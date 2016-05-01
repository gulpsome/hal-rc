require("source-map-support").install()
R = require("ramda")
fs = require("fs")
path = require("path")
isThere = require("is-there")
sourcegate = require("sourcegate")
nocomments = require("strip-json-comments")
task = require("be-goods").gulpTask
logger = require("be-goods").logger

logUse = (what = "") -> console.log what if process.argv[2] is "sourcegate"

obtain = (somewhere) ->
  JSON.parse nocomments fs.readFileSync(path.normalize somewhere).toString()

get = (what, module) ->
  # gutil.log "Looking for '#{what}' in module '#{module}'"
  where = [
    "node_modules/#{what}",
    "node_modules/#{module}/node_modules/#{what}",
    "node_modules/beverage/node_modules/#{module}/node_modules/#{what}"
  ]

  last = where.length - 1
  for i in [0..last]
    try
      gotIt = obtain where[i]
      logUse "Source #{where[i]}"
      return gotIt
    catch e
      if i is last
        logger.error(e)
        throw new Error "Could not find preset at: #{where}"
      continue


getPreset = (tool, name, module) ->
  # the tool is known as recipe
  # the name is known as preset
  presets =
    jscs: "jscs/presets" #{preset}.json will be appended
    jshint:
      airbnb: "airbnb-style/linters/jshintrc"
    eslint:
      airbnb: "airbnb-style/linters/.eslintrc"
    coffeelint:
      # this can't really be found - polarmobile never published it on npm
      "coffeescript-style-guide": "hal-coffeescript-style-guide/coffeelint.json"

  if tool is "jscs"
    get("#{presets.jscs}/#{name}.json", module)
  else if presets[tool]?[name]?
    get(presets[tool][name], module)
  else {}


module.exports = (o = {}, gulp) ->
  empty = [[], {}]
  if R.is(Array, o.sourcegate)
    if R.isEmpty(o.sourcegate) then return [empty]
  else return [empty] # or throw?
  o.sourceopt ?= {}
  ready = []
  watch = []

  for sg in o.sourcegate
    res = R.clone(empty)
    sg.options ?= {}

    unless sg.recipe?
      # 0. without a recipe, hal-rc just hands sources and options to sourcegate
      res = [sg.sources, sg.options]
    else
      logUse()
      logUse("For #{sg.recipe}:")
      sources = []
      module = sg.module or o.sourceopt.module
      prefix = sg.prefix or o.sourceopt.prefix or ''
      preset = sg.preset or o.sourceopt.preset
      # 1. start with preset (something known / standard)
      if preset?
        sources.push getPreset(sg.recipe, preset, module)
      filerc = if sg.recipe is "coffeelint" then "coffeelint.json" else ".#{sg.recipe}rc"
      if module?
        # 2. override with a module config (anybody can have presets)
        config = "#{prefix}#{filerc}"
        if module # false is a valid value
          config = "node_modules/#{module}/#{config}"
        config = path.normalize(config)
        logUse "Source #{config}"

        unless isThere config
          logger.error "Could not find: #{config}"
        else
          if o.sourceopt.watch
            watch.push config
          sources.push config
      sg.options.write ?= {}
      sg.options.write.path = filerc
      # 3. sources, whether an object or array, become the final override
      sources = sources.concat(sg.sources) if sg.sources?
      res = [sources, sg.options]

    ready.push res

  # optional gulp / tasks
  if gulp?
    task gulp, "sourcegate", "Write sourcegate targets.", ->
      for sg in ready
        sourcegate.apply(null, sg)
    if o.sourceopt.watch
      task gulp, "sourcegate:watch",
        "Watch sourcegate sources for changes.", ->
          gulp.watch watch, ["sourcegate"]

  logUse()
  ready
