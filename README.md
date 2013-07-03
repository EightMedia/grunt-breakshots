# grunt-breakshots

> Create screenshots of html files per breakpoint

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-breakshots --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-breakshots');
```

## The "breakshots" task

### Overview
In your project's Gruntfile, add a section named `breakshots` to the data object passed into `grunt.initConfig()`.


### Options

#### options.breakpoints
Type: `Array`
Default value: `[240,320,480,640,700,768,1024,1280]`

#### options.pattern
Type: `String`
Default value: `'FILENAME.BREAKPOINT.EXT'`

#### options.ext
Type: `String`
Default value: `'png'`

`jpg` is also possible.

#### options.cwd
Type: `String`
Default value: `'.'`


### Usage Examples

#### Default Options
In this example, the default options are used to do something with whatever. So if the `testing` file has the content `Testing` and the `123` file had the content `1 2 3`, the generated result would be `Testing, 1 2 3.`

```js
grunt.initConfig({
  breakshots: {
    options: {},
    files: {
      'breakshots/': ['index.html','contact.html','**/*.html']
    },
  },
})
```


## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
