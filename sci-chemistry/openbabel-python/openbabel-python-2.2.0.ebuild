# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="swig"

RDEPEND="~sci-chemistry/openbabel-2.2.0
	dev-lang/python"

DEPEND="${RDEPEND}
	swig? ( >=dev-lang/swig-1.3.29 )"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/openbabel-${PV}"
	cd "${S}"

	local myconf=""
	if use swig ; then
		if ! built_with_use dev-lang/swig python ; then
			echo
			eerror "To be able to build openbabel-python with swig use"
			eerror "dev-lang/swig has to be merged with python enabled."
			eerror "Please, re-emerge dev-lang/swig with USE=\"python\"."
			die "dev-lang/swig has been built without python support"
		else
			myconf="--enable-maintainer-mode"
		fi
	fi
	econf \
		${myconf} \
		--enable-static \
		|| die "econf failed"
	S="${S}/scripts"
	cd "${S}"
	if use swig ; then
		emake python/openbabel_python.cpp \
			|| die "Failed to make SWIG python bindings"
	fi
	S="${S}/python"
	cd "${S}"
}

src_compile() {
	python ./setup.py build || die "python setup build failed"
}

src_install() {
	python ./setup.py install --root="${D}" --optimize=1 \
		|| die "python setup install failed"
	dohtml *.html
	dodoc README
}

pkg_postinst() {
	echo
	elog "To be able to fully use Pybel you might need to install additional"
	elog "libraries:"
	elog "OASA - part of BKChem package"
	elog "PIL  - dev-python/imaging"
}
