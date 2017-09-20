# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Near-optimal RNA-Seq quantification"
HOMEPAGE="http://pachterlab.github.io/kallisto/"
SRC_URI="https://github.com/pachterlab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sci-libs/hdf5"
RDEPEND="${DEPEND}"
