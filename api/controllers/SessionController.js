var crypto = require('crypto');

module.exports = {
	generate: function(req, res) {
		var ua = req.headers['user-agent'];
		var ip = req.ip;
		var session = {};

		Collection.findOne({title: req.param('collection-title')}).exec(function(err, rec) { 
			session['title'] = ip;
			session['key'] = crypto.createHmac('sha1', ip).update(ua + rec.id).digest('hex');
			session['collection'] = rec.id;

			res.send(session);
		});
	},

	subscribe: function(req, res) {
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
	},

	unsubscribe: function(req, res) {
		var query = Session.findOne({id: req.param('id')});

		query.exec(function(err, rec) {
			if(!err && typeof rec != 'undefined') {
				Session.unsubscribe(req.socket, rec);
			} else {
				return res.notFound();
			}	
		});
	}
}