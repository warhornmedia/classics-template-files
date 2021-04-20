#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "jtbayly@gmail.com"
git config --global user.name "Joseph Bayly"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
rm -r *.*
cp -r ../_book/* ./
git add --all *
git commit -am"Update the book" || true
git push -q origin gh-pages
