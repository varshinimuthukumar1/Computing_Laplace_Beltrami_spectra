clearvars;
close all;
clc;

addpath('./utils/');

% number of Laplacian eigenfunctions to compute
nk = 256;

fprintf('reading the shape...');
S1 = read_off_shape('sphere2.off');
C1 = [S1.surface.X S1.surface.Y S1.surface.Z];
fprintf('done\n');

fprintf('computing the cotan Laplacian basis functions...');
% Compute the diagonal (lumped) area matrix
A = vertexAreas(C1, S1.surface.TRIV);
% Compute the contangent Laplacian matrix
W = cotWeights(C1, S1.surface.TRIV);
% Normalize the area (for scale invariance)
A = A / sum(sum(A));

% Compute the eigenfunctions by solving the generalized eigenvalue problem 
% W phi = lambda A phi. Since the matrix W is symmetric positive 
% semi-definite and A is symmetric positive definite, the resulting
% eigenvalues must be real and non-negative. Assuming the mesh is
% connected, there will be exactly one zero eigenvalue.
% The last parameter is an offset sigma and eigs finds the closest
% eigenvalues to sigma. We use a a small negative sigma since we are 
% looking for the smallest eigenvalues, and also want to guarantee that the
% matrix (A^{-1}W - sigma*I) is non-singular.
[e, v] = eigs(W, A, nk, -1e-6);

% Sort the eigenvalues (and thus, the eigenvectors)
[L1.evals, order] = sort(diag(v),'ascend');
L1.evecs = e(:,order);
fprintf('done\n');

%%
figure('pos',[100 100 1000 300]);

% Avoid "negative zero" in Matlab
if(L1.evals(1) < 0 && abs(L1.evals(1)<1e-7))
    L1.evals(1) = 0;
end

% Compute the minumum and maximum values for a consistent color map
emax = max(max(L1.evecs(:,1:5)));
emin = min(min(L1.evecs(:,1:5)));

c = load('mycolormap');
colormap(c.colormap);

% plot the first few eigenfunctions and their eigenvalues
for k=1:5
    h = subplot(1,5,k);
    plot_function_scape(S1.surface, L1.evecs(:,k));
    title(sprintf('$\\lambda_{%d} = %.3g$', k, L1.evals(k)), ...
        'interpreter','latex','FontSize',16);
    % Use a consistent color map
    caxis manual
    caxis([emin emax]);

    lighting flat;
    shading flat  ;
    
    % Create a light in the 3D scene. Comment it to remove illumination
    % and better see color changes, at the expense of not seeing the 3D.
    %camlight('headlight');    
end

% Add a colorbar for showing the function range:
subplot(1,5,5);
cb = colorbar;
set(cb,'position',[.92 .22 .01 .7])

plot(L1.evals)
figure()
S = zeros(1, nk);
npts = size(L1.evecs)
for i = 1:npts(1)
    
    S = S + L1.evecs(i,:);
    
end

S = S.^2 * sum(sum(A))/npts(1);
%plot(S)
figure()

[R,A] = RadialMean(S)
size(S)


