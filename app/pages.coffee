jade = require 'jade'
queries = require './queries.coffee'
fs = require 'fs'

home = jade.compileFile "views/index.jade"
about = jade.compileFile "views/about.jade"
lessons = jade.compileFile "views/index.jade"
challenges = jade.compileFile "views/index.jade"
signup = jade.compileFile "views/signup.jade"
login = jade.compileFile "views/login.jade"

publicPageList = () -> JSON.parse fs.readFileSync(__dirname + "/../routes/publicpagelist.json")

module.exports = (app, passport) ->

	app.get '/', (req, res) ->
		homePageList = publicPageList()
		homePageList["left"][0]["current"] = true
		homeargs = {"pagelist": homePageList}
		queries.getLessons (lessons) ->
			args = homeargs
			args["lessons"] = lessons
			res.send home args

	app.get '/about', (req, res) ->
		aboutPageList = publicPageList()
		aboutPageList["left"][1]["current"] = true
		aboutargs = {"pagelist": aboutPageList}
		res.send about(aboutargs)

	app.get '/lessons', (req, res) ->
		res.send lessons()

	app.get '/challenges', (req, res) ->
		res.send challenges()

	app.get '/signup', (req, res) ->

		res.send signup()

	app.post '/signup', passport.authenticate 'local-signup', {
		successRedirect: '/'
		failureRedirect: '/signup'
		failureFlash: true
	}


	app.get '/login', (req, res) ->
		res.send login()

	app.post '/login', (req, res) ->


	app.get 'logout', (req, res) ->
		req.logout()
		res.redirect '/'

isLoggedIn = (req, res, next) ->
		if req.isAuthenticated()
			next()
		else
			res.redirect '/'