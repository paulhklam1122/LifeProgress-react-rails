@Lift = React.createClass
  getInitialState: ->
    edit: false
    one_rep_max: @props.lift_name
    is_metric: @props.lift.is_metric
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/lifts/#{ @props.lift.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteLift @props.lift
  handleEdit: (e) ->
    e.preventDefault()
    data =
      date: ReactDOM.findDOMNode(@refs.date).value
      lift_name: ReactDOM.findDOMNode(@ref.lift_name).value
      weight_lifted: ReactDOM.findDOMNode(@ref.weight_lifted).value
      is_metric: ReactDOM.findDOMNode(@ref.is_metric).value
      reps_performed: ReactDOM.findDOMNode(@ref.reps_performed).value
      one_rep_max: ReactDOM.findDOMNode(@ref.one_rep_max).value
    $.ajax
      method: 'PUT'
      url: "/lifts/#{@props.lift.id}"
      dataType: 'JSON'
      data:
        lift: data
      success: (data) ->
        @setState edit: false
        @props.handleEditLift @props.lift, data
  reCalculateOneRm: ->
    @setState one_rep_max: @getOneRm(ReactDOM.findDOMNode(@refs.weight_lifted.value), ReactDOM.findDOMNode(@refs.reps_performed.value))
  getOneRm: (weight, reps) ->
    if weight and reps > 0 and reps < 11
      weight / coefficients[reps]
    else
      0
  toggleUnit: (e) ->
    e.preventDefault()
    @setState is_metric: !@state.is_metric
  liftRow: ->
    React.DOM.tr null,
      React.DOM.td null, @props.lift.date
      React.DOM.td null, @props.lift.lift_name
      React.DOM.td null, @props.lift.weight_lifted
      React.DOM.td null, @props.lift.is_metric.toString()
      React.DOM.td null, @props.lift.reps_performed
      React.DOM.td null, @props.lift.one_rep_max
      React.DOM.td null,
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handleToggle
          'Edit'
        React.DOM.button
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'
  liftForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'date'
          defaultValue: @props.lift.date
          ref: 'date'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.lift.lift_name
          ref: 'lift_name'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'number'
          defaultValue: @props.lift.weight_lifted
          ref: 'weight_lifted'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'number'
          min: '1'
          max: '10'
          defaultValue: @props.lift.reps_performed
          ref: 'reps_performed'
          onChange: @reCalculateOneRm
      React.DOM.td null,
        @state.one_rep_max
      React.DOM.td null,
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @toggleUnit
          'Metric = ' + @state.is_metric.toString()
      React.DOM.td null,
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @handleEdit
          'Update'
        React.DOM.button
          className: 'btn btn-danger'
          onClick: @handleToggle
          'Cancel'
  render: ->
    if @state.edit
      @liftForm()
    else
      @liftRow()
