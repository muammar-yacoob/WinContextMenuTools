# <img src="../res/icons/vidlet.ico" height="100" style="vertical-align: middle;"> <span style="vertical-align: middle;">VidLet - Video Tools for Windows</span>

A simple context menu toolkit for video processing, combining compression and format conversion tools.

## Features

- **Compress Video**: Reduce video size with customizable quality settings
- **Convert MKV to MP4**: Quick, lossless format conversion without re-encoding

## Components

VidLet combines two primary video tools:

1. **VideoCompressor**: Compress video files with customizable quality settings
2. **mkv2mp4**: Convert MKV files to MP4 format without re-encoding (preserves quality)

## Installation

VidLet is installed as part of the MedLet suite. Simply run the main `install_medlet.bat` from the root directory.

## Usage

### MP4 Files
Right-click on any MP4 file and select "VidLet" to see:

- **Compress Video**: Opens a dialog to set bitrate and encoding speed
  - Higher bitrate = better quality but larger file size
  - Slower preset = better compression but longer processing time

### MKV Files
Right-click on any MKV file and select "VidLet" to use:

- **Convert to MP4**: Quick lossless conversion to MP4 format
- **Compress Video**: Same compression tool as for MP4 files

![vidlet menu](../res/imgs/vidlet-menu.png)

## Compression Settings

When compressing a video:
- **Bitrate**: Controls quality and file size (default: 1500 kb/s)
- **Preset**: Balance between speed and compression efficiency
  - Options range from "ultrafast" (fastest, lower quality) to "veryslow" (slowest, best quality)
  - "medium" offers a good balance for most use cases

## 🌱 Support & Contributions
If these tools save you time:
- Please⭐ <a href="../../../stargazers" target="_blank">Star</a> to help spread useful tools.
- <a href="https://buymeacoffee.com/spark88" target="_blank">Buy me a coffee</a> to fuel more dev tools.
- or <a href="../../../fork" target="_blank">Contribute</a> - Released under MIT license. 