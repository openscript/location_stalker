class Point
	id: null
	latitude: null
	longitude: null
	altitude: null
	accuracy: null
	session: null

	constructor: (record) ->
		@id = record.id
		@latitude = record.latitude
		@longitude = record.longitude
		@altitude = record.altitude
		@accuracy = record.accuracy
		if typeof(record.session) == 'object'
			@session = new Session(record.session)
		else
			@session = record.session