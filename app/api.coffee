queries = require './queries.coffee'

module.exports = (app, passport) ->

	app.get '/api/getmembers', (req, res) ->
		res.send 'getmembers'
	app.get '/api/getmember', (req, res) ->
		res.send 'getmember'
	app.get '/api/getchallenges', (req, res) ->
		res.send 'getchallenges'
	app.get '/api/getlastchallenges', (req, res) ->
		res.send 'getlastchallenges'

