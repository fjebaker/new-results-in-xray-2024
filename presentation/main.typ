#import "@preview/polylux:0.3.1": *
#import "tamburlaine.typ": *

#let HANDOUT_MODE = true
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

#slide(title: "A black hole and its crown")[
  Introduce the main players: the central singularity, the accretion disc, and the corona
  - some figure illustrating the various corona models
  - an example iron line spectrum

  Cannot directly observe these systems apart from in 2 cases
]

#slide(title: "An illustrative corona")[
  // Use an illustration of the corona to delineate all of the key trajectories (continuum, reflection, etc)
  #set text(size: 18pt)
  #v(1em)
  #grid(
    columns: (54%, 1fr),
    [
        #place(
          top + left,
          [
            1. The corona *illuminates* the accretion disc
            2. Illumination gives rise to an *emissivity profile*
            3. *Reflected emission* depends on the *geometry* of the corona
          ]
        )
        #align(horizon, align(center)[
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
  #set text(size: 18pt)
  Observe *steep emissivity profile* (e.g. Fabian et al., 2004)
  - Phenomenologically described with a broken power law; can be well-fitted by the lamp post model (e.g. Wilkins & Fabian, 2012)
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
          handout: HANDOUT_MODE,
        )
    ],
    [
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
          handout: HANDOUT_MODE,
        )
    ],
  )

  #grid(
    columns: (45%, 1fr),
    [
      #v(1em)
      Emissivities are sensitive to the *geometry of the corona*.
      - The *reflection fraction* can be used to disambiguate similar emissivity profiles (Gonzalez et al., 2017).
    ],
    [
      #text(fill: red)[TODO: figure showing what happens when the corona is extended. Use to motivate the problems with computing extended sources]
    ]
  )
  // What the emissivity is, how it depends on geometry, the evidence that we have
  // for the steep emissivity profile (Fabian paper), that the LP is not favoured
  // by polarization measurements
]


#slide(title: "Extended models")[
  // other models that people have created
]

#slide(title: "Modelling efforts")[
  #set text(size: 20pt)
  Focus on modelling *reflection spectra*:
  #v(1em)
  #align(center)[
    #image("./figs/building-reflection-profiles.svg", width: 81%)
  ]
  #set text(size: 18pt)

  #grid(
    columns: (50%, 1fr),
    column-gutter: 20pt,
    [
      Projection pre-computed using *Cunningham transfer functions* (Cunningham, 1975)
      - Histogram binning becomes *two-dimensional integral* over the disc
    ],
    [
      Works well for *lamp post* model thanks to *high degree of symmetry*
      - Various short cuts for computing *emissivity* of point-sources
    ]
  )

  #v(1em)

  #align(center)[
    Approach starts to break down for *extended coronae*
  ]

  #v(1em)

  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Key challenge: *extended coronae* no longer on-axis symmetric
    - Emissivity profile becomes *time dependent*: $epsilon(r) arrow.r epsilon(r, t)$
    - No point-source short cuts: resort to *Monte Carlo* methods (too slow to fit to data)
  ])

  // Problems associated with modelling extended coronae
  // - symmetries of the lamp post make it easier to exploit
  // - list some of the other methods that people have used
]

#slide(title: "Decomposing extended coronae")[
  #set text(size: 18pt)
  #grid(
    columns: (60%, 1fr),
    [
      #animsvg(
        read("./figs/extended.traces-export.svg"),
        (i, im) => only(i)[
          #image.decode(im, width: 90%)
        ],
        (),
        (hide: ("g126",), display: ("g142",)),
        (display: ("g143", "g133")),
        handout: HANDOUT_MODE,
      )
      #v(1.5em)
      Sweep 2D plane on an axis to calculate the continuous arrival time $t_("corona" arrow.r "disc")$ for a *ring on the disc*
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

  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Consequence of off-axis point is each *ring on the disc* has a *continuous, time-dependent emissivity*
  ])

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
      #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
        Overall effect: *increases flux* contribution around $E \/ E_"0" = 1$
      ])
    ]
  )

  #set text(size: 18pt)
  #grid(
    columns: (1fr, 65%),
    column-gutter: 20pt,
    [
      #set align(horizon)
      Is effect degenerate with other parameters, e.g. *observer inclination* or *corona height*?

      #v(1em)
      #text(size: 15pt)[All figures to the right are for $x=20 r_"g"$]
    ],
    [
      #align(center)[
        #image("./figs/extended-line-profiles-changing.svg", width: 100%)
      ]
    ]
  )
]

#slide(title: "What about timing?")[
  We developed a method using *time-dependent Cunningham transfer functions* for quickly computing timing features such as *reverberation lags*
  - Approach takes calculations from $cal(O)(1" s")$ to $cal(O)(1" ms")$
  // figures
  // Reverberation results and the impact on lags
]

#slide(title: "Next steps")[
  #grid(
    columns: (50%, 1fr),
    [
      We have models for how the *continuum spectrum* is distorted in an extended corona:
    ]
  )


  Started fitting some of these models to data (in prep.)

  Can model interplay between disc and corona (seed photons): propagating fluctuations and seed photons into the corona
  - modelling the blurred continuum spectrum

  #v(1fr)
  #cbox(fill: PRIMARY_COLOR, width: 100%, text(fill: SECONDARY_COLOR)[
    Our main goal: provide the *tooling* to make these types of explorations *tractable*.
  ])
  #v(1em)
]

#slide(title: "Thank you")[
  #set align(horizon)
  Links, acknowledgements, etc.
]
