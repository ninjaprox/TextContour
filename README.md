TextContour
===========

## What is it?

It is a tool to get contour of text in an image. Images may be from external source as input or created from `UITextView`.

This contour is then used to calibrate font due to difference of text rendering on multiple platforms.

## Why?

Why should it run on iOS? By running on iOS, which is target of the calibration, it can directly and seamlessly create image from `UITextView` with arbitrary font and font size. The flow is described as below:

1. Receive an image of text with specified size, font and font size, which is rendered and created by web engine.
2. Create an `UITextView` with the same information as above.
3. Capture image of the `UITextView`.
4. Get contour of text in both images.
5. Compare two contours, then use the difference to calibrate the font.

## Prerequisite

For resources, i.e. fonts and images:

- The background of image must be white.
- The color of text must be black.
- Only one paragraph is accepted, possibly one or multiple lines.

For resource provider, the folder structure must be as below.

```
[resource-provider] // Any name works.
|
|--- fonts
|--- images

TextContour // The TextContour folder mentioned below is this one.
|
|--- TextContour
     |
     |--- Fonts
     |--- Images
```

On the other hand, resource provider folder and `TextContour` folder are sibling. You do not need to worry about `TextContour` folder, it is already structured itself.

## How does it work?

### Local

To prepare for local run, do the following step:

1. Change working directory to `TextContour`.
2. Run `scripts/add-resources.sh` to add resources to the project.

There are two modes, debug and headless, with `TextContour` and `TextContourTests` scheme respectively. In debug mode, i.e. UI mode, there is only one font loaded, this can be changed by the index of the font in `TextContour/Fonts` folder.

In headless mode, it will go through all fonts in `TextContour/Fonts`, create both contours for iOS and web, and images from `UITextView`. All of these are stored in the path which is logged to the console. The output of headless mode includes:

- `Images` folder contains images created from `UITextView`.
- `contours-ios.json`
- `contours-web.json`

After use, there will be change in `TextContour/Info.plist` and `TextContour.xcodeproj/project.pbxproj`, do not commit these changes.

### CI

`TextContour` can be run on CI to create automation system to calibrate fonts. By default, it is set up with [Bitrise](https://www.bitrise.io) to use out of the box. There are environment variables needed to be set before use.

- `FONT_IMAGE_SERVICE_REPO` // Where to clone resources.
- `S3_BUCKET`
- `S3_ACCESS_ID`
- `S3_ACCESS_SECRET`

The output of this process will be uploaded to S3 bucket specified above, consisting of:

- `offsets.json`
- All images created from `UITextView`.

The same process running on CI can be run on local by using [Bitrise CLI](https://www.bitrise.io/cli).

## Dependency

- [GPUImage](https://github.com/BradLarson/GPUImage)