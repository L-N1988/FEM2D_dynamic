% function  main()
clear;
% 2d dynamic problems, Newmark method
sumTime = 1;
dt = 0.01; % fixed time step

% read the element and boundary condation 
fprintf(1,'read the modal\n')
node = load('NLIST.DAT');
sumNode = size(node,1);
elem = load('ELIST.DAT');
sumElem = size(elem,1);
fixNode = load('fixNode.dat');
nodeForce = load('nodeForce.dat'); % �ڵ���
nodeForce(1,:) = [];

% -------------------------------------------------------------------------
mat = [200000,0.3,1;]; % ����ģ�������ɱȡ��ܶ�, ���ֲ�����Ҫ����
ndim = 2;isStress = 1; % 1-plane stress 0-plane strain

% dynamic parameters-------
alpha1 = 0;alpha2 = 0;  % ��������ϵ��
alpha = 0.25250625;  % alpha and delta
delta = 0.505;

h = 1;   % Ӧ���ڶ�ά���⣬Ĭ����1

matID  = elem(:,2); % material num
EX = mat(matID,1); % E
mu = mat(matID,2); % nu
ro = mat(matID,3);

elem(:,1:2) = [];
node(:,1)   = [];
node = node(:,1:ndim);

mnode = size(elem,2);  % ��Ԫ����

if mnode == 4
    reduce = 0;  % �Ƿ���ü������֣�Ϊ1��ʾ�Ͳ��ü������֣�0��ʾȫ���֡�
else
    reduce = 1;  
end

% ---------------------------ת��ѹǿ---------------------------------------
if exist('press.dat','file')
    fprintf(1,'trans the pressure\n')
    nodeForceNew = transPres(node,elem,ndim,mnode);
    nodeForce = [nodeForce;nodeForceNew];
end

% ----------------------------�γ�����ն���--------------------------------
fprintf(1,'sort the global K\n')

[GK_u,GK_v,GK_a] = globalK2D(EX,mu,h,elem,node,isStress,reduce,mnode);
M = globalM(ro,ndim,mnode,node,elem);
% ----------------------------��һ��߽�����-----------------------------------
fprintf(1,'boundary condition\n')

% �Խ�Ԫ��1��ʩ�ӵ�һ��߽�����
[GK,force] = boundary_chang_one(GK_u,GK_v,GK_a,fixNode,nodeForce,sumNode,ndim);

% ----------------------------��ⷽ��--------------------------------------
fprintf(1,'solve the dynamic equation\n')
% ����������
C = alpha1*M+alpha2*GK; % ��������
x = NewMark(alpha,delta,GK,M,C,force,sumTime,dt,ndim);% x Ϊ��ϡ�����

% post
% show the contour at step 20
step = 100;
u = reshape(x(:,step),ndim,[])';

% ux
figure('color',[1 1 1])
axis equal;
showContour(node,elem,u(:,1));
axis off;


% uy
figure('color',[1 1 1])
axis equal;
showContour(node,elem,u(:,2));
axis off;


figure;
plot(dt:dt:sumTime,x(4,:),'LineWidth',2)
