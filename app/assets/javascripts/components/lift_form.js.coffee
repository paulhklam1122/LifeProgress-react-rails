coefficients = {
  1: 1, 2: .943, 3: .906, 4: .881, 5: .851, 6: .831, 7: .807, 8: .786, 9: .765, 10: .744
}
@LiftForm = React.createClass
  getInitialState: ->
    date: ''
    lift_name: ''
    is_metric: false
    weight_lifted: ''
    reps_performed: ''
    one_rep_max: ''
  calculateOneRm: ->
    if @state.weight_lifted and @state.reps_performed
      @state.one_rep_max = @state.weight_lifted / coefficients[@state.reps_performed]
    else
      0
  handleValueChange: (e) ->
    valueName = e.target.name
    @setState "#{ valueName }": e.target.value
  toggleUnit: (e) ->
    e.preventDefault()
    @setState is_metric: !@state.is_metric
  valid: ->
    @state.date && @state.lift_name && @state.weight_lifted && @state.reps_performed && @state.one_rep_max
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { lift: @state }, (data) =>
      @props.handleNewLift data
      @setState @getInitialState()
    , 'JSON'
  render: ->
    React.DOM.form
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          'Date'
        React.DOM.input
          type: 'date'
          className: 'form-control'
          placeholder: 'date'
          name: 'date'
          value: @state.date
          onChange: @handleValueChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'lift_name'
          name: 'lift_name'
          value: @state.lift_name
          onChange: @handleValueChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'weight_lifted'
          name: 'weight_lifted'
          value: @state.weight_lifted
          onChange: @handleValueChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          min: 1
          max: 10
          className: 'form-control'
          placeholder: 'reps_performed'
          name: 'reps_performed'
          value: @state.reps_performed
          onChange: @handleValueChange
      React.DOM.div
        className: 'form-group'
        React.DOM.button
          className: 'btn btn-primary'
          onClick: @toggleUnit
          'Metric = ' + @state.is_metric.toString()
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Create Lift'
      React.createElement OneRepMaxBox, one_rep_max: @calculateOneRm()
