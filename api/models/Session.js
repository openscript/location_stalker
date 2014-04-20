// This is the session model.
// It has a many-to-one association with the collection model.

module.exports = {
	attributes: {
		title: {
			type: 'string',
			required: true
		},
		key: {
			type: 'string',
			required: true
		},
		collection: {
			model: 'collection'
		}
	}
}