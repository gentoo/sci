# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Growler libraries and utilities"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-arch-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="
	>=dev-cpp/growler-link-0.3.7
	>=dev-cpp/growler-thread-0.3.4
	>=dev-cpp/growler-core-0.3.7"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen dev-libs/libxslt )"

DOCS=( README NEWS AUTHORS NOSA ChangeLog )

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable static-libs static) \
		--enable-fast-install
}
