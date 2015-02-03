# 
# * GLOBAL VARIABLES
# 

# these should match with the bootrstrap defined widths

# 
# * ================================================================
# * VIEWPORT
# *
# * get actual window width/height (to match with css media queries)
# 
@viewport = ->
  e = window
  a = "inner"
  unless "innerWidth" of window
    a = "client"
    e = document.documentElement or document.body
  width: e[a + "Width"]
  height: e[a + "Height"]

#
# * ================================================================
# * Mobile Menu Icon
# *
# * Icon which toggles (opens/closes) main menu on smaller resolutions
# 
@toggle_main_menu = ->

  # only applies for mobile window widths
  if viewport().width <= window.xs_screen_max
    mobile_menu_icon = $("#left-sidebar #mobile-menu-icon")
    main_menu = $("#left-sidebar #main-menu")

    # if menu is already visible, hide it and remove active class for menu icon
    if main_menu.is(":visible")
      main_menu.addClass("menu_closed_on_xs").removeClass("menu_opened_on_xs").slideUp "fast", ->
        mobile_menu_icon.removeClass "active"
        return


      # if menu is hidden, show it and add active class to menu icon
    else
      main_menu.addClass("menu_opened_on_xs").removeClass("menu_closed_on_xs").slideDown "fast", ->
        mobile_menu_icon.addClass "active"
        return

  return

# end: only applies for mobile window widths

#
# * ================================================================
# * Main Menu Visiblity on Window Resize
# *
# * Since main menu is hidden on smaller window widths, this function makes sure that it is visible when window is maximised
# 
@main_menu_visiblity_on_resize = ->
  main_menu = $("#left-sidebar #main-menu")

  # for larger window viewports
  if viewport().width > window.xs_screen_max

    # if menu was closed on small (mobile/xs) viewport, show it
    main_menu.show()  if main_menu.hasClass("menu_closed_on_xs")

    # end: for larger window viewports

    # for smaller window viewports (mobile/xs)
  else

    # if menu was closed on small (mobile/xs) viewport, ensure it remains closed
    main_menu.hide()  if main_menu.hasClass("menu_closed_on_xs")

    # if menu was open on small (mobile/xs) viewport, ensure it remains open
    main_menu.show()  if main_menu.hasClass("menu_opened_on_xs")
  return

#
# * ================================================================
# * Sections Content Vertical Position
# *
# * By default, main content for each section is positioned at the bottom of the page. 
# * This function checks the content-wrapper height, and if it is bigger than 80% of the window height, content-wrapper is positioned statically so that a user can scroll down the page, and content is not hidden.
# *
# * This function only applies for non-mobile viewports (when window width is larger than 768px), since on smaller screens, the layout is different
# 
@sections_content_vertical_position = ->

  # only applies for non-mobile window widths (see comment above)
  if viewport().width > window.xs_screen_max
    window_height = $(window).height()
    content_available_height = 0.8 * window_height # the available height for the .content-wrapper when it is absolute positioned

    # for each section
    $("#main-content .section-wrapper").each ->
      content_wrapper = $(this).find(".content-wrapper")
      content_wrapper_height = content_wrapper.height()
      active_section = (if ($(this).hasClass("active")) then true else false) # check if this section is active (visible)

      # if content-wrapper height is larger than the height available in page (without content being hidden), set position to static (not absolute)
      if content_wrapper_height > content_available_height
        content_wrapper.css position: "static"

        # end: if content-wrapper height is larger than the height available

        # if content-wrapper height is smaller than (within) height available, set position to absolute (with bottom and right position set in the CSS)
      else
        content_wrapper.css position: "absolute"
      return


    # scroll to top of active section to ensure top content of section is not hidden on page resize (doesn't apply to mobile devices)
    #
    #            if (active_section == true && !jQuery.browser.mobile)
    #            {
    #                var section_vertical_offset = $(this).offset().top;
    #                $('html, body').stop().animate({
    #                    scrollTop: section_vertical_offset
    #                }, 500,'easeInOutCubic');
    #            }
    #

    # end: for each section

    # end: only applies for non-mobile

    # for mobile viewport
  else

    # remove absolute positionining for all section's content
    $("#main-content .section-wrapper .content-wrapper").css position: "static"
  return

# end: for mobile viewport

