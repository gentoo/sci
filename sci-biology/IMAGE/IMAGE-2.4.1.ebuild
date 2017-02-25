# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Iterative Mapping and Assembly for Gap Elimination using paired-end Illumina"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/image2"
SRC_URI="http://sourceforge.net/projects/image2/files/IMAGE_version2.4.1_64bit.zip"

#http://genomebiology.com/2010/11/4/R41
LICENSE="CC-BY-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled binaries:
# nucmer smalt_x86_64 ssaha2 ssaha2Build velvetg velveth
DEPEND=""
RDEPEND="${DEPEND}"
