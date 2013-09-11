system = require "system"

args =
  ext: system.args[1]
  breakpoints: system.args[2].split(",")
  dest : system.args[3]
  url : system.args[4]

webpage = require "webpage"
page = webpage.create()


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

      page.open args.url, (status)->
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

              page.render "#{args.dest}.#{breakpoint}.#{args.ext}"
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


