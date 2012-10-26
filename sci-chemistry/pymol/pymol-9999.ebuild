# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 2.6 3.* *-jython 2.7-pypy-*"
PYTHON_USE_WITH="tk"
PYTHON_MODNAME="${PN} chempy pmg_tk pmg_wx"

inherit distutils eutils fdo-mime prefix subversion versionator

DESCRIPTION="A Python-extensible molecular graphics system."
HOMEPAGE="http://pymol.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${PN}-icons.tar.xz"
ESVN_REPO_URI="https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="apbs numpy vmd web"

DEPEND="
	dev-python/numpy
	dev-python/pmw
	media-libs/freetype:2
	media-libs/glew
	media-libs/libpng
	media-video/mpeg-tools
	sys-libs/zlib
	media-libs/freeglut
	apbs? (
		dev-libs/maloc
		sci-chemistry/apbs
		sci-chemistry/pdb2pqr
		sci-chemistry/pymol-apbs-plugin
	)
	web? ( !dev-python/webpy )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	subversion_src_unpack
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-setup.py.patch \
		"${FILESDIR}"/${P}-data-path.patch \
		"${FILESDIR}"/${P}-flags.patch

	use web || epatch "${FILESDIR}"/${P}-web.patch

	epatch "${FILESDIR}"/${P}-prefix.patch && \
		eprefixify setup.py

	use vmd && epatch "${FILESDIR}"/${P}-vmd.patch

	if use numpy; then
		sed \
			-e '/PYMOL_NUMPY/s:^#::g' \
			-i setup.py || die
	fi

	rm ./modules/pmg_tk/startup/apbs_tools.py || die

	echo "site_packages = \'$(python_get_sitedir -f)\'" > setup3.py || die

	sed \
		-e "s:/opt/local:${EPREFIX}/usr:g" \
		-e '/ext_comp_args/s:\[.*\]:[]:g' \
		-i setup.py || die

	# python 3.* fix
	# sed '452,465d' -i setup.py
	distutils_src_prepare
}

src_configure() {
	:
}

src_install() {
	distutils_src_install

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF
		PYMOL_PATH="${EPREFIX}/$(python_get_sitedir -f)/${PN}"
		PYMOL_DATA="${EPREFIX}/usr/share/pymol/data"
		PYMOL_SCRIPTS="${EPREFIX}/usr/share/pymol/scripts"
	EOF

	doenvd "${T}"/20pymol

	cat >> "${T}"/pymol <<- EOF
	#!/bin/sh
	$(PYTHON -f) -O \${PYMOL_PATH}/__init__.py -q \$*
	EOF

	dobin "${T}"/pymol

	insinto /usr/share/pymol
	doins -r test data scripts

	insinto /usr/share/pymol/examples
	doins -r examples

	dodoc DEVELOPERS README

	doicon "${WORKDIR}"/${PN}.{xpm,png}
	make_desktop_entry pymol PyMol ${PN} "Graphics;Education;Science;Chemistry" "MimeType=chemical/x-pdb;"
}

pkg_postinst() {
	elog "\t USE=shaders was removed,"
	elog "please use pymol config settings (~/.pymolrc)"
	elog "\t set use_shaders, 1"
	elog "in case of crashes, please deactivate this experimental feature by setting"
	elog "\t set use_shaders, 0"
	elog "\t set sphere_mode, 0"
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
