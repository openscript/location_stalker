noData = null

# Register events
$('document').ready ->
	noData = $('#list tr')
	socket.get '/collection', (res) ->
		createList(res)


$('#create').validate({
	submitHandler: (form) ->
		socket.post '/collection', $('#create').serializeJSON(), (res) -> 
			if !res.error
				$('#create')[0].reset()
		false
})

# Listen to socket
socket.on 'collection', (res) ->
	socket.get '/collection', (res) ->
		recreateList(res)

# Document manipulation
recreateList = (list) ->
	resetList()
	createList(list)

createList = (list) ->
	if list.length > 0
		$('#list').empty()
		$.each list, (index, item) ->
			addCollection(item)

addCollection = (item) ->
	title = $('<td>').append(item.title)
	description = $('<td>').append(item.description || '-') 
	actions = $('<td>').append(createActions(item.id))

	row = $('<tr>', {
		id: item.id
	}).append(title).append(description).append(actions)

	$('#list').append(row)

createActions = (id) ->
	deleteButton = $('<li>').append($('<a>', 
		href: '/collection/' + id,
		class: 'delete button tiny alert',
		text: 'Delete'
		).click (event) ->
			event.preventDefault()
			socket.delete $(this).attr('href'), (res) ->
				true if !res.error
			false
	)

	editButton = $('<li>').append($('<a>',
		href: '/collection/' + id,
		class: 'edit button tiny',
		text: 'Edit'
	))
	$('<ul>', {
		class: 'button-group radius'
	}).append(deleteButton).append(editButton)


resetList = ->
	$('#list').empty().append(noData);
