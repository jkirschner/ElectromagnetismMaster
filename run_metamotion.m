function run_metamotion()

	Grid = nan(20,40);
	Bodies = generate_bodies();
	
	particle_x = 16;
	particle_y = 10.5;
	particle_ode_in = [particle_x, particle_y, 0, 0];
	
	q = input('charge = ');
	particle_ode_in = meta_motion(Grid, Bodies, 7, particle_ode_in, 10);

end

