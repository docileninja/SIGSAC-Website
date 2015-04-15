###MEMBER###

exports.getMembers = () ->
	#derp

exports.getMember = (memberID) ->
	#derp

exports.checkin = (memberID) ->
	#derp

###challenges = [
	{"name"}
]###

exports.getChallenges = () ->
	#derp

exports.getLastXChallenges = (n) ->
	#derp

lessons = [

	{
		"title": "Lesson 13 - Buffer Overflow"
		"desc": "you overflow the buffer duh"
		"link": "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg"
	}

	{
		"title": "Lesson 12 - Format String"
		"desc": "just format it stupid"
		"link": "https://i.ytimg.com/vi/sWIsYWnJIBU/mqdefault.jpg"
	}

]

exports.getLessons = () ->
	return lessons

exports.getLastXLessons = (n) ->
	lastLessons = (lessons[num] for num in [lessons.length..lessons.length-n])
	return lastLessons

###STAFF###

exports.getAttendance = () ->
	#derp

exports.addChallenge = (title, file, desc, lessonIDs) ->
	#derp

exports.addLesson = (title, link, desc) ->
	#pass

###ADMIN###

exports.addEvent = () ->
	#pass

exports.deleteEvent = () ->
	#pass

exports.deleteUser = (memberID) ->
	#derp