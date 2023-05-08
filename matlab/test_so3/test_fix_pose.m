% landmark
clear;
DoF = 3;

NUM_POSES = 1;
NUM_STATES = NUM_POSES * DoF;
NUM_MEAS = NUM_POSES * DoF;
MAX_ITER = 20;

% Simulator
% poses, controls
poses_simu = cell(NUM_POSES, 1);
poses = cell(NUM_POSES, 1);

poses_simu{1} = SO3.eul(0.5, 0.0, 0.0);
poses{1} = poses_simu{1} * SO3.rand;

%% visualize
% ground truth 
figure(1);
for i = 1:NUM_POSES
    hold on; poses_simu{i}.plot;
end
%xlim([-1, 4]); ylim([-2, 3]);
axis equal
title('1 poses - gt');
xlabel('x'); ylabel('y');zlabel('z');
% initial values
figure(2);
for i = 1:NUM_POSES
    hold on; poses{i}.plot;
end
%xlim([-1, 4]); ylim([-2, 3]);
%axis equal
axis equal
xlabel('x'); ylabel('y');zlabel('z');
title('2 poses - init');


% estimator
update_ratio = 0.5;
for iteration = 1:MAX_ITER
    figure(3);
    clf;
    r = zeros(NUM_MEAS, 1);
    J = zeros(NUM_MEAS, NUM_STATES);
    row = 1;
    
    delta_pose = poses_simu{1}.inv * poses{1};
    r(row:(row + 2), 1) = so3vec(delta_pose.log);
    
    cols = 1:3;
    J(row:(row+2), cols) = eye(3,3); 
    
    dx = - inv(J' * J) * J' * r
    % update
    poses{1} = poses{1} * SO3.exp(skew([dx()]*update_ratio));
    
    % plot
    %clf;
    for i = 1:NUM_POSES
        hold on; poses{i}.plot;
    end
    %xlim([-1, 4]); ylim([-2, 3]);
    %axis equal
    axis equal
    title('3 poses - optimization');
    xlabel('x'); ylabel('y');zlabel('z');
    pause(0.5);
end































