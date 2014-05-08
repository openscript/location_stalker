var crypto = require('crypto');

module.exports = {
	generate: function(req, res) {
		var ua = req.headers['user-agent'];
		var ip = req.ip;
		var hash = crypto.createHmac('sha1', ip).update(ua).digest('hex');
		var session = new Session();

		res.send(session);
	}
}