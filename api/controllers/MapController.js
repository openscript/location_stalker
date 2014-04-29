module.exports = {
	view: function(req, res) {
		Collection.findOne({id: req.param('id')}).populate('sessions').exec(function(err, rec) {
			if(!err) {
				Collection.subscribe(req.socket, rec)
				res.view({'collection': rec});
			} else {
				res.view('404')
			}
		});
	}
}