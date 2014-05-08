// This is the group model.
// It has a many-to-many association with the user model.

module.exports = {
	attributes: {
		name: {
			type: 'string',
			required: true
		},

		users: {
			collection: 'user',
			via: 'groups'
		}
	}
}