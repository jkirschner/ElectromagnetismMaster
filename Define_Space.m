function DATA = Define_Space_v5(GridSize,hF)

% Created by Jared Kirschner, Olin College of Engineering, 
% May 5, 2010.  If you have any questions, e-mail me.  Enjoy!

if nargin < 1 || isempty(GridSize)
    GridSize = [40 40]; end;
if nargin < 2 || isempty(hF)
    hF = figure;
else figure(hF)
end

DATA = [];

figure(hF);
hA = gca;
cla(hA);
set(gcf,'doublebuffer','on')

hold on;
grid on;

axis equal;
minmax = [0 GridSize(1) 0 GridSize(2)];
axis(minmax);

gain = 50;
minSZ = 10;

% Colorbar Data:
colorbar;

cdatamin = -10;
cdatamax = 10;
inc = .25;

cArray = cdatamin:inc:cdatamax;
cArrayLen = length(cArray);

skip = round(cArrayLen/10);

map = zeros(cArrayLen,3);
colormap(map);
colormap(jet);
Color_Data = colormap(gca);

elem = 1:skip:cArrayLen;
    
hC = colorbar('YTick', elem, 'YTickLabel', cArray(elem));

% End Colorbar Data

%the mouse-click sets a flag for point aquisition 

% Each time one of these events is triggered, it performs the defined
% line of code.

set(hF,'windowbuttondownfcn',@M_Down);
set(hF,'windowbuttonupfcn',@M_Up);
set(hF,'windowbuttonmotionfcn',@M_Motion);

% Note that internally the function calls above send in two arguements:
% src and eventdata... they need to be included in the function definition,
% but don't actually need to be used.

% Also note that this is ugly hard-coding and it would be much better if 
% this could be generalized.  It can be, I just have yet to figure out how.
    function M_Down(src,evnt)
        
        mousedown = 1;
        
        % src - the object that is the source of the event
        % evnt - empty for this property
           sel_typ = get(hF,'SelectionType');
           switch sel_typ 
              case 'normal'
                 move_obj = 1;
                 set(src,'Selected','on')
              case 'extend'
                 resize = 1;
                 set(src,'Selected','on')
              case 'alt'
                 initialize = 1;
                 set(src,'Selected','on')
                 set(src,'SelectionHighlight','off')
           end

    end
    function M_Up(arg1,arg2)
        if ~isempty(hObj)
        mouseup = 1;
        end
    end
    function M_Motion(arg1,arg2)
        mousemotion = 1;
    end
 
% make a control to stop the loop
stopper = uicontrol('style','pushbutton',...
    'string','Freeze', ...
    'position',[0 0 50 20], ...
    'callback',@Stop_It);

    function Stop_It(arg1,arg2)
        if stopit
            stopit = 0;
            set(stopper,'string','Freeze');
            run_time();
        else stopit = 1;
            set(stopper,'string','Continue');
        end
    end

uicontrol('style','pushbutton',...
    'string','Close Program', ...
    'position',[50 0 100 20], ...
    'callback',{@End_Prgm,1});

    function End_Prgm(arg1,arg2,arg3)
       
        if nargin < 3
            arg3 = 0; end;
        
        if arg3
           DATA = []; 
        end
        
       clf(hF); close(hF); stopit = 1;
           
    end

deleted = uicontrol('style','pushbutton',...
    'string','Delete', ...
    'position',[150 0 50 20], ...
    'callback',@Delete_Obj);

    function Delete_Obj(arg1, arg2)
        if length(hObj) >= 1
            if delete
                set(deleted,'string','Delete');
                delete = 0;
            else delete = 1;
                set(deleted,'string','Cancel');
            end
        end
    end

