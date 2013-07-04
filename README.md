# grunt-breakshots

> Create screenshots with a viewer of html files per breakpoint

This task takes with PhantomJS screenshots of your page, and store them in a folder. Also a nice viewer is generated, so you can browse the screenshots easily.


## Getting Started
This plugin requires Grunt `~0.4.1`

```js
grunt.loadNpmTasks('grunt-breakshots');
```

## The "breakshots" task

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
- 2013/07/04 - 0.1.2 - Added a nice viewer html
- 2013/07/04 - 0.1.1 - Fixed Phantomjs issue
- 2013/07/03 - 0.1.0 - Initial
