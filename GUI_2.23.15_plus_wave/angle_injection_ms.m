function []= angle_injection_ms (ms_position, z_safe_ms, zrefer_ms, relativeangle, com_no, Jet_com,move_speed_ms,inject_speed_ms,delay_time)

default_targetpostion=ms_position; %   ms_position = [x, y]
default_zrefer=zrefer_ms;
default_z_safe=z_safe_ms;
default_speed_xyz=move_speed_ms;
default_speed_inject=inject_speed_ms; 

uicontrol('Style','text',...
        'Position',[460 400 30 15],...
        'String','Info：');

hFeedback=uicontrol('Style','text',...
        'Position',[490 400 60 15],...
        'String','- -');
    

% delete(instrfindall);
% com_name = ['Com',com_no]; 
% s=serial(com_name,'BaudRate',19200);
% fopen(s); set(s, 'TimeOut', 0.02);

%% move to a place to that wants angle injection (平移到指定位置)

xposition1 = round(default_targetpostion (1));
yposition1 = round(default_targetpostion (2));
zposition1 = round(default_z_safe);

outputp1_1=num2str(-zposition1);
outputp1_2=num2str(yposition1);
outputp1_3=num2str(-xposition1);

x_v1=default_speed_xyz;
y_v1=default_speed_xyz;
z_v1=default_speed_xyz;

outputv1_1=num2str(round(z_v1));
outputv1_2=num2str(round(y_v1));
outputv1_3=num2str(round(x_v1));

% delete(instrfindall);
% com_name = ['Com',com_no]; 
% s=serial(com_name,'BaudRate',19200);
% fopen(s);
% set(s, 'TimeOut', 0.02);
% actionmeter_1 = ['C006 ',outputp1_1,' ',outputp1_2,' ',outputp1_3,' ',outputv1_1,' ',outputv1_2,' ',outputv1_3];
% fprintf(s,actionmeter_1);
% 
% 
% while 1 
%     drawnow
% 
%     info_m_1=fscanf(s);
%     if isempty(info_m_1)== 1
%          drawnow
%     else
%         info_m_1_cut=textscan(info_m_1, '%s %s'); %cut the info into cells
%         if     strcmpi(info_m_1_cut{1},'A006')  &&       strcmpi(info_m_1_cut{2},'0') % compare the char, ignore case
%             1;
%             
%         elseif strcmpi(info_m_1_cut{1},'A006')  &&       strcmpi(info_m_1_cut{2},'1')
%             set(hFeedback,'string','STOPPED for hitting z upper limit ');
%                  
%         elseif strcmpi(info_m_1_cut{1},'A006')  &&       strcmpi(info_m_1_cut{2},'2')
%             set(hFeedback,'string','STOPPED for hitting z lower limit ');
%                  
%         elseif strcmpi(info_m_1_cut{1},'A006')  &&  8>str2double(info_m_1_cut{2}) && str2double(info_m_1_cut{2}) >=4
%             set(hFeedback,'string','STOPPED for hitting y lower limit ');
%                  
%         elseif strcmpi(info_m_1_cut{1},'A006')  && 16>str2double(info_m_1_cut{2}) && str2double(info_m_1_cut{2}) >=8
%             set(hFeedback,'string','STOPPED for hitting y upper limit ');   
%                        
%         elseif strcmpi(info_m_1_cut{1},'A006')  && 32>str2double(info_m_1_cut{2}) && str2double(info_m_1_cut{2}) >=16
%             set(hFeedback,'string','STOPPED for hitting x upper limit '); 
%                  
%         elseif strcmpi(info_m_1_cut{1},'A006')  &&    str2double(info_m_1_cut{2}) >= 32
%             set(hFeedback,'string','STOPPED for hitting x lower limit ');
%                 
%         else
%             set(hFeedback,'string',info_m_1);
%                  
%         end
%         
%         break
%     end
% end

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
fopen(s); 
set(s, 'TimeOut', 0.02);
actionmeter_2 = ['C006 ',outputp2_1,' ',outputp2_2,' ',outputp2_3,' ',outputv2_1,' ',outputv2_2,' ',outputv2_3];
fprintf(s,actionmeter_2);

while 1 
    info_m_2=fscanf(s);
    if isempty(info_m_2)== 1
        drawnow;
        
    else
        drawnow;
        info_m_2_cut=textscan(info_m_2, '%s %s'); %cut the info into cells
        if     strcmpi(info_m_2_cut{1},'A006')  &&       strcmpi(info_m_2_cut{2},'0') % compare the char, ignore case
            1;
            
        elseif strcmpi(info_m_2_cut{1},'A006')  &&       strcmpi(info_m_2_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A006')  &&       strcmpi(info_m_2_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A006')  &&  8>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_2_cut{1},'A006')  && 16>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_2_cut{1},'A006')  && 32>str2double(info_m_2_cut{2}) && str2double(info_m_2_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_2_cut{1},'A006')  &&    str2double(info_m_2_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_2);
                 
        end
        
        break
    end
end

%% Injection （扎入）

xposition3=xposition1;
yposition3=yposition1;
zposition3=default_zrefer;

outputp3_1=num2str(round(-zposition3));
outputp3_2=num2str(round(yposition3));
outputp3_3=num2str(round(-xposition3));

x_v3=default_speed_inject/tand(relativeangle);
y_v3=y_v2;
z_v3=default_speed_inject;

outputv3_1=num2str(round(z_v3));
outputv3_2=num2str(round(y_v3));
outputv3_3=num2str(round(x_v3));

delete(instrfindall);
com_name = ['Com',com_no]; 
s=serial(com_name,'BaudRate',19200);
fopen(s); 
set(s, 'TimeOut', 0.02);
actionmeter_3 = ['C006 ',outputp3_1,' ',outputp3_2,' ',outputp3_3,' ',outputv3_1,' ',outputv3_2,' ',outputv3_3]
fprintf(s,actionmeter_3);


