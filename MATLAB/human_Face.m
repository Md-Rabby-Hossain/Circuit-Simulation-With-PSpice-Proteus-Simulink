
% topopt_cantilever.m
% 2D topology optimization (SIMP) for a cantilever beam
% Single-file implementation (educational)
%
% Outputs an optimized 2D material distribution (density field)
% Author: adapted for you

clear; close all; clc;

%% -----------------------
% Problem parameters
%% -----------------------
nelx = 120;        % number of elements in x (width)
nely = 40;         % number of elements in y (height)
volfrac = 0.4;     % target volume fraction (0..1)
penal = 3.0;       % SIMP penalization factor (>=1)
rmin = 3.0;        % filter radius (in element units)
maxiter = 200;     % maximum optimization iterations
tol = 1e-3;        % convergence threshold for changes in design

% material properties (normalized)
E0 = 1.0;          % Young's modulus of solid material
Emin = 1e-9;       % Young's modulus of void (small but >0 for numerical stability)

%% -----------------------
% FE set up: element stiffness matrix (4-node quad, plane stress)
%% -----------------------
% 4-node bilinear quad element (2D, 4x4 ke)
% A standard 2D 4x4 stiffness matrix for unit element
KE = lk();  % returns 8x8 element stiffness in plane stress for unit square

% total degrees of freedom
ndof = 2*(nelx+1)*(nely+1);

%% -----------------------
% Boundary conditions & loads
%% -----------------------
% fixed degrees: left side fully fixed (x=0, all nodes)
fixeddofs = [];
for j = 0:nely
    n = j*(nelx+1) + 1;  % node number at left column (1-based)
    fixeddofs = [fixeddofs, 2*n-1, 2*n]; %#ok<AGROW>
end
fixed = unique(fixeddofs);

% load: downward point load at middle of right edge (end of cantilever)
F = sparse(ndof,1);
node_load_y = round((nely/2)) * (nelx+1) + (nelx+1); % approx middle node at right edge
F(2*node_load_y) = -1.0;

alldofs = 1:ndof;
freedofs = setdiff(alldofs, fixed);

%% -----------------------
% Prepare finite element connectivity
%% -----------------------
% element degrees of freedom mapping (edofMat)
edofMat = zeros(nelx*nely, 8);
el = 0;
for ely = 1:nely
    for elx = 1:nelx
        el = el + 1;
        n1 = (nelx+1)*(ely-1) + elx;
        n2 = (nelx+1)*ely + elx;
        % nodes: n1, n1+1, n2+1, n2 (counterclockwise)
        nodes = [n1, n1+1, n2+1, n2];
        edof = reshape([2*nodes-1; 2*nodes], 1, 8);
        edofMat(el,:) = edof;
    end
end

%% -----------------------
% Filter: build H and Hs (sensitivity filter)
%% -----------------------
iH = []; jH = []; sH = [];
for i = 1:nelx
    for j = 1:nely
        e1 = (i-1)*nely + j;
        % neighbors within rmin
        for k = max(i-floor(rmin),1):min(i+floor(rmin),nelx)
            for l = max(j-floor(rmin),1):min(j+floor(rmin),nely)
                e2 = (k-1)*nely + l;
                fac = rmin - sqrt((i-k)^2 + (j-l)^2);
                if fac > 0
                    iH = [iH; e1];
                    jH = [jH; e2];
                    sH = [sH; fac];
                end
            end
        end
    end
end
H = sparse(iH, jH, sH);
Hs = sum(H,2);

%% -----------------------
% Initialization
%% -----------------------
x = repmat(volfrac, nely, nelx);
xold = x;
change = 1.0;
loop = 0;
obj_hist = [];

