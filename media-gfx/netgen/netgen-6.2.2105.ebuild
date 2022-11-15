# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake desktop python-single-r1 xdg

DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="https://ngsolve.org/ https://github.com/NGSolve/netgen"
SRC_URI="https://github.com/NGSolve/netgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"

IUSE="ffmpeg jpeg mpi opencascade openmp python +gui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	dev-lang/tcl:0/8.6
	dev-lang/tk:0/8.6
	dev-tcltk/tix
	dev-tcltk/togl:0
	gui? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXmu
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
			dev-python/pybind11-stubgen[${PYTHON_USEDEP}]
			'
		)
		mpi? (
			$(python_gen_cond_dep 'dev-python/mpi4py[${PYTHON_USEDEP}]' )
		)
	)
	opencascade? ( sci-libs/opencascade:* )
	ffmpeg? ( media-video/ffmpeg )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	mpi? ( virtual/mpi sci-libs/parmetis opencascade? ( sci-libs/hdf5[mpi] ) )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-vcs/git"

PATCHES=( "${FILESDIR}/${P}-find-tk.patch" )

src_prepare() {
	# https://github.com/NGSolve/netgen/issues/72
	git init -q || die
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	git add . || die
	git commit -qm 'init' || die
	git tag "${PV}" || die

	cmake_src_prepare
}

src_configure() {
	 local mycmakeargs=(
		-DUSE_MPI="$(usex mpi)"
		-DUSE_JPEG="$(usex jpeg)"
		-DUSE_MPEG="$(usex ffmpeg)"
		-DUSE_GUI="$(usex gui)"
		-DUSE_OCC="$(usex opencascade)"
		-DUSE_PYTHON="$(usex python)"
		-DTK_INCLUDE_PATH="/usr/$(get_libdir)/tk8.6/include"
		-DNG_INSTALL_DIR_LIB="$(get_libdir)"
		-DINSTALL_PROFILES=ON
		-DUSE_INTERNAL_TCL=OFF
	)
	if use python; then
		mycmakeargs+=(
			-DPYBIND_INCLUDE_DIR="/usr/lib/${EPYTHON}/site-packages/pybind11/include/"
			-DNG_INSTALL_PYBIND=OFF
		)
	fi
	if use mpi && use python; then
		mycmakeargs+=( -DUSE_MPI4PY=ON )
	else
		mycmakeargs+=( -DUSE_MPI4PY=OFF )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	local NETGENDIR="/usr/share/netgen"

	echo -e "NETGENDIR=${NETGENDIR} \nLDPATH=/usr/$(get_libdir)/Togl2.0" > ./99netgen
	doenvd 99netgen

	mv "${D}"/usr/bin/{*.tcl,*.ocf} "${D}${NETGENDIR}" || die

	# Install icon and .desktop for menu entry
	doicon "${FILESDIR}"/${PN}.png
	domenu "${FILESDIR}"/${PN}.desktop
}
