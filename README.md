# undoc html transformer

## usage

`html.lua undoc-output (OPTIONS) output-dir`

or, using stdin:

`undoc undoc-input | html.lua (OPTIONS) output-dir`

### options

The following options can be changed:

#### title

`--title awesomesauce`

*prepends page titles, adding a dash, eg "awesomesauce - index"*

#### stylesheet

`--stylesheet awesome.css`

*replaces this transformer's default stylesheet with your own*

#### highlightjs

`--highlightjs highlight.js`

*replaces this transformer's default highlight.js configuration with your own*

## building

`html.lua` in the root is a pre-built transformer. However, due to the fact that this transformer embeds many large files such as stylesheets, fonts, and scripts, it is divided into several smaller modules in the `sources` directory.

The final, self-contained `html.lua` is put together with [squish](https://github.com/LuaDist/squish).
