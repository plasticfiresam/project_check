#!/bin/bash

# Check for the presence of installed tools in the system
check_utility() {
    local utility=$1

    if ! command -v "$utility" &> /dev/null; then
        echo "Tool $utility is not installed. Please install $utility and try again."
        exit 1
    fi
}

# Checking for the presence of dot and dcm utilities
check_utility dot
check_utility dcm

# Deleting the analysis_artifacts archive if it exists
if [ -d "analysis_artifacts.zip" ]; then
    rm -rf analysis_artifacts.zip
fi

# Deleting the analyze-widgets directory if it exists
if [ -d "analyze-widgets" ]; then
    rm -rf analyze-widgets
fi

# Deleting the analyze.json file if it exists
if [ -f "analyze.json" ]; then
    rm analyze.json
fi

# Deleting the metrics directory if it exists
if [ -d "metrics" ]; then
    rm -rf metrics
fi

# Analysis with static analyzer according to configuration
dcm analyze lib --reporter=json --json-path=analyze.json

# Widgets analysis
dcm analyze-widgets lib --show-similarity --reporter=html --output-directory=analyze_widgets

# Calculating project metrics
dcm calculate-metrics lib --reporter=html --report-all --output-directory=metrics

# Code quality check

# Deleting and creating the code_quality directory
if [ -d "./code_quality" ]; then
    rm -rf ./code_quality
fi
mkdir code_quality

dcm check-code-duplication lib --per-package --exclude-overrides --reporter=json --json-path=./code_quality/code_duplication.json
dcm check-unused-code lib --reporter=json --json-path=./code_quality/unused_code.json
dcm check-unused-files lib --reporter=json --json-path=./code_quality/unused_files.json
dcm check-dependencies lib --ignored-packages="<template_plugin,template_plugin_interface,cupertino_will_pop_scope,flutter_inappwebview>" --reporter=json --json-path=./code_quality/check_dependencies.json

dcm check-parameters lib --reporter=json --json-path=./code_quality/check_parameters.json
dcm check-exports-completeness lib --reporter=json --json-path=./code_quality/exports_completeness.json

# Building the project structure
sh ./project_structure.sh ./lib > project_structure.dot
dot -Tsvg project_structure.dot -o project_structure.svg

# Archiving all artifacts
zip -r analysis_artifacts.zip analyze.json analyze_widgets metrics code_quality project_structure.svg

# Cleaning up repository artifacts
rm -rf analyze_widgets metrics code_quality analyze.json project_structure.dot project_structure.svg
