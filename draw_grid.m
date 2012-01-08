function foo = draw_grid(hF,hA,Grid)
	
    gridSize = size(Grid);
	figure(hF);
    cla(hA);
    axes(hA);
    set(hF, 'CurrentAxes', hA);

%   set(hA, 'Color', [0 0 0])
    %set(gca, 'Color', [0 0 0]);
    
    %set(hF, 'Color', [0 0 0]);
    %set(subplot(1,1,1), 'Color', [0 0 0]);
    
	surf(Grid, ...
	     'FaceColor', [.3 .3 .5], ...
		 'FaceAlpha', 0.5, ...
		 'EdgeColor', [.4 .4 .1]);
    set(hA, 'Color', [0 0 0]);
    axis([0 gridSize(2) 0 gridSize(1) -10 10]);
	view([30 30])

	axis equal;
    hold on;
	drawnow;
end

