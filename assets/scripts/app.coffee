# Initialize foundation
$(document).foundation();

# Initialize socket.io
socket = window.io.connect();

# Connect/disconnect events
socket.on 'connect', ->
	$('#status').attr('src', '/images/online.gif')

socket.on 'disconnect', ->
	$('#status').attr('src', '/images/offline.gif')