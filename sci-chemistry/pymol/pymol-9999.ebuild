# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 fdo-mime subversion versionator

DESCRIPTION="A Python-extensible molecular graphics system"
HOMEPAGE="http://www.pymol.org/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${PN}-1.7.0.0.png.xz"
ESVN_REPO_URI="svn://svn.code.sf.net/p/pymol/code/trunk/pymol"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS=""
IUSE="apbs web"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pmw[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	media-libs/freetype:2
	media-libs/glew
	media-libs/libpng
	media-video/mpeg-tools
	sys-libs/zlib
	media-libs/freeglut
	apbs? (
		sci-chemistry/apbs
		sci-chemistry/pdb2pqr
		sci-chemistry/pymol-apbs-plugin[${PYTHON_USEDEP}]
	)
	web? ( !dev-python/webpy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	subversion_src_unpack
}

python_prepare_all() {
	sed \
		-e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-e "/ext_comp_args.*+=/s:\[.*\]$:\[\]:g" \
		-e "/import/s:argparse:argparseX:g" \
		-i setup.py || die

	rm ./modules/pmg_tk/startup/apbs_tools.py || die

	sed \
		-e "s:/opt/local:${EPREFIX}/usr:g" \
		-e '/ext_comp_args/s:\[.*\]:[]:g' \
		-i setup.py || die

	distutils-r1_python_prepare_all
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

	python_export python2_7 EPYTHON

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF
		PYMOL_PATH="$(python_get_sitedir)/${PN}"
		PYMOL_DATA="${EPREFIX}/usr/share/pymol/data"
		PYMOL_SCRIPTS="${EPREFIX}/usr/share/pymol/scripts"
	EOF

	doenvd "${T}"/20pymol

	newicon "${WORKDIR}"/${PN}-1.7.0.0.png ${PN}.png
	make_desktop_entry ${PN} PyMol ${PN} \
		"Graphics;Education;Science;Chemistry;" \
		"MimeType=chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;"

	if ! use web; then
		rm -rf "${D}/$(python_get_sitedir)/web" || die
	fi

	rm -f "${ED}"/usr/share/${PN}/LICENSE || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
