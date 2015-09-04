#module.exports = (app, passport) ->
#
#
#
#  # visit pages
#  app.get '/', pages.home
#  app.get '/index(.html)?', pages.home
#  app.get '/about(.html)?', pages.about
#  app.get '/lessons(.html)?', pages.lessons
#  app.get '/challenges(.html)?', pages.challenges
#  app.get '/signup(.html)?', pages.signup
#  app.get '/signin(.html)?', pages.signin
#
#  #api
#  app.get '/api/getmembers', (req, res) ->
#    api.getMembers (body) -> res.send body
#  app.get '/api/getmember', (req, res) ->
#    api.getMember req.query.handle, (body) -> res.send body
#  app.get '/api/getchallenges', (req, res) ->
#    api.getChallenges (body) -> res.send body
#  app.get '/api/getlastchallenges', (req, res) ->
#    api.getLastXChallenges req.query.count, (body) -> res.send body
