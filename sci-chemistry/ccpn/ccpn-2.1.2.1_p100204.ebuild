# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_USE_WITH="ssl tk"

inherit eutils portability python toolchain-funcs versionator

PATCHSET="${PV##*_p}"
MY_PN="${PN}mr"
MY_PV="$(replace_version_separator 3 _ ${PV%%_p*})"

DESCRIPTION="The Collaborative Computing Project for NMR"
SRC_URI="http://www.bio.cam.ac.uk/ccpn/download/${MY_PN}/analysis${MY_PV}.tar.gz"
	[[ -n ${PATCHSET} ]] && SRC_URI="${SRC_URI}	http://dev.gentooexperimental.org/~jlec/distfiles/ccpn-update-${PATCHSET}.patch.bz2"
HOMEPAGE="http://www.ccpn.ac.uk/ccpn"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86"
IUSE="+opengl"

RDEPEND="
	dev-lang/tk
	dev-python/elementtree
	dev-python/numpy
	dev-tcltk/tix
	opengl? ( virtual/glut )"
DEPEND="${RDEPEND}"
RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}/${MY_PN}$(get_version_component_range 1-2 ${PV})

pkg_setup() {
	python_version
}

src_prepare() {
	[[ -n ${PATCHSET} ]] && \
		epatch "${WORKDIR}"/ccpn-update-${PATCHSET}.patch

	local tk_ver
	local myconf

	tk_ver="$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)"

	if use opengl; then
		GLUT_NEED_INIT="-DNEED_GLUT_INIT"
		IGNORE_GL_FLAG=""
		GL_FLAG="-DUSE_GL_FALSE"
		GL_DIR="/usr"
		GL_LIB="-lglut -lGLU -lGL"
		GL_INCLUDE_FLAGS="-I\$(GL_DIR)/include"
		GL_LIB_FLAGS="-L\$(GL_DIR)/$(get_libdir)"

	else
		IGNORE_GL_FLAG="-DIGNORE_GL"
		GL_FLAG="-DUSE_GL_FALSE"
	fi

	GLUT_NOT_IN_GL=""
	GLUT_FLAG="\$(GLUT_NEED_INIT) \$(GLUT_NOT_IN_GL)"

	sed \
		-e "s:^\(CC =\).*:\1 $(tc-getCC):g" \
		-e "s:^\(OPT_FLAG =\).*:\1 ${CFLAGS}:g" \
		-e "s:^\(LINK_FLAGS =.*\):\1 ${LDFLAGS}:g" \
		-e "s:^\(IGNORE_GL_FLAG =\).*:\1 ${IGNORE_GL_FLAG}:g" \
		-e "s:^\(GL_FLAG =\).*:\1 ${GL_FLAG}:g" \
		-e "s:^\(GLUT_NEED_INIT =\).*:\1 ${GLUT_NEED_INIT}:g" \
		-e "s:^\(GLUT_NOT_IN_GL =\).*:\1:g" \
		-e "s:^\(X11_LIB_FLAGS =\).*:\1 -L/usr/$(get_libdir):g" \
		-e "s:^\(TCL_LIB_FLAGS =\).*:\1 -L/usr/$(get_libdir):g" \
		-e "s:^\(TK_LIB_FLAGS =\).*:\1 -L/usr/$(get_libdir):g" \
		-e "s:^\(PYTHON_INCLUDE_FLAGS =\).*:\1 -I\$(PYTHON_DIR)/include/python${PYVER}:g" \
		-e "s:^\(GL_LIB_FLAGS =\).*:\1 -L/usr/$(get_libdir):g" \
		c/environment_default.txt > c/environment.txt
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

	for wrapper in analysis dangle dataShifter eci formatConverter pipe2azara; do
		sed -e "s:gentoo_sitedir:${gentoo_sitedir}:g" \
		    -e "s:libdir:${libdir}:g" \
			-e "s:tkver:${tkver}:g" \
		    "${FILESDIR}"/${wrapper} > "${T}"/${wrapper} || die "Fail fix ${wrapper}"
		dobin "${T}"/${wrapper} || die "Failed to install ${wrapper}"
	done

	for i in python/memops/format/compatibility/{Converters,part2/Converters2}.py; do
		sed \
			-e 's:#from __future__:from __future__:g' \
			-i ${i}
	done

	insinto ${in_path}

	dodir ${in_path}/c

	ebegin "Installing main files"
	doins -r data model python || die "main files installation failed"
	eend

	dohtml -r doc/* || die
	dosym ../../../../share/doc/${PF}/html ${in_path}/doc || die

	einfo "Adjusting permissions"

	files="ccpnmr/c/ContourFile.so
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

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize $(python_get_sitedir)/${PN}
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/${PN}
}
