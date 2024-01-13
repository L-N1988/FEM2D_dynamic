function x = NewMark(alpha,delta,K,M,C,F,sumTime,dt,ndim)
% New-Mark �𲽻��ֽⷽ��
% FΪ������������ʱ��仯


sumStep = fix(sumTime/dt);
sumNode = size(K,1)/ndim;

%--------------------------��ʼ����----------------------------------------
x = zeros(sumNode*ndim,sumStep);
xn = sparse(zeros(sumNode*ndim,1));
vn = xn;
% ����a(0)----aΪ���ٶ�
an = M\(F-C*vn-K*xn);

% ���㲻��Ĳ���
a0 = 1/(alpha*dt^2);
a1 = delta/(alpha*dt);
a2 = 1/(alpha*dt);
a3 = 1/(2*alpha)-1;
a4 = delta/alpha-1;
a5 = dt/2*(delta/alpha-2);
a6 = dt*(1-delta);
a7 = delta*dt;


% �����Ч�ն���K
K = K + a0*M + a1*C;
% ---------------------ÿһ��ʱ�䲽����------------------------------------

for n = 1:sumStep
    f = F + M*(a0*xn+a2*vn+a3*an)+C*(a1*xn+a4*vn+a5*an);  % ��Ч��

    xnp = K\f;
    anp = a0*(xnp-xn)-a2*vn-a3*an;
    vnp = vn+a6*an+a7*anp;
    an = anp;
    vn = vnp;
    xn = xnp;
    x(:,n) = full(xn);

end



