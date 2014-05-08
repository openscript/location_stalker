var bcrypt = require('bcrypt')

// This is the user model.
module.exports = {
	attributes: {
		username: {
			type: 'string',
			required: true,
			unique: true
		},

		password: {
			type: 'string',
			required: true
		},

		groups: {
			collection: 'group',
			via: 'users',
			dominant: true
		}

		toJSON: function() {
			var obj = this.toObject();
			delete obj.password;
			return obj;
		}
	},

	beforeCreate: function(user, cb) {
		bcrypt.genSalt(10, function(err, salt) {
			bcrypt.hash(user.password, salt, function(err, hash) {
				if (err) {
					console.log(err);
					cb(err);
				} else {
					user.password = hash;
					cb(null, user);
				}
			});
		});
	}
}