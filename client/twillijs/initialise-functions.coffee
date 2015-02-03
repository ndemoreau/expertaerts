# 
# * ===============================================================
# * ON DOCUMENT READY
# * ===============================================================
# 
@initialise_document_ready_functions = ->

  # useful variables (used in other functions)
  section_wrappers = get_all_section_wrappers_in_page() # get all the section wrappers in the page
  amount_of_pixels_as_buffer_between_sections = 0.25 * ($(window).height()) # used in update_active_sections_on_scroll();

  # set visible section to active
  update_active_sections_on_scroll section_wrappers, amount_of_pixels_as_buffer_between_sections

  # Sections Content Vertical Position
  sections_content_vertical_position()

  # Initialise General Links Click Events
  initialise_general_links_click_events()

  # Initialise Main Menu Links Click Events
  initialise_main_menu_click_events()

  # initialise hover effect - fade out inactive project grid items
  effect_fade_out_inactive_grid_items()

  # modify heights of .content-wrapper parents of elements with .max-height class set
  set_height_of_parent_content_wrappers()

  # initialise carousel
#  $("#features-carousel").carousel interval: 6000

  # initialise form validation and submit functions 
  validate_and_submit_forms()

  # ------ Owl Carousel ------
  # Initialise Owl Carousels with common class .popup-image-gallery when popup is opened
  # - you can use the same functions below if you want to add a new Owl Carousel with different parameters (in this case call the carousel's unique ID instead)
  # - documentation for Owl Carousel: http://www.owlgraphic.com/owlcarousel/#how-to
  $("#common-modal").on "shown.bs.modal", ->
    if $("#common-modal .popup-image-gallery").length > 0

      # custom parameters for carousel (see Owl Carousel documentation for more info)
      $("#common-modal .popup-image-gallery").owlCarousel
        autoPlay: 5000
        stopOnHover: true
        navigation: false
        paginationSpeed: 1000
        goToFirstSpeed: 2000
        singleItem: true
        lazyLoad: true
        autoHeight: true
        transitionStyle: "fade"
        afterLazyLoad: ->
          position_modal_at_centre() # position popup at the centre of the page
          return

    return


  # Destroy Owl Carousel when modal/popup is closed (it will be re-initialised again when popup is re-opened)
  $("#common-modal").on "hide.bs.modal", ->
    if $("#common-modal .popup-image-gallery").length > 0
      carousel_initialised_data = $("#common-modal .popup-image-gallery").data("owlCarousel")
      carousel_initialised_data.destroy()
    return


  # ------ END: Owl Carousel ------    

  # initialise WOW.js intro animations
  new WOW().init()

  # 
  #     * ----------------------------------------------------------
  #     * ON WINDOW RESIZE
  #     * ----------------------------------------------------------
  #     
  $(window).resize ->

    # update variables already set in document.ready above
    amount_of_pixels_as_buffer_between_sections = 0.25 * ($(window).height()) # used in update_active_sections_on_scroll();

    # Sections Content Vertical Position
    sections_content_vertical_position()  unless jQuery.browser.mobile

    # Main Menu Visiblity on Window Resize
    main_menu_visiblity_on_resize()

    # Set equal height to all carousel slides on small displays
    set_equal_height_to_all_carousel_slides_on_small_displays()

    # Position modal at the centre/middle of the page (if visible)
    position_modal_at_centre()
    return


  # end: on window resize

  # 
  #     * ----------------------------------------------------------
  #     * ON WINDOW SCROLL
  #     * ----------------------------------------------------------
  #     
  $(window).scroll ->

    # Update Active Sections on Scroll (do not use function when menu link was clicked - as this already has a link to the scroll function) -- (do not fire function on mobile viewports)
    update_active_sections_on_scroll section_wrappers, amount_of_pixels_as_buffer_between_sections  if not $("#main-content").hasClass("same_page_link_in_action")

    # update scroll to top icon visibility
    go_to_top_visibility()
    return

  return

# end: on window scroll

# end: initialise_document_ready_functions()

# 
# * ===============================================================
# * ON WINDOW LOAD (after all elements were loaded)
# * ===============================================================
# 
@initialise_window_load_functions = ->

  # update variables already set in document.ready above
  amount_of_pixels_as_buffer_between_sections = 0.25 * ($(window).height()) # used in update_active_sections_on_scroll();

  # Set equal height to all carousel slides on small displays
  set_equal_height_to_all_carousel_slides_on_small_displays()

  # Sections Content Vertical Position (when not viewing on a mobile)
  sections_content_vertical_position()  if viewport().width > window.xs_screen_max

  # preload all section background images after all elements were loaded (when not viewing on a mobile)
  preload_section_backgrounds()  if viewport().width > window.xs_screen_max

  # Grid Items Clearfix
  add_clear_items_to_fix_grid_items_different_heights_issue()  if viewport().width > window.xs_screen_max

  # Load images after other elements are loaded
  load_images "lazy", true, true
  return

# end: initialise_window_load_functions()
$(window).load ->
  initialise_window_load_functions()
  return