#
# * ================================================================
# * Initialise General Links Click Events
# *
# * ** Has to be called BEFORE initialise_main_menu_click_events() **
# *
# * This function handles the onclick events for all the links inside the page with class ".link-scroll"
# * When a link targets an id within the same page, scroll to that id and update active section
# 
@initialise_general_links_click_events = ->

  # in any link inside the page is clicked
  $("a.link-scroll").click (event) ->

    # get target link
    clicked_link_href = $(this).attr("href")

    # if link is not empty
    if clicked_link_href isnt `undefined` and clicked_link_href isnt "" and clicked_link_href isnt "#"
      first_character_of_link = clicked_link_href.substr(0, 1) # will be used below

      # if link is to an ID of an element (anchor link)
      if first_character_of_link is "#"

        # if element with that ID exists inside the page
        if $(clicked_link_href).length > 0

          # add class to identify that scroll is "in action", so that no other scroll functions conflict
          $("#main-content").addClass "same_page_link_in_action"

          # scroll to section
          target_vertical_offset = $(clicked_link_href).offset().top
          $("html, body").stop().animate
            scrollTop: target_vertical_offset
          , 1500, "easeInOutCubic", ->

            # remove class used to identify that scroll is "in action", so that no other scroll functions conflict
            $("#main-content").removeClass "same_page_link_in_action"

            # set visible section to active
            update_active_sections_on_scroll()
            return

          (if event.preventDefault then event.preventDefault() else event.returnValue = false)

          # if element with that ID doesn't exist
        else
          false

        # end: if link is to an ID of an element (anchor link)

        # normal link
      else

        # acts as a normal link

        # end: normal link

        # end: if link is not empty

        # empty link
    else
      (if event.preventDefault then event.preventDefault() else event.returnValue = false)
      false
    return

  return

# end: if any link inside the page is clicked

#
# * ================================================================
# * Initialise Main Menu Click Events
# *
# * ** Has to be called AFTER initialise_general_links_click_events() since it overrides the other function **
# *
# * This function handles the onclick events for the main menu item links
# 
@initialise_main_menu_click_events = ->

  # first remove any click events for menu links (which were set for all links in initialise_general_links_click_events() above)
  $("#main-menu .menu-item > a").off "click"
  $("#main-menu .menu-item > a").prop "onclick", null

  # for each click of main menu item links
  $("#main-menu .menu-item > a").click (event) ->
    clicked_link_href = $(this).attr("href")
    first_character_of_link = clicked_link_href.substr(0, 1) # will be used below
    clicked_link_parent_menu_item = $(this).parent(".menu-item")
    link_menu_item_id = clicked_link_parent_menu_item.attr("id")

    # if menu item has "scroll" class, and links to a section id (starts with #) load scroll function
    if clicked_link_parent_menu_item.hasClass("scroll") and first_character_of_link is "#"
      clicked_menu_item_id = (if (link_menu_item_id isnt `undefined` and link_menu_item_id isnt "") then link_menu_item_id else "")

      # add class to identify that scroll is "in action", so that no other scroll functions conflict
      $("#main-content").addClass "same_page_link_in_action"

      # do not change background on mobile viewports
      change_background = (if (viewport().width > window.xs_screen_max) then true else false)
      scroll_to_section clicked_link_href, clicked_menu_item_id, change_background
      (if event.preventDefault then event.preventDefault() else event.returnValue = false) # stop link from default action

      # if menu item does NOT have "scroll" class, default link action will apply
    else

      # if fake link ("#") or empty, do nothing
      if clicked_link_href is `undefined` or clicked_link_href is "" or clicked_link_href is "#"
        (if event.preventDefault then event.preventDefault() else event.returnValue = false)
        false
    return

  return

#
# * ================================================================
# * Scroll Up/Down to section wrapper
# *
# * This function scrolls up/down to a section, and calls function which updates section to active
# *
# * @param target_section - section id - the id of the section wrapper to which to scroll to
# * @param clicked_menu_item_id - menu item id - the id of the clicked menu item (if function called after clicking on a menu item)
# * @param change_background - true or false - (default true) if false, do not change background on scroll 
# 
@scroll_to_section = (target_section_id, clicked_menu_item_id, change_background) ->

  # only works if the target_section is provided
  if target_section_id isnt `undefined` and target_section_id isnt ""
    target_section_wrapper = $("#main-content " + target_section_id + ".section-wrapper")

    # if target section exists and is not already active
    if target_section_wrapper.length isnt 0 and not target_section_wrapper.hasClass("active")

      # scroll to section
      section_vertical_offset = target_section_wrapper.offset().top
      $("html, body").stop().animate
        scrollTop: section_vertical_offset
      , 1500, "easeInOutCubic", ->

        # remove class used to identify that section is "in action", so that no other scroll functions conflict
        $("#main-content").removeClass "same_page_link_in_action"
        return


      # set section to active
      set_section_to_active target_section_id, clicked_menu_item_id, "", change_background

      # end: if target section exists
    else
      false

    # end: only works if the target_section is provided
  else
    false
  return

