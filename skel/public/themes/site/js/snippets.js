/*
 * Equal height columns.
 */
function equalHeightColumns( cols ) {
	var i, max, height, col;
	for( i = 0; i < cols.length; i++ ) {
		$(cols[i]).css('height', 'auto');
		height = parseInt($(cols[i]).outerHeight());
		if( !max || height > max ) {
			max = height;
		}
	}
	for( i = 0; i < cols.length; i++ ) {
		col = $(cols[i]);
		height = max - (col.outerHeight() - col.height());
		col.css('minHeight', height);
		col.load(this, null, cols);
	}
	return cols;
};
$(document).ready(function() {
	var cols = $('#primary, #secondary');
	if( cols ) {
		equalHeightColumns(cols);
	}
}

