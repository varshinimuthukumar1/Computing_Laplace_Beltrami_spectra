function [R,A] = RadialMean(S)

size2 = size(S)

R = zeros(1,round(sqrt(size2(2))));
A = zeros(1,round(sqrt(size2(2))));

ns = 1;
nl = 1;
i = 1;

while (ns <= size2(2))
    ne = min(ns+nl-1, size2(2));
    R(1,i) = mean(S(1,ns:ne));
    A(1,i) = var(S(1,ns:ne)) / R(1,i)^2;
    i = i+1;
    ns = ns+nl;
    nl = nl+2;
end

R(1)
R(1)= 0.1;
plot(R)
figure()
plot(A)