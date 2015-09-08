express = require 'express'
session = require 'express-session'
passport = require 'passport'
flash = require 'connect-flash'
#mongoose = require 'mongoose'

cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
jade = require 'jade'
fs = require 'fs'
logger = require 'morgan'

app = express()

#configDB = require './config/database.coffee'
#mongoose.connect configDB.url

require('./config/passport.coffee')(passport)

app.use "/", express.static __dirname + '/public'
app.use logger ":remote-addr :method :url     :response-time ms"

app.use session
 	resave: false
 	saveUninitialized: false
 	secret: 'shhhh, very secret'
app.use passport.initialize()
app.use passport.session()
app.use flash()

app.use cookieParser()
app.use bodyParser()

app.set 'view engine', 'jade'

require('./app/pages.coffee')(app, passport)
require('./app/api.coffee')(app, passport)

server = app.listen 8080, "localhost", () ->
	host = server.address().address
	port = server.address().port
	console.log('sigserver listening at http://%s:%s', host, port)