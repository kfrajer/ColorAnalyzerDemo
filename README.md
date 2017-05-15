# ColorAnalyzerDemo

A tool that analyzes an image based on a provided mode suplied as a parameter.  It analyzes an image producing a histogram of the chosen color space. Image can be output in linear or log space and normalized to its maximum value or to an arbitrary value.

To Do:
- Fix integer reference working with alpha component in ARGB/AHSB modes. This values should be long instead.
- Generate a convertion algorithm from RGB to HSB space and visceversa.
- Normalize image to provided (arbitrary) value. If zero is provided, normalize it against its maximum value.
- Generate examples: different mode selections and working with multiple images
- Color selector from source image
- Color slider to span selected color
- Image preview based on single or spanned color
- Inversion of  single (spanned) selected color
