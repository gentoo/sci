# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Math-related classes and functionality"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-math-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="static"

RDEPEND=">=dev-cpp/growler-core-0.3.7"
DEPEND="${RDEPEND}"

DOCS=( README NEWS AUTHORS NOSA ChangeLog )

src_configure() {
	econf \
		$(use_enable static) \
		--enable-fast-install
}
