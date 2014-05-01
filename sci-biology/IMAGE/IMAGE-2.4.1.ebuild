# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Iterative Mapping and Assembly for Gap Elimination - close gaps in assemblies using Illumina paired end reads"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/image2"
SRC_URI="http://sourceforge.net/projects/image2/files/IMAGE_version2.4.1_64bit.zip"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled binaries:
# nucmer smalt_x86_64 ssaha2 ssaha2Build velvetg velveth
DEPEND=""
RDEPEND="${DEPEND}"
