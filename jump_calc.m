height = linspace(0.1, 0.2, 100);
torq = zeros(100);
for i = 1:100
[t1, t2] = vmc_(225, 0, height(i), 90);
torq(i) = t2;
end

plot(height, torq, '-')
title("Torq Required for 225N")
xlabel("height (m)")
ylabel("torq (N*M)")