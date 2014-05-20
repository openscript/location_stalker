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
					Session.publishAdd(rec.session, 'points', rec.id);
					res.json(rec);
				});
			} else {
				return res.notFound();
			}
		});
	}
}