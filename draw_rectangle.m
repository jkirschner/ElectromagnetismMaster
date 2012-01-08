function hR = draw_rectangle(hF, hA, x1, y1, x2, y2, hR)
    
    figure(hF);
    set(hF,'CurrentAxes',hA)
    
    xMin = min([x1 x2]);
    yMin = min([y1 y2]);
    
    xMin = max([0 xMin]);
    yMin = max([0 yMin]);
    
    Height = abs(y1-y2);
    Width = abs(x1-x2);
    
    if xMin + Width > 40
        Width = 40 - xMin;
    end
    if yMin + Height > 40
        Height = 40 - yMin;
    end

    if Width > 0 && Height > 0
        if nargin < 7 || isempty(hR)

        hR = rectangle('Position',[xMin yMin Width Height],'LineWidth',5);

        else

        set(hR,'Position', [xMin yMin Width Height]);
        drawnow;

        end
    else
    
    hR = [];
    
    end
    
end