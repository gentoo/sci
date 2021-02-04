# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="d113f3f7ba119fecd9d946bced8d3dfe9456b933"

DESCRIPTION="Symbolic and algebraic computations system"
HOMEPAGE="https://github.com/GabrielDosReis/open-axiom http://www.open-axiom.org/"
SRC_URI="https://github.com/GabrielDosReis/open-axiom/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

IUSE="X"

RDEPEND="X? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	app-text/noweb
	dev-lisp/ecls[cxx]
"

DOCS="MAINTAINERS TODO STYLES"

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	# There is an option to compile with other lisps. However:
	# - gcl is getting obsolete and unmaintained and is hard masked
	# - could not make it work with sbcl
	econf \
		--with-lisp=ecl \
		$(use_with X x)
}
