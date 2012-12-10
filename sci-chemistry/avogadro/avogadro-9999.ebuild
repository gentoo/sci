# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/avogadro/avogadro-1.0.1.ebuild,v 1.1 2010/05/21 15:33:28 jlec Exp $

EAPI=5

PYTHON_DEPEND="python? 2:2.5"

inherit cmake-utils eutils git-2 python

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/cryos/avogadro.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+glsl python test"

RDEPEND="
	>=sci-chemistry/openbabel-2.3.0
	>=x11-libs/qt-gui-4.5.3:4
	>=x11-libs/qt-opengl-4.5.3:4
	x11-libs/gl2ps
	glsl? ( >=media-libs/glew-1.5.0 )
	python? (
		>=dev-libs/boost-1.35.0-r5[python]
		dev-python/numpy
		dev-python/sip
	)"
DEPEND="${RDEPEND}
	dev-cpp/eigen:2
	dev-util/cmake"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	local mycmakeargs=(
		"-DENABLE_THREADGL=OFF"
		"-DENABLE_RPATH=OFF"
		"-DENABLE_UPDATE_CHECKER=OFF"
		"-DQT_MKSPECS_DIR=${EPREFIX}/usr/share/qt4/mkspecs"
		"-DQT_MKSPECS_RELATIVE=share/qt4/mkspecs"
		$(cmake-utils_use_enable glsl)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use_with sse2 SSE2)
		$(cmake-utils_use_enable python)
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}
