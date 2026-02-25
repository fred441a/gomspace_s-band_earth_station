M = 16;
N = 32;
K = N - M;
% must use circulant
A11 = circulant([0 0 1 0 0 0 0 1],1);
A12 = circulant([0 1 0 0 0 1 0 0],1);

A13 = circulant([0 0 0 1 1 0 0 1],1);   % 3 ones
A14 = circulant([1 0 1 0 0 0 0 1],1);   % 3 ones

A21 = circulant([1 0 0 0 0 0 1 0],1);
A22 = circulant([1 0 1 0 0 0 0 0],1);

A23 = circulant([0 0 0 1 0 0 1 1],1);   % 3 ones
A24 = circulant([0 1 0 0 1 0 0 0],1); % 3 ones

A = [A11 A12 A13 A14
     A21 A22 A23 A24];

C1 = [A11 A12
      A21 A22];

C2 = [A13 A14
      A23 A24];

rank(gf(C2,1));
C2gf = gf(C2,1); % modulo 2, to get invers matrix
C2i = inv(C2gf);


P = [C2i*C1];
I_k = eye(K);

H = [ P eye(M)];

GT = [I_k
        P];

u = [ 1 0 0 1 1 0 0 1 0 1 0 1 1 0 1 0];
c = u*GT.'

H*c.'