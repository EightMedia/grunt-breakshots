system = require "system"

args =
  ext: system.args[1]
  breakpoints: system.args[2].split(",")
  pattern : system.args[3]
  dest : system.args[4]
  source : system.args[5]

webpage = require("webpage")
page = webpage.create()


# get destination filename
destFile = (breakpoint)->
  file = args.pattern
    .replace('FILENAME', args.source.split("/").slice(-1))
    .replace('EXT', args.ext)
    .replace('BREAKPOINT', breakpoint)
  "#{args.dest}/#{file}"


###
 render given urls
 param array of URLs to render
 param callbackPerUrl Function called after finishing each URL, including the last URL
 param callbackFinal Function called after finishing everything
###
renderBreakpoints = (done)->
  next = ()->
    if args.breakpoints.length
      breakpoint = args.breakpoints.shift()

      page.viewportSize =
        width: parseInt(breakpoint,10)
        height: 100

      page.open args.source, (status)->
        window.setTimeout(->
            if status is "success"
              page.render destFile(breakpoint)
              next()
            else
              next()
          , 100)
    else
      done()

  next()


# gogogogo!
renderBreakpoints ()->
  phantom.exit()