while 1 
    info_m_3=fscanf(s);
    if isempty(info_m_3)== 1
         drawnow;
        
    else
        drawnow;
        info_m_3_cut=textscan(info_m_3, '%s %s'); %cut the info into cells
        if     strcmpi(info_m_3_cut{1},'A006')  &&       strcmpi(info_m_3_cut{2},'0') % compare the char, ignore case
            1;
            
        elseif strcmpi(info_m_3_cut{1},'A006')  &&       strcmpi(info_m_3_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A006')  &&       strcmpi(info_m_3_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A006')  &&  8>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_3_cut{1},'A006')  && 16>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_3_cut{1},'A006')  && 32>str2double(info_m_3_cut{2}) && str2double(info_m_3_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_3_cut{1},'A006')  &&    str2double(info_m_3_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_3);
                 
        end
        
        break
    end
end

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
fopen(s); 
set(s, 'TimeOut', 0.02);
actionmeter_4 = ['C006 ',outputp4_1,' ',outputp4_2,' ',outputp4_3,' ',outputv4_1,' ',outputv4_2,' ',outputv4_3];
fprintf(s,actionmeter_4);

while 1 
    info_m_4=fscanf(s);
    if isempty(info_m_4)== 1
         drawnow;
        
    else
        drawnow;
        info_m_4_cut=textscan(info_m_4, '%s %s'); %cut the info into cells
        if     strcmpi(info_m_4_cut{1},'A006')  &&       strcmpi(info_m_4_cut{2},'0') % compare the char, ignore case
            1;
            
        elseif strcmpi(info_m_4_cut{1},'A006')  &&       strcmpi(info_m_4_cut{2},'1')
            set(hFeedback,'string','STOPPED for hitting z upper limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A006')  &&       strcmpi(info_m_4_cut{2},'2')
            set(hFeedback,'string','STOPPED for hitting z lower limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A006')  &&  8>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=4
            set(hFeedback,'string','STOPPED for hitting y lower limit ');
                 
        elseif strcmpi(info_m_4_cut{1},'A006')  && 16>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=8
            set(hFeedback,'string','STOPPED for hitting y upper limit ');   
                       
        elseif strcmpi(info_m_4_cut{1},'A006')  && 32>str2double(info_m_4_cut{2}) && str2double(info_m_4_cut{2}) >=16
            set(hFeedback,'string','STOPPED for hitting x upper limit '); 
                 
        elseif strcmpi(info_m_4_cut{1},'A006')  &&    str2double(info_m_4_cut{2}) >= 32
            set(hFeedback,'string','STOPPED for hitting x lower limit ');
                
        else
            set(hFeedback,'string',info_m_4);
                 
        end
        
        break
    end
end

%% move to original positon

% xposition5=xposition1;
% yposition5=yposition1;
% zposition5=zposition1;
% 
% outputp5_1=num2str(round(-zposition5));
% outputp5_2=num2str(round(yposition5));
% outputp5_3=num2str(round(-xposition5));
% 
% x_v5=x_v2;
% y_v5=y_v2;
% z_v5=z_v2;
% 
% outputv5_1=num2str(round(x_v5));
% outputv5_2=num2str(round(y_v5));
% outputv5_3=num2str(round(z_v5));
% 
% delete(instrfindall);
% com_name = ['Com',com_no]; 
% s=serial(com_name,'BaudRate',19200);
% fopen(s); set(s, 'TimeOut', 0.02);
% actionmeter_5 = ['C006 ',outputp5_1,' ',outputp5_2,' ',outputp5_3,' ',outputv5_1,' ',outputv5_2,' ',outputv5_3];
% fprintf(s,actionmeter_5);
% 
% 
% while 1 drawnow
%     info_m_5=fscanf(s);
%     if isempty(info_m_5)== 1
%          
%         
%     else
%         info_m_5_cut=textscan(info_m_5, '%s %s'); %cut the info into cells
%         if     strcmpi(info_m_5_cut{1},'A006')  &&       strcmpi(info_m_5_cut{2},'0') % compare the char, ignore case
%             1;
%             
%         elseif strcmpi(info_m_5_cut{1},'A006')  &&       strcmpi(info_m_5_cut{2},'1')
%             set(hFeedback,'string','STOPPED for hitting z upper limit ');
%                  
%         elseif strcmpi(info_m_5_cut{1},'A006')  &&       strcmpi(info_m_5_cut{2},'2')
%             set(hFeedback,'string','STOPPED for hitting z lower limit ');
%                  
%         elseif strcmpi(info_m_5_cut{1},'A006')  &&  8>str2double(info_m_5_cut{2}) && str2double(info_m_5_cut{2}) >=4
%             set(hFeedback,'string','STOPPED for hitting y lower limit ');
%                  
%         elseif strcmpi(info_m_5_cut{1},'A006')  && 16>str2double(info_m_5_cut{2}) && str2double(info_m_5_cut{2}) >=8
%             set(hFeedback,'string','STOPPED for hitting y upper limit ');   
%                        
%         elseif strcmpi(info_m_5_cut{1},'A006')  && 32>str2double(info_m_5_cut{2}) && str2double(info_m_5_cut{2}) >=16
%             set(hFeedback,'string','STOPPED for hitting x upper limit '); 
%                  
%         elseif strcmpi(info_m_5_cut{1},'A006')  &&    str2double(info_m_5_cut{2}) >= 32
%             set(hFeedback,'string','STOPPED for hitting x lower limit ');
%                 
%         else
%             set(hFeedback,'string',info_m_5);
%                  
%         end
%         
%         break
%     end
% end



end
