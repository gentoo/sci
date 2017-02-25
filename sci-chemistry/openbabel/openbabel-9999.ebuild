# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER="2.8"

inherit cmake-utils eutils git-r3 wxwidgets

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openbabel/openbabel.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc java openmp perl python ruby test wxwidgets"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/libxml2:2
	!sci-chemistry/babel
	sci-libs/inchi
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8
	doc? ( app-doc/doxygen )"
PDEPEND="
	java? ( sci-chemistry/openbabel-java )
	perl? ( sci-chemistry/openbabel-perl )
	python? ( sci-chemistry/openbabel-python )
	ruby? ( sci-chemistry/openbabel-ruby )"

DOCS="AUTHORS NEWS README.md THANKS doc/*.inc doc/README* doc/*.mol2"

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
		FORTRAN_NEED_OPENMP=1
	fi
}

src_configure() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DOPTIMIZE_NATIVE=OFF
		$(cmake-utils_use_enable openmp OPENMP)
		$(cmake-utils_use wxwidgets BUILD_GUI)"

	cmake-utils_src_configure
}

src_test() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		-DOPTIMIZE_NATIVE=OFF
		-DPYTHON_EXECUTABLE=false
		$(cmake-utils_use wxwidgets BUILD_GUI)
		$(cmake-utils_use_enable openmp OPENMP)
		$(cmake-utils_use_enable test TESTS)"

	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_test -E py
}

src_install() {
	docinto html
	dodoc doc/{*.html,*.png}
	if use doc; then
		docinto html/API
		dodoc doc/API/html/*
	fi

	cmake-utils_src_install

	# Ensure that modules are allways in openbabel/${PV}
	pushd "${ED}/usr/$(get_libdir)/openbabel" > /dev/null || die
	ver=$(ls -d * | grep -E '([0-9]+[.]){2}[0-9]+')
	if [ "${ver}" != "${PV}" ] ; then
		ln -s ${ver} ${PV} || die
	fi
	popd > /dev/null || die
}
