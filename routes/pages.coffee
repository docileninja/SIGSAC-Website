jade = require 'jade'

home = jade.compileFile "views/index.jade"
about = jade.compileFile "views/about.jade"
lessons = jade.compileFile "views/index.jade"
challenges = jade.compileFile "views/index.jade"
signup = jade.compileFile "views/index.jade"
signin = jade.compileFile "views/index.jade"

exports.home = (req, res) ->
	res.send(home())

exports.about = (req, res) ->
	res.send(about())

exports.lessons = (req, res) ->
	res.send(lessons())

exports.challenges = (req, res) ->
	res.send(challenges())

exports.signup = (req, res) ->
	res.send(signup())

exports.signin = (req, res) ->
	res.send(signin())