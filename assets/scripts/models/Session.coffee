class Session
	id: null
	title: null
	key: null
	collection: null
	points: []

	constructor: (record) ->
		@id = record.id
		@title = record.title
		@key = record.key
		if typeof(record.collection) == 'object'
			@collection = new Session(record.collection)
		else
			@collection = record.collection
		if typeof(record.points) == 'object'
			for point in record.points
				@points.push(new Point(point))

	addPoint: (point, callback) ->
		@points.push(point)
		callback? point
		return point

	removePoint: (point) ->
		del = null

		for value, index in @points
			if value.id == point.id
				del = index
				break

		@points.splice(del, 1) if del != null