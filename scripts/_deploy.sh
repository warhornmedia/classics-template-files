#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] 
[ "${TRAVIS_BRANCH}" != "master" ] 

git config --global user.email "jtbayly@gmail.com"
git config --global user.name "Joseph Bayly"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
cp -r ../_book/* ./
git add --all *
git commit -m"Update the book" || true
git push -q origin gh-pages
