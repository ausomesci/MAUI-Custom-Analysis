%Picking off peaks (Anterograde, Retrograde, and 2nd Anterograde) in MAUI Doppler velocity export

close all;
clear all;


%Select the individual file
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

%Analysis Parameters: How many cycles are you analyzing? Do you want to threshold out low velocity noise?
numPeaks = str2num(cell2mat(inputdlg('How many cycles are you analyzing?')));
AntThres = str2num(cell2mat(inputdlg('What is the error threshold for anterograde velocities?')));
RetThres = str2num(cell2mat(inputdlg('What is the error threshold for retrograde velocities?')));

%Minimum distance between peaks (to handle late diastolic flow profile). Maybe be adjusted
minDist = 100;

close;

%Find anterograde peaks
fig1 = figure('Name','Anterograde Peaks');
set(fig1, 'Position', [50 300 450 300]);
%From peak velocity enveloppe trace
[peakpks,peaklocs] = findpeaks(tpeak,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',AntThres);
plot(time,tpeak,time(peaklocs),peakpks,'or');
hold;
%From mean velocity trace
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
%From peak velocity enveloppe trace
[peakretpks,peakretlocs] = findpeaks(peakret,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',RetThres);
plot(time,peakret,time(peakretlocs),peakretpks,'or');
hold;
%From mean velocity trace
[meanretpks,meanretlocs] = findpeaks(meanret,'MinPeakDistance',minDist,'NPeaks',numPeaks,'MinPeakHeight',RetThres);
plot(time,meanret,time(meanretlocs),meanretpks,'or');
title('Retrograde Peaks');
xlabel('Time (sec)');
ylabel('Blood velocity (cm/s)');


out(1,1) = mean(tmean);         %Mean blood velocity from mean velocity trace
out(1,2) = mean(meanpks);       %Average of anterograde peaks from mean velocity trace
out(1,3) = mean(-meanretpks);   %Average of retrograde peaks from mean velocity trace
out(1,4) = mean(tpeak);         %Mean blood veloicty from peak velocity trace
out(1,5) = mean(peakpks);       %Average of anterograde peaks from peak velocity trace
out(1,6) = mean(-peakretpks);   %Average of retrograde peaks from peak velocity trace


%Export to excel if you want
% xlswrite('LBNP_30_Peaks.xlsx',outmat);
