% Create a VISA-GENERIC object.
interfaceObj = instrfind('Type', 'visa-generic', 'RsrcName', 'USB0::0x0699::0x0413::C010681::0', 'Tag', '');
% Create the VISA-GENERIC object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('TEK', 'USB0::0x0699::0x0413::C010681::0');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

interfaceObj.timeout=800;
1
% Create a device object. 
deviceObj = icdevice('tektronix_tds2024.mdd', interfaceObj);

2
% Connect device object to hardware.
connect(deviceObj);
3
% Execute device object function(s).
groupObj = get(deviceObj, 'Waveform');
groupObj = groupObj(1);
n=4
figure
[Y,X] = invoke(groupObj, 'readwaveform', 'channel1');
pause(1)
while 1
[Y,X] = invoke(groupObj, 'readwaveform', 'channel1');

n=n+1
h=plot(X,Y);
pause(1)
end

