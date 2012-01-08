function res = interp_point(data,x)

low_it = floor(x);

if low_it == 0
    res = ceil(max(data)); return;
elseif low_it >= length(data)
    res = floor(min(data)); return;
end

m = (data(low_it+1)-data(low_it)) / (1);

res = data(low_it) + m * (x-low_it);

end