clear;
include_sptatial_toolbox;
X = SE2.exp(vec2se2([1, 2, 0.5]));
tao_x = (vec2se2([0, 0, 0.05]))
Y = X*SE2.exp(tao_x);
X.plot;
hold on; Y.plot;

temp = Y*X.inv;
tao_identy = temp.log
tao_identy - tao_x

SE2.exp(tao_identy)*X - X * SE2.exp(tao_x)

X * SE2.exp(tao_x) * X.inv - SE2.exp(X.T * tao_x * X.inv.T) 

% eq 30
Adx = eye(3,3);
Adx(1:2, 1:2) = X.R;
Adx(1:2, 3) = -skew(1)*X.transl';
Adx * se2vec(tao_x) - se2vec(X.T * tao_x * X.inv.T)

% Example 6
theta = 0.1;
R = SO2(-1.3).R;
t = [1, 2]';
R*skew(theta)*R' - skew(theta)

rho = [0.1, 0.2]';
t2 = [R*rho - skew(theta)* t; theta];
t1 = zeros(3,3);
t1(1:2, 1:2) = skew(theta);
t1(1:2, 3) = skew(theta)*t + R*rho;
t1 - skew(t2)

t3 = zeros(3, 3);
t3(1:2,1:2) = R*skew(theta)*R';
t3(1:2, 3) = - R * skew(theta)*R'*t + R*rho;
t3 - skew(t2)



