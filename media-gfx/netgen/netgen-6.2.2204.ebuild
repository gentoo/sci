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

IUSE="ffmpeg jpeg mpi opencascade python gui"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ffmpeg? ( gui )
	jpeg? ( gui )
	python? ( gui )
"

DEPEND="
	sys-libs/zlib
	ffmpeg? ( media-video/ffmpeg:= )
	gui? (
		dev-lang/tcl:0/8.6
		dev-lang/tk:0/8.6
		media-libs/glu
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libxcb:=
	)
	jpeg? ( media-libs/libjpeg-turbo:0= )
	mpi? (
		sci-libs/metis
		virtual/mpi
	)
	opencascade? ( sci-libs/opencascade:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
			'
		)
		mpi? (
			$(python_gen_cond_dep 'dev-python/mpi4py[${PYTHON_USEDEP}]' )
		)
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/lsb-release
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-use-external-pybind11.patch"
	"${FILESDIR}/${P}-find-Tk-include-directories.patch"
	"${FILESDIR}/${P}-find-libjpeg-turbo-library.patch"
	"${FILESDIR}/${P}-link-against-ffmpeg.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# NOTE: need to manually check and update this string on version bumps!
	cat <<- EOF > "${S}/version.txt" || die
		v${PV}-0-gde0d706e
	EOF
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# currently not working in a sandbox, expects netgen to be installed
		# see https://github.com/NGSolve/netgen/issues/132
		-DBUILD_STUB_FILES=OFF
		-DINSTALL_PROFILES=OFF
		-DNG_INSTALL_DIR_CMAKE="$(get_libdir)/cmake/${PN}"
		-DNG_INSTALL_DIR_INCLUDE="include/${PN}"
		-DNG_INSTALL_DIR_LIB="$(get_libdir)"
		-DUSE_CCACHE=OFF
		# doesn't build with this version
		-DUSE_CGNS=OFF
		-DUSE_GUI="$(usex gui)"
		-DUSE_INTERNAL_TCL=OFF
		-DUSE_JPEG="$(usex jpeg)"
		-DUSE_MPEG="$(usex ffmpeg)"
		# respect users -march= choice
		-DUSE_NATIVE_ARCH=OFF
		-DUSE_MPI="$(usex mpi)"
		-DUSE_OCC="$(usex opencascade)"
		-DUSE_PYTHON="$(usex python)"
		-DUSE_SUPERBUILD=OFF
	)
	# no need to set this, if we only build the library
	if use gui; then
		mycmakeargs+=( -DTK_INCLUDE_PATH="/usr/$(get_libdir)/tk8.6/include" )
	fi
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
	use python && python_optimize

	local NETGENDIR="/usr/share/${PN}"
	echo -e "NETGENDIR=${NETGENDIR}" > ./99netgen || die
	doenvd 99netgen

	if use gui; then
		mv "${ED}"/usr/bin/{*.tcl,*.ocf} "${ED}${NETGENDIR}" || die

		doicon "${FILESDIR}"/${PN}.png
		domenu "${FILESDIR}"/${PN}.desktop
	fi

	mv "${ED}"/usr/share/${PN}/doc/ng4.pdf "${ED}"/usr/share/doc/${PF} || die
	dosym -r /usr/share/doc/${PF}/ng4.pdf /usr/share/${PN}/doc/ng4.pdf
}
