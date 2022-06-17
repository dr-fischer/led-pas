using LibSerialPort, Plots

name = "/dev/ttyACM0";
baudrate = 115200;

sp = LibSerialPort.open(name, baudrate)
sleep(1);

function getfft()
	sp_flush(sp, SP_BUF_BOTH)
	write(sp, "getfft");
	sleep(2.45);
	if bytesavailable(sp) > 0
		x = String(read(sp));
	    return x
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
          y = getfft();
          z = split(y);
          a = parse.(Float64, z);
          l = length(a);
          x = ((1:l)  .+ 3037.0 ) .* (8096.0/16384.0) .- 6.5;
		  # signal_at_f[1:(end-1)] = signal_at_f[2:(end-1)];

		  if length(signal_at_f) > 999
			  signal_at_f[1:999] = signal_at_f[2:1000];
			  signal_at_f[1000] = a[500];
		  else
	  		  signal_at_f = vcat(signal_at_f, a[500]);
		  end
          p1 = bar(x, a, legend = false, linecolor=1, xlab = "Frequency (Hz)", ylab = "S (arb.)", color = :green, fillcolor = :green)
		  p2 = plot(1:length(signal_at_f), signal_at_f, label = signal_at_f[end], xlabel = "N", ylabel = "S-532 at F (arb.)", color = :green)
		  display(plot(p1, p2, layout = (2, 1)))
		  sleep(0.05)
        end
    catch e
        if e isa InterruptException
            println("ended by user")
		end
		rethrow(e)
		LibSerialPort.close(sp)
	end
	
end

readloop()
