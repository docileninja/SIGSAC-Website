mysql = require "mysql"

pool = mysql.createPool
  connectionLimit: 100,
  host: "localhost"
  user: "sigsac"
  password: "sigsac"
  database: "sigsac"

###MEMBER###

exports.getLessons = (done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT name, description, image_link AS link FROM lessons ORDER BY on_date DESC;", (err, lessons) ->
      conn.release()
      done lessons

exports.getAttendanceForMember = (handle, done) ->
	pool.getConnection (err, conn) ->
		conn.query "SELECT name, description, image_link AS link FROM lessons
                INNER JOIN member_attends_lesson AS atten ON atten.lesson = lessons.name
                WHERE atten.handle = ? ORDER BY on_date DESC;", handle, (err, lessons) ->
			conn.release()
			done lessons

exports.checkIn = (handle, code, done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT name FROM lessons WHERE code = ?;", code, (err, rows) ->
      if rows.length
        conn.query "INSERT INTO member_attends_lesson (handle, lesson) VALUES (?, ?);", [handle, rows[0].name], (err, result) ->
          conn.release()
          return done true
      else
        conn.release()
        return done false

exports.getChallenges = (done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT * FROM challenges;", (err, rows) ->
      conn.release()
      done rows

exports.makeCadet = (handle, done) ->
  pool.getConnection (err, conn) ->
    conn.query "INSERT INTO cadets (handle, xnumber, grad_year, major) VALUES (?, '#####', '####', 'No major');", handle, (err, result) ->
      conn.release()
      done result

exports.makeOfficer = (handle, done) ->
  pool.getConnection (err, conn) ->
    conn.query "INSERT INTO officers (handle, rank) VALUES (?, 'Colonel');", handle, (err, result) ->
      conn.release()
      done result

exports.getResources = (page, done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT title, CONCAT('/resources/', LCASE(REPLACE(title, ' ', ''))) AS link FROM resources WHERE title != 'main';", (err, resources) ->
      conn.query "SELECT title, html FROM resources WHERE LCASE(REPLACE(title, ' ', '')) = ?;", page, (err, content) ->
        conn.release()
        if content.length != 0
          done true, resources, content[0]
        else
          done false, null, null

exports.getLesson = (title, done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT * FROM lessons WHERE name = ?;", title, (err, rows) ->
      conn.release()
      if rows.length == 0
        done false, null
      else
        done true, rows[0]

exports.addLesson = (lesson, done) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT * FROM lessons WHERE name = ?;", lesson.name, (err, rows) ->
      if rows.length != 0
        conn.release()
        done false
      else
        conn.query "INSERT INTO lessons (name, description, html_description, image_link, video_link, on_date, code)
                    VALUES (?, ?, ?, ?, ?, CURDATE(), ?);", [lesson.name, lesson.description, lesson.html_description, lesson.image_link, lesson.video_link, lesson.code], (err, result) ->
          conn.release()
          done true

exports.deleteLesson = (title, done) ->
  pool.getConnection (err, conn) ->
    conn.query "DELETE FROM challenge_for_lesson WHERE lesson = ?;", title, (err, res1) ->
      conn.query "DELETE FROM member_attends_lesson WHERE lesson = ?;", title, (err, res2) ->
        conn.query "DELETE FROM lessons WHERE name = ?;", title, (err, res3) ->
          conn.release()
          done [res1, res2, res3]

#exports.getMembers = (fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT * FROM members;", (err, rows) ->
#			conn.release()
#			fn rows
#
#exports.getMember = (handle, fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT * FROM members WHERE handle = '" + handle + "';", (err, rows) ->
#			conn.release()
#			fn rows[0]
#

#
#exports.getLastXChallenges = (n, fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT * FROM challenges LIMIT " + n + ";", (err, rows) ->
#			conn.release()
#			fn rows
#
#exports.getLessons = (fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT lesson_name AS title, description, image_link AS link FROM lessons ORDER BY on_date DESC;", (err, rows) ->
#			conn.release()
#			fn rows
#
#exports.getLastXLessons = (n, fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT lesson_name AS title, description, image_link AS link FROM lessons ORDER BY on_date DESC LIMIT " + n + ";", (err, rows) ->
#			conn.release()
#			fn rows
#
####STAFF###
#
#exports.getAllMembersAttendance = (fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT DISTINCT handle FROM member_attends_lesson;", (err, members) ->
#			conn.release()
#			fn (member["handle"] for member in members)
#
#
#exports.addChallenge = (title, file, desc, lessonIDs) ->
#	#derp
#
#exports.addLesson = (title, link, desc) ->
#	#pass
#
####ADMIN###
#
#exports.addEvent = () ->
#	#pass
#
#exports.deleteEvent = () ->
#	#pass
#
#exports.deleteUser = (memberID) ->
#	#derp