Submit = uicontrol('style','pushbutton',...
    'string','Submit', ...
    'position',[200 0 50 20], ...
    'callback',@Submit_data);

    function Submit_data(arg1,arg2)
       
        virtual_body = struct('Xpos',[],'Ypos',[],'Xvel',[],'Yvel',[],...
            'potential',[],'dims',[],'shapename','circle');
        
        bodies(1:length(hObj)) = virtual_body; clear virtual_body;
        
        for m = 1:length(hObj)
           
            bodies(m).Xpos = get(hObj(m),'xdata');
            bodies(m).Ypos = get(hObj(m),'ydata');
            bodies(m).Xvel = 2*rand-1;
            bodies(m).Yvel = 2*rand-1;
            
            tempColor = get(hObj(m),'Color');
            
            % Iterate through color data to find match
            for k = 1:size(Color_Data,1)
               
                if isequal(tempColor,Color_Data(k,:))
                   bodies(m).potential = cArray(k);
                   break; % end for loop
                end
                
            end
            
            % Error handler
            if isempty(bodies(m).potential)
                warndlg('Error.  Potential not found.');
            end
            
            bodies(m).dims = MarkerSize2Radius(...
                                get(hObj(m),'MarkerSize'), minmax);
            
        end
        
        DATA = bodies; clear bodies;
        End_Prgm(arg1,arg2);
        
    end

%start looping and waiting for a mouse click
stopit = 0;
mousedown = 0;
mouseup = 0;
mousemotion = 0;
initialize = 0;
move_obj = 0;
resize = 0;
delete = 0;

hObj = [];

