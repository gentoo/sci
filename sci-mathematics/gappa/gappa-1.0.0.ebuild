# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PID=32744

DESCRIPTION="A tool to help verifying and proving properties on floating-point or fixed-point arithmetic"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/${PID}/${P}.tar.gz"

LICENSE="|| ( CeCILL-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/gmp
	dev-libs/mpfr
	dev-libs/boost"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile(){
	./remake -d ${MAKEOPTS} || die
	if use doc; then
		cd doc/doxygen
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install(){
	dobin src/gappa
	dodoc README AUTHORS ChangeLog NEWS TODO
	use doc && dohtml -r doc/doxygen/html/*
}
