# hal (-) \*rc

*Hal should be, well, linted, to begin with.*

## Why

Or what is the point of this?

```txt
Node modules tend to be many.
One tends to repeat, oneself.
Over and over copy / pasting.
Even with the best practices.
```

For one example this could be the perfect implementation of your *code linting* best practices, as described in Henrik Joreteg's [Human JavaScript](http://read.humanjavascript.com/ch03-code-for-humans.html) / *code for humans*.  Say one works on a project using [airbnb](https://github.com/airbnb/javascript)'s style.  The following `gulpfile.js` would give one `gulp sourcegate` and `gulp sourcegate:watch` tasks for writing `.jshintrc` and `.jscsrc` to a project's root:

```javascript
var gulp = require('beverage')(require('gulp'), {
  sourcegate: [{recipe: 'jscs'}, {recipe: 'jshint'}],
  sourcegatePreset: 'airbnb'
})
```

One could setup linting rule overrides by mere configuration.  No need to fork presets.  If this became a coding standard for more than one project, one could reuse the configuration.  But I'm getting ahead of myself.  Back to `hal-rc` and what it does.

## Use

[![NPM](https://nodei.co/npm/hal-rc.png?mini=true)](https://www.npmjs.org/package/hal-rc)

1. Make [sourcegate](https://github.com/orlin/sourcegate) more conveniently configurable, especially in the context of [beverage](https://github.com/orlin/beverage), for the purpose of writing `.*rc` files that will setup hinting and linting rules for a project - without copy / paste.  In this context `hal-rc` simply gets the options ready for calling `sourcegate` with.

    ```javascript
    var options = require('hal-rc')({
      // options listed next
    })
    // call sourcegate with the above, see the tests about how
    ```

2. Offer `gulpfriendly` task(s) creation, while keeping it optional - i.e. call without the `gulp` argument and build your own workflow using whatever approach / other tools you may prefer instead.

    ```javascript
    require('hal-rc')({
      // options listed next
    }, require('gulp'))
    // use gulp cli for running the sourcegate tasks
    ```

3. A place where I keep my own linting rules and preferences - in `rc/*`.  This would be irrelevant for anybody else though feel free to follow / tweak my coding standard if you like.  Unless of course we collaborate on some projects that are based on these settings.  In which case we can negotiate the rules, in common.  Easy setup makes for an easy start.  I'm not religious, about what code should look like.

### Configure:

- `sourcegate: []` creates tasks that write configuration files, documented next
- `sourcegateRx: {}` abbreviation for sourcegateRecipeDefaults so one can skip stuff like `sources: {node: true}` for each jshint-linted project, skip the defaults with `sourcegate: [{recipe: 'jshint', sources: {}}]`, for example, or override with `sourcegateModule / module` config
- `sourcegateModule: 'a-node_modules-module-name'` optional like everything else
- `sourcegatePrefix`: '.'` will look for `".#{recipe}rc"`, it can also be a path
- `sourcegatePreset: "airbnb"` for example, in some cases there are presets across tools, this sets a default one for configuration DRY-ness; presets of tools installed in the project's `node_modules` have priority over presets form `sourcegateModule`'s `node_modules`, this way a project can have its own version of presets
- `sourcegateWatch: true` will create a `sourcegate:watch` task, if `hal-rc` is handed `gulp` via the second argument

The above options can be used to setup configuration files from a template to the project's root with possible overrides.  This is done with the [sourcegate module](https://github.com/orlin/sourcegate) and some example files would be: `.jshintrc`, `.jscsrc`, `.eslintrc`, etc.  If there is a package in node_modules that contains some / many / most / all your baseline defaults for coding style preferences / standards, `sourcegateModule` will tell HAL about it so the config is DRYer.  Or each template can set its own individual module / path.  It could be a published module, or a git repo in `devDependencies`.  One gets a convenient setup for tools that use json config files, for example:

- [jscs](http://jscs.info)
- [jshint](http://jshint.com)
- [eslint](http://eslint.org)
- [coffeelint](http://www.coffeelint.org)

These tools are here called recipes.
Any tool that looks for its configuration in a ".#{tool}rc" file,
in a project's root dir - is automatically supported as a recipe.
The config would look like:

```javascript
{
  recipe: 'name', // a tool's name
  module: 'name', // overrides the sourcegateModule default
  prefix: '.', // what goes between module and "#{recipe}rc"
  preset: 'name', // so far only for `jscs`, or "airbnb", or "coffeescript-style-guide"
  sources: [], // sourcegate's first argument - stuff to merge
  sources: {}, // shorthand for overrides that don't come from a file
  options: {} // handed to sourcegate
}
```

Some tools, such as jscs have presets, use the `preset` option for easy config.
In this case, jscs would have to be a dependency of either:

1. the project using the `hal-rc` or `beverage` module
2. the configured `sourcegateModule`

Presets are just a way to bootstrap one's styleduide, by taking defaults from another styleguide - the one providing the presets.  It could be any node module or a non-packaged repo used as module with [napa](https://github.com/shama/napa) for example.  If `sourcegate` can read it, and your tools (linters) use JSON config, then it's supported already.

The `recipe`, `module`, `prefix` and `preset` options are merely conveniences.

One can always fallback to [sourcegate options](https://github.com/orlin/sourcegate#configure).
The minimum needed in such a case is:

```javascript
{
  sources: [
    // one or more things to merge
  ],
  options: {write: {path: 'name-me.json'}} // if not ".#{tool}rc"
}
```

## Test [![Build Status](https://img.shields.io/travis/orlin/hal-rc.svg?style=flat)](https://travis-ci.org/orlin/hal-rc)

```sh
npm test
```

## Unlicensed

This is free and unencumbered public domain software.
For more information, see [UNLICENSE](http://unlicense.org).
