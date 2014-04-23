noData = null

# Register events
$('document').ready ->
	noData = $('#list tbody tr')
	socket.get '/collection', (res) ->
		createList(res)
		return
	return

$('#create form').validate({
	submitHandler: (form) ->
		socket.post '/collection', $('#create form').serializeJSON(), (res) -> 
			if !res.error
				$('#create form')[0].reset()
				addCollection(res)
		false
})

$('#edit form').validate({
	submitHandler: (form) ->
		data = $('#edit form').serializeJSON()
		socket.put '/collection/' + data.id, data ,(res) -> 
			if !res.error
				$('#edit form')[0].reset()
				socket.get '/collection', (res) ->
					recreateList(res)
				cancelEdit()
		false
})

$('#edit a.cancel').click ->
	cancelEdit()

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

cancelEdit = ->
	$('#edit').hide()
	$('#create').show()
	$('#edit form')[0].reset()

recreateList = (list) ->
	resetList()
	createList(list)

createList = (list) ->
	if list.length > 0
		$.each list, (index, item) ->
			addCollection(item)

addCollection = (item) ->
	title = $('<td>').append(item.title)
	description = $('<td>').append(item.description || '-') 
	actions = $('<td>').append(createActions(item.id))

	row = $('<tr>', {
		id: item.id
	}).append(title).append(description).append(actions)

	$('#list tbody').prepend(row)
	listChanged()

deleteCollection = (id) ->
	$('tr#' + id).remove()
	listChanged()

editCollection = (id) ->
	socket.get '/collection/' + id, (res) ->
		if res.error
			return
		else
			$('#edit input[name=\'id\'').attr('value', res.id)
			$('#edit input[name=\'title\'').attr('value', res.title)
			$('#edit textarea[name=\'description\'').text(res.description)
	$('#create').hide()
	$('#edit').show()


createActions = (id) ->
	deleteButton = $('<li>').append($('<a>', 
		href: '/collection/' + id,
		class: 'delete button tiny alert',
		text: 'Delete'
		).click (event) ->
			event.preventDefault()
			socket.delete $(this).attr('href'), (res) ->
				if !res.error
					deleteCollection(id)
			false
	)

	editButton = $('<li>').append($('<a>',
		href: '/collection/' + id,
		class: 'edit button tiny',
		text: 'Edit'
		).click (event) ->
			event.preventDefault()
			editCollection(id)
			false
	)

	$('<ul>', {
		class: 'button-group radius'
	}).append(deleteButton).append(editButton)

resetList = ->
	$('#list tbody').empty()
	listChanged()