#
# * ================================================================
# * Set Section to Active
# *
# * When a user scrolls or clicks to scroll to a section, this function is called to set that particular section to active
# *
# * - sets menu item to active
# * - sets active class to section wrapper
# * - change background image of page (if set for that particular section)
# *
# * @param target_section - section id - the id of the active section wrapper
# * @param clicked_menu_item_id - menu item id - the id of the clicked menu item (if function called after clicking on a menu item)
# * @param called_on_scroll - true or false - if set to true, this function was called when scrolling, hence background changes should be faster
# * @param change_background - true or false - (default true) if false, do not change background on scroll 
# 
@set_section_to_active = (target_section_id, clicked_menu_item_id, called_on_scroll, change_background) ->
  console.log "activating..."
  # only works if the target_section is provided
  if target_section_id isnt `undefined` and target_section_id isnt ""
    section_wrapper = $(target_section_id)

    # remove current active classes
    $("#main-menu .menu-item").removeClass "active"
    $("#main-content .azimuth-block").children().removeClass "active"

    # ------ set menu item to active ---------
    # if clicked menu item id is provided and exists
    clicked_menu_item_object = (if (clicked_menu_item_id? and clicked_menu_item_id isnt "") then $("#main-menu #" + clicked_menu_item_id + ".menu-item") else "")
    if clicked_menu_item_object isnt "" and clicked_menu_item_object.length isnt 0
      clicked_menu_item_object.addClass "active"

      # if clicked menu item id is not provided, find menu item corresponding to the target section id
    else
      section_name = target_section_id.substr(1) # section ids (links) start with "#"
      menu_key = new RegExp "#" + section_wrapper.attr("id"), "i"
      menu_item = Azimuth.collections.Navigation.findOne({url: menu_key})
      section_name = menu_item._id if menu_item
      console.log "section name: #{section_name}"
      $(".menu-item-" + section_name + ".menu-item").addClass "active" # assuming menu items ids start with "menu-item-"

    # ------ set section wrapper to active ---------
    section_wrapper.addClass "active"

    # Hide/Show Main Menu "TOP" icon
    toggle_top_icon_in_main_menu()

    # ------ change custom background ------
    unless change_background is false
      section_custom_background_attr = section_wrapper.attr("data-custom-background-img")
      section_custom_background = (if (section_custom_background_attr isnt `undefined` and section_custom_background_attr isnt "") then section_custom_background_attr else $("#outer-background-container").attr("data-default-background-img")) # use #outer-background-container default image if custom background not set
      console.log "new background #{section_custom_background}"

      # if target section wrapper has custom background set
      if section_custom_background isnt `undefined` and section_custom_background isnt ""
        console.log "changing background"
        transition_speed = (if (called_on_scroll isnt true) then 1500 else 550) # crossfading speed should be faster when function called on scroll
        $("#outer-background-container").backstretch section_custom_background,
          fade: transition_speed

  return

# end: if target section wrapper has custom background set

# end: change custom background

# end: only works if the target_section is provided

#
# * ================================================================
# * Get All Section Wrappers in Page
# *
# * This function returns an array of all the section wrappers in the page
# *
# 
@get_all_section_wrappers_in_page = ->
  section_wrappers = $("#main-content").find(".azimuth-block").children()
  section_wrappers

