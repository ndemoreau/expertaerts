Template.basicLayout.rendered = ->
  setTimeout( ->
    setSizes()
    fadeBackground()
    $(window).on('resize', ->
      console.log "resize"
      setSizes()
    )

  ,2000)

  updatePosition = ->
    scrollPosition = $(window).scrollLeft()
    $(".page").each ->
      pagePosition = @offsetLeft
      pageWidth = $(window).width()
      currentPage = @id
      if pagePosition >= scrollPosition and pagePosition < scrollPosition + pageWidth / 2 and !$("#menu-item-" + currentPage).hasClass("active")
        $(".menu-item").removeClass("active")
        $("#menu-item-" + currentPage).addClass("active")


  throttled = _.throttle updatePosition, 100
  $(window).scroll(throttled)


@setSizes = ->
  height = $(window).height()
  optimalwidth = Math.round(9720 * height / 912)
  pageWidth = Math.round($(window).width())
  minimalWidth = pageWidth * 6
  width = Math.max(optimalwidth, minimalWidth)

  console.log width
  console.log pageWidth
  unless $("body").hasClass("admin")
    console.log "setting sizes as it should"
    $(".contents-container").css("background-size", width + "px " + height + "px")
    $(".contents-container").css("width",width + "px")
    $(".contents-container").css("height",height + "px")
    $(".page").css("width",pageWidth + "px")

gradient = .9
@fadeBackground = ->
  $(".mainlogo").removeClass("hidden")
  setTimeout( ->
    console.log "fading"
    $(".background-image-overlay").css("background","linear-gradient(to bottom, rgba(0, 0, 41, .9),  rgba(0, 0, 41, " + gradient + ")")
    gradient = gradient - .1
    if gradient > .1
      fadeBackground()
  ,100

  )

