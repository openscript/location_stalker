var passport = require('passport');

module.exports = {
	signIn: function(res, req) {
		return res.view();
	},

	process: function(res, req) {
		passport.authenticate('local', function(err, user, info) {
			if(err || !user) {
				res.redirect('/signIn');
				return;
			}
			req.logIn(user, function(err) {
				if(err) {
					res.redirect('/signIn');
				}
				return res.redirect('/');
			});
		});
	},

	signOut: function(res, req) {
		req.logOut();
	}
}