#
# * ================================================================
# * Update Active Sections on Scroll
# *
# * This function is fired when the user scrolls, and updates the active section depending on the vertical scroll position
# *
# * @param section_wrappers - all the section wrappers in a page
# * @param amount_of_pixels_as_buffer_between_sections - integer - a proportion of the website height, used to match visible sections more accurately
# 
@update_active_sections_on_scroll = (section_wrappers, amount_of_pixels_as_buffer_between_sections) ->

  # first check if already loaded (to make function faster), otherwise search for all the section wrappers
  all_section_wrappers = (if (section_wrappers isnt `undefined` and section_wrappers isnt "") then section_wrappers else $("#main-content").find(".section-wrapper"))
  console.log "updating section..."
  # see comment above
  amount_of_pixels_as_buffer_between_sections = (if (amount_of_pixels_as_buffer_between_sections isnt amount_of_pixels_as_buffer_between_sections and amount_of_pixels_as_buffer_between_sections isnt "") then amount_of_pixels_as_buffer_between_sections else 0.25 * ($(window).height()))
  scroll_from_top = $(document).scrollTop()

  # get the visible section
  current_scroll_section = all_section_wrappers.map(->
#    console.log "current section wrapper: #{$(this).attr("id")}"
    offset_from_top = ($(this).offset().top) - amount_of_pixels_as_buffer_between_sections
    section_height = $(this).height()
    offset_from_bottom = offset_from_top + section_height
#    console.log "scroll from top: #{scroll_from_top},  offset from top:  #{offset_from_top}, offset from bottom: #{offset_from_bottom}"
#    console.log "true? #{scroll_from_top > offset_from_top and scroll_from_top <= offset_from_bottom}"
    this  if scroll_from_top > offset_from_top and scroll_from_top <= offset_from_bottom
  )

  # update such section to active
  if current_scroll_section isnt `undefined` and current_scroll_section isnt ""
    active_section_id = "#" + current_scroll_section.attr("id")
    console.log "active:  #{active_section_id}"
    # DON'T do update if visible section is already active
    set_section_to_active active_section_id, "", true  unless current_scroll_section.hasClass("active")
  return

#
# * ================================================================
# * Hide/Show Main Menu "TOP" icon
# *
# * This function hides the top "^" icon in the main menu when the user is at the top of the page, and shows it when the user scrolls down.
# 
@toggle_top_icon_in_main_menu = ->
  intro_menu_item = $("#main-menu #menu-item-intro")
  if intro_menu_item.hasClass("active")
    intro_menu_item.css(opacity: 0).addClass "main-menu-top-icon-active"
  else
    intro_menu_item.css(opacity: 0.7).removeClass "main-menu-top-icon-active"
  return

#
# * ================================================================
# * Preload All Sections Background Images
# *
# * This function preloads all the background images set for all section wrappers in the page
# *
# 
@preload_section_backgrounds = ->
  section_wrappers = get_all_section_wrappers_in_page()

  # if there are sections
  if section_wrappers.length > 0

    # for each section wrapper
    section_wrappers.each ->

      # if a custom background image is set, load it
      section_custom_background = $(this).attr("data-custom-background-img")
      if section_custom_background isnt `undefined` and section_custom_background isnt ""
        img = new Image()
        img.src = section_custom_background
      return

  return

#
# * ================================================================
# * Grid Items Clearfix
# *
# * This function adds clearfixes after the grid items to fix issues with different grid items heights
# *
# 
@add_clear_items_to_fix_grid_items_different_heights_issue = ->

  # if there are grid items
  if $("#main-content .grid .grid-item").length > 0
    list_grid = $("#main-content .grid")

    # 2 columns
    if list_grid.hasClass("clearfix-for-2cols")

      # add clearfixes after every 2 items (for 2 cols grid)
      list_grid.find(".grid-item:nth-of-type(2n+2)").after "<article class=\"clearfix\"></article>"
      false

      # 3 columns
    else if list_grid.hasClass("clearfix-for-3cols")

      # add clearfixes after every 2 items (for 2 cols grid)
      list_grid.find(".grid-item:nth-of-type(3n+3)").after "<article class=\"clearfix\"></article>"
      false

# end: if there are grid items   

#
# * ================================================================
# * Effect Fade Out Inactive Grid Items
# *
# * On hover of a grid item, the other grid items are faded out.
# * It is applied to .project-grid containers with class ".effect-fade-inactive"
# *
# 
@effect_fade_out_inactive_grid_items = ->

  # if there are project-grid sections with effect activated
  if $("#main-content .projects-grid.effect-fade-inactive").length > 0

    # for each projects grid with effect
    $("#main-content .projects-grid.effect-fade-inactive").each ->
      this_project_grid = $(this)

      # on hover of each grid-item content
      this_project_grid.find(".grid-item .item-content").hover (->

        # on mouse over
        this_item_content = $(this)
        this_item_content.css opacity: 1 # fade in this item
        this_project_grid.find(".grid-item .item-content").not(this_item_content).css opacity: 0.3 # fade out other items
        return
      ), ->

        # on mouse out
        this_item_content = $(this)
        this_item_content.css opacity: 0.3 # fade out this
        return


      # end: on hover of each grid-item content            

      # ensure that on mouse out of grid, all its items are not faded
      this_project_grid.hover (->
      ), ->
        setTimeout (->
          this_project_grid.find(".grid-item .item-content").css opacity: 1
          return
        ), 200
        return

      return

  return

