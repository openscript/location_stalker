noData = null

# Register events
$('document').ready ->
	noData = $('#list tbody tr')
	socket.get '/collection', (res) ->
		createList(res)
		return
	return

# Listen to socket
socket.on 'collection', (res) ->
	socket.get '/collection', (res) ->
		recreateList(res)
		return
	return

# Document manipulation
listChanged = ->
	if $('#list tbody').children().length <= 0
		$('#list tbody').append(noData)
	else
		$('#list tbody').children('.noData').remove()

emptyList = ->
	$('#list tbody').empty()

recreateList = (list) ->
	emptyList()
	createList(list)

createList = (list) ->
	if list.length > 0
		$.each list, (index, item) ->
			addCollection(item)

addCollection = (item) ->
	title = $('<td>').append(item.title)
	description = $('<td>').append(item.description || '-') 
	activity = $('<td>')
	actions = $('<td>').append(createActions(item.id))

	row = $('<tr>', {
		id: item.id
	}).append(title).append(description).append(activity).append(actions)

	$('#list tbody').prepend(row)
	listChanged()

createActions = (id) ->
	$('<a>', 
		href: '/map/' + id,
		class: 'view button tiny expand',
		text: 'View on map'
	)