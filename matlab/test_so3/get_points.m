function [ points ] = get_points( input_args )
% 生成极角和方位角
theta = linspace(0, pi, 20);
phi = linspace(0, 2*pi, 20);

% 将极角和方位角变为网格矩阵
[theta, phi] = meshgrid(theta, phi);

% 计算坐标
x = sin(theta).*cos(phi);
y = sin(theta).*sin(phi);
z = cos(theta);

% 生成 3D 点
points = [x(:), y(:), z(:)];

% 绘制球
% scatter3(x(:), y(:), z(:), 20, 'filled');

% 设置坐标轴
% axis equal;

%points(1,:) = points(1,:) + 2;
%points(2,:) = points(2,:) + 2;
%points(3,:) = points(3,:) + 2;
end

