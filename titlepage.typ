//! Titlepage definition.


#import "locale.typ" as locale
#import "utils.typ": newpage


#let emptyline(count: 1) = {
  for _ in range(count) {
    linebreak()
    parbreak()
  }
}


/// Prints the titlepage of the document, including its backpage.
///
/// - author (str): Author full name.
/// - date (datetime): Presentation date.
/// - language (str): Language of the cover.
/// - title (str): Thesis title.
/// - type-of-thesis (str): Thesis type.
/// - date-format (str): Format syntax (see https://typst.app/docs/reference/foundations/datetime/#format)
/// - degree (str): Thesis degree/master.
/// - school (str): School.
/// - department (str): Department.
/// - location (str): Presentation location.
/// - advisors (array): Array of advisor names (`str`).
/// - license (bool): Whether to include a CC BY-NC-ND 4.0 license.
/// - accent-color (color): Accent color for the page.
/// - double-sided (bool): Whether to use double-sided pages.
/// - title-font (str, auto): Font of the title.
/// - font-size (lenght): Font size.
///
/// -> content
#let titlepage(
  author,
  date,
  language,
  title,
  type-of-thesis,
  date-format,
  degree,
  school,
  department,
  location,
  advisors,
  accent-color,
  license: true,
  title-font: auto,
  font-size: 12pt,
) = {
  // general configuration
  set page(
    margin: (x: 0.98in, y: 0.79in),
    header: [],
    footer: [],
  )
  set par(justify: false, leading: 0.5em, spacing: 1.5em)
  show link: set text(black)

  set text(size: font-size, fill: accent-color, hyphenate: false)
  if title-font != auto {
    set text(font: title-font)
  }
  set align(center)

  // logo
  v(.7cm)
  image("img/logo-udima.jpg", height: 2.5in)

  v(1.7em)

  [UNIVERSIDAD A DISTANCIA DE MADRID]
  linebreak()
  [(UDIMA)]

  parbreak()

  emph[#locale.SCHOOL.at(language) #school]
  linebreak()
  emph[#locale.DEPARTMENT.at(language) #department]

  parbreak()

  emph(degree)

  parbreak()
  emptyline(count: 2)

  {
    set text(size: 14pt)

    text(
      weight: "semibold",
      style: "italic",
      upper(title),
    )

    parbreak()
    v(-.2em)

    underline(strong(author))

    parbreak()

    emptyline(count: 2)

    v(-.6em)

    strong(upper(type-of-thesis))

    parbreak()
    v(-.2em)

    // advisors
    locale.ADVISOR.at(language)
    parbreak()

    for advisor in advisors {
      underline(advisor)
      linebreak()
    }

    parbreak()
  }

  emptyline(count: 2)
  v(-1em)

  upper(location)
  linebreak()

  // date
  // currently, Typst doesn't support localization for the format syntax
  if (language != "en" and date-format.contains("[month repr:long]")) {
    date-format = date-format.replace(
      "[month repr:long]",
      locale.MONTHS.at(language).at(date.month() - 1),
    )
  }

  date.display(date-format)

  // license
  if license {
    place(
      bottom + left,
      {
        set text(fill: black, size: 0.5em)
        set par(justify: false)
        box(width: 60%, {
          image("img/creativecommons.png", width: 3.5cm)
          v(0.05em)
          locale.CC-LICENSE.at(language)
        })
      },
    )
  }
}
