function handle = draw_radius(hA, r, x, y, Field)
%DRAW_RADIUS Draws circle of given radius around given point, following terrain of given field.
% 	axes(hA);
    T = linspace(0, 2*pi, 20);
	X = r .* cos(T) + x;
	Y = r .* sin(T) + y;
	Z = zeros(1, length(X)); % interpolate_field isn't really vector-ready
	for i=1:length(Z)
		Z(i) = interpolate_field(Field, X(i), Y(i));
	end
	handle = plot3(X,Y,Z, 'g');
end

