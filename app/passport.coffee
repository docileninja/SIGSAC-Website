LocalStrategy = require('passport-local').Strategy
bcrypt = require 'bcrypt-nodejs'

#Promise = require 'promises'
#User = require '../app/models/user.coffee'

mysql = require 'mysql'
pool = mysql.createPool
  connectionLimit: 100,
  host: "localhost"
  user: "sigsac"
  password: "sigsac"
  database: "sigsac"

validatePassword = (password, hash) ->
  return bcrypt.compareSync password, hash

hashPassword = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync 8, null

addUser = (user, done) ->
  pool.getConnection (err, conn) ->
      conn.query "INSERT INTO members (handle, first_name, last_name, phone, email, join_date, hash)
                  VALUES (?,?,?,?,?,CURDATE(),?);",
                  [user.handle, user.firstname, user.lastname, user.phone, user.email, user.hash], (err, results) ->
        conn.release()
        if err
          throw err
        else
          return done null, user

module.exports = (passport) ->
  passport.serializeUser (user, done) ->
    done null, user.handle

  passport.deserializeUser (handle, done) ->
    pool.getConnection (err, conn) ->
      conn.query "SELECT members.handle, first_name, last_name, phone, email, acm_id, join_date, hash, duty_position AS position, start_date, end_date, xnumber, grad_year, major, rank FROM members
                  LEFT JOIN member_holds_position AS holds_pos ON members.handle = holds_pos.handle
                  LEFT JOIN cadets ON members.handle = cadets.handle
                  LEFT JOIN officers ON members.handle = officers.handle
                  where members.handle = ?;", handle, (err, rows) ->
        conn.release()
        done err, rows[0]

  passport.use 'local-signup', new LocalStrategy {
    usernameField: 'email'
    passwordField: 'password'
    passReqToCallback: true
  }, (req, email, password, done) ->
    user = req.body
    process.nextTick () ->
      pool.getConnection (err, conn) ->
        conn.query "SELECT * FROM members WHERE handle = ? OR email = ?;", [user.handle, email], (err, rows) ->
          conn.release()
          if err
            return done err
          if rows.length
            return done null, false, req.flash 'signupMessage', 'That handle and/or email is already taken.'
          else
            user.hash = hashPassword password
            addUser user, done


  passport.use 'local-login', new LocalStrategy {
    usernameField: 'email'
    passwordField: 'password'
    passReqToCallback: true
  }, (req, email, password, done) ->
    process.nextTick () ->
      pool.getConnection (err, conn) ->
        conn.query "SELECT * FROM members WHERE email = ? OR handle = ?;", [email, email], (err, rows) ->
          conn.release()
          if err
            return done err
          if !rows.length
            return done null, false, req.flash 'loginMessage', 'Invalid username and/or password.'
          if validatePassword password, rows[0].hash
            return done null, rows[0]
          else
            return done null, false, req.flash 'loginMessage', 'Invalid username and/or password.'