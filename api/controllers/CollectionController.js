module.exports = {
	manage: function(req, res) {
		return res.view();
	},

	subscribe: function(req, res) {
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