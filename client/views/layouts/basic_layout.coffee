Template.basicLayout.rendered = ->
  setTimeout( ->
    setSizes()
    if  Iron.Location.get().originalUrl.indexOf("#") > -1
      this_url = Iron.Location.get().originalUrl.split("#")[1]
      console.log this_url
      goToPage this_url, 0

    $(".startup-background").fadeOut("2000")
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
  optimalwidth = Math.round(8100 * height / 912)
  pageWidth = Math.round($(window).width())
  minimalWidth = pageWidth * 5
  width = Math.max(optimalwidth, minimalWidth)

  console.log width
  console.log pageWidth
  unless $("body").hasClass("admin")
    console.log "setting sizes as it should"
    $(".contents-container").css("background-size", width + "px " + height + "px")
    $(".contents-container").css("width",width + "px")
    $(".contents-container").css("height",height + "px")
    $(".page").css("width",pageWidth + "px")

