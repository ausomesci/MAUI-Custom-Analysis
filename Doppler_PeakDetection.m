%Picking off peaks (Anterograde, Retrograde, and 2nd Anterograde) in MAUI Doppler velocity export

close all;
clear all;


%Open the individual file
[filename,pathname] = uigetfile('*.*');
path = char(pathname);
[row,files_selected] = size(filename);
filename = cellstr(filename);

    
tempfile = char(filename);
disp(tempfile);

data = xlsread(tempfile);

%Excel Sheet Details
%1 = frame number
%2 = time
%10 = peak anterograde velocity
%11 = mean anterograde velocity
%12 = mean retrograde velocity
%13 = peak retrograde velocity
%14 = peak all velocity
%15 = mean all velocity

frame = data(:,1);
time = data(:,2); %in quad for each interpolated velocity
peakANT = data(:,10);
meanANT = data(:,11);
meanRET = data(:,12);
peakRET = data(:,13);
tpeak = data(:,14);
tmean = data(:,15);

len = length(tpeak);
timevec = 1:1:len;

%Plot to check
fig0 = figure('Name','Initial check');
plot(time,tpeak);
hold;
plot(time,tmean);

%Analysis Parameters
numPeaks = str2num(cell2mat(inputdlg('How many cycles are you analyzing?')));
AntThres = str2num(cell2mat(inputdlg('What is the error threshold for anterograde velocities?')));
RetThres = str2num(cell2mat(inputdlg('What is the error threshold for retrograde velocities?')));
% BPM = questdlg('What is the approximate heart rate?','Heart rate','60 bpm','100 bpm','140 bpm','60 bpm');
% switch BPM
%     case '60 bpm'
%         hr = 60;
%     case '100 bpm'
%         hr = 100;
%     case '140 bpm'
%         hr = 140;
% end
% fps = 25; %Have to check the default on the Mindray
% minDist = (fps*60)/hr; %Something isn't working here

minDist = 100;

close;

%Find anterograde peaks
fig1 = figure('Name','Anterograde Peaks');
set(fig1, 'Position', [50 300 450 300]);

[peakpks,peaklocs] = findpeaks(tpeak,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',AntThres);
plot(time,tpeak,time(peaklocs),peakpks,'or');
hold;

[meanpks,meanlocs] = findpeaks(tmean,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',AntThres);
plot(time,tmean,time(meanlocs),meanpks,'or');
title('Anterograde Peaks');
xlabel('Time (sec)');
ylabel('Blood velocity (cm/s)');

%Find retrograde peaks
peakret = tpeak*-1;
meanret = tmean*-1;

fig2 = figure('Name','Retrograde Peaks');
xlabel('Time (sec)');
ylabel('Blood velocity (cm/s)');
set(fig2, 'Position', [525 300 450 300]);
[peakretpks,peakretlocs] = findpeaks(peakret,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',RetThres);
plot(time,peakret,time(peakretlocs),peakretpks,'or');
hold;

[meanretpks,meanretlocs] = findpeaks(meanret,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',RetThres);
plot(time,meanret,time(meanretlocs),meanretpks,'or');
title('Retrograde Peaks');
xlabel('Time (sec)');
ylabel('Blood velocity (cm/s)');

%Find second anterograde peaks
peak2ant = tpeak;
lenpeakpks = length(peakpks);
peakthreshold = (sum(peakpks)/lenpeakpks)/2;
largepeaks = find(abs(tpeak)>peakthreshold);
peak2ant(largepeaks) = NaN;

mean2ant = tmean;
lenmeanpks = length(meanpks);
meanthreshold = (sum(meanpks)/lenmeanpks)/2;
largemeans = find(abs(tmean)>meanthreshold);
mean2ant(largemeans) = NaN;

fig3 = figure('Name','2nd Anterograde Peaks');
set(fig3, 'Position', [1000 300 450 300]);
[peak2antpks,peak2antlocs] = findpeaks(peak2ant,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',0);
plot(time,peak2ant,time(peak2antlocs),peak2antpks,'or');
hold;

[mean2antpks,mean2antlocs] = findpeaks(mean2ant,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',0);
plot(time,mean2ant,time(mean2antlocs),mean2antpks,'or');
title('2nd Anterograde Peaks');
xlabel('Time (sec)');
ylabel('Blood velocity (cm/s)');

% outmat(:,1) = peakpks;      %Anterograde peak blood velocity single points
% outmat(:,2) = meanpks;      %Anterograde mean blood velocity single points
% outmat(:,3) = -peakretpks;  %Retrograde peak blood velocity single points
% outmat(:,4) = -meanretpks;  %Retrograde mean blood velocity single points
% outmat(:,5) = peak2antpks;  %2nd Ant peak blood velocity single points
% outmat(:,6) = mean2antpks;  %2nd Ant mean blood velocity single points

out(1,1) = mean(tmean);
out(1,2) = mean(meanpks);
out(1,3) = mean(-meanretpks);
out(1,4) = mean(mean2antpks);
out(1,5) = mean(tpeak);
out(1,6) = mean(peakpks);
out(1,7) = mean(-peakretpks);
out(1,8) = mean(peak2antpks);

%% Fix 2nd ant peak
out(1,4) = mean(realmean2(:,2));
out(1,8) = mean(realpeak2(:,2));

% xlswrite('LBNP_30_Peaks.xlsx',outmat);