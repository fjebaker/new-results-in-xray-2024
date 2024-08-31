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

#slide(title: "A black hole and its crown")[
  Introduce the main players: the central singularity, the accretion disc, and the corona
  - some figure illustrating the various corona models
]

#slide(title: "An illustrative corona")[
  // Use an illustration of the corona to delineate all of the key trajectories (continuum, reflection, etc)

  #grid(
    columns: (58%, 1fr),
    align(horizon, align(center)[
      #v(2em)
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
    ]),
    [Hello World]
  )

]

#slide(title: "The corona changes the emissivity of the disc")[
  What the emissivity is, how it depends on geometry, the evidence that we have
  for the steep emissivity profile (Fabian paper), that the LP is not favoured
  by polarization measurements
]

#slide(title: "Modelling efforts")[
  Problems associated with modelling extended coronae
  - symmetries of the lamp post make it easier to exploit
  - list some of the other methods that people have used
]

#slide(title: "Decomposing extended coronae")[
  How we split an extended model into concentric annuli, and treat each
  individually
]

#slide(title: "Time dependent emissivity")[
  How we deal with the time dependence
]

#slide(title: "Putting it back together")[
  Reconstructing the full extended corona, how the emissivity function is used with Cunninham transfer functions, models that can be efficiently pre-computed and are fast enough to fit
]

#slide(title: "Illustrative results")[
  Reconstructing the full extended corona, how the emissivity function is used with Cunninham transfer functions, models that can be efficiently pre-computed and are fast enough to fit
]

#slide(title: "What about timing?")[
  Reverberation results and the impact on lags
]

#slide(title: "Next steps")[
  Start modelling interplay between disc and corona (seed photons): propagating fluctuations and seed photons into the corona
  - modelling the blurred continuum spectrum
]

#slide(title: "Thank you")[
  #set align(horizon)
  Links, acknowledgements, etc.
]
