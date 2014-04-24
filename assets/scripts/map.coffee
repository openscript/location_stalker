map = L.map('map')
noData = null

# Set up map layer
osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
osmAttrib='<a href="http://openstreetmap.org">OpenStreetMap</a>'
osm = new L.TileLayer osmUrl, {
	minZoom: 8, 
	maxZoom: 12, 
	attribution: osmAttrib
}

map.setView new L.LatLng(51.3, 0.7), 9
map.addLayer(osm)

# Register events
$('document').ready ->
	noData = $('p.noData')
	socket.get '/collection' + collection, (res) ->
		createList(res)
		return
	return

# Document manipulation
createList = (list) ->
	title = $('<h2>').text(list.title)
	$('#nav').title

resetList = ->
	$('#nav').empty()