// This is the collection model.
// It has a one-to-many association with the session model.

module.exports = {
	attributes: {
		title: {
			type: 'string',
			required: true
		},
		description: {
			type: 'text',
			required: false
		},
		sessions: {
			collection: 'session',
			via: 'collection'
		}
	}
}