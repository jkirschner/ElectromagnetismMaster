function pointGrid = populate_grid(gridSize, bodies)
	pointGrid = nan(gridSize);
	for a = 1:length(bodies)
	    pointGrid = draw_circle(pointGrid, bodies(a));
	end
end

