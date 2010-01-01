# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="chempy pmg_tk pymol"
PYTHON_USE_WITH="tk"

inherit distutils

APBS_PATCH="090618"
REV="3859"

DESCRIPTION="A Python-extensible molecular graphics system."
HOMEPAGE="http://pymol.sourceforge.net/"
SRC_URI="apbs? ( mirror://gentoo/apbs_tools.py.${APBS_PATCH}.bz2 )
	http://pymol.svn.sourceforge.net/viewvc/pymol/trunk/pymol.tar.gz?view=tar&pathrev=${REV} -> ${P}.tar.gz"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apbs shaders"

DEPEND="
	dev-python/numpy
	dev-python/pmw
	media-libs/libpng
	media-libs/freetype:2
	media-video/mpeg-tools
	sys-libs/zlib
	virtual/glut
	apbs? (
		dev-libs/maloc
		sci-chemistry/apbs
		sci-chemistry/pdb2pqr
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

pkg_setup(){
	python_version
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}/${P}-data-path.patch \
		|| die "Failed to apply data-path.patch"

	# Turn off splash screen.  Please do make a project contribution
	# if you are able though. # 299020
	epatch "${FILESDIR}"/${PV}/nosplash-gentoo.patch

	# Respect CFLAGS
	sed -i \
		-e "s:\(ext_comp_args=\).*:\1[]:g" \
		"${S}"/setup.py || die "Failed running sed on setup.py"

	use shaders && epatch "${FILESDIR}"/${PV}/${P}-shaders.patch

	if use apbs; then
		cp -f "${WORKDIR}"/apbs_tools.py.${APBS_PATCH} modules/pmg_tk/startup/apbs_tools.py \
			|| die "Failed to copy apbs_tools.py"

		sed "s:LIBANDPYTHON:$(python_get_libdir):g" \
			-i modules/pmg_tk/startup/apbs_tools.py \
				|| die "Failed running sed on apbs_tools.py"
	fi
}

src_configure() {
	:
}

src_install() {
	distutils_src_install

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF
		PYMOL_PATH=$(python_get_sitedir)/${PN}
		PYMOL_DATA="/usr/share/pymol/data"
		PYMOL_SCRIPTS="/usr/share/pymol/scripts"
	EOF

	if use apbs; then
		echo "APBS_PSIZE=$(python_get_sitedir)/pdb2pqr/src/psize.py" >> "${T}"/20pymol
	fi

	doenvd "${T}"/20pymol || die "Failed to install env.d file."

	cat >> "${T}"/pymol <<- EOF
	#!/bin/sh
	${python} -O \${PYMOL_PATH}/__init__.py \$*
	EOF

	dobin "${T}"/pymol || die "Failed to install wrapper."

	insinto /usr/share/pymol
	doins -r test data scripts || die "no shared data"

	insinto /usr/share/pymol/examples
	doins -r examples || die "Failed to install docs."

	dodoc DEVELOPERS README || die "Failed to install docs."

	if ! use apbs; then
		rm "${D}"$(python_get_sitedir)/pmg_tk/startup/apbs_tools.py
	fi
}
