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
			required: true,
			unique: true
		},
		collection: {
			model: 'collection',
			required: true
		},
		points: {
			collection: 'point',
			via: 'session'
		}
	},

	publishAdd: function(id, alias, rec, req, options) {

		// Make sure there's an options object
		options = options || {};

		// Enforce valid usage
		var invalidId = !id || _.isObject(id);
		var invalidAlias = !alias || !_.isString(alias);
		var invalidAddedId = !rec.id || _.isObject(rec.id);
		if ( invalidId || invalidAlias || invalidAddedId ) {
			return sails.log.error('Invalid usage of ' + this.identity + '`publishAdd(id, alias, rec.id, [socketToOmit])`');
		}

		if (sails.util.isFunction(this.beforePublishAdd)) {
			this.beforePublishAdd(id, alias, rec.id, req);
		}

		// If a request object was sent, get its socket, otherwise assume a socket was sent.
		var socketToOmit = (req && req.socket ? req.socket : req);

		// In development environment, blast out a message to everyone
		if (sails.config.environment == 'development') {
			sails.sockets.publishToFirehose({
				id: id,
				model: this.identity,
				verb: 'addedTo',
				attribute: alias,
				addedRec: rec
			});
		}

		this.publish(id, this.identity, 'add:'+alias, {
			id: id,
			verb: 'addedTo',
			attribute: alias,
			addedRec: rec
		}, socketToOmit);

		if (!options.noReverse) {
			// Get the reverse association
			var reverseModel = sails.models[_.find(this.associations, {alias: alias}).collection];

			var data;

			// Subscribe to the model you're adding
			if (req) {
				data = {};
				data[reverseModel.primaryKey] = rec.id;
				reverseModel.subscribe(req, data);
			}

			var reverseAssociation = _.find(reverseModel.associations, {collection: this.identity}) || _.find(reverseModel.associations, {model: this.identity});

			if (reverseAssociation) {
				// If this is a many-to-many association, do a publishAdd for the
				// other side.
				if (reverseAssociation.type == 'collection') {
					reverseModel.publishAdd(rec.id, reverseAssociation.alias, id, req, { noReverse: true });
				} else {
					// Otherwise, do a publishUpdate
					data = {};
					data[reverseAssociation.alias] = id;
					reverseModel.publishUpdate(rec.id, data, req, {noReverse:true});
				}
			}

		}

		if (sails.util.isFunction(this.afterPublishAdd)) {
			this.afterPublishAdd(id, alias, rec.id, req);
		}
	}
}