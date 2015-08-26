# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Pthread wrapper library"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-thread-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
IUSE="doc static"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-cpp/growler-link-0.3.7"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( README NEWS AUTHORS NOSA ChangeLog )

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable static) \
		--enable-fast-install
}
