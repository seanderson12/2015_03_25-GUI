function wave_show(hwave,Cbox, capacitor_out)
global h_fid
global stop_flag
%% location of the dat
fid = fopen(h_fid,'r');
%testing for read data in float 32.
capacitor_info = fread(fid,'float32');
% want the last 50-20 points 
duration=1;
capacitor_info=capacitor_info(end-duration*10000-3:end-duration*10000);
capacitor_current=mean(capacitor_info);
fclose(fid);

%% Show
set(0, 'CurrentFigure', hwave);
critical_percentage=0.02;
if (1+critical_percentage) >(capacitor_current/capacitor_out) && (capacitor_current/capacitor_out) > (1-critical_percentage) && stop_flag==0
    hold off
    plot([0,1],[capacitor_out,capacitor_out]);
    hold on
    plot(0.5, capacitor_current,'r*')
    stop_flag=0;
    set(gca,'YLim',[0,1.3*capacitor_current])
else
    plot([0,1],[0,1.3*capacitor_current]);
    hold on
    plot([0,1],[1.3*capacitor_current,0]);
    stop_flag=1;
end
set(Cbox,'String',['C is: ', num2str(capacitor_current)]);

end