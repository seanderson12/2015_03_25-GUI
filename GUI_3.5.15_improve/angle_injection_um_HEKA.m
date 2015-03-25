function []= angle_injection_um_HEKA(um_position, z_safe_um, zrefer_um, relativeangle, com_no, Jet_com,move_speed_um,inject_speed_um,delay_time)
global stop_flag
wave_timer_HEKA= timer('Name','ButtonTimer','StartDelay', 0,'Period', 0.5 ,...
                   'ExecutionMode','fixedRate',...
                   'StartFcn','[hwave,Cbox,capacitor]=wave_init();',...
                   'StopFcn','wave_stop(hwave);',...
                   'TimerFcn','wave_show(hwave,Cbox, capacitor);'); 


default_targetpostion=um_position; %   ms_position = [x, y]
default_zrefer=zrefer_um;
default_z_safe=z_safe_um;
default_speed_xyz=move_speed_um;
default_speed_inject=inject_speed_um; 

uicontrol('Style','text',...
        'Position',[460 400 30 15],...
        'String','Info:');

hFeedback=uicontrol('Style','text',...
        'Position',[490 400 60 15],...
        'String','- -');
    

% delete(instrfindall);
% com_name = ['Com',com_no]; 
% s=serial(com_name,'BaudRate',19200);
% fopen(s); set(s, 'TimeOut', 0.02);

%% The cells location that wants angle injection (平移到指定位置)

xposition1 = round(default_targetpostion (1));
yposition1 = round(default_targetpostion (2));
zposition1 = round(default_z_safe);

outputp1_1=num2str(-zposition1);
outputp1_2=num2str(yposition1);
outputp1_3=num2str(-xposition1);

x_v1=default_speed_xyz;
y_v1=default_speed_xyz;
z_v1=default_speed_xyz;



%% move back to get x space for injection. (平移)
zrelative=zposition1-default_zrefer;
xrelative=zrelative/tand(relativeangle);

xposition2=xposition1-xrelative;
yposition2=yposition1;
zposition2=zposition1;

outputp2_1=num2str(round(-zposition2));
outputp2_2=num2str(round(yposition2));
outputp2_3=num2str(round(-xposition2));

x_v2=x_v1;
y_v2=y_v1;
z_v2=z_v1;

outputv2_1=num2str(round(z_v2));
outputv2_2=num2str(round(y_v2));
outputv2_3=num2str(round(x_v2));

delete(instrfindall);
com_name = ['Com',com_no]; 
s=serial(com_name,'BaudRate',19200);
fopen(s); set(s, 'TimeOut', 0.02);
actionmeter_2 = ['C007 ',outputp2_1,' ',outputp2_2,' ',outputp2_3,' ',outputv2_1,' ',outputv2_2,' ',outputv2_3];
fprintf(s,actionmeter_2);

while 1
    info_m_2=fscanf(s);
    if isempty(info_m_2)== 1
        drawnow;
        
    else
        drawnow;
        info_m_2_cut=textscan(info_m_2, '%s %s'); %cut the info into cells
        if     strcmpi(info_m_2_cut{1},'A007')  &&       strcmpi(info_m_2_cut{2},'0') % compare the char, ignore case
            1;
            
        elseif strcmpi(info_m_2_cut{1},'A007')  &&       strcmpi(info_m_2_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A007')  &&       strcmpi(info_m_2_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A007')  &&  8>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A007')  && 16>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_2_cut{1},'A007')  && 32>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_2_cut{1},'A007')  &&    str2double(info_m_2_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_2);
                 
        end
        
        break
    end
end

%%
pause(0.3);
start(wave_timer_HEKA);
zrelative

zlimit_room=4;
x_extend=ones(1,zlimit_room)*(-zrelative)/tand(relativeangle);

z_above=10;
if -zrelative>(z_above+1)
    step_length_z=(-zrelative-z_above):(-zrelative+zlimit_room); %positive
    step_length_x=[((-zrelative-z_above):(-zrelative))/tand(relativeangle),x_extend];%positive
