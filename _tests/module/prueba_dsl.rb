require_relative '../../view/css_dsl'
extend CSS_DSL

export_as 'test.css', css {

  let color_logo = rgb(10,240,255)

  mixin(:noDecoration) {
    textDecoration none
  }

  # tag

  body {
    color color_logo
    width 500.px
    background {
      width 200.pc      # <--- property anidada
      height 100.em
    }
  }

  # clase sola

  clase1 {
    position absolute
  }

  # id solo

  _id1 {
    textAlign left
  }

  # tag + clase

  div.clase2 {
    color red
  }

  # tag + clase + pseudoclase

  span.clase3( :hover ){
    color rgb(10,240,110)
  }

  # tag + clase + pseudoclase

  li.clase4( :hover) {
    with :noDecoration
    color yellow
  }

  # id + pseudoclase

  _id( :hover ) {
    with :noDecoration
  }
}