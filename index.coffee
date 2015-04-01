express = require 'express'
session = require 'express-session'
jade = require 'jade'
fs = require 'fs'

pages = require __dirname + '/routes/pages.coffee'


app = express()

app.use("/", express.static __dirname + '/public')
app.use session {
 	resave: false
 	saveUninitialized: false
 	secret: 'shhhh, very secret'
}

#pages
app.get('/', pages.home)
app.get('/about.*', pages.about)
app.get('/lessons.*', pages.lessons)
app.get('/challenges.*', pages.challenges)
app.get('/signup.*', pages.signup)
app.get('/signin.*', pages.signin)

#api


#session
#app.post('/signin', )
#app.get('/signout', )

server = app.listen(8080, () ->

	host = server.address().address
	port = server.address().port

	console.log('Example app listening at http://%s:%s', host, port)

)