else
    step_length_z=1:(-zrelative+zlimit_room);%positive
    step_length_x=[(1:-zrelative)/tand(relativeangle),x_extend];%positive
end


%% Injection （扎入）
step_count=1;


x_v3=default_speed_inject/tand(relativeangle);
y_v3=y_v2;
z_v3=default_speed_inject;



while stop_flag~=1 && step_count>=length(step_length_z);
xposition3=xposition2-step_length_x(step_count); %xposition2>xposition1 %going to xposition3=xposition1;
yposition3=yposition1;
zposition3=zposition1+step_length_z(step_count);%zrelative is negative, so default_zrefer>zposition1 %going to default_zrefer

outputp3_1=num2str(round(-zposition3));
outputp3_2=num2str(round(yposition3));
outputp3_3=num2str(round(-xposition3));


outputv3_1=num2str(round(z_v3));
outputv3_2=num2str(round(y_v3));
outputv3_3=num2str(round(x_v3));

delete(instrfindall);
com_name = ['Com',com_no]; 
s=serial(com_name,'BaudRate',19200);
fopen(s); set(s, 'TimeOut', 0.02);
actionmeter_3 = ['C007 ',outputp3_1,' ',outputp3_2,' ',outputp3_3,' ',outputv3_1,' ',outputv3_2,' ',outputv3_3];
fprintf(s,actionmeter_3);


while 1
    info_m_3=fscanf(s);
    if isempty(info_m_3)== 1
        drawnow;
        
    else
        drawnow;
        info_m_3_cut=textscan(info_m_3, '%s %s'); %cut the info into cells
        if     strcmpi(info_m_3_cut{1},'A007')  &&       strcmpi(info_m_3_cut{2},'0') % compare the char, ignore case
            1;
            
        elseif strcmpi(info_m_3_cut{1},'A007')  &&       strcmpi(info_m_3_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A007')  &&       strcmpi(info_m_3_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A007')  &&  8>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A007')  && 16>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_3_cut{1},'A007')  && 32>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_3_cut{1},'A007')  &&    str2double(info_m_3_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_3);
                 
        end
        
        break
    end
end
step_count=step_count+1;
end
stop_flag
%% FemtoJet 
delete(instrfindall);
com_name = ['Com',com_no]; 
s=serial(com_name,'BaudRate',19200);
fopen(s); set(s, 'TimeOut', 0.02);
pause(delay_time);

%% poll back (撤回)

xposition4=xposition2;
yposition4=yposition2;
zposition4=zposition2;

outputp4_1=num2str(round(-zposition4));
outputp4_2=num2str(round(yposition4));
outputp4_3=num2str(round(-xposition4));

x_v4=x_v3;
y_v4=y_v3;
z_v4=z_v3;

outputv4_1=num2str(round(x_v4));
outputv4_2=num2str(round(y_v4));
outputv4_3=num2str(round(z_v4));

delete(instrfindall);
com_name = ['Com',com_no]; 
s=serial(com_name,'BaudRate',19200);
fopen(s); set(s, 'TimeOut', 0.02);
actionmeter_4 = ['C007 ',outputp4_1,' ',outputp4_2,' ',outputp4_3,' ',outputv4_1,' ',outputv4_2,' ',outputv4_3];
fprintf(s,actionmeter_4);

while 1
    info_m_4=fscanf(s);
    if isempty(info_m_4)== 1
        drawnow;
        
    else
        drawnow;
        info_m_4_cut=textscan(info_m_4, '%s %s'); %cut the info into cells

        if     strcmpi(info_m_4_cut{1},'A007')  &&       strcmpi(info_m_4_cut{2},'0') % compare the char, ignore case
            1;    
            
        elseif strcmpi(info_m_4_cut{1},'A007')  &&       strcmpi(info_m_4_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A007')  &&       strcmpi(info_m_4_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A007')  &&  8>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A007')  && 16>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_4_cut{1},'A007')  && 32>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_4_cut{1},'A007')  &&    str2double(info_m_4_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_4);
                 
        end
        
        break
    end
    
end

stop(wave_timer_HEKA);

end
