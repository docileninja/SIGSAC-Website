jade = require 'jade'
queries = require './queries.coffee'
fs = require 'fs'

module.exports = (app, passport) ->

  ## GENERAL PAGES ##

	app.get '/', (req, res) ->
		queries.getLessons (lessons) ->
			res.render "index.jade",
        lessons: lessons
        loggedin: req.isAuthenticated()
        user: req.user

	app.get '/lessons', (req, res) ->
    queries.getLessons (lessons) ->
      res.render "lessons.jade",
        lessons: lessons
        loggedin: req.isAuthenticated()
        user: req.user

	app.get '/challenges', (req, res) ->
    res.render "challenges.jade",
      loggedin: req.isAuthenticated()
      user: req.user

  app.get '/resources', (req, res) ->
    queries.getResources '', (success, resources, content) ->
      if success
        res.render "resources.jade",
          loggedin: req.isAuthenticated()
          user: req.user
          resources: resources
          content: content
      else
        res.redirect '/'

  app.get '/resources/:topic', (req, res) ->
    queries.getResources req.params.topic, (success, resources, content) ->
      if success
        res.render "resources.jade",
          loggedin: req.isAuthenticated()
          user: req.user
          resources: resources
          content: content
      else
        res.redirect '/resources'

  app.get '/about', (req, res) ->
    res.render "about.jade",
      loggedin: req.isAuthenticated()
      user: req.user

  ## MEMBER PAGES ##

  app.get '/profile', isLoggedIn, (req, res) ->
    res.render "profile.jade",
      loggedin: true
      user: req.user

  app.post '/profile', isLoggedIn, (req, res) ->
    res.send 'not yet implemented'

  app.get '/attendance', isLoggedIn, (req, res) ->
    queries.getAttendanceForMember req.user.handle, (lessons) ->
      res.render "attendance.jade",
        lessons: lessons
        loggedin: true
        user: req.user
        flash: req.flash 'attendanceMessage'

  app.post '/attendance', isLoggedIn, (req, res) ->
    queries.checkIn req.user.handle, req.body.code, (success) ->
      if !success
        req.flash 'attendanceMessage', 'Code does not correspond to any lesson'
      res.redirect '/attendance'

  app.get '/amcadet', isLoggedIn, notCadet, notOfficer, (req, res) ->
    queries.makeCadet req.user.handle, () ->
      res.redirect '/profile'

  app.get '/amofficer', isLoggedIn, notCadet, notOfficer, (req, res) ->
    queries.makeOfficer req.user.handle, () ->
      res.redirect '/profile'

  ## ADMIN ##

  app.get '/admin', isLoggedIn, isAdmin, (req, res) ->
    res.render 'admin.jade',
      loggedin: true
      user: req.user

  app.get '/admin/lessons', isLoggedIn, isAdmin, (req, res) ->
    queries.getLessons (lessons) ->
      res.render 'admin/lessons',
        lessons: lessons
        loggedin: true
        user: req.user
        flash: req.flash 'lessonMessage'

  app.get '/admin/lessons/addlesson', isLoggedIn, isAdmin, (req, res) ->
    res.render 'admin/addlesson',
      loggedin: true
      user: req.user

  app.post '/admin/lessons/addlesson', isLoggedIn, isAdmin, (req, res) ->
    lesson = req.body
    queries.addLesson lesson, (success) ->
      if !success
        req.flash 'lessonMessage', 'Lesson with same title already exists.'
      res.redirect '/admin/lessons'

  app.get '/admin/lessons/edit/:title', isLoggedIn, isAdmin, (req, res) ->
    queries.getLesson req.params.title, (success, lesson) ->
      if success
        res.render 'admin/editlesson',
          loggedin: true
          user: req.user
          lesson: lesson
      else
        req.flash 'lessonMessage', 'Lesson with title, ' + req.params.title + ', does not exist.'
        res.redirect '/admin/lessons'

  app.get '/admin/lessons/delete/:title', isLoggedIn, isAdmin, (req, res) ->
    queries.deleteLesson req.params.title, () ->
      res.redirect '/admin/lessons'

  ## AUTHENTICATION ##

	app.get '/signup', kickLoggedIn, (req, res) ->
    res.render "signup.jade",
      flash: req.flash 'signupMessage'

	app.post '/signup', passport.authenticate 'local-signup', {
		successRedirect: '/'
		failureRedirect: '/signup'
		failureFlash: true
	}

	app.get '/login', kickLoggedIn, (req, res) ->
    res.render "login.jade",
      flash: req.flash 'loginMessage'

	app.post '/login', passport.authenticate 'local-login', {
		successRedirect: '/'
		failureRedirect: '/login'
		failureFlash: true
	}

	app.get '/logout', (req, res) ->
		req.logout()
		res.redirect '/'


## HELPFUL MIDDLEWARE ##

isLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  else
    req.flash 'loginMessage', 'You must be logged in to view that page.'
    res.redirect '/login'

kickLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    res.redirect '/'
  else
    return next()

isAdmin = (req, res, next) ->
  if req.user.position == "Admin"
    return next()
  else
    res.redirect '/'

notOfficer = (req, res, next) ->
  if req.user.rank
    return res.redirect '/'
  else
    return next()

notCadet = (req, res, next) ->
  if req.user.xnumber
    return res.redirect '/'
  else
    return next()