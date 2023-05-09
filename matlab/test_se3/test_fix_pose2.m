% landmark
clear;
DoF = 6;

NUM_POSES = 1;
NUM_STATES = NUM_POSES * DoF;
NUM_MEAS = NUM_POSES * DoF;
MAX_ITER = 20;

% Simulator
% poses, controls
poses_simu = cell(NUM_POSES, 1);
poses = cell(NUM_POSES, 1);

poses_simu{1} = SE3.rand;
poses{1} = poses_simu{1} * SE3.rand;

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
update_ratio = 1;
for iteration = 1:MAX_ITER
    figure(3);
    clf;
    r = zeros(NUM_MEAS, 1);
    J = zeros(NUM_MEAS, NUM_STATES);
    row = 1;
    
    delta_pose = poses{1}.inv * poses_simu{1};
    r(row:(row + 5), 1) = se3vec(delta_pose.log);
    
    cols = 1:6;
    J_x = zeros(6, 6);
    M_bar = poses_simu{1};
    J_x(1:3, 1:3) = M_bar.R';
    J_x(1:3, 4:6) = - M_bar.R'*skew(M_bar.transl);
    J_x(4:6, 4:6) = M_bar.R';
    
    J_M = zeros(6,6);
    M = poses{1};
    J_M(1:3, 1:3) = M.R;
    J_M(1:3, 4:6) = skew(M.transl)*M.R;
    J_M(4:6, 4:6) = M.R;
    
    J_M = -J_M;
    
    J(row:(row+5), cols) = J_x * J_M; 
    
    dx = - inv(J' * J) * J' * r
    % update
    poses{1} = poses{1} * SE3.exp(vec2se3([dx()]*update_ratio));
    
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































