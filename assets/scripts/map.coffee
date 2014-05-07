map = L.map('map')
noData = null

# Set up map layer
osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
osmAttrib='<a href="http://openstreetmap.org">OpenStreetMap</a>'
osm = new L.TileLayer osmUrl, {
	minZoom: 2, 
	maxZoom: 20, 
	attribution: osmAttrib
}

map.setView new L.LatLng(0, 0), 2
map.addLayer(osm)

# Register events
$('document').ready ->
	noData = $('p.noData')
	socket.get '/map/collection/' + $('#nav').data('collection'), (collection) ->
		createList(collection)

# Listen to socket
socket.on 'collection', (res) ->
	socket.get '/map/collection/' + $('#nav').data('collection'), (collection) ->
		recreateList(collection)

# Document manipulation
listChanged = ->
	if $('#nav').children(':not(.noData)').length <= 0
		$('#nav').append(noData)
	else
		$('#nav').children('.noData').remove()

recreateList = (collection) ->
	emptyList()
	createList(collection)

createList = (collection) ->
	if collection.sessions.length > 0
		title = $('<h2>').text(collection.title)
		list = $('<ul>')
		$('#nav').append(title).append(list)
		$.each collection.sessions, (index, session) ->
			addSession(session, false)
	listChanged()

emptyList = ->
	$('#nav').empty()

addSession = (session, checked) ->
	item = $('<li>')
	
	checkbox = $('<input>', {
		name: session.id,
		value: session.id,
		id: 'session-' + session.id,
		type: 'checkbox'
	})
	
	checkbox.attr('checked', 'checked') if checked
	checkbox.change ->
		if this.checked
			populateWithPoints(session)

	label = $('<label>', {
		for: 'session-' + session.id,
		text: session.title
	})

	item.append(checkbox).append(label)
	$('#nav ul').append(item)

setPoints = (points) ->
	true

addPoint = (point) ->
	true

populateWithPoints = (session) ->
	socket.get '/map/session/' + session.id, (session) ->
		setPoints