% Analytical Laplace

function res = Laplace_Solver_v5(Internal_Grid)

[lY lX] = size(Internal_Grid);

Grid = nan(lY+2,lX+2); % Inner grid is lX units

% Define Initial Conditions

Top = zeros(1,lX); Bottom = zeros(1,lX);
Left = zeros(1,lY); Right = zeros(1,lY);

Top(1:end) = 0;
Bottom(1:end) = 0;
Left(1:end) = 0;
Right(1:end) = 0;

% End definition of Initial Conditions

% Place initial conditions into grid

Grid(1,2:end-1) = Bottom;
Grid(end,2:end-1) = Top;
Grid(2:end-1,1) = Left;
Grid(2:end-1,end) = Right;

Grid(1,1) = 0; Grid(1,end) = 0; Grid(end,1) = 0; Grid(end,end) = 0;

Grid(2:end-1,2:end-1) = Internal_Grid; clear Internal_Grid;

% End placement of initial conditions into grid

Grid = Grid'; % Allows for 'find' function to work horizontally,
    % then vertically, in order to find non-zero elements.
    
preDef = find(Grid(2:end-1,2:end-1)>-Inf);
[I,J] = ind2sub(size(Grid(2:end-1,2:end-1)),preDef);

const = 0.25;
repeat_unit = [linspace(const,const,lX-1) 0];

% whole_unit = zeros(1,lX-1);
% 
% for n = 1:(lX^2/length(repeat_unit))
%     
%     whole_unit(1:n*length(repeat_unit)) = ...
%         [whole_unit(1:(n-1)*length(repeat_unit)) repeat_unit];
%     
% end
% 
% clear repeat_unit;

MakeDiagonal = zeros(lX*lY,5);

% Central Diagonal (0) = -1;
MakeDiagonal(:,3) = -1;

% Diagonal (+-1) = [1/4*(lX-1), 0]n
MakeDiagonal(:,2) = repmat(repeat_unit',lY,1); % change to lY in gen code
MakeDiagonal(:,4) = repmat(repeat_unit',lY,1); % change to lY in gen code

% Diagonal (+-2) = 1/4
MakeDiagonal(:,1) = const; MakeDiagonal(:,5) = const;

A = spdiags(MakeDiagonal,[-lX -1 0 1 lX],lX*lY,lX*lY);

% whos A
% original_size = 8*lX^2*lY^2

clear repeat_unit MakeDiagonal;

% whole_unit(end) = [];
% if length(whole_unit) ~= (lX^2-1)
%     error('Problem with first diagonals.');
% end
% 
% A = sparse(diag(linspace(-1,-1,lX^2),0)) + ...
%     sparse(diag(whole_unit,1) + sparse(diag(whole_unit,-1))) + ...
%     sparse(diag(linspace(const,const,lX^2-lX),lX)) + ...
%     sparse(diag(linspace(const,const,lX^2-lX),-lX));
% 
% size(A)

b = zeros(lX*lY,1);

for n = 1:length(b)

    if n <= lX
        b(n,1) = b(n,1) - Top(n)*const; end;
    if n > (lX*lY - lX) && n <= lX*lY
        b(n,1) = b(n,1) - Bottom(n-(lY-1)*lX)*const; end;
    if ~mod(n+lX-1,lX)
        b(n,1) = b(n,1) - Left(round( (n+lX-1)/lX ))*const; end;
    if ~mod(n,lX)
        b(n,1) = b(n,1) - Right(round(n/lX))*const; end;
    
end

for n = 1:length(preDef)
   
    for m = 1:lX*lY
        
        if A(m,preDef(n)) ~= 0
        
            A(m,preDef(n)) = 0;
            b(m,1) = b(m,1) - Grid(I(n)+1,J(n)+1)*const; % m is the position in 
                % the grid.
            
        end
        
    end
    
end

A(preDef,:) = []; % Removes previously defined elements
b(preDef) = []; % Removes previously defined elements

vv = A\b;

clear b;

for k = 1:length(preDef)
   
    vv(preDef(k)) = Grid(I(k)+1,J(k)+1);
    
end

Grid = Grid';

for k = 1:lY
    for m = 1:lX
       
        Grid(k+1,m+1) = vv((k-1)*lX+m); % +1 to enter inner grid
        
    end
end

%surf(Grid)
%% surf(Grid,'EdgeColor','none')
%% [eX eY] = gradient(-Grid);
%% hold on;
%% quiver(eX,eY);
%axis equal;
%view([45 45])
%drawnow;

res = Grid;

end
