function A = vertexAreas(X, T)

% Triangle areas
N = cross(X(T(:,1),:)-X(T(:,2),:), X(T(:,1),:) - X(T(:,3),:));
At = 1/2*normv(N);

% Vertex areas = 1/3*(sum of areas of triangles nearby)
I = [T(:,1);T(:,2);T(:,3)];
J = ones(size(I));
S = 1/3*[At(:,1);At(:,1);At(:,1)];
nv = size(X,1);
% Vector of area weights
A = sparse(I,J,S,nv,1);

% Convert to a sparse diagonal matrix
A = spdiags(A,0,nv,nv);