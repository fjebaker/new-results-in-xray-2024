include("common.jl")
using StatsBase

m = KerrMetric(a = 0.99)
x = SVector(0.0, 1000.0, deg2rad(60), 0.0)
d1 = ThinDisc(0.0, 20.0)

pf = ConstPointFunctions.redshift(m, x) ∘
    # filter only those geodesics that intersected with
    # geometry
    ConstPointFunctions.filter_intersected()

α, β, img = rendergeodesics(
  m, x, d1, 2x[2]; 
  pf = pf, verbose = true,
  αlims = (-25, 25),
  βlims = (-15, 20),
  image_width = 800,
  image_height = 800,
  callback = domain_upper_hemisphere(),
)

# make redshift histogram
redshift_data = filter(!isnan, vec(img))

x_bins = range(0.0, 1.4, 28) 
lineprof = StatsBase.fit(Histogram, redshift_data, x_bins)


d2 = ThinDisc(0.0, Inf)

# emissivity data
model1 = LampPostModel(h = 10.0)
emprof1 = emissivity_profile(m, d2, model1; n_samples = 100_000)
model3 = LampPostModel(h = 20.0)
emprof3 = emissivity_profile(m, d2, model3; n_samples = 100_000)

gs = range(0.0, 1.4, 180)
# the transfer functions can be computed once and reused for each but i am lazy
_, flux1 = lineprofile(m, x, d2, emprof1; bins = gs, maxrₑ = 100.0, verbose = true)
_, flux3 = lineprofile(m, x, d2, emprof3; bins = gs, maxrₑ = 100.0, verbose = true)


begin
    fig = Figure(size = (900, 250))
    ga = fig[1,1] = GridLayout()

    ax1 = Axis(ga[1,1], aspect = DataAspect(), title = "Ray-traced image", xlabel = "α", ylabel = "β") 
    # heatmap!(ax1, α, β, img', colormap = :batlow)
    
    xlims!(ax1, -26, 26)
    ylims!(ax1, -15, 19)

    ax2 = Axis(ga[1,2], title = "Redshift Profile", xlabel = "g", ylabel = "Fraction")
    barplot!(ax2, x_bins[1:end-1], lineprof.weights ./ sum(lineprof.weights), color = x_bins[1:end-1], colormap = :batlow)
    
    ga_sub = ga[1,3] = GridLayout()
    ax_mini = Axis(ga_sub[1,1], xscale = log10, yscale = log10, title = "Em. Prof.")    
    hidedecorations!(ax_mini, grid=false)
    space = Axis(ga_sub[2,1], 
        topspinecolor = RGBAf(0.0,0.0,0.0,0.0),
        bottomspinecolor = RGBAf(0.0,0.0,0.0,0.0),
        leftspinecolor = RGBAf(0.0,0.0,0.0,0.0),
        rightspinecolor = RGBAf(0.0,0.0,0.0,0.0),
    )    
    hidedecorations!(space)
    rowsize!(ga_sub, 1, Relative(1/3))
    
    _palette = _default_palette()
    lines!(ax_mini, emprof1.radii, emprof1.ε, color = popfirst!(_palette))
    lines!(ax_mini, emprof3.radii, emprof3.ε ./ 10, color = popfirst!(_palette))

    
    ax3 = Axis(ga[1,4], title = "Line Profile", xlabel = "E / E₀", ylabel = "Flux (arb.)", yaxisposition=:right)
    
    _palette = _default_palette()
    for flux in (flux1, flux3)
        lines!(ax3, gs, flux, color = popfirst!(_palette))
    end

    colsize!(ga, 1, Relative(0.30))
    colsize!(ga, 3, Relative(1/8))
    colgap!(ga, 50)
    

    Makie.save("presentation/figs/raw/building-reflection-profiles-2.svg", fig)
    fig
end