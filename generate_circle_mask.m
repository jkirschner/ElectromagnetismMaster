function resMask = generate_circle_mask(M, shape)
%GENERATE_MASK Summary of this function goes here
%   Detailed explanation goes here
	if ~strcmp(shape.shapename, 'circle')
		error('incorrectly called generate_circle_mask on a non-circle!')
	end

	r = shape.dims(1);
	Mask = zeros(size(M));

	function r = distance(x1, y1, x2, y2)
		r = sqrt((x1 - x2).^2 + (y1 - y2).^2);
	end

	dx = 1; % x-distance between cells
	dy = 1; % y-distance between cells

	[max_y, max_x] = size(M);
	for j = 1:max_x
		tx = (j + .5) * dx;
		for i = 1:max_y
			ty = (i + .5) * dy;
			if (distance(shape.Xpos,shape.Ypos, tx,ty) <= r) && ( ...
				M(i,j) ~= M(i-1,j) || ...
				M(i,j) ~= M(i+1,j) || ...
				M(i,j) ~= M(i,j-1) || ...
				M(i,j) ~= M(i,j+1) ...
                )
				Mask(i,j) = 1;
            end
        end
    end
    
    resMask = Mask;

end