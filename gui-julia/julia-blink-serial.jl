using LibSerialPort, Interact, Blink, Plots

name = "/dev/ttyACM1";
baudrate = 115200;

sp = LibSerialPort.open(name, baudrate)
sleep(1);
w = Window()

function getfft()
	sp_flush(sp, SP_BUF_BOTH)
	write(sp, "getfft");
	sleep(2.45);
	if bytesavailable(sp) > 0
		x = String(read(sp));
      	z = split(x);
		a = parse.(Float64, z);
	    return a
	else
		sleep(2);
	end
end

function readloop(i=1)
	if i == 1
		signal_at_f = [];
		i = 2;
	end
    try
        while i < 200
         d = getfft();
        end
    catch e
        if e isa InterruptException
            println("ended by user")
		end
		rethrow(e)
		LibSerialPort.close(sp)
	end
	return d
end

gfft = button("Get FFT");

ui = vbox(gfft, mp)
body!(w, ui);

mp = @manipulate for a=d
    y = @. a
    plot(y)
end
