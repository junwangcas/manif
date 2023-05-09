function [ v ] = so3vec( A )
%SO3VEC Summary of this function goes here
%   Detailed explanation goes here
v = [A(3,2)-A(2,3); A(1,3)-A(3,1); A(2,1)-A(1,2)] / 2;


end