# end: for each projects grid with effect

# end: if there are project-grid sections with effect activated  

#
# * ================================================================
# * Set height of parent content wrappers
# *
# * This function looks for any elements (in main content) with .max-height set as class, looks for the parent .content-wrapper and sets its percentage height to fill the page
# * - if a data-height-percent attribute is set to the element with .max-height class, that defined percantage height is used
# 
@set_height_of_parent_content_wrappers = ->
  elements_with_max_height_class = $("#main-content .max-height")

  # for each element
  elements_with_max_height_class.each ->
    parent_content_wrapper = $(this).parents(".content-wrapper")

    # if parent .content-wrapper is found
    if parent_content_wrapper.length > 0
      parent_content_wrapper.parents(".section-wrapper").addClass "modified-height"

      # if data-height-percent attribute is set for the element with class ".max-height", then use that defined percentage height
      defined_height_percentage = $(this).attr("data-height-percent")
      if defined_height_percentage isnt `undefined` and defined_height_percentage isnt "" and not isNaN(defined_height_percentage)
        parent_content_wrapper.css height: defined_height_percentage + "%"

        # else, if no defined percentage height is set, set a default 80% height to the content-wrapper
      else
        parent_content_wrapper.css height: "80%"
    return

  return

# end: if parent .content-wrapper is found

# end: for each element

#
# * ================================================================
# * Set equal height to all carousel slides on small displays
# *
# * In order to avoid adjusting height on slide change on small displays, find the largest height among all slides in the carousel, and set all slides' height to that particular height
# *
# 
@set_equal_height_to_all_carousel_slides_on_small_displays = ->
  carousels = $("#main-content .carousel")

  # for each carousel
  carousels.each ->
    visible_set_percentage_height = (if ($(this).attr("data-height-percent") isnt `undefined` and $(this).attr("data-height-percent") isnt "" and not isNaN($(this).attr("data-height-percent"))) then $(this).attr("data-height-percent") else 80) # the carousel height (percentage) in proportion of the screen height (default is 80)
    visible_set_height = (visible_set_percentage_height / 100) * viewport().height
    carousel_slides = $(this).find(".item .carousel-text-content")
    $(this).find(".item:not(.active)").css # temporary fix to get the hidden slides' height
      opacity: "0"
      position: "absolute"
      display: "block"

    carousel_slides.css height: "auto" # reset previously set height before getting actual height
    all_slides_height = []

    # for each slide, get their height and store them in an array
    carousel_slides.each ->
      all_slides_height.push $(this).height()
      return

    largest_slide_height = Math.max.apply(Math, all_slides_height) + 40 # get largest height among all slides (add 40px to make sure no content is hidden)
    $(this).find(".item:not(.active)").attr "style", "" # reset the temporary fix to get the hidden slides' height

    # if on small displays or small heights (slide height larger than visible height)
    if viewport().width <= window.sm_screen_max or largest_slide_height >= visible_set_height
      $(this).parents(".section-wrapper").addClass "modified-height"
      carousel_slides.height largest_slide_height # apply the largest height to all slides

      # end: if on small displays

      # on larger displays
    else
      $(this).parents(".section-wrapper").removeClass "modified-height"
      $(this).removeClass("slides-height-modified").find(".item .carousel-text-content").css height: "100%"
    return

  return

# end: for each carousel

#
# * ================================================================
# * Populate and Open Modal (Popup)
# *
# * @param event - NEEDED to stop default link actions (since link will be used to open popup)
# * @param modal_content_id - the id of the container with the content which will be populated in the modal body
# * @param section_in_modal - selector - optional - if set, when modal is shown, the popup will scroll to this section
# 
@populate_and_open_modal = (event, modal_content_id, section_in_modal) ->
  modal = $("#common-modal.modal")
  modal_body = modal.find(".modal-body")
  modal_content_container_to_populate = $("#" + modal_content_id)

  # if modal and content container exists
  if modal_body.length > 0 and modal_content_container_to_populate.length > 0

    # fade out main content of page (so modal content is readable)
    $("#outer-container").fadeTo "fast", 0.2

    # get initial vertical offset so that when modal is opened/closed, it ensures that page doesn't scroll to top (bugfix)
    initial_vertical_scroll_offset = $(document).scrollTop()
    modal_content = modal_content_container_to_populate.html() # get content to populate in modal
    modal_body.empty().html modal_content # first empty the modal body and then populate it with new content

    # open modal (popup)
    modal.modal()

    # when modal is shown, position it in the middle of the page 
    modal.on "shown.bs.modal", (e) ->
      position_modal_at_centre()

      # if set, scroll to a given section inside the popup
      if section_in_modal isnt `undefined` and $("#common-modal.modal").find(section_in_modal).length > 0
        section_vertical_offset = $("#common-modal.modal").find(section_in_modal).offset().top
        $("#common-modal.modal").stop().animate
          scrollTop: section_vertical_offset
        , 800, "easeInOutCubic"
      return


    # when modal starts to close, fade in main content 
    modal.on "hide.bs.modal", (e) ->
      $("#outer-container").fadeTo "fast", 1
      return


    # when modal is hidden, empty modal body 
    modal.on "hidden.bs.modal", (e) ->
      modal_body.empty() # empty modal body
      return


  # end: if modal and content container exists
  (if event.preventDefault then event.preventDefault() else event.returnValue = false)
  false

