#!/bin/sh
#
# vim: expandtab ts=2 :

SPHINXBUILD=sphinx-build
TMPDIR='/tmp/offlineimap-sphinx-doctrees'
WEBSITE='../website'
DOCBASE="${WEBSITE}/_doc"
DESTBASE="${DOCBASE}/versions"
VERSIONS_YML="${WEBSITE}/_data/versions.yml"

version="v$(../offlineimap.py --version)"

test -d "$DESTBASE" || exit 1
dest="${DESTBASE}/${version}"

#
# Build sphinx documentation.
#
echo "Cleaning target directory: $dest"
rm -rf "$dest"
$SPHINXBUILD -b html -d "$TMPDIR" doc-src "$dest"

#
# Dynamically build JSON definitions for Jekyll.
#
echo "Building Jekyll data: $VERSIONS_YML"
for version in $(ls "$DESTBASE")
do
  echo "- $version"
done > "$VERSIONS_YML"

#
# Copy usefull sources of documentation.
#

# Changelogs.
for foo in ../Changelog.md ../Changelog.maint.md
do
  cp -afv "$foo" "$DOCBASE"
done
