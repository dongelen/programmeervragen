function rectIntersects (r1, r2)
{
	return !(
		r1.x >= (r2.x + r2.width) || 	// r1 links > r2 rechts
		r2.x >= (r1.x + r1.width) || 	// r2 links > r1 rechts
		r1.y >= (r2.y + r2.height) ||	// r1 boven > r2 onder
		r2.y >= (r1.y + r1.height) 		// r2 boven > r1 onder
	);
}

function createRectObject (x, y, w, h) {
	obj = new Object();
	obj.x = x;
	obj.y = y;
	obj.width = w;
	obj.height = h;
	
	return obj;
}