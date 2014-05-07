module.exports = {
	local: function(req, res) {
		return res.view();
	},

	global: function(req, res) {
		return res.view();
	}
}