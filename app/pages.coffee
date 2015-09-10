api = require './queries.coffee'
upload = require('connect-multiparty')()
fs = require 'fs'
Q = require 'q'

readDir = Q.denodeify(fs.readdir)
readFile = Q.denodeify(fs.readFile)
writeFile = Q.denodeify(fs.writeFile)
unlink = Q.denodeify(fs.unlink)

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
    api.getPage 'About'
    .then (content) ->
      res.render "about.jade",
        loggedin: req.isAuthenticated()
        user: req.user
        content: content

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
    if !lesson.length
      res.redirect '/admin/lessons'
    else
      api.addLesson lesson
      .then () ->
        undefined
      .catch (errorMessage) -> # , (err) ->  would also work
        console.log errorMessage
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
    .catch (errorMessage) ->
      req.flash 'lessonMessage', errorMessage
      res.redirect '/admin/lessons'

  app.post '/admin/lessons/edit/:title', isLoggedIn, isAdmin, (req, res) ->
    lesson = req.body
    lesson.name = req.params.title
    api.editLesson lesson
    .then () ->
      undefined
    .catch (errorMessage) ->
      req.flash 'lessonMessage', errorMessage
    .finally () ->
      res.redirect '/admin/lessons'

  app.get '/admin/lessons/delete/:title', isLoggedIn, isAdmin, (req, res) ->
    api.deleteLesson req.params.title
    .then () ->
      res.redirect '/admin/lessons'

  app.get '/admin/home', isLoggedIn, isAdmin, (req, res) ->
    api.getPage "Home"
    .then (home) ->
      res.render 'admin/editpage',
        loggedin: true
        user: req.user
        page: home
        flash: req.flash 'editHomeMessage'
    .catch (errorMessage) ->
      req.flash 'adminMessage', errorMessage
      res.redirect '/admin'

  app.post '/admin/home', isLoggedIn, isAdmin, (req, res) ->
    home = req.body
    home.name = "Home"
    api.editPage home
    .then () ->
      undefined
    .catch (errorMessage) ->
      req.flash 'editHomeMessage', errorMessage
    .finally () ->
      res.redirect '/admin/home'

  app.get '/admin/about', isLoggedIn, isAdmin, (req, res) ->
    api.getPage "about"
    .then (about) ->
      res.render 'admin/editpage',
        loggedin: true
        user: req.user
        page: about
        flash: req.flash 'editPageMessage'
    .catch (errorMessage) ->
      req.flash 'adminMessage', errorMessage
      res.redirect '/admin'

  app.post '/admin/about', isLoggedIn, isAdmin, (req, res) ->
    about = req.body
    about.name = "About"
    api.editPage about
    .then () ->
      undefined
    .catch (errorMessage) ->
      req.flash 'editAboutMessage', errorMessage
    .finally () ->
      res.redirect '/admin/about'

  app.get '/admin/uploadimage', isLoggedIn, isAdmin, (req, res) ->
    readDir __dirname + "/../public/images/uploads"
    .then (files) ->
      res.render 'admin/imageupload',
        user: req.user
        loggedin: true
        images: files

  app.post '/admin/uploadimage', isLoggedIn, isAdmin, upload, (req, res) ->
    newPath = __dirname + "/../public/images/uploads/" + req.files.image.originalFilename
    readFile req.files.image.path
    .then (file) ->
      writeFile newPath, file
      .then () ->
        undefined
      .catch (err) ->
        console.log err
      .finally () ->
        res.redirect '/admin/uploadimage'

  app.get '/admin/uploadchallenge', isLoggedIn, isAdmin, (req, res) ->
    console.log __dirname + "/../public/challenges"
    readDir __dirname + "/../public/challenges"
    .then (files) ->
      console.log files
      res.render 'admin/challengeupload',
        user: req.user
        loggedin: true
        files: files

  app.post '/admin/uploadchallenge', isLoggedIn, isAdmin, upload, (req, res) ->
    newPath = __dirname + "/../public/challenges/" + req.files.image.originalFilename
    readFile req.files.image.path
    .then (file) ->
      writeFile newPath, file
      .then () ->
        undefined
      .catch (err) ->
        console.log err
      .finally () ->
        res.redirect '/admin/uploadchallenge'

  app.post '/admin/deletefile', isLoggedIn, isAdmin, (req, res) ->
    file = req.body.file
    path = __dirname + "/../public/" + file
    unlink path
    .then () ->
      undefined
    .catch (err) ->
      console.log err
    .finally () ->
      res.redirect '/admin'


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
      url: req.query.url

	app.post '/login', passport.authenticate('local-login',
		failureRedirect: '/login'
		failureFlash: true),
    (req, res) ->
      res.redirect req.flash('redirect')

	app.get '/logout', (req, res) ->
		req.logout()
		res.redirect '/'


## HELPFUL MIDDLEWARE ##

isLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  else
    req.flash 'loginMessage', 'You must be logged in to view that page. ' + req.originalUrl
    res.redirect '/login?url=' + req.originalUrl

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