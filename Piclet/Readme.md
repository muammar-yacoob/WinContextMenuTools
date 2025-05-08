# <img src="../res/icons/piclet.ico" height="100" style="vertical-align: middle;"> <span style="vertical-align: middle;">Piclet - Image Tools for Windows</span>

A simple context menu toolkit for image processing, combining the functionality of Png2Icon and background removal tools.

## Features

- **Convert to Icon**: Turn your PNG images into Windows icons with multiple resolutions
- **Remove Background**: Remove white backgrounds from PNG images
- **Resize Images**: Easily resize with custom dimensions and quality settings

## Installation

Piclet is installed as part of the MedLet suite. Simply run the main `install_medlet.bat` from the root directory.

## Usage

### PNG Files
Right-click on any PNG file and select "Piclet" to see all options:

- **Convert to Icon**: Creates a multi-resolution icon file (.ico) using ImageMagick
- **Remove Background**: Removes white background and saves a transparent version
- **Resize Image**: Opens a dialog to resize with custom dimensions and quality

### JPG Files
Right-click on any JPG file and select "Piclet" to use:

- **Resize Image**: Opens a dialog to resize with custom dimensions and quality

### Resize Options
When resizing an image:
- Enter width and height in pixels (use 0 for one dimension to maintain aspect ratio)
- Set quality level (1-100, with 90 being a good default)
- A new file is created with dimensions in the filename

![piclet menu](../res/imgs/piclet-menu.png)

## 🌱 Support & Contributions
If these tools save you time:
- Please⭐ <a href="../../../stargazers" target="_blank">Star</a> to help spread useful tools.
- <a href="https://buymeacoffee.com/spark88" target="_blank">Buy me a coffee</a> to fuel more dev tools.
- or <a href="../../../fork" target="_blank">Contribute</a> - Released under MIT license. 