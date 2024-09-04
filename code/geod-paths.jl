using Gradus, Makie, CairoMakie

m = KerrMetric(M=1.0, a=0.0)
# observer position
x = SVector(0.0, 10000.0, π/2, 0.0)

# set up impact parameter space
α = collect(range(-10.0, 10.0, 20))
β = fill(0, size(α))

# build initial velocity and position vectors
vs = map_impact_parameters(m, x, α, β)
xs = fill(x, size(vs))

sols = tracegeodesics(m, xs, vs, 20000.0)

begin
    fig = Figure(size = (400,400))
    ax = Axis(fig[1,1], aspect = DataAspect(), title = "Schwarzschild") 
    
    for sol in sols.u
        path = Gradus._extract_path(sol, 2048, t_span = 100.0)  
        x = path[1]
        y = path[2]
        
        lines!(ax, x, y)
    end
    
    dim = 17
    Makie.xlims!(ax, -dim,dim)
    Makie.ylims!(ax, -dim,dim)

    R = Gradus.inner_radius(m)

    ϕ = collect(range(0.0, 2π, 100))
    r = fill(R, size(ϕ))

    x = @. r * cos(ϕ)
    y = @. r * sin(ϕ)
    lines!(ax, x, y, color = :black, linewidth = 3.0)

    Makie.save("presentation/figs/raw/schwarzschild.svg", fig)
    fig
end

m = KerrMetric(M=1.0, a=-0.998)

# build initial velocity and position vectors
vs = map_impact_parameters(m, x, α, β)
xs = fill(x, size(vs))

sols = tracegeodesics(m, xs, vs, 20000.0)

begin
    fig = Figure(size = (400,400))
    ax = Axis(fig[1,1], aspect = DataAspect(), title = "Kerr") 
    
    for sol in sols.u
        path = Gradus._extract_path(sol, 2048, t_span = 100.0)  
        x = path[1]
        y = path[2]
        
        lines!(ax, x, y)
    end
    
    dim = 17
    Makie.xlims!(ax, -dim,dim)
    Makie.ylims!(ax, -dim,dim)

    R = Gradus.inner_radius(m)

    ϕ = collect(range(0.0, 2π, 100))
    r = fill(R, size(ϕ))

    x = @. r * cos(ϕ)
    y = @. r * sin(ϕ)
    lines!(ax, x, y, color = :black, linewidth = 3.0)

    Makie.save("presentation/figs/raw/kerr.svg", fig)
    fig
end