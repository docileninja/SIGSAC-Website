mysql = require "mysql"
Q = require "q"
md = require("markdown").markdown

pool = mysql.createPool
  connectionLimit: 100
  host: "localhost"
  user: "sigsac"
  password: "sigsac"
  database: "sigsac"

## Bind query into promise logic ##
query = (queryString, args) ->
  promise = Q.defer()
  pool.getConnection (err, conn) ->
    if err
      promise.reject(err)
    else
      conn.query queryString, args, (err, result) ->
        if err
          promise.reject(err)
        else
          promise.resolve(result)
  promise.promise

###MEMBER###

exports.getLessons = () ->
  query "SELECT name, description, image_link, video_link FROM lessons ORDER BY on_date DESC;"

exports.getAttendanceForMember = (handle) ->
  query "SELECT name, description, image_link, video_link FROM lessons
         INNER JOIN member_attends_lesson AS atten ON atten.lesson = lessons.name
         WHERE atten.handle = ? ORDER BY on_date DESC;", handle

exports.checkIn = (handle, code) ->
  promise = Q.defer()
  query "SELECT name FROM lessons WHERE code = ?;", code
  .then (matches) ->
    if matches.length != 0
      query "INSERT INTO member_attends_lesson (handle, lesson) VALUES (?, ?);", [handle, matches[0].name]
      .then (results) ->
        promise.resolve null
    else
      promise.reject 'Code does not correspond to any lesson'
  promise.promise

exports.getChallenges = () ->
  query "SELECT * FROM challenges;"

exports.makeCadet = (handle) ->
  query "INSERT INTO cadets (handle, xnumber, grad_year, major) VALUES (?, '#####', '####', 'No major');", handle

exports.makeOfficer = (handle) ->
  query "INSERT INTO officers (handle, rank) VALUES (?, 'Colonel');", handle

exports.getResourceTitles = () ->
  query "SELECT title FROM resources;-- ORDER BY rank;"

exports.getResource = (page) ->
  promise = Q.defer()
  query "SELECT title, markdown, html FROM resources WHERE title = ?;", page.title
  .then (rows) ->
    if rows.length
      promise.resolve rows[0]
    else
      promise.reject "No page matching " + page.title + "."
  .catch (err) ->
    promise.reject err.message
  promise.promise

exports.addResource = (page) ->
  promise = Q.defer()
  query "SELECT * FROM resources WHERE title = ?;", page.title
  .then (results) ->
    if results.length
      promise.reject 'Resource with title, ' + page.title + ' already exists.'
    else
      query "INSERT INTO resources (title, markdown, html) VALUES (?, ?, ?);",
            [page.title, page.markdown, md.toHTML(page.markdown)]
      .then () ->
        promise.resolve null
      .catch (error) ->
        promise.reject error.message
  .catch (error) ->
    promise.reject error.message
  promise.promise

exports.editResource = (page) ->
  promise = Q.defer()
  query "SELECT title FROM resources WHERE title = ?;", page.title
  .then (results) ->
    if results.length != 0
      query "UPDATE resources SET markdown = ?, html = ? WHERE title = ?;",
            [page.markdown, md.toHTML(page.markdown), page.title]
      .then () ->
        promise.resolve null
      .catch (error) ->
        promise.reject error.message
    else
      promise.reject "No resource " + page.title + "."
  .catch (error) ->
    promise.reject error.message
  promise.promise

exports.deleteResource = (page) ->
  promise = Q.defer()
  query "DELETE FROM resources WHERE title = ?;", page.title
  .then () ->
    promise.resolve null
  .catch (err) ->
    promise.reject err.message
  promise.promise

exports.getLesson = (title) ->
  promise = Q.defer()
  query "SELECT * FROM lessons WHERE name = ?;", title
  .then (lessons) ->
    if lessons.length
      promise.resolve lessons[0]
    else
      promise.reject 'Lesson with title, ' + title + ', does not exist.'
  promise.promise

## Admin ##

exports.addLesson = (lesson) ->
  promise = Q.defer()
  query "SELECT * FROM lessons WHERE name = ?;", lesson.name
  .then (rows) ->
    if rows.length
      promise.reject 'Lesson with same title already exists.'
    else
      query "INSERT INTO lessons (name, markdown, description, image_link, video_link, on_date, code)
             VALUES (?, ?, ?, ?, ?, CURDATE(), ?);",
        [lesson.name, lesson.markdown, md.toHTML(lesson.markdown), lesson.image_link, lesson.video_link, lesson.code]
      .then () ->
        promise.resolve null
      .catch (err) ->
        promise.reject err.message
  promise.promise

exports.editLesson = (lesson) ->
  promise = Q.defer()
  query "SELECT * FROM lessons WHERE name = ?;", lesson.name
  .then (rows) ->
    if rows.length
      query "UPDATE lessons SET markdown = ?, description = ?, image_link = ?, video_link = ?, code = ? WHERE name = ?;",
            [lesson.markdown, md.toHTML(lesson.markdown), lesson.image_link, lesson.video_link, lesson.code, lesson.name]
      .then () ->
        promise.resolve null
      .catch () ->
        promise.reject "Error updating lesson"
    else
      promise.reject "Error, lesson does not exist."
  promise.promise

exports.deleteLesson = (title) ->
  promise = Q.defer()
  query "DELETE FROM challenge_for_lesson WHERE lesson = ?;", title
  .then () ->
    query "DELETE FROM member_attends_lesson WHERE lesson = ?;", title
    .then () ->
      query "DELETE FROM lessons WHERE name = ?;", title
      .then () ->
        promise.resolve null
  promise.promise

exports.getPage = (page) ->
  promise = Q.defer()
  query "SELECT * FROM pages WHERE name = ?;", page
  .then (pages) ->
    if pages.length
      promise.resolve pages[0]
    else
      promise.reject "No page found with name, " + page + "."
  .catch (err) ->
    console.log err
    promise.reject err.message
  promise.promise

exports.editPage = (page) ->
  promise = Q.defer()
  query "UPDATE pages SET markdown = ?, html = ? WHERE name = ?;",
        [page.markdown, md.toHTML(page.markdown), page.name]
  .then (result) ->
    if result.rowsAffected
      promise.resolve null
    else
      promise.reject "Page, " + page.name + " does not exist."
  promise.promise
