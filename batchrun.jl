#!/usr/bin/env julia
###
### Running network social evolution simulations in batch using SLURM
###

### Edited Sep19 11:32am (after running the sims) to separate the part that defines the
### parameter range into a separate .jl file, to use that information in the script
### reading off and plotting the data

include("params.jl")

## this loop takes each combination of parameter sets and writes a sbatch shell script for passing it along
for p in 1:nsets

    simstr = "./main.jl "

    # create filename base from basename and run number
    numstr = lpad(string(p), length(string(nsets)), "0")
    filebase = basename * numstr

    # add parameter values as command line options
    simstr *= join( map( (x) -> "--" * x[1] * "=" * string(x[2]) , zip(parnames, parsets[p])), " ")
    simstr *= " --file=" * filebase

    #make a list of the argument to be passed on to main.jl
    arguments = ["sbatch", "--job-name", "network_coop_" * numstr, "--output", basename * string(p)* ".out", "--wrap", simstr]

    # run(`$arguments`)
    print(arguments)

end
