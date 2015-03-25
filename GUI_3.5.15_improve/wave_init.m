function [hwave,CapacitorTextBox, capacitor_out]=wave_init()
global stop_flag
global h_fid
stop_flag=0;

%% location of the dat
fid = fopen(h_fid,'r');
%testing for read data in float 32.
capacitor_info = fread(fid,'float32');
% want the last 50-20 points 
duration=1;
capacitor_info=capacitor_info(end-duration*10000-10:end-duration*10000);
capacitor_out=mean(capacitor_info)

%% Figure
hwave=figure();
set(hwave, 'MenuBar', 'none');
set(hwave, 'ToolBar', 'none');
set(hwave,'Position',[950 500 250 150]);
CapacitorTextBox= uicontrol('style','text');
set(CapacitorTextBox,'Position',[80 -135 100 150]);
set(CapacitorTextBox,'String','C is: ------');

end
