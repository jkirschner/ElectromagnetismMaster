function ret = draw_circle(M, shape)
%CIRCLE Summary of this function goes here
%   Detailed explanation goes here
	if ~strcmp(shape.shapename, 'circle')
		error('incorrectly called generate_circle_mask on a non-circle!')
	end

	function r = distance(x1, y1, x2, y2)
		r = sqrt((x1 - x2).^2 + (y1 - y2).^2);
	end

	dx = 1; % x-distance between cells
	dy = 1; % y-distance between cells

	r = shape.dims(1);
	[max_y, max_x] = size(M);
	for j = 1:max_x
		tx = (j + .5) * dx;
		for i = 1:max_y
			ty = (i + .5) * dy;
			if isnan(M(i,j)) && (distance(shape.Xpos,shape.Ypos, tx,ty) <= r)
				M(i,j) = shape.potential;
			end
		end
	end

	ret = M;
    
end
