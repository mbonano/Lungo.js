###
Initialize the <articles> layout of a certain <section>

@namespace Lungo
@class Aside

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###

Lungo.Aside = do(lng = Lungo) ->
  C = lng.Constants

  ###
  Active aside for a determinate section
  @method active
  @param  {object} Section element
  ###
  active = (section) ->
    aside_id = section.data("aside")
    current_aside = lng.Element.Cache.aside

    # Deactive
    if current_aside and aside_id isnt current_aside?.attr(C.ATTRIBUTE.ID)
      if lng.DEVICE is C.DEVICE.PHONE
        current_aside.removeClass(C.CLASS.SHOW).removeClass C.CLASS.ACTIVE
      else
        current_aside.addClass(C.CLASS.HIDE)
        setTimeout (-> current_aside.removeClass(C.CLASS.SHOW).removeClass(C.CLASS.ACTIVE).removeClass(C.CLASS.HIDE)), C.TRANSITION.DURATION
      lng.Element.Cache.aside = null

    # Active
    if aside_id
      lng.Element.Cache.aside = lng.dom(C.ELEMENT.ASIDE + "#" + aside_id)
      lng.Element.Cache.aside.addClass C.CLASS.ACTIVE
      lng.Aside.show aside_id  unless lng.DEVICE is C.DEVICE.PHONE
    lng.Element.Cache.aside


  ###
  Toggle an aside element
  @method toggle
  @param  {string} Aside id
  ###
  toggle = ->
    if lng.Element.Cache.aside
      is_visible = lng.Element.Cache.aside.hasClass(C.CLASS.SHOW)
      if is_visible then lng.Aside.hide() else lng.Aside.show()


  ###
  Display an aside element with a particular <section>
  @method show
  ###
  show = ->
    if lng.Element.Cache.aside?
      setTimeout (-> lng.Element.Cache.aside.addClass C.CLASS.SHOW), C.TRANSITION.DURATION
      if lng.DEVICE is C.DEVICE.PHONE
        lng.Element.Cache.aside.addClass C.CLASS.SHOW
        lng.Element.Cache.section.addClass(_asideStylesheet()).addClass(C.CLASS.ASIDE)


  ###
  Hide an aside element with a particular section
  @method hide
  ###
  hide = ->
    if lng.Element.Cache.aside? and lng.DEVICE is C.DEVICE.PHONE
      lng.Element.Cache.section.removeClass(C.CLASS.ASIDE)
      setTimeout (-> lng.Element.Cache.aside.removeClass C.CLASS.SHOW), C.TRANSITION.DURATION

  ###
  @todo
  @method draggable
  ###
  draggable = ->
    MIN_XDIFF = parseInt(document.body.getBoundingClientRect().width / 3, 10)
    MIN_XDIFF = 128
    lng.dom(C.QUERY.HREF_ASIDE).each ->
      started = false
      el = lng.dom(this)
      section = el.closest("section")
      aside = lng.dom("aside#" + el.data("aside"))
      section.swiping (gesture) ->
        unless section.hasClass("aside")
          xdiff = gesture.currentTouch.x - gesture.iniTouch.x
          ydiff = Math.abs(gesture.currentTouch.y - gesture.iniTouch.y)
          started = (if started then true else xdiff > 3 * ydiff and xdiff < 50)
          if started
            xdiff = (if xdiff > 256 then 256 else (if xdiff < 0 then 0 else xdiff))
            aside.addClass C.CLASS.SHOW
            section.vendor "transform", "translateX(#{xdiff}px)"
            section.vendor "transition-duration", "0s"
          else
            section.attr "style", ""

      section.swipe (gesture) ->
        diff = gesture.currentTouch.x - gesture.iniTouch.x
        ydiff = Math.abs(gesture.currentTouch.y - gesture.iniTouch.y)
        section.attr "style", ""
        if diff > MIN_XDIFF and started
          show aside
        else
          hide aside
        started = false


  ###
  Private methods
  ###
  _asideStylesheet = ->
    if lng.Element.Cache.aside?.hasClass(C.CLASS.RIGHT) then "#{C.CLASS.RIGHT}" else "  "

  active: active
  toggle: toggle
  show: show
  hide: hide
  draggable: draggable