#
# * ================================================================
# * Position modal at the centre/middle of the page (if visible)
# *
# 
@position_modal_at_centre = ->
  modal_outer_container = $(".modal")

  # if modal exists and is visible
  if modal_outer_container.length > 0 and modal_outer_container.is(":visible")
    modal_content_container = modal_outer_container.find(".modal-dialog")
    modal_width = modal_content_container.width()
    modal_height = modal_content_container.height()
    check_if_modal_content_fits_inside_the_page = (if ((modal_height + 70) < viewport().height) then true else false)

    # for large viewports only, centre/middle align
    # align in the middle ONLY if the modal content height is less than the window height
    if viewport().width > window.sm_screen_max and check_if_modal_content_fits_inside_the_page is true
      top_margin_to_align_modal_at_middle_of_page = (viewport().height - modal_height) / 2
      modal_content_container.css
        "margin-top": top_margin_to_align_modal_at_middle_of_page + "px"
        "margin-bottom": "20px"


      # end: for large viewports

      # for smaller viewports
    else
      modal_content_container.removeAttr "style"
  return

# end: for small viewports

#
# * ================================================================
# * Go To Top Icon Visibility
# *
# * - icon is hidden at the top of the page, shown when scrolling further down
# 
@go_to_top_visibility = ->
  go_to_top_icon = $("#go-to-top")

  # if icon exists
  if go_to_top_icon.length > 0
    scroll_from_top = $(document).scrollTop()

    # if at the top section of the page, hide icon
    if scroll_from_top < viewport().height
      go_to_top_icon.removeClass "active"

      # if further down the page, show icon
    else
      go_to_top_icon.addClass "active"
  return

#
# * ================================================================
# * Scroll to Top of the Page
# *
# * - scrolls to top of the page (#outer-container)
# 
@scroll_to_top = ->
  $("html, body").stop().animate
    scrollTop: 0
  , 1500, "easeInOutCubic", ->
    $("#go-to-top").removeClass "active" # deactive scroll to top icin
    return

  return

#
# * ================================================================
# * Load Images
# *
# * - <img> elements with a particular class and "data-img-src" attribute are loaded
# *
# * @param images_objects_selector_class - the selector class of the <img> objects which will be loaded
# * @param remove_selector_class_after_image_loaded - if set to true, the selector class used to load images will be removed after the image is loaded (for css purposes)
# * @param vertical_layout_positioning_check - if set to true, fire sections_content_vertical_position() function correct vertical positioning of sections
# 
@load_images = (images_objects_selector_class, remove_selector_class_after_image_loaded, vertical_layout_positioning_check) ->

  # if images exist
  images_objects = $("." + images_objects_selector_class)
  if images_objects.length > 0

    # prepare image sources
    images = new Array()
    images_objects.each ->
      image_src = $(this).attr("data-img-src")
      if image_src isnt `undefined` and image_src isnt ""
        image_object_data = new Array()
        image_object_data["img_object"] = $(this) # image as an object (to use after load)
        image_object_data["img_src"] = image_src
        images.push image_object_data # add to images array
      return


    # load images
    new_image_object = new Image()
    count_images_to_load = images.length
    i = 0
    while i < count_images_to_load
      new_image_object.src = images[i]["img_src"]
      images[i]["img_object"].attr "src", images[i]["img_src"]

      # if enabled, remove selector class after the image is loaded
      images[i]["img_object"].removeClass images_objects_selector_class  if remove_selector_class_after_image_loaded is true

      # if enabled, correct vertical positioning of sections (after last image) (only when not viewing on mobile viewport)
      sections_content_vertical_position()  if vertical_layout_positioning_check is true and i is count_images_to_load - 1 and (not jQuery.browser.mobile or viewport().width > window.xs_screen_max)
      i++
  return

