@serializeForm = (f) ->
  form={}
  $.each f.serializeArray(), ->
    form[@name] = @value
  form