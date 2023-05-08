clear;
pose = SE3.rand;
pose.plot
axis equal;

p = [1, 1, 1]';
pprim = pose * p;

