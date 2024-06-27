#!/bin/bash

# Check for the presence of an argument
if [ -z "$1" ]; then
    echo "Please specify the path to the lib directory of the project"
    exit 1
fi

LIB_DIR=$1

# Check if the directory exists
if [ ! -d "$LIB_DIR" ]; then
    echo "The directory $LIB_DIR does not exist"
    exit 1
fi

# Function to get the relative path
get_relative_path() {
    local target=$1
    local base=$2
    local target_abs=$(cd "$target"; pwd)
    local base_abs=$(cd "$base"; pwd)
    echo "${target_abs#$base_abs/}"
}

# Function to analyze the directory structure
analyze_directory() {
    local dir=$1
    local indent=$2
    local parent=$3

    for entry in "$dir"/*; do
        if [ -d "$entry" ]; then
            local dirname=$(basename "$entry")
            local fullpath=$(get_relative_path "$entry" "$LIB_DIR")

            # Define color for specified directories
            local color=""
            case $dirname in
                features) color="lightblue";;
                util) color="lightgreen";;
                assets) color="lightyellow";;
                application) color="lightcoral";;
                data) color="lightpink";;
                domain) color="lightgoldenrodyellow";;
                common) color="lightgray";;
                presentation) color="lightsalmon";;
                widgets) color="lightsteelblue";;
                *) color="white";;  # Default color
            esac

            echo "${indent}\"$fullpath\" [label=\"$dirname\", shape=folder, style=filled, fillcolor=\"$color\"];"
            if [ -n "$parent" ]; then
                echo "${indent}\"$parent\" -> \"$fullpath\";"
            fi
            analyze_directory "$entry" "  $indent" "$fullpath"
        fi
    done
}

# Start of the dot file
echo "digraph flutter_project {"
echo "  node [fontname=\"Arial\"];"
echo "  rankdir=LR;"  # Makes horizontal reading easier
echo "  concentrate=true;"  # Simplifies connections

# Root directory
echo "  \"$(basename "$LIB_DIR")\" [label=\"$(basename "$LIB_DIR")\", shape=folder];"

# Analyze the specified directory
analyze_directory "$LIB_DIR" "  " "$(basename "$LIB_DIR")"

# End of the dot file
echo "}"
