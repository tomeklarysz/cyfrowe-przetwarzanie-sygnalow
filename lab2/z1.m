clear all; close all;
N = 20;
W = zeros(N);
for k = 0:N-1
    W(k+1,1:N) = sqrt(2/N) * cos((pi*k/N) * ((0:N-1)+0.5));
end

for k = 1:N
    wiersz = W(k,1:N);
    for i = 1:N
        if i ~= k
            dot(wiersz, W(i,1:N)),
        end
    end
end