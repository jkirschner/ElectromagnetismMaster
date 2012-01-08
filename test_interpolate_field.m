function r = test_interpolate_field()
	clf; hold on;
	test_field = [1 2; 3 4];
	X = linspace(1,2,10);
	Y = linspace(1,2,10);
	for i = 1:10
		for j = 1:10
			plot3(X(i), Y(j), interpolate_field(test_field, X(i), Y(j)), 'o');
		end
	end
end

