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

	get: function(req, res) {
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
	}
}