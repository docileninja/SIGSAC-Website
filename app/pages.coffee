api = require './queries.coffee'

module.exports = (app, passport) ->

  ## GENERAL PAGES ##

	app.get '/', (req, res) ->
    api.getPage 'home'
    .then (content) ->
      api.getLessons()
      .then (lessons) ->
        api.getChallenges()
          .then (challenges) ->
            res.render "index.jade",
              lessons: lessons
              challenges: challenges
              content: content
              loggedin: req.isAuthenticated()
              user: req.user

	app.get '/lessons', (req, res) ->
    api.getLessons()
    .then (lessons) ->
      res.render "lessons.jade",
        lessons: lessons
        loggedin: req.isAuthenticated()
        user: req.user

	app.get '/challenges', (req, res) ->
    res.render "challenges.jade",
      loggedin: req.isAuthenticated()
      user: req.user

  app.get '/resources', (req, res) ->
    api.getResource ''
    .then (content) ->
      if content.length
        api.getResourceTitles()
        .then (resources) ->
          res.render "resources.jade",
            loggedin: req.isAuthenticated()
            user: req.user
            resources: resources
            content: content[0]
      else
        res.redirect '/'



  app.get '/resources/:topic', (req, res) ->
    api.getResourceTitles()
    .then (resources) ->
      api.getResource req.params.topic
      .then (content) ->
        if content.length
          res.render "resources.jade",
            loggedin: req.isAuthenticated()
            user: req.user
            resources: resources
            content: content[0]
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
    api.getAttendanceForMember req.user.handle
    .then (lessons) ->
      res.render "attendance.jade",
        lessons: lessons
        loggedin: true
        user: req.user
        flash: req.flash 'attendanceMessage'

  app.post '/attendance', isLoggedIn, (req, res) ->
    api.checkIn req.user.handle, req.body.code
    .then () ->
      undefined
    .catch (errorMessage) ->
      req.flash 'attendanceMessage', errorMessage
    .finally () ->
      res.redirect '/attendance'

  app.get '/amcadet', isLoggedIn, notCadet, notOfficer, (req, res) ->
    api.makeCadet req.user.handle
    .then () ->
      res.redirect '/profile'

  app.get '/amofficer', isLoggedIn, notCadet, notOfficer, (req, res) ->
    api.makeOfficer req.user.handle
    .then () ->
      res.redirect '/profile'

  ## ADMIN ##

  app.get '/admin', isLoggedIn, isAdmin, (req, res) ->
    res.render 'admin.jade',
      loggedin: true
      user: req.user

  app.get '/admin/lessons', isLoggedIn, isAdmin, (req, res) ->
    api.getLessons()
    .then (lessons) ->
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
    api.addLesson lesson
    .then () ->
      undefined
    .catch (errorMessage) -> # , (err) ->  would also work
      req.flash 'lessonMessage', 'Lesson with same title already exists.'
    .finally () ->
      res.redirect '/admin/lessons'

  app.get '/admin/lessons/edit/:title', isLoggedIn, isAdmin, (req, res) ->
    api.getLesson req.params.title
    .then (lesson) ->
      res.render 'admin/editlesson',
        loggedin: true
        user: req.user
        lesson: lesson
    .catch (err) ->
      req.flash 'lessonMessage', err
      res.redirect '/admin/lessons'

  app.get '/admin/lessons/delete/:title', isLoggedIn, isAdmin, (req, res) ->
    api.deleteLesson req.params.title
    .then () ->
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