#import "@preview/polylux:0.3.1": *
#import "tamburlaine.typ": *

#let HANDOUT_MODE = false
#enable-handout-mode(HANDOUT_MODE)

#show: tamburlaine-theme.with(aspect-ratio: "4-3")
#show link: item => underline(text(blue)[#item])

#let COLOR_CD = color.rgb("#56B4E9")
#let COLOR_REFL = color.rgb("#D55E00")
#let COLOR_CONT = color.rgb("#0072B2")

#set par(spacing: 0.5em, leading: 0.5em)
#set text(tracking: -0.5pt, size: 22pt)

#let uob_logo = read("./figs/UoB_CMYK_24.svg")

#let todo(item) = text(fill: red, [#item])

#title-slide(
  title_size: 30pt,
  title: [
    #set text(tracking: -3pt)
    #set align(left)
    #move(
      dy: -0.3em,
      text(
        size: 90pt,
        move(dy: -31pt, stack(
          spacing: 4pt,
          move(dx: -43pt, dy: 17pt, [#text(fill: TEXT_COLOR)[Moving out]]),
          move(dx: 0pt, text(size: 60pt, weight: "regular")[ from under the]),
          [lamp#text(weight: "regular")[ post:]#v(40pt)],
          move(dx: 170pt, align(right, text(size: 60pt, [extended corona modelling #v(-20pt)])))
        )
      ))
    )
    #v(0.5em)
  ],
  authors: ([Fergus Baker#super("1")], text(weight: "regular", [Andrew Young#super("1")])),
  where: "New Results in X-ray astronomy",
)[
  #align(right)[#image.decode(uob_logo, width: 20%)]
]

#slide(title: "Context")[
  // new ray tracing code
  // studying the innermost regions of the accreting black hole, right up to event horizon
  // strong gravity regime, when we propagate light in our spectral models, trajectory and indeed travel time of photons is heavily distorted
  // ray tracing codes let us model these systems

  #set align(center)
  #grid(columns: (60%, 1fr),
  [
    #v(1em)
    #image("./figs/gradus_logo.png", width: 40%)
    #align(left)[
    *Gradus.jl*: a new open-source general relativistic ray-tracer in Julia
    #text(size: 13pt)[(Baker & Young, in prep.)]
  ]

    #uncover("4-")[
      #image("./figs/teapot.png", width: 60%)
    ]
  ],
  [
    #v(0.5em)
    #stack(dir: ttb,
    spacing: 20pt,
    uncover("2-")[#image("./figs/schwarzschild.svg", width: 70%)],
    uncover("3-")[#image("./figs/kerr.svg", width: 70%)],
    )
  ],
  [],
  )
]

#slide(title: "A black hole and its crown")[
  // Use an illustration of the corona to delineate all of the key trajectories (continuum, reflection, etc)
  #set text(size: 18pt)
  #v(1em)
  #grid(
    columns: (54%, 1fr),
    [
        #place(
          top + left,
          [
            #uncover("9-")[
            #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
            1. The corona *illuminates* the accretion disc
            2. Illumination gives rise to an *emissivity profile*
            3. The *emissivity profile* depends on the *geometry* of the corona
          ])
          ]
          ]
        )
        #align(horizon, align(center)[
        #v(1em)
        #animsvg(
          read("./figs/lamp-post.traces.svg"),
          (i, im) => only(i)[
            #image.decode(im, width: 100%)
          ],
          (hide:
            ("g238", "g239", "g241", "g240",
             // continuum
             "g251",
             // reflected
             "g255", "g260",
             // returning
             "g249", "g259",
             // reprocessed
             "g250", "g256",
             // continuum
             "g248", "g261",
             // eye
             "g237",
            ),
          ),
          (display: ("g238", "g239", "g241", "g240", "g256")),
          (hide: ("g240", "g238")),
          (hide: ("g241", "g239")),
          (display: ("g250", "g249")),
          (hide: ("g250",), display: ("g259",)),
          (display: ("g237", "g255", "g260")),
          (display: ("g248", "g261")),
          (),
          handout: HANDOUT_MODE,
        )
      ])
    ],
    [
      #set align(right)
      #uncover("2-")[Corona emits *high energy X-ray* spectrum]
      #set text(size: 15pt)
      #uncover("3-")[- Photons that hit the disc are *reprocessed*]
      #uncover("5-")[- Reprocessed emission carries *reflection spectrum*]
      #set align(center)
      #uncover("5-", image("./figs/reflection-spectrum.svg", width: 90%))
      #v(-20pt)
      #uncover("7-", image("./figs/disc-projection.png", width: 80%))
    ]

  )

]

