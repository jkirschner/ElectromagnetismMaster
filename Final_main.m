function game_state = Final_main(handles)

    hA = handles.axes1;
    hQ = handles.Qslider;
    hF = handles.output;
    
    % Calculating points
    
    point_t_max = 50*get(handles.diff,'Value');
    
    point_mult = zeros(1,point_t_max);
    point_mult(1) = 0.001;
    curMult = get(handles.multiplier,'String');
    curMult(1) = [];
    
    cc = (str2double(curMult)) * ...
         get(handles.diff,'Value')^2;
    set(handles.maxpts,'String',num2str(1000*cc));
    rate = (1/(get(handles.diff,'Value')));
    
    for t_it = 2:point_t_max
       
        point_mult(t_it) = point_mult(t_it-1)*(1+rate) - ...
            point_mult(t_it-1)*(rate)*((point_mult(t_it-1)/cc))^.8;
        
    end
    
    point_mult = -1000*point_mult + 1000*cc;
    
    % Calculating points END
    
    gridSize = [40 40];
	Grid = nan(gridSize);
	Bodies = Define_Space(gridSize,handles.def_fig);
    
    set(handles.instructions,'String',handles.instruct.play);
    
    if isempty(Bodies);
        set(handles.begin,'Visible','on');
        game_state = [];
        return;
    end
    
    gain = 1;
    min_speed = .1;
    
    buffer = .2*(gridSize(1)+gridSize(2))/2;
    
    randVx = gain*(2*rand-1);
    randVy = gain*(2*rand-1);
    
    if abs(randVx) <= min_speed
        randVx = sign(2*rand-1)*min_speed;
    elseif abs(randVy) <= min_speed
        randVy = sign(2*rand-1)*min_speed;
    end
        
	particle_ode_in = [rand*(gridSize(2)-buffer)+buffer/2, ...
                       rand*(gridSize(1)-buffer)+buffer/2, randVx, randVy];
    
    game_state = []; % 0 is loss, 1 is win
 
    win_pos = [ max([rand*(gridSize(2)-2)+1 1]) ...
                max([rand*(gridSize(1)-2)+1 1]) ];
            
    % Win radius
    
    rad_choice = get(handles.diff,'Value');
    
    switch rad_choice
        case 1
            win_rad = 10;
        case 2
            win_rad = 7.5;
        case 3
            win_rad = 5;
        case 4
            win_rad = 3;
        case 5
            win_rad = 1;
    end
    
    % Win radius

    while sqrt( (particle_ode_in(1) - win_pos(1))^2 + ...
                (particle_ode_in(2) - win_pos(2))^2 ) <= win_rad
            
    particle_ode_in(1:2) = [rand*(gridSize(2)-buffer)+buffer/2, ...
                       rand*(gridSize(1)-buffer)+buffer/2];

    end
            
            
    max_t = 1;
    t_step = .1;
    
    hD = handles.curdist;
    
    cDtext = get(hD,'String');
    cDtext(11:end) = []; % 'Distance:_' = 10 characters
    
    cD = sqrt( (particle_ode_in(1) - win_pos(1))^2 + ...
                (particle_ode_in(2) - win_pos(2))^2 ) - win_rad;
    
    set(hD,'String',[cDtext sprintf('%.2f',cD)]);
    
    t_begin = tic;
    
    PointData = struct('point_mult',point_mult,'handle',handles.Mtime);
    
    switch get(handles.popupmenu1,'Value') % type
        case 1 % Static
            
            % speed_set: 1-Very Easy, 2-Easy, 3-Medium, 4-Hard,
            % 5-Somerville
            delay = (rad_choice/5) * 0.1;

            potentialGrid = Laplace_Solver(populate_grid(size(Grid), Bodies));
            draw_grid(hF, hA, potentialGrid);

            px = particle_ode_in(1);
            py = particle_ode_in(2);
            hold on;
            h_player = plot3(px, py, interpolate_field(potentialGrid, px, py),...
                             'm.', 'MarkerSize', 20);
            
            win_x = win_pos(1);
            win_y = win_pos(2);
            h_target = plot3(win_x,win_y, interpolate_field(potentialGrid, win_x, win_y),...
                             'b.','MarkerSize',20);
            
            h_target_ring = draw_radius(hA,win_rad, win_x, win_y, potentialGrid);

            particle_handles = struct('player', h_player, ...
                                      'target', h_target, ...
                                      'target_ring', h_target_ring);
            vel_handles = struct('Vx',handles.xvel,'Vy',handles.yvel);

            update_t = struct('start',t_begin,'handle',handles.t_elapsed);
            
             while isempty(game_state)
                 [particle_ode_in, game_state] = particle_motion(Grid, Bodies, t_step, ...
                     max_t, delay, particle_ode_in, game_state, win_pos, win_rad, ...
                     hA, hQ, hF, particle_handles, vel_handles, update_t, hD,...
                     PointData);
             end
            
        case 2 % Dynamic
        
            % speed set: 1-Very Slow
            
            game_state = meta_motion(Grid, Bodies, 7, particle_ode_in, 10, ...
                win_pos, win_rad, hF, hA, hQ);

    end


end