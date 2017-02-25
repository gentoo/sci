# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Close gaps using PacBio RS or 454 FLX+ reads"
HOMEPAGE="https://www.hgsc.bcm.edu/software/jelly"
SRC_URI="http://sourceforge.net/projects/pb-jelly/files/PBSuite_14.9.9.tgz -> pb-jelly-14.9.9.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-biology/blasr
	<=dev-python/networkx-1.1[${PYTHON_USEDEP}]" # upstream says "Versions past v1.1 have been shown to have many issues."
RDEPEND="${DEPEND}"
