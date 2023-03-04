clear;

%% equation 8 
include_sptatial_toolbox;
theta = pi/2;
R = SO2(theta)
m = skew(theta);
(expm(m)  - R.R)
(logm(R.R) - m)


v = 2.1;% rad/s
t = 3.0;
skew(v)*t - skew(v*t)

%% equation 16 - 27
syms tao
taylor(expm(tao))

tao = theta;
s = 2;
expm((t + s) * skew(tao)) - expm(t*skew(tao)) * expm(s*skew(tao))

expm(-skew(tao)) - expm(skew(tao))^(-1)
X = expm(skew(tao));
expm(X*skew(tao)*X') - X * expm(skew(tao)) * X'


tao1 = 0.1;
X * expm(skew(tao1)) - expm(skew(tao1)) * X

%% sec II F
tao_local = 0.1;
tao_global = X*skew(tao_local)*X'
tao_global - skew(tao_local)

%% sec II G
%% sec II H
theta = pi/2;
X_bar = SO2(theta);
t = 0.1;
X = X_bar * SO2(t);



