run_time()

    function run_time()

        while (stopit == 0)
            
        if (mousedown == 1)

            if (initialize == 1)
                
                mouse = get(hA,'currentpoint');

                xPos = mouse(1,1);
                yPos = mouse(1,2);
                
                if ~delete

                isclear = 1;
                
                if ~isempty(hObj)
                   
                    isclear = ~obj_detect([],hObj, minSZ, minmax, ...
                                [xPos yPos]);
                    
                end

                mouseup = 0;

                if isclear
                
                init_color = Color_Data(round(rand*(size(Color_Data,1)-1)+1),:); 
                    
                hObj(end+1) = plot(hA,xPos,yPos,'.','MarkerSize', minSZ,...
                    'Color', init_color);
                pnt = length(hObj);

                while mousedown

                    mouse = get(gca,'currentpoint');

                    xPos = mouse(1,1);
                    yPos = mouse(1,2);

                    new_size = sqrt( (xPos - get(hObj(end),'xdata'))^2 + ...
                                     (yPos - get(hObj(end),'ydata'))^2 );
                                 
                    % function res = edge_detect(object_handle, MS, minmax)
                    if ~edge_detect(hObj(end), gain*new_size, minmax) && ...
                       ~obj_detect(length(hObj),hObj,gain*new_size, minmax)
                    
                    set(hObj(end),'MarkerSize', max([gain*new_size minSZ]));
                    
                    end
                    
                    set(hA,'XLim',minmax(1:2)); 
                    set(hA,'YLim',minmax(3:4));
                    
                    drawnow;
                    
                    if mouseup == 1
                        mouseup = 0;
                        mousedown = 0;
                        mousemotion = 0;
                    end

                end
                
                end

                mouseup = 0;
                mousedown = 0;
                mousemotion = 0;
                initialize = 0;

                elseif delete
                    
                    hR = [];
                    
                        while ~mouseup
                            mouse2 = get(hA,'currentpoint');

                            hR = draw_rectangle(hF,hA,xPos,yPos, ...
                                mouse2(1,1),mouse2(1,2), hR);

                        end

                        mouseup = 0;
                        initialize = 0;
                        
                        mouse2 = get(hA,'currentpoint');
                        
                        xPos2 = mouse2(1,1); yPos2 = mouse2(1,2);
                        
                        del_elem = [];
                        
                        for del_it = 1:length(hObj)
                            
                            cur_cmX = get(hObj(del_it),'xdata');
                            cur_cmY = get(hObj(del_it),'ydata');

                            if cur_cmX >= min([xPos xPos2]) && ...
                               cur_cmX <= max([xPos xPos2]) && ...
                               cur_cmY >= min([yPos yPos2]) && ...
                               cur_cmY <= max([yPos yPos2])

                                del_elem = [del_elem del_it];
                                set(hObj(del_it),'Visible','off');
                           
                            end

                        end
                        
                        set(hR,'Visible','off');
                        clear hR;
                        drawnow;
                        set(deleted,'string','Delete')
                        hObj(del_elem) = [];
                        delete = 0;
                    
                end
            end
            
            if ~isempty(hObj)
            if ((move_obj == 1 || resize == 1))
            
                mouse = get(hA,'currentpoint');

                xPos = mouse(1,1);
                yPos = mouse(1,2);
                
            if xPos > minmax(2)
                
                % current obj = pnt
                
                AxisPos = get(hA,'Position');
                
                % Fractional width, height of axis
                cAxisPos = get(hC,'Position');

                set(hF,'Units','Points')
                figPos = get(hF,'Position'); % in points
                set(hF,'Units','Pixels') % Default
                
                cAxisPoints = cAxisPos .* figPos; % Points of Left, Bottom,
                    % Width, Height
                
                ClickHeight = (yPos/(minmax(4)-minmax(3)))* ...
                    AxisPos(4)*figPos(4) + cAxisPoints(2);
                
                cBarHeights = linspace(cAxisPoints(2),...
                    cAxisPoints(2) + cAxisPoints(4), cArrayLen+1);
                
                [cBarVal, cBarPnt] = min(abs( cBarHeights - ClickHeight ));
                
                if cBarPnt >= size(Color_Data,1)
                    cBarPnt = size(Color_Data,1);
                end
                
                set(hObj(pnt),'Color',Color_Data(cBarPnt,:));
                
                if mouseup == 1
                    
                    mouseup = 0;
                    mousedown = 0;
                    mousemotion = 0;
                    move_obj = 0;
                
                end
                
            else
                
                xArray = zeros(1,length(hObj));
                yArray = zeros(1,length(hObj));
                
                for n = 1:length(hObj)
                    
                   xArray(n) = get(hObj(n),'xdata');
                   yArray(n) = get(hObj(n),'ydata');
                    
                end

                [val, pnt] = min( abs( ...
                            (xPos - xArray).^2 + ...
                            (yPos - yArray).^2 ...
                            ) );

                if delete
                    
                    % Delete individual object
                    if move_obj
                        set(hObj(pnt),'Visible','off')
                        drawnow;
                        hObj(pnt) = [];
                        set(deleted,'string','Delete')
                        delete = 0;
                    % Delete multiple objects
                    end
                    
                else
                
                xObjPos = get(hObj(pnt),'xdata');
                yObjPos = get(hObj(pnt),'ydata');
                oldMarkSize = get(hObj(pnt),'MarkerSize');
                        
                clear xArray yArray;
                
                if ~isclear
                   mouseup = 0; 
                end
                
                while mousedown
                    
                    if move_obj == 1

                        mouse = get(gca,'currentpoint');

                        xPosNew = mouse(1,1);
                        yPosNew = mouse(1,2);

                        xChange = xPosNew - xPos;
                        yChange = yPosNew - yPos;
                        
                        if ~edge_detect(hObj(pnt), ...
                                get(hObj(pnt),'MarkerSize'), minmax, ...
                                [(xObjPos + xChange) (yObjPos + yChange)]) && ...
                           ~obj_detect(pnt,hObj, ...
                                get(hObj(pnt),'MarkerSize'), minmax, ...
                                [(xObjPos + xChange) (yObjPos + yChange)])
                       %function res = obj_detect(pnt, obj_handles, MS,
                       %minmax, Ref)
                        
                        set(hObj(pnt),'xdata',xObjPos + xChange);
                        set(hObj(pnt),'ydata',yObjPos + yChange);
                        
                        else
                        end
                        
                        set(gca,'XLim',minmax(1:2)); 
                        set(gca,'YLim',minmax(3:4));
                        drawnow;

                        if mouseup == 1
                            mouseup = 0;
                            mousedown = 0;
                            mousemotion = 0;
                            move_obj = 0;
                        end
                    end
                    
                    if resize == 1

                        mouse = get(gca,'currentpoint');

                        xPosNew = mouse(1,1);
                        yPosNew = mouse(1,2);

                        xChange = xPosNew - xPos;
                        yChange = yPosNew - yPos;
                        
                        newVec = [xChange yChange];
                        oldVec = [(xPos - xObjPos) (yPos - yObjPos)];
                        
                        projection = dot(newVec,oldVec) ...
                                     / (norm(oldVec))^2 .* oldVec;
                        
                        mag_proj = sign(dot(newVec,oldVec)) * ...
                                   norm(projection);
                        clear projection;
                        
                        if ~edge_detect(hObj(pnt), ...
                                max([oldMarkSize + 50*mag_proj minSZ]), ...
                                minmax) && ...
                           ~obj_detect(pnt, hObj, ...
                                max([oldMarkSize + 50*mag_proj minSZ]), minmax)
                        
                        set( hObj(pnt),'MarkerSize', ...
                            max([oldMarkSize + 50*mag_proj minSZ]) );

                        end;
                        
                        set(gca,'XLim',minmax(1:2)); 
                        set(gca,'YLim',minmax(3:4));
                        drawnow;

                        if mouseup == 1
                            mouseup = 0;
                            mousedown = 0;
                            mousemotion = 0;
                            resize = 0;
                        end
                        
                    end
                    
                end % end while
                end % end delete if
            end
                
            end
            end

        end

            drawnow;
            
        end
        
    end

