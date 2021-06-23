#!/usr/bin/env bash
pandoc tutorial.md -o tutorial.pdf --from markdown --number-sections --top-level-division=chapter --toc --syntax-definition gd-script.xml --highlight-style=tango  --template eisvogel --pdf-engine xelatex
pandoc tutorial.md -o tutorial.html --from markdown --number-sections --top-level-division=chapter --toc --syntax-definition gd-script.xml --highlight-style=tango  --template template.html