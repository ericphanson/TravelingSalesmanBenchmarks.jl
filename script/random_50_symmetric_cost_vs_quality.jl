
using TravelingSalesmanExact, GLPK
using TravelingSalesmanHeuristics
using TravelingSalesmanExact: ATT, euclidean_distance
using TravelingSalesmanBenchmarks
using Plots
gr(fmt=:svg)
repo_directory = TravelingSalesmanBenchmarks.repo_directory;
data_directory = joinpath(repo_directory, "data");


N = 50
cost = 100*rand(N, N)
cost = (cost + transpose(cost) )/2


t_exact, c_exact = get_optimal_tour(cost, with_optimizer(GLPK.Optimizer))

c(q) = solve_tsp(cost; quality_factor = q)[2]

qs = range(10, stop = 100, step = 10)

plot(qs, c, xlabel="quality", ylabel="Cost", label="solve_tsp 1", title="random symmetric cost matrix")
for j = 2:5
    plot!(qs, c, label="solve_tsp $j")
end
hline!([c_exact], label="Exact cost")


TravelingSalesmanBenchmarks.bench_footer(WEAVE_ARGS[:file])