# end: load images

# end: if images exist

#
# * ================================================================
# * Form validation and submit actions
# *
# * @param form_object - objects -  if set, validate and submit this form only. Otherwise search for all forms with class .validate-form
# 
@validate_and_submit_forms = (form_object) ->
  forms = (if (form_object isnt `undefined` and form_object.length > 0) then form_object else $("form.validate-form"))

  # for each form 
  forms.each ->
    this_form = $(this)

    # -------------- onChange of each form field with validation enabled (with class .validate) --------------
    this_form.find(".validate-field").each ->
      $(this).change ->

        # first empty any error containers
        $(this).siblings(".alert").fadeOut "fast", ->
          $(this).remove()
          return


        # value is not empty, validate it
        unless $(this).val().trim() is ""
          validation_message = validate_fields(this_form, $(this))
          if validation_message.length > 0

            # if there are errors (not successfull)
            if validation_message[0]["message"] isnt `undefined` and validation_message[0]["message"] isnt "" and validation_message[0]["message"] isnt "success"

              # create error field
              error_field_html = "<div class=\"alert\">" + validation_message[0]["message"] + "</div>"
              $(this).after error_field_html
              $(this).siblings(".alert").fadeIn "fast"
        return

      return


    # end: if there are errors

    # end: if value is not empty

    # -------------- end: onChange of each form field --------------

    # -------------- on Submit of form --------------
    this_form.submit (event) ->
      (if event.preventDefault then event.preventDefault() else event.returnValue = false) # stop default action (will be handled via AJAX below)

      # show form loader
      $(this).find(".form-loader").fadeIn "fast"
      form_action = $(this).attr("action")

      # if action is not set (URL to mail.php), stop form action
      return false  if form_action is `undefined` and form_action is ""

      # clear all errors
      $(this).find(".alert").fadeOut "fast", ->
        $(this).remove()
        return

      $(this).find(".form-general-error-container").fadeOut "fast", ->
        $(this).empty()
        return

      errors_found = false

      # for each field with validation enabled (with class .validate)
      $(this).find(".validate-field").each ->
        validation_message = validate_fields(this_form, $(this))
        if validation_message.length > 0

          # if there are errors (not successfull)
          if validation_message[0]["message"] isnt `undefined` and validation_message[0]["message"] isnt "" and validation_message[0]["message"] isnt "success"

            # create error field
            error_field_html = "<div class=\"alert\">" + validation_message[0]["message"] + "</div>"
            $(this).after error_field_html
            $(this).siblings(".alert").fadeIn "fast"
            errors_found = true
        return


      # end: if there are errors

      # end: for each field

      # if errors were found, stop form from being submitted
      if errors_found is true

        # hide loader
        $(this).find(".form-loader").fadeOut "fast"
        return false

      # submit form
      $.ajax
        type: "POST"
        url: form_action
        data: $(this).serialize()
        dataType: "html"
        success: (data) ->

          # if form submission was processed (successfully or not)

          # hide loader
          this_form.find(".form-loader").fadeOut "fast"
          submission_successful = (if (data is "Form submitted successfully.") then true else false)

          # prepare message to show after form processed
          message_field_html = "<div class=\"alert "
          message_field_html += (if (submission_successful is true) then "success" else "error")
          message_field_html += "\">" + data + "</div>"

          # show message
          this_form.find(".form-general-error-container").html(message_field_html).fadeIn "fast", ->

            # if submission was successful, hide message after some time
            $(this).delay(10000).fadeOut "fast", ->
              $(this).html ""
              return

            return


          # if form submitted successfully, empty fields
          this_form.find(".form-control").val ""  if submission_successful is true
          return

        error: (data) ->

          # if form submission wasn't processed

          # hide loader
          this_form.find(".form-loader").fadeOut "fast"

          # show error message
          error_field_html = "<div class=\"alert\">An error occured. Please try again later.</div>"
          this_form.find(".form-general-error-container").html(error_field_html).fadeIn "fast"
          return

      return

    return

  return

# end: submit form           

# -------------- end: on Submit of form --------------

# end: for each form

