
%% QC-LDPC z_i solver over GF(2)
clc; clear;

n = 511;


% Taken from CCSDS 131.0 chapter 7
a11  = zeros(1,n);  a11([0+1 176+1])   = 1;
a21  = zeros(1,n);  a21([99+1 471+1])  = 1;

a115 = zeros(1,n);  a115([0+1 247+1])  = 1;
a116 = zeros(1,n);  a116([36+1 261+1]) = 1;
a215 = zeros(1,n);  a215([51+1 382+1]) = 1;
a216 = zeros(1,n);  a216([192+1 414+1])= 1;

% turn into circulant vectors of binary numbers
% these are for 
A11  = gf(circulant(a11), 1);
A21  = gf(circulant(a21), 1);

% This is used for D, keep all in mod2
A115 = gf(circulant(a115),1);
A116 = gf(circulant(a116),1);
A215 = gf(circulant(a215),1);
A216 = gf(circulant(a216),1);

% build block matrices, to solve for B
D = [A115 A116;
     A215 A216];
% and here all the M's can be done at somepoint
M = [A11;
     A21];

% And now we start doing something more crazy.
% - This here is the first collum of M that we want.
% - and we do that bu this vector of [1 0 ... 0]
u = gf(zeros(n,1),1);
u(1) = 1;
% This is just a way to get the first collumn of M
rhs = M * u;              % 1022 × 1 (GF(2))

% per 131, 511 and 1022 are supposed to be 0
cols = setdiff(1:1022, [511 1022]);
Dred = D(:, cols);        % 1022 × 1020

% solve the reduced system
zred = Dred \ rhs;        % unique solution in GF(2)


% re-insert 0, that was taken away
zT = gf(zeros(1022,1),1);
zT(cols) = zred;

% turn the 2x511 vector into 512, for hex conversion:
bi1  = zT(1:511);          % 511×1 GF column vector
bi1 = [gf(0,1); bi1];     % 512×1 GF column vector (prepend zero safely)
bi2  = zT(512:1022);       % 511×1 GF column vector
bi2 = [gf(0,1);bi2];

% Turn hexstring into binary to check if it is correct.
hexStr1 = '55BF56CC55283DFEEFEA8C8CFF04E1EBD9067710988E25048D67525426939E2068D2DC6FCD2F822BEB6BD96C8A76F4932AAE9BC53AD20A2A9C86BB461E43759C';
c_gf1 = hex2binVec(hexStr1, true);
hexStr2 = '6855AE08698A50AA3051768793DC238544AF3FE987391021AAF6383A6503409C3CE971A80B3ECE12363EE809A01D91204F1811123EAB867D3E40E8C652585D28';
c_gf2 = hex2binVec(hexStr2, true);

%check if it is correct
c1 = bi1 + c_gf1;          % addition in GF(2) = XOR
c2 = bi2 + c_gf2;

% This is too see if there are any non zero elements. Aka we failed
nnz(c1.x)
nnz(c2.x)

%%
function binVec = hex2binVec(hexStr, returnGF)

    if nargin < 2
        returnGF = false;
    end

    hexStr = char(hexStr);

    % Convert entire string at once
    decVals = hex2dec(hexStr(:));
    binMat = dec2bin(decVals,4);

    % Convert to numeric column vector
    binVec = reshape(binMat.',[],1) - '0';

    if returnGF
        binVec = gf(binVec,1);
    end
end


%{





n = 511;
% Taken from CCSDS 131.0 chapter 7
a11  = zeros(1,n);  a11([0+1 176+1])   = 1;
a21  = zeros(1,n);  a21([99+1 471+1])  = 1;

a115 = zeros(1,n);  a115([0+1 247+1])  = 1;
a116 = zeros(1,n);  a116([36+1 261+1]) = 1;
a215 = zeros(1,n);  a215([51+1 382+1]) = 1;
a216 = zeros(1,n);  a216([192+1 414+1])= 1;

% turn into circulant vectors of binary numbers
% these are for 
A11  = gf(circulant(a11), 1);
A21  = gf(circulant(a21), 1);

% This is used for D, keep all in mod2
A115 = gf(circulant(a115),1);
A116 = gf(circulant(a116),1);
A215 = gf(circulant(a215),1);
A216 = gf(circulant(a216),1);

D = [A115 A116
     A215 A216];

inv_d = rref(D)

M = [A11
    A12];

%}