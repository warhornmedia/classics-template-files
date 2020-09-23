#!/bin/sh

set -ev

git for-each-ref --sort='*authordate' --format='%(taggerdate:short) | %(tag) | %(contents)' refs/tags

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

# Command to create *both* epub and mobi files.
# Turned off to speed up rebuilds during testing.
# Before turning on, make sure you turn on Calibre installation in .travis.yml
# Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi')"

# Command that *only* creates epub files.
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
