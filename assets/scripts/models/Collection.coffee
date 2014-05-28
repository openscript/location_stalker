class Collection
	id: null
	title: null
	description: null
	sessions: {}

	constructor: (record) ->
		@id = record.id
		@title = record.title
		@key = record.key
		if typeof(record.sessions) == 'object'
			for session in record.sessions
				model = new Session(session)
				@sessions[model.id] = model;