# Copyright 2014-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="A software that delivers parallel interactive visualizations"
HOMEPAGE="https://wci.llnl.gov/codes/visit/home.html"
SRC_URI="http://portal.nersc.gov/svn/visit/trunk/releases/${PV}/visit${PV}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="hdf5 tcmalloc cgns"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-libs/silo
	hdf5? ( sci-libs/hdf5 )
	tcmalloc? ( dev-util/google-perftools )
	cgns? ( sci-libs/cgnslib )
	>=sci-libs/vtk-6.0.0[imaging,python,rendering,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV}/src"

src_prepare() {
	epatch "${FILESDIR}/${P}-findpython.patch"
	epatch "${FILESDIR}/${P}-findvtk.patch"
	epatch "${FILESDIR}/${P}-vtklibs.patch"
	epatch "${FILESDIR}/${P}-dont_symlink_visit_dir.patch"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt/visit
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_DIR="${EPREFIX}/usr/"
		-DVISIT_PYTHON_SKIP_INSTALL=true
		-DVISIT_VTK_SKIP_INSTALL=true
		-DVISIT_THREAD=true
		-DQT_BIN="${EPREFIX}/usr/bin"
		-DVISIT_ZLIB_DIR="${EPREFIX}/usr"
	)
	if use hdf5; then
		mycmakeargs+=( -DHDF5_DIR="${EPREFIX}/usr/" )
	fi
	if use tcmalloc; then
		mycmakeargs+=( -DTCMALLOC_DIR="${EPREFIX}/usr/" )
	fi
	if use cgns; then
		mycmakeargs+=( -DCGNS_DIR="${EPREFIX}/usr/" )
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	cat > "${T}"/99visit <<- EOF
		PATH=${EPREFIX}/opt/visit/bin
	EOF
	doenvd "${T}"/99visit
}
