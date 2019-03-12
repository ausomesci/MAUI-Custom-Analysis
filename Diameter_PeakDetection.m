%Picking off peaks (Anterograde, Retrograde, and 2nd Anterograde) in MAUI Doppler velocity export
%Click 'Run' and select the MAUI diameter export file with your data. The
%code with read in column 6 (media-media) to pull off maximum and minimum
%arterial diameters, and export them to a separate excel file


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

%1 = frame number
%5 = time
%6 = media-media I2-I7 (cm)
%7 = Top IMT (cm)
%8 = Bottom IMT (cm)
%10 = intima-intima I4-I5 (cm)

frame = data(:,1);
time = data(:,5);
I27 = data(:,6);
% nIMT = data(:,7);
% fIMT = data(:,8);
% I45 = data(:,10);

len = length(I27);
timevec = 1:1:len;

%Plot trace to screen data and check peaks
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

out(1,1) = sysmean;
out(1,2) = diasmean;
out(1,3) = meanmean;

%%
out(1,1) = mean(realsys(:,2));
out(1,2) = -mean(realdias(:,2));
out(1,3) = mean(meand(:,2));

% xlswrite('Diameters_temp.xlsx',outmat);