# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Geometry Engine - Open Source"
HOMEPAGE="http://geos.refractions.net"
SRC_URI="http://geos.refractions.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~sparc"
IUSE="static doc python"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )\
		python? ( dev-lang/python dev-lang/swig )"

src_compile(){
	cd ${S}
	libtoolize --force
	
	local myconf
	myconf=""
	use static && myconf="$(use_enable static)"
	
	econf ${myconf} || die "Error: econf failed"
	
	emake || die "Error: emake failed"
	if use python; then
		einfo "Compilling PyGEOS"
		cd ${S}/swig/python
		swig -c++ -python -modern -o geos_wrap.cxx ../geos.i
		python setup.py build
	fi
}

src_test() {
	cd ${S}
	make check || die "Tring make check without success."
# I think this test must be made after the PyGEOS installation
#	if use python; then
#		cd ${S}/swig/python
#		python tests/runtests.py -v
#	fi		
}

src_install(){
	into /usr
	einstall
	dodoc AUTHORS COPYING INSTALL NEWS README TODO
	if use doc; then
		cd ${S}/doc
		make doxygen-html
		dohtml -r doxygen_docs/html/*
	fi
	if use python; then
		einfo "Intalling PyGEOS"
		cd ${S}/swig/python
		python setup.py install --prefix="${D}/usr/"
		insinto /usr/share/doc/${PF}/python
		doins README.txt tests/*.py
		insinto /usr/share/doc/${PF}/python/cases
		doins tests/cases/*
	fi
}

