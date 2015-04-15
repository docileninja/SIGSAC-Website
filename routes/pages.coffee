jade = require 'jade'
api = require __dirname + "/api.coffee"
fs = require 'fs'

home = jade.compileFile "views/index.jade"
about = jade.compileFile "views/about.jade"
lessons = jade.compileFile "views/index.jade"
challenges = jade.compileFile "views/index.jade"
signup = jade.compileFile "views/index.jade"
signin = jade.compileFile "views/signin.jade"

publicPageList = JSON.parse fs.readFileSync(__dirname + "/publicpagelist.json")

exports.home = (req, res) ->
	homePageList = publicPageList
	homePageList["left"][0]["current"] = true
	homeargs = {"lessons": api.getLessons(), "pagelist": homePageList}
	res.send(home(homeargs))

exports.about = (req, res) ->
	aboutPageList = publicPageList
	aboutPageList["left"][1]["current"] = true
	aboutargs = {"pagelist": aboutPageList}
	res.send(about(aboutargs))

exports.lessons = (req, res) ->
	res.send(lessons())

exports.challenges = (req, res) ->
	res.send(challenges())

exports.signup = (req, res) ->
	res.send(signup())

exports.signin = (req, res) ->
	signinargs = {"stylesheets": ["css/signin.css"]}
	res.send(signin(signinargs))