function []=tb_timer()
tp= timer('Name','ButtonTimer','StartDelay', 0,'Period', 0.5 ,...
           'ExecutionMode','fixedRate',...
           'StartFcn','[hwave,hdevice,Cbox]=wave_init();',...
           'StopFcn','wave_stop(hwave,hdevice);',...
           'TimerFcn','[capacitor]=wave_show(hwave,hdevice,Cbox,capacitor);'); 


    function [hwave,hdevice]=wavestart(hObject,event)
            hwave=figure(50);
            %device initial
            device=daq.getDevices;

            %%
            %create session
            hdevice=daq.createSession('ni');
            %add channel from 'myDAQ1'
            %ai=analoginput

            addAnalogInputChannel(hdevice,'myDAQ1', 0:1, 'Voltage');

            %s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage')


            %%
            % Will run for s.DurationInSeconds (0.1) second (2000 scans) 
            % eg. at 20000 scans/second.
            hdevice.Rate=40000;
            hdevice.DurationInSeconds=0.002
            %s.Channels.Range=[-2 2];

            %%
            %configure channel property
            tc=hdevice.Channels(1);

            %setting the property
            set(tc)
            tc.Coupling = 'DC'; %'DC' or 'AC'
            tc.TerminalConfig = 'Differential'; 
 
    end

    function waveshow(hObject,event,hwave)
            set(0, 'CurrentFigure', hwave);
            
            %device initial
            device=daq.getDevices;

            %%
            %create session
            s=daq.createSession('ni');
            %add channel from 'myDAQ1'
            %ai=analoginput

            addAnalogInputChannel(s,'myDAQ1', 0:1, 'Voltage');

            %s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage')


            %%
            % Will run for s.DurationInSeconds (0.1) second (2000 scans) 
            % eg. at 20000 scans/second.
            s.Rate=40000;
            s.DurationInSeconds=0.002
            %s.Channels.Range=[-2 2];

            %%
            %configure channel property
            tc=s.Channels(1);

            %setting the property
            set(tc)
            tc.Coupling = 'DC'; %'DC' or 'AC'
            tc.TerminalConfig = 'Differential'; 
    end

%tb.TimerFcn = @(x,y)preview(vid,hImage);
end