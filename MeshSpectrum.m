function S = MeshSpectrum(base_filename)
% S = MeshSpectrum(base_filename)
% compute the projection of a set of surface samples onto spectral mesh basis
% then evaluate the power spectrum

[status,result]=system(['mesh_info ' base_filename '.obj' ' vertices']);
basis_size = [str2double(result) inf];
[status,result]=system(['mesh_info ' base_filename '.obj' ' area']);
surfArea = str2double(result);

fid = fopen(strcat(base_filename, '.bases'), 'rb');
nbasis = fread(fid, 1, 'int32=>int32');
E = fread(fid, basis_size, 'float32=>float32');
fclose(fid);

S = zeros(1, nbasis);

pts = load(strcat(base_filename, '.asp'));

size2 = size(pts);

for i = 1:size2(1)
    i0 = round(pts(i,1)) + 1;
    i1 = round(pts(i,2)) + 1;
    i2 = round(pts(i,3)) + 1;
    alpha = pts(i,4);
    beta = pts(i,5);
    gamma = 1.0 - alpha - beta;
    S = S + E(i0,:)*alpha + E(i1,:)*beta + E(i2,:)*gamma;
end
S = S.^2 * surfArea / size2(1);
%S = S(nbasis-1:-1:1);

plot(S);