#
# * ================================================================
# * Form validation - separate fields
# *
# * @param form_object - object - required - the form in which the fields relate to
# * @param single_field - object - if set, the function will validate only that particular field. Otherwise the function will validate all the fields with class .validate
# 
@validate_fields = (form_object, single_field) ->

  # if form exists
  if form_object isnt `undefined` and form_object.length > 0
    form_fields_to_validate = (if (single_field isnt `undefined` and single_field.length > 0) then single_field else form_object.find(".validate")) # if single field is set, the function will validate only that particular field. Otherwise the function will validate all the fields with class .validate
    validation_messages = new Array()

    # for each field to validate
    form_fields_to_validate.each ->
      validation_type = $(this).attr("data-validation-type")
      field_required = $(this).hasClass("required")
      field_value = $(this).val().trim()
      single_field_error_details = new Array() # will contain this field and its error
      single_field_error_details["field_object"] = $(this)
      single_field_error_details["message"] = "success" # default is success. If the above tests fail, replace message with error

      # if field is required and value is empty
      single_field_error_details["message"] = "This field is required"  if field_required is true and (field_value is "" or field_value is null or field_value is `undefined`)

      # string validation
      if validation_type is "string" and (field_value isnt "" and field_value isnt null and field_value isnt `undefined`)
        single_field_error_details["message"] = "Invalid characters found."  unless field_value.match(/^[a-z0-9 .\-]+$/i)?

        # email validation
      else if validation_type is "email" and (field_value isnt "" and field_value isnt null and field_value isnt `undefined`)
        single_field_error_details["message"] = "Please enter a valid email address."  unless field_value.match(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)?

        # phone validation
      else single_field_error_details["message"] = "Invalid characters found."  unless field_value.match(/^\(?\+?[\d\(\-\s\)]+$/)?  if validation_type is "phone" and (field_value isnt "" and field_value isnt null and field_value isnt `undefined`)
      validation_messages.push single_field_error_details # if none of the above fail, return validation successfull
      return


    # end: for each field to validate
    validation_messages

# end: if form exists

#
# * ================================================================
# * Fixed Background image dimensions on mobile
# *
# * in order to avoid stretching issues when scrolling on mobile devices, set background image to a fixed size (depending on window height)
# 
@fixed_bg_image_dimensions_on_mobile = ->
  desktop_background_container = $("#outer-background-container")

  # if desktop bg container exists
  if desktop_background_container.length > 0
    default_background_image = desktop_background_container.attr("data-default-background-img")

    # if default bg image is set
    if default_background_image isnt `undefined` and default_background_image isnt ""

      # if on mobile device
      unless jQuery.browser.mobile

        # get the mobile window dimensions plus extra 10% (to make sure that the background fills all the screen)
        window_height_plus_extra = viewport().height + (0.1 * viewport().height)
        window_width_plus_extra = viewport().width + (0.1 * viewport().width)
        new_image_object = new Image()
        new_image_object.src = default_background_image

        # set background to body
        $("body").css
          "background-image": "url(" + default_background_image + ")"
          "background-position": "top center"
          "background-repeat": "no-repeat"
          "background-attachment": "fixed"
          "background-size": "auto " + window_height_plus_extra + "px, cover"


        # hide other set backgrounds
        desktop_background_container.css opacity: "0"

        # if NOT on mobile device
      else

        # remove image bg to body
        $("body").css
          "background-image": ""
          "background-position": ""
          "background-repeat": ""
          "background-size": ""
          "background-attachment": ""
          background: "#000"


        # show other set backgrounds
        desktop_background_container.css opacity: "1"
  return

# end: if default bg image is set

# end: if desktop bg container exists

#
# * ================================================================
# * IE9: Contact Form Fields Placeholders
# *
# * Since IE9 or less browsers do not support "placeholders" for form input fields, set replace "placeholder" value inside the field value.
# 
@contact_form_IE9_placeholder_fix = ->
  forms = $("form")

  # for each form 
  forms.each ->
    this_form = $(this)

    # for each input field
    $(this).find(".form-control").each ->
      field_placeholder = $(this).attr("placeholder")

      # if a placeholder is set
      if field_placeholder isnt `undefined` and field_placeholder isnt ""

        # set default value to input field
        $(this).val field_placeholder

        # set an onfocus event to clear input field
        $(this).focus ->
          $(this).val ""  if $(this).val() is field_placeholder
          return


        # set an onblur event to insert placeholder if field is empty
        $(this).blur ->
          $(this).val field_placeholder  if $(this).val() is ""
          return

      return

    return

  return
window.xs_screen_max = 768
window.sm_screen_max = 992

# end: for each input field