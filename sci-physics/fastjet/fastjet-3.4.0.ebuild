# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=plugins
PYTHON_COMPAT=( python3_{8..10} )
DOCS_BUILDER="doxygen"

inherit autotools flag-o-matic fortran-2 python-r1 docs

DESCRIPTION="A software package for jet finding in pp and e+e- collisions"
HOMEPAGE="https://fastjet.fr/"
SRC_URI="https://fastjet.fr/repo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cgal doc examples python +plugins +contrib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# For now, we depend on cgal[gmp(-)] and append -lgmp to libs, despite possible incompatibility with cgal-5.5
DEPEND="
	contrib? ( sci-physics/fastjet-contrib )
	cgal? ( sci-mathematics/cgal:=[shared(+),gmp(-)] )
	plugins? ( sci-physics/siscone:= )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-doc/doxygen[dot]
	virtual/fortran
"

PATCHES=(
	"${FILESDIR}"/${P}-system-siscone.patch
	"${FILESDIR}"/${P}-gfortran.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-libs -lgmp
	econf \
		$(use_enable cgal) \
		$(use_enable plugins allplugins) \
		$(use_enable plugins allcxxplugins) \
		--enable-shared \
		--enable-static=no \
		--disable-static \
		--disable-auto-ptr  \
		$(use_enable python pyext)
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	if use examples; then
		emake -C example maintainer-clean
		find example -iname 'makefile*' -delete || die

		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	find "${ED}" -name '*.la' -delete || die
}
