#!/usr/bin/env bash
pandoc tutorial.rst --filter pandoc-emphasize-code -o tutorial.pdf --from rst --number-sections  --toc --syntax-definition gd-script.xml --highlight-style=tango  --metadata-file=meta.yaml --template eisvogel --pdf-engine xelatex --top-level-division=chapter
pandoc tutorial.rst --filter pandoc-emphasize-code -o tutorial.html --from rst --number-sections --top-level-division=chapter --toc --syntax-definition gd-script.xml --metadata-file=meta.yaml --highlight-style=tango  --template template.html