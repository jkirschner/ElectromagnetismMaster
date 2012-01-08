function Bodies = update_bodies_with_ode(Bodies, ode_io)
	% given an ode in/out, return a new vector of Bodies with the
	% positions/velocities replaced by the values in ode_io.
	for n = 1:length(Bodies)
		Bodies(n).Xpos = ode_io(2*n-1);
	    Bodies(n).Ypos = ode_io(2*n);
	    Bodies(n).Xvel = ode_io(2*length(Bodies) + 2*n-1);
	    Bodies(n).Yvel = ode_io(2*length(Bodies) + 2*n);
	end
end

