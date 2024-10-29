T = SE2(0.5, 0.14, 0.35);

rng(123);
source_pts = rand(5, 2);
target_pts = zeros(size(source_pts));
for i = 1:size(source_pts,1)
    pt = source_pts(i, :);
    target_pt = T*pt';
    target_pts(i, :) = target_pt';
end
source_pts
target_pts