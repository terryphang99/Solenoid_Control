clear
fs = 8192;
s_duration = 5;
duration = 0.5;
frequency = 20;
tr = duration; %time interval
totalstep = 10;
start_phrase = 0.5*pi;
end_phrase = 1.5*pi;

t = 0:1/fs:duration;
t_s = 0:1/fs:s_duration;
t1 = start_phrase/(2*pi*frequency):1/fs:end_phrase/(2*pi*frequency);

mask = sin(2*pi*frequency*t);
mask_s = sin(2*pi*frequency*t_s);
mask_p = sin(2*pi*frequency*t1);
mask_w = zeros(length(t),1);

abs_sin = abs(mask);
abs_sin2 = mask;
for i = 1:length(mask)
    if mask(i) < 0
        abs_sin2(i) = 0;
    end
end

for j = 1:fs*duration
    tt = mod(j,fs/frequency);
    if tt < 0.5*fs/frequency
        rect(j)=1;
        rect2(j)=1;
    else
        rect(j)=-1;
        rect2(j)=0;
    end
end

saw = sawtooth(2*pi*frequency*t);
tria = sawtooth(2*pi*frequency*t, 0.5);

% saw_up1 = linspace(0,1,fs/frequency/4);
% saw_up2 = linspace(-1,0,fs/frequency/4);
% saw_down1 = linspace(1,0,fs/frequency/4);
% saw_down2 = linspace(0,-1,fs/frequency/4);
% for j = 1:fs*duration
%     tt = mod(j,fs/frequency);
%     tt = floor(tt/(fs/frequency/4));
%     temp = mod(j,fs/frequency/4);
%     switch tt
%         case 0
%             
%         case 1
%         case 2
%         case 3
%         otherwise
%             disp('0')
%     end
%     if tt <= 0.25*fs/frequency
%         saw(j)=saw_up1(temp);
%         saw2(j)=saw_up1(temp);
%     else if (tt <= 0.5*fs/frequency) & (tt > 0.25*fs/frequency)
%         rect(j)=-1;
%         rect2(j)=0;
%     else if
%                 
%     end
% end



% for i = 1:length(t)
%     idx = mod(i,length(t1)+tr*fs);
%     if idx < length(t1)
%         mask_w(i) = mask_p(idx);
%     end
% end

s_sounddata(:,2)=mask_s;
s_sounddata(:,1)=0;

sounddata(:,2)=mask;
sounddata(:,1)=0;

% sound(s_sounddata);
% pause(s_duration+1);

for i = 1:totalstep
    sound(sounddata);
    pause(duration+tr);
end