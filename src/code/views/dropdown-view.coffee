{div, i, span, ul, li} = React.DOM

DropdownItem = React.createFactory React.createClass

  displayName: 'DropdownItem'

  clicked: ->
    @props.select @props.item

  render: ->
    className = "menuItem #{if @props.isActionMenu and not @props.item.action then 'disabled' else ''}"
    name = @props.item.name or @props.item
    (li {className: className, onClick: @clicked }, name)

DropDown = React.createClass

  displayName: 'Dropdown'

  getDefaultProps: ->
    isActionMenu: true              # Whether each item contains its own action
    onSelect: (item) ->             # If not, @props.onSelect is called
      log.info "Selected #{item}"

  getInitialState: ->
    showingMenu: false
    timeout: null

  blur: ->
    @unblur()
    timeout = setTimeout ( => @setState {showingMenu: false} ), 500
    @setState {timeout: timeout}

  unblur: ->
    if @state.timeout
      clearTimeout(@state.timeout)
    @setState {timeout: null}

  select: (item) ->
    nextState = (not @state.showingMenu)
    @setState {showingMenu: nextState}
    return unless item
    if @props.isActionMenu and item.action
      item.action()
    else
      @props.onSelect item

  render: ->
    menuClass = if @state.showingMenu then 'menu-showing' else 'menu-hidden'
    select = (item) =>
      ( => @select(item))
    (div {className: 'menu'},
      (span {className: 'menu-anchor', onClick: => @select(null)},
        @props.anchor
        (i {className: 'icon-codap-arrow-expand'})
      )
      if @props.items?.length > 0
        (div {className: menuClass, onMouseLeave: @blur, onMouseEnter: @unblur},
          (ul {},
            (DropdownItem {key: item.name or item, item: item, select: @select, isActionMenu: @props.isActionMenu}) for item in @props.items
          )
        )
    )

module.exports = DropDown