# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="A tool to help verifying and proving properties on floating-point or fixed-point arithmetic"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/33486/${P}.tar.gz"

LICENSE="|| ( CeCILL-2.0 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/gmp
		dev-libs/mpfr
		dev-libs/boost"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i Remakefile.in \
		-e "s:mkdir -p @bindir@:mkdir -p \${DESTDIR}@bindir@:g" \
		-e "s:cp src/gappa @bindir@:cp src/gappa \${DESTDIR}@bindir@:g"
}

src_compile() {
	./remake -d ${MAKEOPTS} || die "emake failed"
	if use doc; then
		./remake doc/html/index.html
	fi
}

src_install() {
	DESTDIR="${D}" ./remake install || die "emake install failed"
	dodoc NEWS README AUTHORS ChangeLog
	use doc && dohtml -A png -r doc/html/*
}