#slide(title: "The corona changes the emissivity of the disc")[
  #v(2em)
  #set text(size: 18pt)
  #grid(
    columns: (45%, 1fr),
    [
        #v(2em)
        #set align(center)
        #animsvg(
          read("./figs/corona-plot.svg"),
          (i, im) => only(i)[
            #image.decode(im, width: 80%)
          ],
          (hide: ("g114", "g115", "g116-3")),
          (display: ("g116-3",)),
          (display: ("g115",)),
          (display: ("g114",)),
          (),
          (),
          handout: HANDOUT_MODE,
        )
        #v(1em)
    ],
    [
      #v(1em)
        #animsvg(
          read("./figs/emissivity-and-time.svg"),
          (i, im) => only(i)[
            #image.decode(im, width: 100%)
          ],
          (hide: ("g370", "g371", "g372", "g373", "g374", "g375", "g227", "g312")),
          (display: ("g372",)),
          (display: ("g371",)),
          (display: ("g370", "g369")),
          (display: ("g373", "g374", "g375", "g227", "g312")),
          (),
          handout: HANDOUT_MODE,
        )
    ],
  )
  #v(1em)
  #uncover("4-")[
    Emissivities are sensitive to the *geometry of the corona* (Gonzalez et al., 2017).
  ]
  #v(0.5em)
  #uncover("6-")[
  Observe *steep emissivity profile* (e.g. Fabian et al., 2004)
  - Can be fitted by the *lamp post* model (e.g. Wilkins & Fabian, 2012)
  - Does not accurately explain the observed *variability* (Cackett et al., 2021)
  ]

  // What the emissivity is, how it depends on geometry, the evidence that we have
  // for the steep emissivity profile (Fabian paper), that the LP is not favoured
  // by polarization measurements
]


#slide(title: "Modelling efforts")[
  #set text(size: 20pt)
  // Focus on modelling *reflection spectra*:
  #v(1.5em)
  #align(center)[
    #image("./figs/building-reflection-profiles.svg", width: 81%)
  ]
  #set text(size: 18pt)

  #grid(
    columns: (50%, 1fr),
    column-gutter: 20pt,
    [
      #uncover("2-")[
      Projection pre-computed using *Cunningham transfer functions* (Cunningham, 1975)
      - Histogram binning becomes *two-dimensional integral* over the disc
      ]
    ],
    [
      #uncover("3-")[
      Works well for *lamp post* model thanks to *high degree of symmetry*
      - Various short cuts for computing *emissivity* of point-sources
      ]
    ]
  )

  #v(1em)

  #align(center)[
    #uncover("4-")[
    Approach starts to break down for *extended coronae*
  ]
  ]

  #v(1em)
  #uncover("5-")[
  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Key challenge: *extended coronae* no longer on-axis symmetric
    - Emissivity profile becomes *time dependent*: $epsilon(r) arrow.r epsilon(r, t)$
    - No point-source short cuts: resort to *Monte Carlo* methods
  ])
  ]

  // Problems associated with modelling extended coronae
  // - symmetries of the lamp post make it easier to exploit
  // - list some of the other methods that people have used
]

#slide(title: "Extended models")[
  #v(1em)
  // other models that people have created
    #set text(size: 20pt)
  Extended coronal geometry in reverberation modelling:
  #v(1em)
  #grid(columns: (60%, 1fr),
    row-gutter: 10pt,
    column-gutter: 20pt,
    [
      - *Two lamp post* model (e.g. Chainakun & Young, 2017, Lucchini et al., 2023)
    ], [
      #image("./figs/chainakun_young_2017.png", width: 90%)
    ],
    [
      - Towards general *extended sources* (*Wilkins et al., 2016*)
    ],
    [
      #image("./figs/wilkins_et_al_2014.png", width: 90%)
    ]
  )
]


#slide(title: "Decomposing extended coronae")[
  #set text(size: 18pt)
  #grid(
    columns: (60%, 1fr),
    [
      #animsvg(
        read("./figs/extended.traces-export.svg"),
        (i, im) => only(i + 1)[
          #image.decode(im, width: 90%)
        ],
        (),
        (hide: ("g126",), display: ("g142",)),
        (display: ("g143", "g133")),
        (),
        handout: HANDOUT_MODE,
      )
      #v(1.5em)
      #uncover("4-")[
      Sweep 2D plane on an axis to calculate the continuous arrival time $t_("corona" arrow.r "disc")$ for a *ring on the disc*
    ]
    ],
    [
      #v(1em)
      Split volume into *discs* of height $delta h$
      - Each disc split into *annuli* $(x, x + delta x)$
      - From *symmetry*, treat the annulus as an *off-axis point*
      #align(center)[
        #image("./figs/decomposition.svg", width: 80%)
      ]
      - Weight contribution of each annulus by its *volume* $tilde 2 pi x delta x delta h$
    ]
  )

  #v(2em)
  #uncover("5-")[
  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Consequence of off-axis point is each *ring on the disc* has a *continuous, time-dependent emissivity*

  ])]

  // How we split an extended model into concentric annuli, and treat each
  // individually
]

