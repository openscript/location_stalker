module.exports = {
	view: function(req, res) {
		Collection.findOne({id: req.param('id')}).exec(function(err, rec) {
			if(!err && typeof rec != 'undefined') {
				return res.view({'collection': rec.id});
			} else {
				return res.notFound();
			}
		});
	},

	add: function(req, res) {
		Session.findOne({key: req.param('key')}).exec(function(err, rec) {
			if(!err && typeof rec != 'undefined') {
				Point.create({
					latitude: req.param('latitude'),
					longitude: req.param('longitude'),
					altitude: req.param('altitude'),
					accuracy: req.param('accuracy'),
					session: rec.id
				}).exec(function(err, rec) {
					res.json(rec);
				});
			} else {
				return res.notFound();
			}
		});
	},

	collection: function(req, res) {
		var query = Collection.findOne({id: req.param('id')});
		query.populate('sessions', {sort: 'createdAt DESC'});

		query.exec(function(err, rec) {
			if(!err && typeof rec != 'undefined') {
				Collection.subscribe(req.socket, rec);
				return res.json(rec);
			} else {
				return res.notFound();
			}
		});
	},

	session: function(req, res) {
		var query = Session.findOne({id: req.param('id')});
		query.populate('points', {sort: 'createdAt DESC'});

		query.exec(function(err, rec) {
			if(!err && typeof rec != 'undefined') {
				Session.subscribe(req.socket, rec);
				return res.json(rec);
			} else {
				return res.notFound();
			}
		});
	}
}