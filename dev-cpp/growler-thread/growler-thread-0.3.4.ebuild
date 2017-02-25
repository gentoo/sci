# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Pthread wrapper library"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-thread-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND=">=dev-cpp/growler-link-0.3.7"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( README NEWS AUTHORS NOSA ChangeLog )

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable static-libs static) \
		--enable-fast-install
}
