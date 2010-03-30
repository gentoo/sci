# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pymol/pymol-1.2.3-r1.ebuild,v 1.3 2010/03/23 13:54:53 fauli Exp $

EAPI="3"

SUPPORT_PYTHON_ABIS="1"
PYTHON_USE_WITH="tk"

inherit eutils distutils prefix subversion

ESVN_REPO_URI="https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol"

DESCRIPTION="A Python-extensible molecular graphics system."
HOMEPAGE="http://pymol.sourceforge.net/"
SRC_URI=""

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="apbs numpy shaders vmd"

DEPEND="
		dev-python/numpy
		dev-python/pmw
		media-libs/freetype:2
		media-libs/libpng
		media-video/mpeg-tools
		sys-libs/zlib
		virtual/glut
		apbs? (
			dev-libs/maloc
			sci-chemistry/apbs
			sci-chemistry/pdb2pqr
			sci-chemistry/pymol-apbs-plugin
		)"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3.* 2.4"


src_prepare() {
	epatch "${FILESDIR}"/1.2.2-data-path.patch

	epatch "${FILESDIR}"/1.2.2-prefix.patch && \
	eprefixify setup.py

	# Turn off splash screen.  Please do make a project contribution
	# if you are able though. #299020
	epatch "${FILESDIR}"/nosplash-gentoo.patch

	# Respect CFLAGS
	sed -i \
		-e "s:\(ext_comp_args=\).*:\1[]:g" \
		"${S}"/setup.py || die "Failed running sed on setup.py"

	use shaders && \
		sed \
			-e '/PYMOL_OPENGL_SHADERS/s:^#::g' \
			-i setup.py

	use vmd && \
		sed \
			-e 's:\] + 0 \* \[:] + 1 * [:g' \
			-e '/contrib\/uiuc\/plugins/s:^#::g' \
			-e '/PYMOL_VMD_PLUGINS/s:^#::g' \
			-i setup.py

	use numpy && \
		sed \
			-e '/PYMOL_NUMPY/s:^#::g' \
			-i setup.py
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

	doenvd "${T}"/20pymol || die "Failed to install env.d file."

	cat >> "${T}"/pymol <<- EOF
	#!/bin/sh
	$(PYTHON -f) -O \${PYMOL_PATH}/__init__.py \$*
	EOF

	dobin "${T}"/pymol || die "Failed to install wrapper."

	insinto /usr/share/pymol
	doins -r test data scripts || die "no shared data"

	insinto /usr/share/pymol/examples
	doins -r examples || die "Failed to install docs."

	dodoc DEVELOPERS README || die "Failed to install docs."

#	rm "${D}"$(python_get_sitedir)/pmg_tk/startup/apbs_tools.py
}
