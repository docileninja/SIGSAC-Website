mysql = require "mysql"

pool = mysql.createPool
  connectionLimit: 100,
  host: "localhost"
  user: "sigsac"
  password: "sigsac"
  database: "sigsac"

###MEMBER###

exports.getLessons = (fn) ->
  pool.getConnection (err, conn) ->
    conn.query "SELECT lesson_name AS title, description, image_link AS link FROM lessons ORDER BY on_date DESC;", (err, rows) ->
      conn.release()
      fn rows

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
#exports.checkin = (memberID) ->
#	#derp
#


#exports.getChallenges = (fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT * FROM challenges;", (err, rows) ->
#			conn.release()
#			fn rows
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
#exports.getAttendanceForMember = (handle, fn) ->
#	pool.getConnection (err, conn) ->
#		conn.query "SELECT lesson FROM member_attends_lesson WHERE handle = '" + handle + "';", (err, lessons) ->
#			conn.release()
#			fn (lesson["lesson"] for lesson in lessons)
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