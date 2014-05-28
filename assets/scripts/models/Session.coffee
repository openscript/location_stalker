class Session
	id: null
	title: null
	key: null
	collection: null
	points: {}

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
				model = new Point(point)
				points[model.id] = model;

	addPoint: (point) ->
		points[point.id] = point

	removePoint: (point) ->
		delete points[point.id]