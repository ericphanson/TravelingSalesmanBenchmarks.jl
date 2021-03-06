
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
gr(fmt=:svg)
repo_directory = TravelingSalesmanBenchmarks.repo_directory;
data_directory = joinpath(repo_directory, "data");


cities = simple_parse_tsp(joinpath(data_directory, "att48.tsp"), verbose = false)
N = length(cities)
cost = [ ATT(cities[i], cities[j]) for i=1:N, j=1:N ]


t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

c(q) = solve_tsp(cost; quality_factor = q)[2]

qs = range(10, stop = 100, step = 10)

plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="att48.tsp")
for j = 2:5
    plot!(qs, c, label="solve_tsp $j")
end
hline!([c_exact], label="Exact cost")


file = @isdefined(WEAVE_ARGS) ? WEAVE_ARGS[:file] : nothing
TravelingSalesmanBenchmarks.bench_footer(file)

