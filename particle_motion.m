function [ode_out,game_state] = particle_motion(grid, bodies, t_step, ...
                                   max_t, delay, particle_init_ode_in,...
                                   game_state, win_pos, win_rad, hA, hQ, hF, ...
                                   particle_handles, vel_handles, update_t, ...
                                   hD, PointData)
	
%     hF = handles.output;
%     hA = handles.axes1;
%     hQ = handles.Qslider;

%     prec = 4;

    particle_q = get(hQ,'Value');

    figure(hF);
    axes(hA);
    
    gridSize = size(grid);

    particle_m = 1;

    potentialGrid = Laplace_Solver(populate_grid(size(grid), bodies));
    
	[Ex, Ey] = gradient(-potentialGrid);
    hold on;

    px = particle_init_ode_in(1); py = particle_init_ode_in(2);
    z = interpolate_field(potentialGrid,px,py);
    z_win = interpolate_field(potentialGrid,win_pos(1),win_pos(2));

    t_array = [0:t_step:max_t inf];
    t_iterator = 1;

    options = odeset('Events', @events);
    
	[T, Simres] = ode45(@ode_motion,[0 max_t],particle_init_ode_in,options);

	ode_out = Simres(end,:);

	function ode_res = ode_motion(t, in)
        
		px = in(1);
		py = in(2);

		[max_y, max_x] = size(grid);
		if px < 1 || py < 1 || px > max_x || py > max_y
			% x and/or y are out of the grid bounds, so stop moving the particle
			ode_res = [0;0;0;0];
		end
		vx = in(3);
		vy = in(4);

		ex = interpolate_field(Ex, px, py);
		ey = interpolate_field(Ey, px, py);

		ax = particle_q * ex / particle_m;
		ay = particle_q * ey / particle_m;
        
        if t >= t_array(t_iterator)
            
            z = interpolate_field(potentialGrid,px,py);
            z_win = interpolate_field(potentialGrid,win_pos(1),win_pos(2));
            
            sVx = get(vel_handles.Vx,'String');
            sVy = get(vel_handles.Vy,'String');
            
            % 'X_Velocity:_" and "Y..." are 12 characters...
            sVx(13:end) = []; sVy(13:end) = [];
            
                set(vel_handles.Vx,'String', [sVx sprintf('%.3f', vx)]);
                set(vel_handles.Vy,'String', [sVy sprintf('%.3f', vy)]);
            
                set(particle_handles.player,'xdata',px);
                set(particle_handles.player,'ydata',py);
                set(particle_handles.player,'zdata',z);
                
                set(particle_handles.target,'xdata',win_pos(1));
                set(particle_handles.target,'ydata',win_pos(2));
                set(particle_handles.target,'zdata',z_win);
                
                cDtext = get(hD,'String');
                cDtext(11:end) = [];
                
                cD = sqrt( (px-win_pos(1))^2 + (py-win_pos(2))^2 ) - win_rad;
                set(hD,'String',[cDtext sprintf('%.2f',cD)]);
            
            el_time = get(update_t.handle,'String');
            % 'Elapsed_Time:_' = 14 characters
            el_time(15:end) = [];
            
            set(update_t.handle,'String',[el_time sprintf('%.2f', ...
                toc(update_t.start))]);
            
            set(PointData.handle,'String',sprintf('%07.3f',interp_point( ...
                PointData.point_mult,toc(update_t.start))));
                
            pause(delay)
            drawnow;
            
            t_iterator = t_iterator + 1;
            
        end

		ode_res = [vx; vy; ax; ay];
    end

    function [value, isterminal, direction] = events(t,Data)
        
        curXpos = Data(1);
        curYpos = Data(2);
        
        xValue = abs((curXpos - 1 - (gridSize(2)+1)/2)) - gridSize(2)/2;
        yValue = abs((curYpos - 1 - (gridSize(1)+1)/2)) - gridSize(1)/2;
        
        value(1) = max([xValue yValue]);

        if value(1) >= 0
        
            game_state = 0;
            
        end
        
        dist = sqrt( (curXpos - win_pos(1))^2 + (curYpos - win_pos(2))^2 );

        value(2) = dist - win_rad;
        
        if value(2) <= 0
        
            game_state = 1;
            
        end
        
        isterminal(1) = 1;
        direction(1) = 1; % when above zero...
        isterminal(2) = 1;
        direction(2) = -1;
        
    end

end

