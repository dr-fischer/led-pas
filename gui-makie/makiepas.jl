using Makie
using GLMakie
using DataStructures: CircularBuffer
using LibSerialPort

list_ports()
portname = "/dev/ttyACM0"
baud = 115200

function getFFT(port; baud = 115200)
    serdat = ""
    LibSerialPort.open(portname, baud) do sp
        # set_read_timeout(sp, timeout)
        sleep(0.01)
        write(sp, "fft")
        sleep(0.01)
        serdat = readuntil(sp, "!!!!")
        close(sp)
    end
    serdat = split.(serdat, "\r\n")
    serdat = split.(serdat, ", ")
    x = ones(length(serdat)-1)
    y = ones(length(serdat)-1)
    for i in 1:length(serdat)-1
        x[i] = parse(Float64, serdat[i][1])
        y[i] = parse(Float64, serdat[i][2])
    end
    return [x y]
end

function getMagAtF(fftdat, f)
    return fftdat[findall(isapprox(f), fftdat[:, 1]), 2]
end

fres = 1370
bufferlength = 500

# setup observables
fftdat = getFFT(portname)
x = Observable(fftdat[:, 1])
y = Observable(fftdat[:, 2])
t = CircularBuffer{Float64}(bufferlength);
fill!(t, Float64(0))
t = Observable(t)
mag = CircularBuffer{Float64}(bufferlength);
fill!(mag, Float64(0))
mag = Observable(mag)

# setup Makie figure
fig = Figure()
display(fig)
axs = [Axis(fig[j, 1]) for j in 1:2]

# add data to figure
barplot!(axs[1], x, y, color = :blue)
lines!(axs[2], t, mag, linewidth = 2, color = :blue)
DataInspector(fig)

# add axis labels
axs[1].xlabel = "Frequency (Hz)"
axs[1].ylabel = "Magnitude"
axs[2].xlabel = "Elapsed Time (seconds)"
axs[2].ylabel = "Magnitude at $(fres) Hz"
xlims!(axs[1], 400, 4000)
ylims!(axs[1], 0, maximum(fftdat[:, 2])*1.2)

i = 1
while true
    
    # empty circular buffer and reset to 0
    if i == 1
        empty!(t[])
        fill!(t[], Float64(0))
    end

    # get new data and push to observables
    fftdat = getFFT(portname)
    x[] = fftdat[:, 1]
    y[] = fftdat[:, 2]
    push!(t[], i)
    t[] = t[]
    push!(mag[], getMagAtF(fftdat, fres)[1])
    mag[] = mag[]

    # autoscale axis limts
    if i < bufferlength
        xlims!(axs[2], t[][bufferlength-i], t[][bufferlength])
        ylims!(axs[2], minimum(mag[][bufferlength-i+1:end])/1.2, maximum(mag[])*1.1)
    else
        xlims!(axs[2], t[][1], t[][bufferlength])
        ylims!(axs[2], minimum(mag[][1:end])/1.2, maximum(mag[])*1.1)
    end

    # increment iterator count
    i += 1
end