TextContour
===========

## What is it?

It is a prototype that gets contour of text in an image. The image may be from external sources as input or created from `UITextView`.

This contour is then used to calibrate font due to difference of text rendering on multiple platforms.

## Why?

Why should it run on iOS? By running on iOS, which is target of the calibration, it can directly and seamlessly create image from `UITextView` with arbitrary font and font size. The flow can be described as below:

1. Receive an image of text with specified size, font and font size, which is rendered and created by web engine.
2. Create an `UITextView` with the same information as above.
3. Create an image of `UITextView`.
4. Get contour of text in both images.
5. Compare two contours, then use the difference to calibrate the font.

## Prerequisite

- The background of the image must be white.
- The color of the text must be black.
- There must be only one paragraph, possibly one or multiple lines.

## Dependency

- [GPUImage](https://github.com/BradLarson/GPUImage)