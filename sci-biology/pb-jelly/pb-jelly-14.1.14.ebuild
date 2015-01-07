# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Close gaps using PacBio RS or 454 FLX+ reads"
HOMEPAGE="https://www.hgsc.bcm.edu/software/jelly"
SRC_URI="http://sourceforge.net/projects/pb-jelly/files/PBJelly/PBJelly_14.1.14.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-biology/blasr
	dev-python/networkx-1.1" # upstream says "Versions past v1.1 have been shown to have many issues."
RDEPEND="${DEPEND}"
