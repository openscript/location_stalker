# This represents the map
map = L.map 'map'

# This represents all painted session layers
layers = {}

# This represents the model
data = null

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
		data = new Collection(collection)
		addCollection(data)


# Listen to socket
socket.on 'collection', (res) ->
	if res.verb == 'addedTo' && res.attribute == 'sessions'
		session = new Session(res.addedRec)
		data.addSession(session, addSession)

socket.on 'session', (res) ->
	if res.verb == 'addedTo' && res.attribute == 'points'
		point = new Point(res.addedRec)
		data.getSessionById(point.session).addPoint(point, addPoint)

# Display available sessions
listChanged = ->
	if $('#nav').children(':not(.noData)').length <= 0
		$('#nav').append(noData)
	else
		$('#nav').children('.noData').remove()

reloadCollection = (collection) ->
	$('#nav').empty()
	createList(collection)

addCollection = (collection) ->
	if collection.sessions.length > 0
		title = $('<h2>').text(collection.title)
		list = $('<ul>')
		$('#nav').append(title).append(list)
		for session in collection.sessions
			addSession(session, false)
	listChanged()

addSession = (session, checked = false) ->
	item = $('<li>')
	
	checkbox = $('<input>', {
		name: session.id,
		value: session.id,
		id: 'session-' + session.id,
		type: 'checkbox'
	})

	checkbox.change ->
		if this.checked
			subscribeSession(session)
		else
			unsubscribeSession(session)
	
	checkbox.attr('checked', 'checked') if checked

	label = $('<label>', {
		for: 'session-' + session.id,
		text: session.title
	})

	item.append(checkbox).append(label)
	$('#nav ul').append(item)

addPoint = (point) ->
	layer = layers[point.session]
	layer.addLayer L.marker([point.longitude, point.latitude], {icon: pointIcon})

# Display sessions on map
subscribeSession = (session) ->
	if layers[session.id] == undefined
		socket.get '/session/subscribe/' + session.id, (record) ->
			session = data.replaceSession(new Session(record))

			layers[session.id] = new L.LayerGroup
			for point in session.points
				addPoint(point)
			layers[session.id].addTo(map)
	else
		layers[session.id].addTo(map)

unsubscribeSession = (session) ->
	if layers[session.id] != undefined
		socket.get '/session/unsubscribe/' + session.id
		map.removeLayer(layers[session.id])