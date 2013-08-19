# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils flag-o-matic

DESCRIPTION="Object-oriented Scientific Computing Library"
HOMEPAGE="http://o2scl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples hdf5 static-libs"

RDEPEND="
	dev-libs/boost
	sci-libs/gsl
	hdf5? ( sci-libs/hdf5 )"
DEPEND="${RDEPEND}"

src_configure() {
	use debug || append-cppflags -DO2SCL_NO_RANGE_CHECK
	local myeconfargs=(
		$(use_enable hdf5 hdf)
		$(use_enable hdf5 partlib)
		$(use_enable hdf5 eoslib)
	)
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test o2scl-test
}

src_install() {
	autotools-utils_src_install
	rm -r "${ED}"/usr/doc || die
	use doc && dohtml -r doc/o2scl/html/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
