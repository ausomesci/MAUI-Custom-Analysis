%% Picking off peaks (Anterograde, Retrograde, and 2nd Anterograde) in MAUI Doppler velocity export

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

%Column information
%1 = frame number
%5 = time
%6 = media-media I2-I7 (cm)
%7 = Top IMT (cm)
%8 = Bottom IMT (cm)
%10 = intima-intima I4-I5 (cm)

frame = data(:,1);
time = data(:,5);
I27 = data(:,6);
% nIMT = data(:,7); %IMT isn't identifiable in brachial artery images, so ignore for now.
% fIMT = data(:,8);
% I45 = data(:,10);

len = length(I27);
timevec = 1:1:len;

%Plot trace to screen data and check peaks. Identify how many cycles you want to analyze
fig0 = figure('Name','Initial check');
plot(time,I27);
numPeaks = str2num(cell2mat(inputdlg('How many cycles are you analyzing?')));

%Find Systolic peaks of I4-I5
fig1 = figure('Name','Systolic Peaks');
set(fig1, 'Position', [50 300 450 300]);
[Syspks,Syspeaklocs] = findpeaks(I27,'MinPeakDistance',20,'NPeaks',numPeaks);
plot(timevec,I27,timevec(Syspeaklocs),Syspks,'or');
hold;
title('Systolic Peaks');
xlabel('Time (sec)');
ylabel('Diameter (cm)');

%Find retrograde peaks
peakDias = I27*-1;          %Flip signal to get the minimums
fig2 = figure('Name','Diastolic Peaks');
xlabel('Time (sec)');
ylabel('Diameter (cm)');
title('Retrograde Peaks');
set(fig2, 'Position', [525 300 450 300]);
[Diaspks,Diaspeaklocs] = findpeaks(peakDias,'MinPeakDistance',20,'NPeaks',numPeaks);
plot(timevec,peakDias,timevec(Diaspeaklocs),Diaspks,'or');
hold;

outmat(:,1) = Syspks;       %Systolic diameter single points
outmat(:,2) = -Diaspks;     %Diastolic diameter single points

sysmean = mean(outmat(:,1));
diasmean = mean(outmat(:,2));
meanmean = mean(I27);

out(1,1) = sysmean; %Average of systolic peaks
out(1,2) = diasmean; %Average of diastolic minimums
out(1,3) = meanmean; %Mean diameter for entire image


%Export if you want
% xlswrite('Diameters_temp.xlsx',outmat);
