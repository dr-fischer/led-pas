using LibSerialPort, FFTW, DSP, Plots, FileIO, OffsetArrays, PlutoUI, WAV
name = "/dev/ttyACM0"
baudrate = 115200

function getfft(s)
	
	LibSerialPort.open(name, baudrate) do sp
	sleep(0.5)

	write(sp, s)
	sleep(2)
	
	if bytesavailable(sp) > 0
		x = String(read(sp))
	end
		
    return x
	end
end

yb = getfft("getfft")

y = String(yb)

z = split(y)

a = parse.(Float64, z)

l=length(a)

x = ((1:l)  .+ 3775.0 ) .* (8096.0/16384.0) .- 8


display(plot(x, a, legend = false, linecolor=1, xlab = "Frequency (Hz)", ylab = "Magnitude (mV)", xlims = [1860, 1880]))

