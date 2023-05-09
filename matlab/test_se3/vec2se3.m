function [se3] = vec2se3( vec )
se3 = zeros(4, 4);
vec_theta = vec(4:6);
vec_rho = vec(1:3);

se3(1:3, 4) = vec_rho;
se3(1:3, 1:3) = skew(vec_theta);
end

