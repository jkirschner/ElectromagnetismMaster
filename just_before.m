function res = just_before(X, x)
% takes a vector X and a scalar x and returns the smallest index of X, 
% i, such that X(i) < x
	for i=1:length(X)
		if x <= X(i)
			res = i-1;
			return
		end
	end
	res = length(X);
end


