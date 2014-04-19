# Register events
$('#create a').click -> 
	socket.post('/collection', $('#create').serializeJSON(), (res) -> true if !res.error)