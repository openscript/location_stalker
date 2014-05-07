// This is the point model.
// It has a many-to-one association with the session model.

module.exports = {
	attributes: {
		latitude: {
			type: 'float',
			required: true
		},
		longitude: {
			type: 'float',
			required: true
		},
		altitude: {
			type: 'float',
			required: false
		},
		accuracy: {
			type: 'float',
			required: false
		},
		session: {
			model: 'session'
		}
	}
}