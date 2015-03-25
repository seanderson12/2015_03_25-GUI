function testest
%       start(Wave_timer); %daq method
global stop_flag
global h_fid
    

        default_path='\\169.254.13.253\Anderson_Share\test\';
        [file,path] = uigetfile({'*.dat';'*.*'},'Load Dat File',default_path);
        %make path for data file
        h_fid=fullfile(path,file)
        if isequal(h_fid,0)
            disp('File select cancelled')
        end
        
wave_timer_HEKA= timer('Name','ButtonTimer','StartDelay', 0,'Period', 0.5 ,...
                   'ExecutionMode','fixedRate',...
                   'StartFcn','[hwave,Cbox,capacitor]=wave_init();',...
                   'StopFcn','wave_stop(hwave);',...
                   'TimerFcn','wave_show(hwave,Cbox, capacitor);'); 
               

     

start(wave_timer_HEKA);
stop_flag
pause(1)
stop_flag
%tb.TimerFcn = @(x,y)preview(vid,hImage);
end