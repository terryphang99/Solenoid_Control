clear
fs = 8192;
tr = 2; %time interval
td = 2;
frequency = 20;

duration = 1;
totalstep = 10;

t = 0:1/fs:duration;
mask = sin(2*pi*frequency*t);
slen = length(mask);

sounddata1 = zeros(slen,2);
sounddata2 = zeros(slen,2);

sounddata1(:,2)=mask;
sounddata2(:,1)=mask;

for i = 1:totalstep
    sound(sounddata1);
    pause(duration+tr);
    sound(sounddata2);
    pause(duration+tr);
end