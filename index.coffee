express = require 'express'
session = require 'express-session'
jade = require 'jade'
fs = require 'fs'
logger = require 'morgan'

pages = require __dirname + '/routes/pages.coffee'
api = require __dirname + '/routes/api.coffee'

app = express()

app.use "/", express.static __dirname + '/public'
app.use logger ":remote-addr :method :url     :response-time ms"
app.use session
 	resave: false
 	saveUninitialized: false
 	secret: 'shhhh, very secret'

#pages
app.get '/', pages.home
app.get '/index(.html)?', pages.home
app.get '/about(.html)?', pages.about
app.get '/lessons(.html)?', pages.lessons
app.get '/challenges(.html)?', pages.challenges
app.get '/signup(.html)?', pages.signup
app.get '/signin(.html)?', pages.signin

#api
app.get '/api/getmembers', (req, res) ->
	api.getMembers (body) -> res.send body
app.get '/api/getmember', (req, res) ->
	api.getMember req.query.handle, (body) -> res.send body
app.get '/api/getchallenges', (req, res) ->
	api.getChallenges (body) -> res.send body
app.get '/api/getlastchallenges', (req, res) ->
	api.getLastXChallenges req.query.count, (body) -> res.send body

#session
app.post  '/signin', (req, res) -> console.log "signin attempted"
#app.get('/signout', )

server = app.listen 8080, "localhost", () ->
	host = server.address().address
	port = server.address().port
	console.log('sigserver listening at http://%s:%s', host, port)