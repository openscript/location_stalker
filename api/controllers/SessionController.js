var crypto = require('crypto');

module.exports = {
	generate: function(req, res) {
		var ua = req.headers['user-agent'];
		var ip = req.ip;
		var hash = crypto.createHmac('sha1', ip).update(ua).digest('hex');
		var session = {};

		Collection.findOne({title: req.param('collection-title')}).exec(function(err, rec) { 
			session['title'] = ip;
			session['key'] = hash;
			session['collection'] = rec.id;

			res.send(session);
		});
	}
}