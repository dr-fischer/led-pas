using LibSerialPort, Plots

function readloop()
    sprt = "/dev/ttyACM0";
    br  = 9600;
    s = LibSerialPort.open(sprt, 9600)
    i = 1;
    n = 1;
    x = zeros(10)
    try
        while i < 2
            if bytesavailable(s) > 0
                x[1:9] = x[2:10];
                x[10] = (parse(Float64, readline(s)));
                display(plot(x, xlab = "Time", ylab = "Signal", xlims = [0, 10], ylims = [0, ceil.(maximum(x))], legend = false))
            end
            sleep(0.05)
        end
    catch e
        if e isa InterruptException
            println("ended by user")
            LibSerialPort.close(s)
            rethrow(e)
        end
    end
end

readloop()

