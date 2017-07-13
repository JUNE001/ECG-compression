clear;clc; close all;  
load A.mat;
load 1;                                           
x = double(data1061); 
%% Resample
ifreq = 1000;
sfreq = 360;
x = Resample(x,ifreq,sfreq);
x = x';
%% Filter
%Lowpass
N  = 8;    % Order
Fc = 40;  % Cutoff Frequency
Fs = 1000;  % Sampling Frequency
% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');
x = filter(Hd,x);
% Bandstop filter
N  = 6;
Fc1 = 49;
Fc2 = 51;
[b,a] = bandstopfilter(Fs,N,Fc1,Fc2);
x = filter(b,a,x);
%Median filter
L1 = 1000*0.3;
L2 = 1000*0.6;
approach = 'md';
baseline = filtbwdmm(x',L1,L2,approach);
x = x - baseline';

%% CS and BSBL
[a,b] = size(x);                                              %Get the size of the signal
Phi = A;                                                      
[M,N] = size(Phi);                                            
blkLen = 20;                                                
groupStartLoc = 1:blkLen:N;                                 
X = zeros(1,rdnum);                                           
XX = zeros(1,a);
%     XX=zeros(1,rdnum);                                          
i = 1;                                                        
A = zeros(M,N);
for n = 1:M
A(n,:) = dct(Phi(n,:));
end
% =========================== Sliding window ====================
tic;
    while (i<=a-N+1)                                            
        X = x(i:i+N-1);                                           
        y = Phi * X;                                            
        if ~any(X(:))  % 判断向量是否是全0矩阵
           XX(i:i+N-1) = X';
         else
            Result1 =  BSBL_BO(A,y,groupStartLoc,0,'prune_gamma',-1, 'max_iters',20); 

            XX(i:i+N-1) = idct(Result1.x);                                
            clear Result1;                                           
        end
        i = i+N;     
    end
t_bo2 = toc;
%% Output


XX = XX';
disp(['ONE :',num2str((norm(x-XX))/norm(x))]);                                                                     %
disp(['运行时间:',num2str(t_bo2)]);


 