#slide(title: "Time dependent emissivity")[
  #set text(size: 18pt)
  For a *single, off-axis point source*, calculate the *emissivity* $epsilon_i (r, t)$ for each annulus $i$:

  #grid(
    columns: (60%, 1fr),
    [
      #align(center)[
        #image("./figs/time-dep-emissivity.png", width: 80%)
      ]
    ],
    [
      #v(2em)
      Two separate annuli, one at $x = 3 r_"g"$ (green-pink), another at $x = 11 r_"g"$ (purple-orange).
    ]
  )

  #uncover("2-")[
  Combine (i.e. $plus.circle$) all $epsilon_i (r, t)$ to calculate *disc-like corona*:
  #grid(
    columns: (60%, 1fr),
    [
      #align(center)[
        #image("./figs/time-dep-emissivity-disc.png", width: 80%)
      ]
    ],
    [
      #v(2em)
      Combine all *emissivity functions* between $x = 0 r_"g"$ and $x = 11 r_"g"$.

      #v(2em)

      #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
        Emissivity variations on the timescale on tens of $t_"g"$
      ])
    ]
  )
  ]
  // How we deal with the time dependence
]

#slide(title: "Putting it back together")[
  *Time-averaged* the emissivity and we can calculate *line profiles*:
  #v(0.3em)


  #grid(
    columns: (65%, 1fr),
    column-gutter: 20pt,
    [
      #align(center)[
        #image("./figs/extended-line-profiles.svg", width: 100%)
      ]
    ],
    [
      #set align(horizon)
      #uncover("2-")[
      #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
        Overall effect: *increases flux* contribution around $E \/ E_"0" = 1$
      ])
      ]
    ]
  )

  #set text(size: 18pt)
  #grid(
    columns: (1fr, 65%),
    column-gutter: 20pt,
    [
      #set align(horizon)
      #uncover("3-")[
      Is effect degenerate with other parameters, e.g. *observer inclination* or *corona height*?
      ]

      #uncover("4-")[
      #v(1em)
      #text(size: 15pt)[All figures to the right are for $x=20 r_"g"$]
      ]
    ],
    [
      #uncover("4-")[
      #align(center)[
        #image("./figs/extended-line-profiles-changing.svg", width: 100%)
      ]
      ]
    ]
  )
]

#slide(title: "What about timing?")[
  We developed a method using *time-dependent Cunningham transfer functions* for quickly computing timing features such as *reverberation lags*
  - Approach takes calculations from $cal(O)(1" s")$ to $cal(O)(1" ms")$
  // figures
  // Reverberation results and the impact on lags
  #grid(
    columns: (50%, 1fr),
    [
      #image("figs/extended-transfer-comparison.png")

      #v(0.5em)
      #set align(center)
      #cbox(fill: PRIMARY_COLOR, width: 90%, text(fill: SECONDARY_COLOR)[
        #set text(size: 18pt)
        #set align(left)
        Main effects:
        - *Increases* the *low frequency* lag
        - *Dilutes* the *high frequency* lag
        - *Dilutes* the low energy lag
      ])
    ],
    [
      #image("figs/extended-comparison.svg")
    ],
  )

  #v(1em)

  But similar things happen for the *continuum component*...

]

#slide(title: "Next steps")[

  #grid(
    columns: (50%, 1fr),
    [
      #v(2em)
      Modelling the effect on the *continuum component*:
    ],
    [
      #image("./figs/continuum.transfer-function.png")
      #h(2em)#text(size: 15pt)[Left: 45$degree$ #h(1fr) Right: 75$degree$]#h(2em)
    ]
  )

  Modelling various *coronal geometries*: e.g. slab / columns / opaque and translucent

  #grid(
    columns: (50%, 1fr),
    [
      #v(0.5em)
      Coupling disc and coronal physics: propagating *source fluctuations* within the corona.
    ],
    [
      #set align(center)
      #v(-0.5em)
      #image("./figs/propagation.svg", width: 50%)
    ]
  )

  #v(1fr)
  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Our main goal: provide the *tooling* to make these types of explorations *tractable*.
  ])
  #v(1em)
]

#slide(title: "Thank you")[
    #v(1em)
  #align(center)[
  #cbox(fill: PRIMARY_COLOR, width: 90%, text(fill: SECONDARY_COLOR)[
    == Summary
    #align(left)[
      Gradus.jl can efficiently compute *extended cornae*
      - Construct models that are *performant enough* for parameter fitting
      #v(0.5em)
      *Extended coronae* have *time-dependent* emissivity profiles
      - Timescale of variations on the order of 10s of $t_"g"$
      - Disk-like coronae increase reflection spectral spectrum flux around $E\/E_0 = 1$
    ]
  ])
  ]
  #v(1em)
  #set text(size: 18pt)
  Gradus.jl source code (GPL-3.0):
  - https://github.com/astro-group-bristol/Gradus.jl
  #v(0.5em)
  Documentation:
  - https://astro-group-bristol.github.io/Gradus.jl/
  #v(0.5em)
  Source for slides and figures:
  - https://github.com/fjebaker/new-results-in-xray-2024
  #v(0.5em)
  #align(right)[
  Contact: \
  #link("fergus.baker@bristol.ac.uk")
  ]
]
