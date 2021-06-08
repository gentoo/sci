# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Verifying and proving properties on floating-point or fixed-point arithmetic"
HOMEPAGE="http://gappa.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/38044/${P}.tar.gz"

LICENSE="|| ( CeCILL-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-libs/boost
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	default
	sed -i Remakefile.in \
		-e "s:mkdir -p @bindir@:mkdir -p \${DESTDIR}@bindir@:g" \
		-e "s:cp src/gappa @bindir@:cp src/gappa \${DESTDIR}@bindir@:g"
}

src_compile() {
	# Remove --load-average or -l because remake does not accept these
	echo ${MAKEOPTS} | egrep -o '(\-l|\-\-load\-average)(=?|[[:space:]]*)[[:digit:]]+' > /dev/null
	if [ $? -eq 0 ]; then
		MAKEOPTS="${MAKEOPTS/$(echo ${MAKEOPTS} | egrep -o '(\-l|\-\-load\-average)(=?|[[:space:]]*)[[:digit:]]+')/}"
	fi
	./remake -d ${MAKEOPTS} || die "emake failed"
	if use doc; then
		./remake doc/html/index.html
	fi
}

src_install() {
	DESTDIR="${D}" ./remake install
	einstalldocs
	use doc && dodoc -r doc/html/*
}
