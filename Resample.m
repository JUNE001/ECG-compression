function [data] = Resample(edata,ifreq,sfreq)
% Ifreq :the resampling frequency, sfreq :the original sampling frequency
f = ifreq;
g = sfreq;
count = 1;
gv0 = 0;
gv1 = 0;
k = 1;
%% Get the least common multiple

while (f - g)  > 0.005 || (f - g) < -0.005
    if (f > g) 
        f = f-g; 
    else 
        g = g-f;
    end
    mticks = round(sfreq/f); %
    nticks = round(ifreq/f);
    mnticks = mticks * nticks; % 
    gvtime = 0;
    rgvtime = nticks; % 
end
%% Resample

[edatalen,~] = size(edata);
while count < edatalen
if  rgvtime > mnticks

    rgvtime = rgvtime - mnticks;
    gvtime  = gvtime - mnticks;
end
while gvtime > rgvtime && count < edatalen

    gv0 = gv1; % 
    gv1 = edata(count); 
    count = count + 1;
    rgvtime = rgvtime + nticks;
end

data(k) = gv0 + mod(gvtime,nticks)*(gv1-gv0)/nticks ; %
k = k+1;
gv0 = gv1;
gvtime = gvtime + mticks; % 
end
end