<div align="center">

<img src="snap/gui/vibe.png" alt="Vibe logo" width="128" />

# Vibe

**Offline transcription of audio and video with Whisper models**

[![vibe](https://snapcraft.io/vibe/badge.svg)](https://snapcraft.io/vibe)
[![Base: core26](https://img.shields.io/badge/Base-core26-2C8C3C?logo=canonical&logoColor=white)](https://snapcraft.io/core26)
![Confinement: strict](https://img.shields.io/badge/Confinement-strict-2C8C3C)
[![Maintainer: sidaliteir](https://img.shields.io/badge/Maintainer-sidaliteir-2C8C3C?logo=snapcraft&logoColor=white)](https://snapcraft.io/publisher/sidaliteir)
![Architectures: amd64 and arm64](https://img.shields.io/badge/Architectures-amd64%20%7C%20arm64-2C8C3C?logo=linux&logoColor=white)

[Getting Started](#getting-started) · [Configure](#configure) · [Limitations](#limitations) · [Build](#build) · [Support](#support) · [License](#license)

Unofficial snap packaging for [Vibe](https://github.com/thewh1teagle/vibe), a desktop app that transcribes audio and video on your own computer with whisper.cpp.

</div>

---

## Getting Started

<a href="https://snapcraft.io/vibe"><img alt="Get it from the Snap Store" src="https://snapcraft.io/en/dark/install.svg" width="180"></a>

```bash
sudo snap install vibe
vibe
```

You can also launch Vibe from the application menu. On first launch it downloads its default model (about 1.6 GB), then you can open a file or paste a link to transcribe it.

The transcription engine also runs without the window:

```bash
vibe.cli pull https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin --output ~/ggml-tiny.bin
vibe.cli transcribe ~/ggml-tiny.bin ~/recording.mp3
vibe.cli --help
```

## Configure

Use the application's settings. There are no `snap set` options.

```bash
sudo snap connect vibe:audio-record      # optional: record from the microphone
sudo snap connect vibe:removable-media   # optional: files on /media, /mnt
```

Models, settings and logs are stored in `~/snap/vibe/common`.

## Limitations

- Files must be in your home directory or connected removable storage. Hidden folders in your home directory are not accessible.
- Recording system audio, meeting detection and starting Vibe at login are unavailable.
- An existing native installation's models and settings are not imported. Application updates are managed by snapd.

## Build

```bash
git clone https://github.com/sidalit/vibe-snap.git
cd vibe-snap
sudo snap install snapcraft --classic
snapcraft pack
```

## Support

- **Installation or snap issues:** [open a packaging issue](https://github.com/sidalit/vibe-snap/issues).
- **Application bugs:** [report them upstream](https://github.com/thewh1teagle/vibe/issues).

## License

Snap packaging: [MIT](https://github.com/sidalit/vibe-snap/blob/main/LICENSE).
