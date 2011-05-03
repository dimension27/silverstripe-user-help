var Browser = function() { this.init(); };
Browser.getInstance = function() {
	if( !Browser.instance ) { Browser.instance = new Browser(); }
	return Browser.instance;
};
Browser.prototype = {
	init: function() {
		var ua = navigator.userAgent.toLowerCase(),
			is = function(t) { return ua.indexOf(t) != -1; };
		this.name = (!(/opera|webtv/i.test(ua)) && /msie (\d)/.test(ua)) ? ((is('mac') ? 'ieMac ' : '') + 'ie ie' + RegExp.$1)
				: is('gecko/') && /.* (.+)\/(\d)\.[\d.]+($| \()/.test(ua) ? 'gecko ' + RegExp.$1 + RegExp.$2 : is('opera') ? 'opera' : is('konqueror') ? 'konqueror' : is('applewebkit/') ? 'webkit safari' : is('mozilla/') ? 'gecko' : '';
		this.os = (is('x11') || is('linux')) ? 'linux' : is('mac') ? 'mac' : is('win') ? 'win' : '';
	},
	addClasses: function () {
		var c = this.name+' '+this.os;
		var h = document.getElementsByTagName('html')[0];
		h.className += h.className?' '+c:c;
	},
	is: function( name ) {
		return this.name.indexOf(name) != -1;
	}
};
Browser.getInstance().addClasses();