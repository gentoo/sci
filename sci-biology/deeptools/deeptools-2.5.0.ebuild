# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )

inherit distutils-r1

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Extract reads from BAM files, normalize, draw figures, convert BAM to bigWig"
HOMEPAGE="https://github.com/fidelram/deepTools"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/fidelram/deepTools"
	KEYWORDS=""
else
	SRC_URI="https://github.com/fidelram/deepTools/archive/2.5.0.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=dev-python/numpy-1.8.0
		>=sci-libs/scipy-0.17.0
		>=dev-python/py2bit-0.1.0
		>=dev-python/pyBigWig-0.2.1
		>=sci-biology/pysam-0.8
		>=dev-python/matplotlib-1.4.0"
RDEPEND="${DEPEND}"
