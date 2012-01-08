function ode_in = bodies2odein(Bodies)
	num_bodies = length(Bodies);
	ode_in = zeros(1, 4*num_bodies);
	for n = 1:num_bodies
		ode_in(2*n-1) = Bodies(n).Xpos;
		ode_in(2*n)   = Bodies(n).Ypos;
		ode_in(2*n-1 + 2*num_bodies) = Bodies(n).Xvel;
		ode_in(2*n   + 2*num_bodies) = Bodies(n).Yvel;
	end
end

