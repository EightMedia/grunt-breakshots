system = require "system"

args =
  ext: system.args[1]
  breakpoints: system.args[2].split(",")
  pattern : system.args[3]
  dest : system.args[4]
  source : system.args[5]

webpage = require "webpage"
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
  next = ->
    if args.breakpoints.length
      breakpoint = parseInt(args.breakpoints.shift(), 10)

      page.viewportSize =
        width: breakpoint
        height: 100

      page.open args.source, (status)->
        window.setTimeout(->
            if status is "success"
              size = page.evaluate (breakpoint)->
                  document.querySelector('html').style.width = "#{breakpoint}px"

                  width: document.body.clientWidth
                  height: document.body.clientHeight
                , breakpoint

              page.clipRect =
                top: 0
                left: 0
                width: breakpoint
                height: size.height

              page.render destFile(breakpoint)
              next()
            else
              next()
          , 100)
    else
      done()
  next()


# gogogogo!
renderBreakpoints ->
  phantom.exit()


