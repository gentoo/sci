# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Math-related classes and functionality"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-math-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=dev-cpp/growler-core-0.3.7"
DEPEND="${RDEPEND}"

DOCS=( README NEWS AUTHORS NOSA ChangeLog )

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-fast-install
}
