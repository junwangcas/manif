% landmark fix, pose optimize
clear;
DoF = 3;
Dim = 3;

landmarks_simu = get_points();

NUM_POSES = 1;
NUM_LMKS = length(landmarks_simu);
NUM_FACTORS = 5;
NUM_STATES = NUM_POSES * DoF;
NUM_MEAS = NUM_POSES * NUM_LMKS * Dim;
MAX_ITER = 20;


% Define the beacon's measurements in R^2
y_sigmas = [0.001, 0.001, 0.001]';
y_sigmas = [0.0, 0.0, 0.0]';
S = eye(3, 3);

pairs = [];  % pose - landmark
for i = 1:NUM_LMKS
    pairs = cat(1, pairs, [1, i]);
end

% Simulator
% poses, controls
poses_simu = cell(NUM_POSES, 1);
poses = cell(NUM_POSES, 1);

poses_simu{1} = SO3.eul(0.5, 0.0, 0.0);
poses{1} = poses_simu{1} * SO3.rand;

% measures
measurements = zeros(length(pairs), Dim);
for id_pair = 1:length(pairs)
    id_pose = pairs(id_pair, 1);
    id_lmk = pairs(id_pair, 2);
    X_simu = poses_simu{id_pose};
    Xi = poses{id_pose};
    
    b = landmarks_simu(id_lmk, :)';
    y_noise = y_sigmas * rand();
    y = X_simu.inv * b;
    
    measurements(id_pair, :) = y; % + y_noise;
end

%% visualize
% ground truth 
figure(1);
plot3(landmarks_simu(:,1), landmarks_simu(:,2), landmarks_simu(:, 3), '*r');
for i = 1:NUM_POSES
    hold on; poses_simu{i}.plot;
end
axis equal
xlabel('x'); ylabel('y');zlabel('z');
title('1-lmks-gt');
% initial values
figure(2);
plot3(landmarks_simu(:,1), landmarks_simu(:,2), landmarks_simu(:,3), '*r');
for i = 1:NUM_POSES
    hold on; poses{i}.plot;
end
axis equal
xlabel('x'); ylabel('y');zlabel('z');
%axis equal
title('2lmks poses - init');

update_ratio = 0.5;
% estimator
for iteration = 1:MAX_ITER
    figure(3);
    clf;
    r = zeros(NUM_MEAS, 1);
    J = zeros(NUM_MEAS, NUM_STATES);
    row = 1;
    
    for i = 1 : length(pairs)
        id_lmk = pairs(i, 2);
        M = poses{1};
        b = landmarks_simu(i, :);
        y = measurements(i, :);
        
        e = M.inv * b';
        r(row:(row + Dim - 1), 1) = S * (e - y');
        
        cols = 1 : 3 
        ix = M.inv;
        J_e_ix = - ix.R * skew(b);
        J_ix_x = -M.R;
        J(row:(row + Dim - 1), cols) = J_e_ix * J_ix_x;  % chain rule
        
        row = row + Dim;
    end
    
    dx = - inv(J' * J) * J' * r
    % update
    poses{1} = poses{1} * SO3.exp(skew([dx()]*update_ratio));
    
    % plot
    %clf;
    plot3(landmarks_simu(:,1), landmarks_simu(:,2),landmarks_simu(:,3), '*r');
    for i = 1:NUM_POSES
        hold on; poses{i}.plot;
    end
    axis equal
    %axis auto
    title('3-lmks-optimization');
    pause(0.5);
end































