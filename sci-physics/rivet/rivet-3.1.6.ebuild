# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit python-single-r1 flag-o-matic autotools

MY_PN="Rivet"
MY_PF=${MY_PN}-${PV}

DESCRIPTION="Rivet toolkit (Robust Independent Validation of Experiment and Theory)"
HOMEPAGE="https://gitlab.com/hepcedar/rivet"
SRC_URI="https://www.hepforge.org/archive/rivet/${MY_PF}.tar.gz"
S=${WORKDIR}/${MY_PF}

LICENSE="GPL-3+"
SLOT="3"
KEYWORDS="~amd64"
IUSE="+hepmc3 hepmc2"
REQUIRED_USE="
	^^ ( hepmc3 hepmc2 )
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	>=sci-physics/yoda-1.9.5[python(-),${PYTHON_SINGLE_USEDEP}]
	>=sci-physics/fastjet-3.4.0[plugins]
	>=sci-physics/fastjet-contrib-1.048
	hepmc2? ( sci-physics/hepmc:0=[-cm(-),gev(+)] )
	hepmc3? ( sci-physics/hepmc:3=[-cm(-),gev(+)] )

	sci-libs/gsl

	virtual/latex-base
	media-gfx/imagemagick
	app-text/ghostscript-gpl

	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/fortran
	>=dev-python/cython-0.29.24
"

PATCHES=(
	"${FILESDIR}"/${P}-binreloc.patch
	"${FILESDIR}"/${PN}-3.1.5-test.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	#TODO does this affect more cpus?
	replace-cpu-flags znver1 x86-64
	PREFIX_YODA=$(yoda-config --prefix) || die
	PREFIX_FJ=$(fastjet-config --prefix) || die
	econf \
		$(usex hepmc2 "--with-hepmc=/usr" "") \
		$(usex hepmc3 "--with-hepmc3=/usr" "") \
		--with-yoda=$PREFIX_YODA \
		--with-fastjet=$PREFIX_FJ
}

src_install() {
	default
	python_optimize
	find "${ED}" -name '*.la' -delete || die
}
