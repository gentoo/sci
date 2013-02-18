# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 fdo-mime prefix subversion versionator

DESCRIPTION="A Python-extensible molecular graphics system"
HOMEPAGE="http://pymol.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${PN}-icons.tar.xz"
ESVN_REPO_URI="https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="apbs"

DEPEND="
	dev-python/numpy
	dev-python/pmw[${PYTHON_USEDEP}]
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
	!dev-python/webpy"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	subversion_src_unpack
}

python_prepare_all() {
	sed \
		-e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-e "/ext_comp_args/s:=.*$:=:g" \
		-i setup.py || die

	rm ./modules/pmg_tk/startup/apbs_tools.py || die

	distutils-r1_python_prepare_all

	eprefixify setup.py
}

src_prepare() {
	subversion_src_prepare
	distutils-r1_src_prepare
}

python_install() {
	distutils-r1_python_install --pymol-path="${EPREFIX}/usr/share/pymol"
}

python_install_all() {
	distutils-r1_python_install_all

	doicon "${WORKDIR}"/${PN}.{xpm,png}
	make_desktop_entry pymol PyMol ${PN} "Graphics;Education;Science;Chemistry" "MimeType=chemical/x-pdb;"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
