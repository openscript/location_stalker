class Collection
	id: null
	title: null
	description: null
	sessions: []

	constructor: (record) ->
		@id = record.id
		@title = record.title
		@key = record.key
		if typeof(record.sessions) == 'object'
			for session in record.sessions
				@sessions.push(new Session(session))

	addSession: (session, callback) ->
		@sessions.push(session)
		callback? session
		return session

	getSessionById: (id) ->
		return @sessions[@getSessionIndexById(id)]

	getSessionIndexById: (id) ->
		for value, index in @sessions
			if value.id == id
				return index
		return null

	removeSession: (session) ->
		del = @getSessionIndexById(session.id)

		@sessions.splice(del, 1) if del != null

	replaceSession: (session) ->
		@removeSession(session)
		@addSession(session)