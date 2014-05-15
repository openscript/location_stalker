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
	}
}