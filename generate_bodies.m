function Bodies = generate_bodies()
	prototype = struct('Xpos',[],'Ypos',[],'Xvel',[],'Yvel',[],...
	                   'potential',[], 'shapename','circle','dims',[]);

	Grid = nan(20,40);
	
	Bodies(1:2) = prototype;
	
	Bodies(1).Xpos = 10;
	Bodies(1).Ypos = 10;
	Bodies(1).Xvel = 0;
	Bodies(1).Yvel = 0;
	Bodies(1).potential = 5;
	Bodies(1).dims = 1;
	
	Bodies(2).Xpos = 30;
	Bodies(2).Ypos = 10;
	Bodies(2).Xvel = 0;
	Bodies(2).Yvel = 0;
	Bodies(2).potential = -3;
	Bodies(2).dims = 1;
end

