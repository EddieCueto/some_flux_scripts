using Statistics

gpucommand = `nvidia-smi`
cpucommand = `powerstat -R -n -d0`
ramcommand = `free`

gpu = read(gpucommand, String);
gpu = split(gpu, "\n")
smis = Array{Any}(undef,length(gpu))
for i in 1:length(gpu)
    smis[i] = filter(x->x≠"",split(gpu[i], " "))
end
gpus = Array{Any}[]
for strings in smis
    if length(strings) > 5 && strings[6] == "/"
        push!(gpus,strings)
    end
end

#test = Array{Any}[]
#for strings in smis 
#    if length(strings) > 1
#        println("$(typeof(string[2])) : $(strings)")
        #if occursin(r"^-?(0|([1-9][0-9]*))(\.[0-9]+)?([eE][-+]?[0-9]+)?$", strings[2])
        #    append!(test,strings)
        #end
#    end
#end

nogpus = length(gpus)

powerdraw = Array{Float32}(undef,nogpus)
powercap = Array{Float32}(undef,nogpus)
for p in 1:nogpus
    
    if gpus[p][5] == "N/A"
        gpus[p][5] = "0.0"
    end
    if gpus[p][7] == "N/A"
        gpus[p][7] = "0.0"
    end
    powerdraw[p] = parse(Float32,gpus[p][5])
    powercap[p] = parse(Float32,gpus[p][7])
end

pwavg = mean(powerdraw)
cpavg = mean(powercap)

println("The power average draw of the GPU's is $(pwavg) / $(cpavg) Watts.")

cpu = read(cpucommand, String);
cpu = split(cpu,"\n")
cpu = cpu[66][60:64]#cpu[66:end-9]#cpu[5:end]

println("The average power draw of the CPU is $cpu Watts.")

ram = read(ramcommand, String);
ram = split(ram,"\n")
ram = split(ram[2]," ")
filter!(x->x≠"",ram)
usedram = parse(Float32,ram[3])
totalram = parse(Float32,ram[2])

println("The amount of power draw of the RAM is ram $(((usedram*1.575)/totalram)*1.904) Watts.")
