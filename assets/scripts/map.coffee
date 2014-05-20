# This represents the map
map = L.map 'map'

# This represents all painted session layers
sessionLayers = {}

# This contains the
noData = null

# Define some icons
markerIcon = L.icon {
	iconUrl: '/images/marker.png',
	shadownUrl: '/images/marker-shadow.png',
	iconSize: [34, 33],
	shadowSize: [34, 33],
	iconAnchor: [14, 23],
	shadownAnchor: [14, 23],
	popupAnchor: [14, -10]
}

pointIcon = L.icon {
	iconUrl: '/images/point.png',
	iconSize: [20, 20],
	iconAnchor: [10, 10],
	popupAnchor: [10, -10]
}

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
	socket.get '/collection/subscribe/' + $('#nav').data('collection'), (collection) ->
		createList(collection)

# Listen to socket
socket.on 'collection', (res) ->
	socket.get '/collection/subscribe/' + $('#nav').data('collection'), (collection) ->
		recreateList(collection)

socket.on 'session', (res) ->
	true

socket.on 'point', (res) ->
	true

# Display available sessions
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
			subscribeSession(session)
		else
			unsubscribeSession(session)

	label = $('<label>', {
		for: 'session-' + session.id,
		text: session.title
	})

	item.append(checkbox).append(label)
	$('#nav ul').append(item)

# Display sessions to map
subscribeSession = (session) ->
	if sessionLayers[session.id] == undefined
		socket.get '/session/subscribe/' + session.id, (session) ->
			layer = new L.LayerGroup
			$.each session.points, (index, point) ->
				layer.addLayer L.marker([point.longitude, point.latitude], {icon: pointIcon})
			sessionLayers[session.id] = layer
			sessionLayers[session.id].addTo(map)
	else
		sessionLayers[session.id].addTo(map)

unsubscribeSession = (session) ->
	if sessionLayers[session.id] != undefined
		socket.get '/session/unsubscribe/' + session.id
		map.removeLayer(sessionLayers[session.id])