# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5
PYTHON_MODNAME="ccpn"
PYTHON_USE_WITH="ssl tk"
EAPI="2"

inherit eutils distutils multilib portability python toolchain-funcs versionator

MY_PN="${PN}mr"

DESCRIPTION="The Collaborative Computing Project for NMR"
SRC_URI="http://www.bio.cam.ac.uk/ccpn/download/${MY_PN}/analysis${PV}.tar.gz"
HOMEPAGE="http://www.ccpn.ac.uk/ccpn"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86"
IUSE="doc opengl"

RDEPEND="
	dev-lang/tk
	dev-python/elementtree
	dev-python/numpy
	dev-tcltk/tix
	virtual/glut"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}/${MY_PN}$(get_version_component_range 1-2 ${PV})

pkg_setup() {
	python_version
}

src_prepare() {
	local tk_ver
	local myconf

	tk_ver="$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)"

	if use opengl; then
		if has_version media-libs/freeglut; then
			ccpnadd GLUT_NEED_INIT = -DNEED_GLUT_INIT
		else
			ccpnadd GLUT_NEED_INIT =
		fi

		ccpnadd IGNORE_GL_FLAG =
		ccpnadd GL_FLAG = -DUSE_GL_FALSE
		ccpnadd GLUT_NOT_IN_GL =
		ccpnadd GL_DIR = /usr
		ccpnadd GL_LIB = -lglut -lGLU -lGL
		ccpnadd GL_INCLUDE_FLAGS = -I\$\(GL_DIR\)/include
		ccpnadd GL_LIB_FLAGS = -L\$\(GL_DIR\)/$(get_libdir)

	else
		ccpnadd IGNORE_GL_FLAG = -DIGNORE_GL
		ccpnadd GL_FLAG = -DUSE_GL_FALSE
		ccpnadd GLUT_NOT_IN_GL =
	fi
	ccpnadd GLUT_FLAG = \$\(GLUT_NEED_INIT\) \$\(GLUT_NOT_IN_GL\)
	ccpnadd CC = $(tc-getCC)
	ccpnadd LINK_FLAGS = ${LDFLAGS} -fPIC
	ccpnadd MALLOC_FLAG =
	ccpnadd FPIC_FLAG = -fPIC
	ccpnadd SHARED_FLAGS = -shared
	ccpnadd MATH_LIB = -lm
	ccpnadd X11_DIR = /usr
	ccpnadd X11_LIB = -lX11 -lXext
	ccpnadd X11_INCLUDE_FLAGS = -I\$\(X11_DIR\)/include
	ccpnadd X11_LIB_FLAGS = -L\$\(X11_DIR\)/lib
	ccpnadd TCL_DIR = /usr
	ccpnadd TCL_LIB = -ltcl${tk_ver}
	ccpnadd TCL_INCLUDE_FLAGS = -I\$\(TCL_DIR\)/include
	ccpnadd TCL_LIB_FLAGS = -L\$\(TCL_DIR\)/$(get_libdir)
	ccpnadd TK_DIR = /usr
	ccpnadd TK_LIB = -ltk${tk_ver}
	ccpnadd TK_INCLUDE_FLAGS = -I\$\(TK_DIR\)/include
	ccpnadd TK_LIB_FLAGS = -L\$\(TK_DIR\)/$(get_libdir)
	ccpnadd PYTHON_DIR = /usr
	ccpnadd PYTHON_INCLUDE_FLAGS = -I\$\(PYTHON_DIR\)/include/python${PYVER}
	ccpnadd CC_FLAGS = ${CFLAGS} \$\(MALLOC_FLAG\) \$\(FPIC_FLAG\)
	ccpnadd LINK = $(tc-getCC)
	ccpnadd MAKE = make
	ccpnadd CO_NAME = -c \$\<
	ccpnadd OUT_NAME = -o \$@
	ccpnadd OBJ_SUFFIX = o
	ccpnadd DYLIB_SUFFIX = so
	ccpnadd RM = rm -f
	ccpnadd LINK_LIBRARIES = sh linkSharedObjs
}

src_compile() {
	emake \
		-C c \
		all links || \
		die "failed to compile"
}

src_install() {

	local in_path
	local gentoo_sitedir
	local libdir
	local files
	local tkver

	in_path=$(python_get_sitedir)/${PN}
	gentoo_sitedir=$(python_get_sitedir)
	libdir=$(get_libdir)
	tkver=$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)

	for wrapper in analysis dangle dataShifter formatConverter pipe2azara; do
		sed -e "s:gentoo_sitedir:${gentoo_sitedir}:g" \
		    -e "s:libdir:${libdir}:g" \
			-e "s:tkver:${tkver}:g" \
		    "${FILESDIR}"/${wrapper} > "${T}"/${wrapper} || die "Fail fix ${wrapper}"
		dobin "${T}"/${wrapper} || die "Failed to install ${wrapper}"
	done

	use doc && treecopy $(find . -name doc) "${D}"usr/share/doc/${PF}/html/

	ebegin "Removing unneeded docs"
	find . -name doc -exec rm -rf '{}' \; 2> /dev/null
	eend

	for i in ccpnmr2.1/python/memops/format/compatibility/{Converters,part2/Converters2}.py; do
		sed \
			-e 's:#from __future__:from __future__:g' \
			-i ${i}
	done

	insinto ${in_path}

	ebegin "Installing main files"
	doins -r {data,model,python} || die "main files installation failed"
	eend

	einfo "Adjusting permissions"

	files="
		ccpnmr/c/ContourFile.so
		ccpnmr/c/ContourLevels.so
		ccpnmr/c/ContourStyle.so
		ccpnmr/c/PeakList.so
		ccpnmr/c/SliceFile.so
		ccpnmr/c/WinPeakList.so
		ccpnmr/c/AtomCoordList.so
		ccpnmr/c/AtomCoord.so
		ccpnmr/c/Bacus.so
		ccpnmr/c/CloudUtil.so
		ccpnmr/c/DistConstraintList.so
		ccpnmr/c/DistConstraint.so
		ccpnmr/c/DistForce.so
		ccpnmr/c/Dynamics.so
		ccpnmr/c/Midge.so
		ccp/c/StructAtom.so
		ccp/c/StructBond.so
		ccp/c/StructStructure.so
		ccp/c/StructUtil.so
		memops/c/BlockFile.so
		memops/c/FitMethod.so
		memops/c/GlHandler.so
		memops/c/MemCache.so
		memops/c/PdfHandler.so
		memops/c/PsHandler.so
		memops/c/ShapeFile.so
		memops/c/StoreFile.so
		memops/c/StoreHandler.so
		memops/c/TkHandler.so"

	for FILE in ${files}; do
		fperms 755 ${in_path}/python/${FILE}
	done
}

ccpnadd() {
	echo $@ >> "${S}"/c/environment.txt
}
