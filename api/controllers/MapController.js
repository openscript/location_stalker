module.exports = {
	view: function(req, res) {
		return res.view({'collection': 5});
	}
}