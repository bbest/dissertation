
# Make Animated GIF from Screenshots

1. Take screenshots in Mac with Cmd + Shift + 3, which saves PNG to ~/Desktop/Screen*.png.

1. Get dimensions in PhotoShop from Window > Info (modify units to pixels) and drawing rectangle.

  ```
  [x]x[y]+[ul:x]+[ul:y]
  2038x820+88+670
  ```
  The [x] and [y] in the offset (if present) gives the location of the upper left corner of the cropped image with respect to the original image.

1. Run ImageMagick command after cd.

  ```bash
  convert -delay 100 -loop 0 \
   'Screen*.png[2038x820+88+670]' \
   +repage routing_animation.gif
  ```
