function z = interpolate_field(Field, x, y) % asdf
	[max_y, max_x] = size(Field);

	if x < 1
		x = 1;
        z = 0; return;
	end
	if y < 1
		y = 1;
        z = 0; return;
	elseif x > max_x
		x = max_x;
        z = 0; return;
	elseif y > max_y
		y = max_y;
        z = 0; return;
	end

	if is_int(y) && is_int(x)
		% x and y are both in the grid; no interpolation needed

		z = Field(y, x);

	elseif is_int(y)
		% y lies perfectly on a gridline; interpolate along x axis
		% 
		%  +------------------> x
		%  | a +----*---+ b
		%  v
		%
		%  y
		%

		a_y = y;
		b_y = y;

		a_x = just_before(1:max_x, x);
		b_x = a_x + 1;

		a_z = Field(a_y, a_x);
		b_z = Field(b_y, b_x);

		z = a_z + (b_z - a_z)/(b_x - a_x)*(x - a_x);

	elseif is_int(x)
		% x lies perfectly on a gridline; interpolate along y axis
		%
		%  +-------> x
		%  |   a
		%  |  +
		%  |  |
		%  |  |
		%  |  *
		%  |  |
		%  |  +
		%  v   b
		%
		%  y
		
		a_x = x;
		b_x = x;
		
		a_y = just_before(1:max_y, y);
		b_y = a_y + 1;

		a_z = Field(a_y, a_x);
		b_z = Field(b_y, b_x);

		z = a_z + (b_z - a_z)/(b_y - a_y)*(y - a_y);
	else
		% neither x or y lie perfectly on a gridline
		%
		% labels:
		%
		%  +-------------------> x
		%  |   a    m    b
		%  |    +---+---+
		%  |    |       |
		%  |    |   *p  |
		%  |    |       |
		%  |    +---+---+
		%  |   c    n    d
		%  v
		%  
		%  y

		a_y = just_before(1:max_y, y);
		b_y = a_y;
		c_y = a_y + 1;
		d_y = c_y;

		a_x = just_before(1:max_x, x);
		c_x = a_x;
		b_x = a_x + 1;
		d_x = b_x;

		a_z = Field(a_y, a_x);
		b_z = Field(b_y, b_x);
		c_z = Field(c_y, c_x);
		d_z = Field(d_y, d_x);

		m_x = x;
		n_x = x;
		m_y = a_y;
		n_y = c_y;

		m_z = a_z + (b_z - a_z)/(b_x - a_x)*(m_x - a_x);
		n_z = c_z + (d_z - c_z)/(d_x - c_x)*(n_x - c_x);

		z = n_z + (m_z - n_z)/(m_y - n_y)*(y - n_y);
	end
end

function res = is_int(x)
	res = round(x) == x;
end