%% -----------------------
% Optimization loop (OC method)
%% -----------------------
fprintf('Starting topology optimization: nelx=%d nely=%d volfrac=%.3f\n', nelx, nely, volfrac);
while (change > tol) && (loop < maxiter)
    loop = loop + 1;
    % FE-analysis
    xPhys = x; % filtered design (we'll apply filter to sensitivities)
    sK = zeros(64*(nelx*nely),1); % pre-alloc for assembly
    % assemble global stiffness
    K = sparse(ndof, ndof);
    ce = zeros(nelx*nely,1);
    for el = 1:nelx*nely
        xi = xPhys(el);
        ke = (Emin + xi^penal*(E0 - Emin)) * KE;
        edofs = edofMat(el,:);
        K(edofs, edofs) = K(edofs, edofs) + ke;
    end
    % Solve system
    U = zeros(ndof,1);
    % use MATLAB backslash on reduced system for speed
    U(freedofs) = K(freedofs, freedofs) \ F(freedofs);
    % objective and sensitivities
    ce = zeros(nelx*nely,1);
    dc = zeros(nely, nelx);
    for el = 1:nelx*nely
        edofs = edofMat(el,:);
        ue = U(edofs);
        ce(el) = ue' * (KE * ue);
    end
    c = sum((Emin + (xPhys(:).^penal)*(E0 - Emin)) .* ce);
    % sensitivity
    dc_vec = -penal * (xPhys(:).^(penal-1)) * (E0 - Emin) .* ce;
    % filter sensitivities
    dc_filtered = reshape((H * (dc_vec) ./ Hs), nely, nelx);
    % objective history
    obj_hist = [obj_hist; c];
    % Optimality Criteria update of design variables
    l1 = 0; l2 = 1e9; move = 0.2;
    while (l2 - l1) > 1e-4
        lmid = 0.5*(l2 + l1);
        xnew = max(0.001, max(x - move, min(1.0, min(x + move, x .* sqrt(-dc_filtered./lmid)))));
        if mean(xnew(:)) - volfrac > 0
            l1 = lmid;
        else
            l2 = lmid;
        end
    end
    change = max(max(abs(xnew - x)));
    x = xnew;
    % Print progress
    fprintf('It:%3d Obj: %.4f Vol: %.3f ch: %.4f\n', loop, c, mean(x(:)), change);
    % display
    if mod(loop,5)==0 || loop==1 || change<tol
        colormap(gray); imagesc(1-flipud(x)); axis equal; axis off; title(sprintf('Iteration: %d',loop));
        drawnow;
    end
end

fprintf('Finished at iter %d, volume fraction = %.3f\n', loop, mean(x(:)));

%% -----------------------
% Postprocess: show final density and optionally export
%% -----------------------
figure('Name','Optimized topology','Color',[1 1 1]);
imagesc(1-flipud(x)); colormap(gray); axis equal; axis off;
title('Optimized material layout (black = solid)');

% save image
im = ind2rgb(gray2ind(mat2gray(1-flipud(x)),256), gray(256));
imwrite(im, 'topopt_result.png');
fprintf('Saved result to topopt_result.png\n');

%% -----------------------
% Helper: element stiffness (8x8) for unit square, plane stress
%% -----------------------
function KE = lk()
    % 4-node bilinear element (unit square), plane stress, unit thickness
    E = 1; nu = 0.3;
    % 2D elasticity matrix (plane stress)
    C = E/(1-nu^2) * [1, nu, 0; nu, 1, 0; 0, 0, (1-nu)/2];
    % 2x2 Gauss quadrature points
    [gp,w] = gauss_quad2d();
    KE = zeros(8,8);
    for i = 1:length(w)
        xi = gp(i,1); eta = gp(i,2); wi = w(i);
        % shape function derivatives w.r.t natural coordinates
        dN_dxi = 1/4 * [- (1-eta), (1-eta), (1+eta), -(1+eta);
                        - (1-xi), - (1+xi), (1+xi), (1-xi)]; % 2x4
        J = dN_dxi * [0 0;1 0;1 1;0 1]; % mapping to unit square nodes coordinates
        detJ = det(J); invJ = inv(J);
        dN_dx = invJ * dN_dxi; % 2x4
        B = zeros(3,8);
        for k = 1:4
            B(:, 2*k-1:2*k) = [dN_dx(1,k), 0; 0, dN_dx(2,k); dN_dx(2,k), dN_dx(1,k)];
        end
        KE = KE + B' * C * B * detJ * wi;
    end
end

function [gp,w] = gauss_quad2d()
    % 2x2 Gauss quadrature for square [-1,1]x[-1,1]
    g1 = 1/sqrt(3);
    gp = [-g1, -g1; g1, -g1; g1, g1; -g1, g1];
    w = [1;1;1;1];
end
