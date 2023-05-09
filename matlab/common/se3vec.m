function [ vec ] = se3vec( se3 )
vec_so3 = so3vec(se3(1:3, 1:3));
vec = [se3(1:3, 4); vec_so3];
end

