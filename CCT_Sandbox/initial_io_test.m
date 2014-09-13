config_io;
address = 8224;
bits = [1 2 4 8 16 32 64 128];

for b = 1:8;
    test = bits(b);
    outp(address,test);
    WaitSecs(1);
    outp(address,0);
    WaitSecs(.5);
end

outp(address,1);
WaitSecs(.05);
outp(address,3);
WaitSecs(1);
%outp(address,3);
outp(address,0);
