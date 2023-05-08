clear;
addpath('../common/');
include_sptatial_toolbox
% 固定pose，lmk为变量
Dim = 3;

landmarks_simu = get_points();

NUM_POSES = 1;
NUM_LMKS = length(landmarks_simu);
NUM_FACTORS = 5;
NUM_STATES = NUM_LMKS * Dim;
NUM_MEAS = NUM_FACTORS * Dim;
MAX_ITER = 20;


% Define the beacon's measurements in R^2
y_sigmas = [0.01, 0.01, 0.01]';
y_sigmas = [0.0, 0.0, 0.0]';
S = inv(diag(y_sigmas));
S = eye(3, 3);

pairs = [];  % pose - landmark
for i = 1:NUM_LMKS
    pairs = cat(1, pairs, [1, i]);
end


%x_lim = [-0.2, 4];
%y_lim = [-2, 7];


% Simulator
poses_simu = cell(NUM_POSES, 1);
poses_simu{1} = SO3.eul(0.5, 0.0, 0.0);
% measures
measurements = zeros(length(pairs), Dim);
landmarks = zeros(length(landmarks_simu), Dim);
for id_pair = 1:length(pairs)
    id_pose = pairs(id_pair, 1);
    id_lmk = pairs(id_pair, 2);
    X_simu = poses_simu{id_pose};
    
    b = landmarks_simu(id_lmk, :)';
    y_noise = y_sigmas * rand();
    y = X_simu.inv * b;
    
    measurements(id_pair, :) = y + y_noise;
    landmarks(id_lmk, :) = b + rand(Dim, 1) * 1.5;%*100; 
end

%% visualize
% ground truth 
figure(1);
plot3(landmarks_simu(:,1), landmarks_simu(:,2), landmarks_simu(:, 3), '*r');
hold on; poses_simu{1}.plot;
%xlim(x_lim); ylim(y_lim);
axis equal
xlabel('x'); ylabel('y');zlabel('z');
title('1-lmks-gt');
% initial values
figure(2);
plot3(landmarks(:,1), landmarks(:,2), landmarks_simu(:,3), '*r');
for i = 1:NUM_POSES
    hold on; poses_simu{i}.plot;
end
%xlim(x_lim); ylim(y_lim);
axis equal
%axis auto
xlabel('x'); ylabel('y');zlabel('z');
title('2-lmks-init');


% estimator
update_ratio = 0.5;
for iteration = 1:MAX_ITER
    figure(3);
    clf;
    r = zeros(NUM_MEAS, 1);
    J = zeros(NUM_MEAS, NUM_STATES);
    row = 1;
    
    for i = 1 : length(pairs)
        id_lmk = pairs(i, 2);
        X = poses_simu{1};
        b = landmarks(i, :);
        y = measurements(i, :);
        
        e = X.inv * b';
        r(row:(row + Dim - 1), 1) = S * (e - y');
        
        cols = (Dim * id_lmk - 2) : (Dim * id_lmk);
        
        ix = X.inv;
        J_e_p = ix.R;
        J(row:(row + Dim - 1), cols) = J_e_p; %% equ 167
        
        
        
        row = row + Dim;
    end
    
    dx = - inv(J' * J) * J' * r
    % update
    for i = 1 : length(landmarks)
        landmarks(i, :) = landmarks(i, :) + update_ratio * dx((Dim * i - 2) : (Dim * i))';
    end
    
    % plot
    plot3(landmarks(:,1), landmarks(:,2),landmarks(:,3), '*r');
    for i = 1:NUM_POSES
        hold on; poses_simu{i}.plot;
    end
    %xlim(x_lim); ylim(y_lim);
    axis equal
    %axis auto
    title('3-lmks-optimization');
    pause(0.5);
end































