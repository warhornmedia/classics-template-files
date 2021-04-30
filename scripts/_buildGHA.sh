#!/bin/sh

set -ev

# Install fonts

# encrypted via: "gpg -c font1.zip"
echo NotASecret | gpg --batch --yes --passphrase-fd 0 -d --output classics-template-files/fonts/font1.zip classics-template-files/fonts/font1.zip.gpg
unzip classics-template-files/fonts/font1.zip
unzip classics-template-files/fonts/font2.zip
sudo cp -vf Calluna/Calluna-Regular.otf /Library/Fonts
sudo cp -vf LiberationSerif-Regular.ttf /Library/Fonts
sudo cp -vf LiberationSerif-BoldItalic.ttf /Library/Fonts
sudo cp -vf LiberationSerif-Bold.ttf /Library/Fonts
sudo cp -vf LiberationSerif-Italic.ttf /Library/Fonts

# render web version
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

# Lookup what other formats are supposed to be available for download
formats="$(grep 'download:' _output.yml)"

# if PDF is in the download list
if [[ $formats == *"pdf"* ]]; then
  # render PDF version
  Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
fi

# if MOBI is in the download list
if [[ $formats == *"mobi"* ]]; then
  # render epub and mobi version
  brew install --cask calibre
  brew install --cask kindle-previewer
  curl  https://plugins.calibre-ebook.com/272407.zip --output plugin.zip
  calibre-customize -a plugin.zip
  #calibre-debug -r "KFX Output" -- 
  Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi'); cmd = paste("calibre-debug -r \"KFX Output\" -- ", epubFile,sep=""); kfxFile <- system(cmd,intern=FALSE);
"
# if EPUB is in the download list
elif [[ $formats == *"epub"* ]]; then
  # render the epub
  Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
fi


# render ePub version
# if --includeMobi is added in the local book build, go ahead and build that, too. 
#if [ "$1" == "--includeMobi" ]; then 
#  brew install --cask calibre
#  Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi')"
#else
#  Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
#fi

# Command to create *both* epub and mobi files.
# Turned off to speed up rebuilds during testing.
# Before turning on, make sure you install Calibre first
# Rscript -e "epubFile <- bookdown::render_book('index.Rmd', 'bookdown::epub_book'); bookdown::calibre(epubFile, 'mobi')"

# Command that *only* creates epub files.
#Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
