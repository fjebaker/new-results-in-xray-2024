import Random
include("common.jl")

function trace_corona_trajectories(
    m::AbstractMetric,
    d::AbstractAccretionGeometry,
    model;
    callback = domain_upper_hemisphere(),
    sampler = EvenSampler(BothHemispheres(), GoldenSpiralGenerator()),
    n_samples = 74,
    kwargs...,
)
    xs, vs, _ = Gradus.sample_position_direction_velocity(m, model, sampler, n_samples)
    tracegeodesics(
        m,
        xs,
        vs,
        d,
        1000;
        callback = callback,
        kwargs...,
    )
end

m = KerrMetric(1.0, 0.5)
d = ShakuraSunyaev(m; eddington_ratio = 0.1)
dim = 26

model1 = LampPostModel(h = 5.0, θ = 0.001)
traj1 = trace_corona_trajectories(m, d, model1)
model2 = LampPostModel(h = 10.0, θ = 0.001)
traj2 = trace_corona_trajectories(m, d, model2)
model3 = LampPostModel(h = 20.0, θ = 0.0001)
traj3 = trace_corona_trajectories(m, d, model3)

function is_intersected(sol) 
    intersected = (sol.prob.p.status[] == StatusCodes.IntersectedWithGeometry)
    if intersected
        return sol.u[end][2] < 21
    end
    false
end

begin
    fig = Figure(size = (800, 600))
    ax = Axis3(
        fig[1, 1],
        aspect = (1, 1, 1),
        limits = (-dim, dim, -dim, dim, -dim, dim),
        elevation = π / 23, #π / 12,
        azimuth = -deg2rad(65),
        viewmode = :fitzoom,
        xgridvisible = false,
        ygridvisible = false,
        zgridvisible = false,
        xlabelvisible = false,
        ylabelvisible = false,
        xspinewidth = 0,
        yspinewidth = 0,
        zspinewidth = 0,
    )
    hidedecorations!(ax)

    R = Gradus.inner_radius(m)
    bounding_sphere!(ax; R = R, color = :black)

    for r in range(Gradus.isco(m), 24.0, step = 3)
        plotring(ax, r; height = cross_section(d, r),  horizon_r = R, color = :black, dim = dim)
    end

    _palette = _default_palette()
    for traj in (traj1, traj2, traj3)
        c = popfirst!(_palette)
        for sol in filter(is_intersected, traj.u)
            plot_sol(
                ax,
                sol;
                color = c,
                horizon_r = R,
                dim = dim,
                show_intersect = false,
            ) 
        end
    end
    
    coronae = (model1, model2, model3)
    _palette = _default_palette()
    cs = map(coronae) do i
        scatter!(ax, [0], [0], [i.h], markersize = 15, color = popfirst!(_palette))
    end
    
    Legend(fig[1, 2], [cs...], ["h=5", "h=10", "h=20"])

    Makie.save("presentation/figs/raw/corona-plot.pdf", fig)
    fig
end