end

function res = MarkerSize2Radius(MS_cur, minmax)
        
        points_diameter = MS_cur / 3;
        
        % Fractional width, height of axis
        axisPos = get(gca,'Position');
        axisPos(1:2) = [];

        set(gcf,'Units','Points')
        figPos = get(gcf,'Position');
        figPos(1:2) = []; % Width and height of figure
        set(gcf,'Units','Pixels') % Default
        
        axisPoints = axisPos .* figPos;
        
        frac_axis = (points_diameter/2)./axisPoints;
        true_r = frac_axis .* [(minmax(2)-minmax(1)) (minmax(4)-minmax(3))];
        
        res = true_r(2);
        
end
    
function res = edge_detect(object_handle, MS, minmax, Ref)

        buffer = 2; % extra space on sides
        rad = MarkerSize2Radius(MS, minmax);
        
        if nargin < 4 || isempty(Ref)
            xRef = get(object_handle,'xdata');
            yRef = get(object_handle,'ydata');
        else xRef = Ref(1); yRef = Ref(2);
        end

            if xRef - rad <= minmax(1) + buffer
                res = 1;
            elseif xRef + rad >= minmax(2) - buffer
                res = 1;
            elseif yRef - rad <= minmax(3) + buffer
                res = 1;
            elseif yRef + rad >= minmax(4) - buffer
                res = 1;
            else res = 0;
            end
        
end

function res = obj_detect(pnt, obj_handles, MS, minmax, Ref)
    
    buffer = 2; % extra space on sides

    if nargin < 5 || isempty(Ref)
            xPos1 = get(obj_handles(pnt),'xdata');
            yPos1 = get(obj_handles(pnt),'ydata');
    else xPos1 = Ref(1); yPos1 = Ref(2);
    end
    
    obj_handles(pnt) = [];
    
    rad1 = MarkerSize2Radius(MS, minmax);
    
    for n = 1:length(obj_handles)
        
        xPos2 = get(obj_handles(n),'xdata');
        yPos2 = get(obj_handles(n),'ydata');

        dist = sqrt( (xPos1-xPos2)^2 + (yPos1-yPos2)^2 );
        
        rad2 = MarkerSize2Radius(get(obj_handles(n),'MarkerSize'),minmax);
        
        if dist <= rad1 + rad2 + buffer
            res = 1;
            return;
        end
        
    end

    res = 0;
    
end