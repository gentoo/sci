# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pymol/pymol-0.99_rc10.ebuild,v 1.9 2009/08/02 14:58:31 je_fro Exp $

inherit distutils eutils multilib subversion

ESVN_REPO_URI="https://pymol.svn.sourceforge.net/svnroot/pymol/branches/b099/pymol@2974"
DESCRIPTION="A Python-extensible molecular graphics system."
HOMEPAGE="http://pymol.sourceforge.net/"

LICENSE="pymol"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-lang/python
dev-python/pmw
dev-lang/tk
media-libs/libpng
sys-libs/zlib
virtual/glut"

RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack

	epatch "${FILESDIR}"/${P}-data-path.patch

# Turn off splash screen.  Please do make a project contribution
# if you are able.
	[[ -n "$WANT_NOSPLASH" ]] && epatch "${FILESDIR}"/nosplash-gentoo.patch

# Respect CFLAGS
	sed -i \
	-e "s:\(ext_comp_args=\).*:\1[]:g" \
	"${S}"/setup.py
}

src_install() {
	python_version

	distutils_src_install
	cd "${S}"

#The following three lines probably do not do their jobs and should be
#changed
	PYTHONPATH="${D}/usr/$(get_libdir)/site-packages" ${python} setup2.py

# These environment variables should not go in the wrapper script, or else
# it will be impossible to use the PyMOL libraries from Python.
		cat >> "${T}"/20pymol << EOF
		PYMOL_PATH=/usr/$(get_libdir)/python${PYVER}/site-packages/pymol
		PYMOL_DATA="/usr/share/pymol/data"
		PYMOL_SCRIPTS="/usr/share/pymol/scripts"
EOF

	doenvd "${T}"/20pymol || die "Failed to install env.d file."

# Make our own wrapper
		cat >> "${T}"/pymol << EOF
#!/bin/sh
		${python} \${PYMOL_PATH}/__init__.py \$*
EOF

		exeinto /usr/bin
		doexe "${T}"/pymol || die "Failed to install wrapper."
		dodoc DEVELOPERS CHANGES || die "Failed to install docs."

		mv examples "${D}"/usr/share/doc/${PF}/ || die "Failed moving docs."

		dodir /usr/share/pymol
		mv test "${D}"/usr/share/pymol/ || die "Failed moving test files."
		mv data "${D}"/usr/share/pymol/ || die "Failed moving data files."
		mv scripts "${D}"/usr/share/pymol/ || die "Failed moving scripts."
}
