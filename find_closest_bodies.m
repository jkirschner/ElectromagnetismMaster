function [b1, b2, min_dist] = find_closest_bodies(Bodies)
	num_bodies = length(Bodies);
	min_dist = Inf;
	for i = 1:num_bodies
		for j = i+1:num_bodies
			dist = distance_between(Bodies(i), Bodies(j));
			if dist < min_dist
				min_dist = dist;
				b1 = Bodies(i);
				b2 = Bodies(j);
			end
		end
	end
end

function r = distance_between(b1, b2)
	r = sqrt((b1.Xpos - b2.Xpos)^2 + (b1.Ypos - b2.Ypos)^2);
end

