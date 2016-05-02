Handlebars.registerHelper "isActive", (template) ->
  currentRoute = Router.current().route.getName()
  if currentRoute and template is currentRoute then return "active"
  else return ""
Handlebars.registerHelper "session",(input) ->
  Session.get(input)
Handlebars.registerHelper "__",(input, value) ->
  language= TAPi18n.getLanguage()
  if language && input[value + '_' + language] then input[value + '_' + language] else input[value + '_fr']
Handlebars.registerHelper "view_boolean",(input) ->
  if input
    return "Yes"
  else
    return "No"
Handlebars.registerHelper "trimString",(input, size) ->
  input.substring(0, size) + "..."
Handlebars.registerHelper "date", (date) ->
  moment(date).format("DD/MM/YYYY")

Handlebars.registerHelper "isPublished",(published) ->
  if published
    return "Published"
  else
    return "Not published"
