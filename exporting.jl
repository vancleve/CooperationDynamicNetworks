using StatsBase
using Plots
using FileIO
gr()

## Parameter object
struct NetworkParam

    pn::Float64
    pr::Float64
    netsize::Int64
    generations::Int64
    b::Float64
    c::Float64
    d::Float64
    mu::Float64
    evollink::Bool
    mulink::Float64
    sigmapn::Float64
    sigmapr::Float64
    clink::Float64
    retint::Int64
    funnoevollink::String
    funevollink::String
    delta::Float64
    payfun::String
    replicates::Int64

    # Constructor. Takes keyword arguments to make it easier to call with command line arguments
	NetworkParam(;pn::Float64=0.5, pr::Float64=0.1, netsize::Int64=100, generations::Int64=100,
				  b::Float64=1.0, c::Float64=0.5, d::Float64=0.0, mu::Float64=0.01, evollink::Bool=false,
				  mulink::Float64=0.0, sigmapn::Float64=0.05, sigmapr::Float64=0.01,clink::Float64=0.0,
				  retint::Int64=0, funnoevollink::String="Coauthor", funevollink::String="Coauthor",
				  delta::Float64=1.0, payfun::String="Lin", replicates::Int64=1, networksaveint::Int64=1) = new(pn, pr, netsize, generations, b, c, d, mu, evollink, mulink, sigmapn, sigmapr, clink, retint, funnoevollink, funevollink, delta, payfun, replicates, networksaveint)


end

dum = []

# load the file with the parameter ranges for this simulation.
include("params.jl")
reps=parvals[19][1]

means=zeros(7,nsets*reps)

for i in 1:nsets
	for j in 1:reps
    		dum=load("data"*lpad(string(i),length(string(nsets)),0)*"-"*lpad(string(j),length(digits(reps)),"0")*".jld2")
    		means[:,(i-1)*10+j]=[dum["params"].b, dum["params"].c, dum["params"].d, dum["params"].clink, mean(dum["typehist"][20000:100000]),  mean(dum["pn"][20000:100000]),  mean(dum["pr"][20000:100000])]
	end
end

writecsv("./dataexport/means.csv",means)
