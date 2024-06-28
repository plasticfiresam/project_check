# Flutter Project Analyzer

This repository contains a script to analyze the directory structure of a Flutter project and generate a visualization in the DOT format. 

## Prerequisites

Ensure the following utilities are installed on your system:

- `dot` (part of Graphviz)
- `dcm`

## Installation

You can install `dot` (Graphviz) using Homebrew on macOS:

```bash
brew install graphviz
```

`dcm` should be installed according to its documentation.

## Usage

1. **Clone the repository:**
2. **Make the scripts executable:**

```bash
chmod +x project_structure.sh
chmod +x common_analysis.sh
```

3. **Run the script:**

```bash
./common_analysis.sh /path/to/project/lib
```

This script will:

- Check for the presence of the required utilities `dot` and `dcm`.
- Analyze the directory structure of your Flutter project's `lib` directory.
- Generate a SVG file representing the directory structure with highlighted directories.
- Add all artifacts of analysis to single archive.

## Directory Highlighting

The script highlights specific directories in the visualization:

- `features`: lightblue
- `util`: lightgreen
- `assets`: lightyellow
- `application`: lightcoral
- `data`: lightpink
- `domain`: lightgoldenrodyellow
- `common`: lightgray
- `presentation`: lightsalmon
- `widgets`: lightsteelblue

## Cleanup

The script will remove the following old artifacts before generating new ones:

- Directories: `analyze_widgets`, `metrics`, `code_quality`
- Files: `analyze.json`, `structure.png`, `project_structure.dot`, `project_structure.svg`
