#!/bin/sh

set -ev

# Install fonts
unzip classics-template-files/fonts/font1.zip
unzip classics-template-files/fonts/font2.zip
sudo cp -vf Calluna/Calluna-Regular.otf /Library/Fonts
sudo cp -vf LiberationSerif-Regular.ttf /Library/Fonts
sudo cp -vf LiberationSerif-BoldItalic.ttf /Library/Fonts
sudo cp -vf LiberationSerif-Bold.ttf /Library/Fonts
sudo cp -vf LiberationSerif-Italic.ttf /Library/Fonts

# render each format
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

if [ $1 = "--includeMobi" ]; then 
  brew install --cask calibre
  Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi')"
else
  Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
fi

# Command to create *both* epub and mobi files.
# Turned off to speed up rebuilds during testing.
# Before turning on, make sure you install Calibre first
# Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi')"

# Command that *only* creates epub files.
#Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
