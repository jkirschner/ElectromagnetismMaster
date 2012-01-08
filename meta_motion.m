function game_state = meta_motion(Grid, Bodies, max_t, ...
                                  particle_ode_in, particle_q, ...
                                  win_pos, win_rad, ...
                                  hF, hA, hQ)

	% world parameters
	num_bodies = length(Bodies);
	gridSize = size(Grid);

	% body/particle parameters
	body_mass = 1;
	body_area = 1;
	e_0 = 1;
	particle_m = 1;

	% plotting parameters
	animation_resolution = 100; % draw 100 frames
	plot_points = [linspace(0, max_t, animation_resolution) Inf];
	plot_index = 1;

	if ~isa(Bodies, 'struct')
		error('META_MOTION: input Bodies not of type struct');
	end

	bodies_ode_in = bodies2odein(Bodies);

	disp('thinking...');
    options = odeset('Events', @events);
	[T, Simres] = ode45(@ode_motion, [0 max_t], ...
	                    [bodies_ode_in particle_ode_in], ...
                        options);

	% ode in/out format:
	%
	%   [Px_1, Py_1, ..., Px_n, Py_n, \
	%    Vx_1, Vy_1, ..., Vx_n, Vy_n, \
	%    particle_x, particle_y, particle_vx, particle_vy]
	%

	% ode_out = Simres(end,:);  % entire ode_out
	ode_out = Simres(end, 4*num_bodies+1:4*num_bodies+4); % only particle_ode_in

	function ode_res = ode_motion(t, in)
		%%% spinner :)
		%current_spinner = next_spinner(current_spinner);
		%fprintf('\b%s', current_spinner);

		%%% populate grid; then set up voltage & electric fields
		Bodies = update_bodies_with_ode(Bodies, in);
		potentialGrid = Laplace_Solver(populate_grid(gridSize, Bodies));
		[Ex, Ey] = gradient(-potentialGrid);
		eX = Ex(2:end-1, 2:end-1); % why do we do this?
		eY = Ey(2:end-1, 2:end-1); % can we save memory by just using Ex, Ey?
		
		%%% body motion
		% 2*num_bodies = each body has x, y force components
		Fstruct = zeros(1, 2*num_bodies);
		for a = 1:num_bodies

            
			currentMask = generate_circle_mask(Grid, Bodies(a));
			[it_y, it_x] = find(currentMask);
			eRes = [0 0];
			for it = 1:length(it_y)
				field_at_border = [eX(it_y(it), it_x(it)), ...
				                   eY(it_y(it), it_x(it))];
				radius_vector = [it_x(it) - Bodies(a).Xpos, ...
				                 it_y(it) - Bodies(a).Ypos];
				eRes = eRes + field_at_border * ...
				           sign(dot(field_at_border, radius_vector));
			end
			Fstruct(2*a-1:2*a) = body_area * e_0 * eRes;
			clear eRes currentMask it_x it_y; % is this line necessary?
		end
		dVdt = (Fstruct./body_mass)';
		clear Fstruct;
		dPdt = in(2*num_bodies+1:4*num_bodies); % this uses old velocities...
		bodies_ode_res = [dPdt; dVdt];

		%%% particle motion
		px = in(4*num_bodies+1);
		py = in(4*num_bodies+2);
		vx = in(4*num_bodies+3);
		vy = in(4*num_bodies+4);
		max_x = gridSize(2);
		max_y = gridSize(1);

		if px < 1 || py < 1 || px > max_x || py > max_y
			% x or y are out of the grid bounds, so stop moving the particle
			ode_res = [0;0;0;0];
        end

        particle_q = get(hQ, 'Value');
		ax = particle_q * interpolate_field(Ex, px, py) / particle_m;
		ay = particle_q * interpolate_field(Ey, px, py) / particle_m;

		particle_ode_res = [vx; vy; ax; ay];

		%%% final return value!
		ode_res = [bodies_ode_res; particle_ode_res];

		%%% plotting/animation
		if t > plot_points(plot_index)
			plot_index = plot_index + 1;
			draw_grid(hF, hA, potentialGrid);
			plot3(px, py, interpolate_field(potentialGrid, px, py), ...
			      'm.', 'MarkerSize', 20);
            win_x = win_pos(1);
            win_y = win_pos(2);
            plot3(win_x, win_y, interpolate_field(potentialGrid, win_x, win_y),...
                  'b.', 'MarkerSize', 20);
            draw_radius(hA, win_rad, win_x, win_y, potentialGrid);
			drawnow;
		end
    end

    function [value, isterminal, direction] = events(t,Data)
        
        curXpos = Data(4*num_bodies+1);
        curYpos = Data(4*num_bodies+2);
        
        xValue = abs((curXpos - gridSize(2)/2)) - gridSize(2)/2 + 1;
        yValue = abs((curYpos - gridSize(1)/2)) - gridSize(1)/2 + 1;
        
        value(1) = max([xValue yValue]);

        if value(1) >= 0
        
            game_state = 0;
            
        end
        
        dist = sqrt( (curXpos - win_pos(1))^2 + (curYpos - win_pos(2))^2 );

        value(2) = dist - win_rad;
        
        if value(2) <= 0
        
            game_state = 1;
            
        end
        
        tempBodies = update_bodies_with_ode(Bodies, Data);
        
        % check to see if the body is outside of the grid & stop if so
        min_dist = inf;
%         minObj = [];
        edge_buf = 1;
        for a = 1:length(tempBodies)
            b = tempBodies(a);
            r = b.dims(1);
            
%             temp_min = min([(b.Xpos - r - 1), (b.Xpos + r - gridSize(2)), ...
%                 (b.Ypos - r - 1), (b.Ypos + r - gridSize(1))]);
            temp_min1 = min([(b.Xpos - r - 1 - edge_buf), ...
                            (b.Ypos - r - 1 - edge_buf)]);
            temp_min2 = max([(b.Xpos + r - gridSize(2) + edge_buf), ...
                            (b.Ypos + r - gridSize(1)) + edge_buf]);
            
            [val, val_pnt] = min(abs([temp_min1 temp_min2]));
            
            if val_pnt == 1
                val = val*sign(temp_min1);
            end

            if val_pnt == 2
                val = val*sign(temp_min2);
            end
            
            if abs(val) < abs(min_dist)
            
                min_dist = val;
%                 minObj = b;
               
            end
            
            if (b.Xpos - r <= 1 + edge_buf) || (b.Xpos + r >= gridSize(2) - edge_buf) || ...
                    (b.Ypos - r <= 1 + edge_buf) || (b.Ypos + r >= gridSize(1) - edge_buf)
                game_state = 0;
            end
            
        end

        value(3) = min_dist;

        if num_bodies > 1
        [b1, b2, nearest_dist] = find_closest_bodies(tempBodies);
		value(4) = nearest_dist - (b1.dims(1) + b2.dims(1));
        else value(4) = Inf;
        end;

		if value(4) < 0
			game_state = 0;
		end
        
        isterminal(1) =  1;
        direction (1) =  1; % when above zero...
        isterminal(2) =  1;
        direction (2) = -1;
        isterminal(3) =  1;
        direction (3) =  0;
        isterminal(4) =  1;
        direction (4) =  0;
        
    end
end

