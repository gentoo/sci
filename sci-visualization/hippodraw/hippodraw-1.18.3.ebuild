# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN=HippoDraw

DESCRIPTION="Highly interactive data analysis Qt environment for C++ and python"
HOMEPAGE="http://www.slac.stanford.edu/grp/ek/hippodraw/"
SRC_URI="ftp://ftp.slac.stanford.edu/users/pfkeb/${PN}/${MY_PN}-${PV}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="root fits minuit numarray doc"

# minuit: included in root-5, but standalone cheaper to build
# qt4 not implemented:
# - won't work with sip on amd64
# - is still under testing
# opengl: completely buggy
# wcslib: not yet implemented (wcslib has nasty build system)
# sip: still buggy (gcc411 issue?)

RDEPEND=">=dev-lang/python-2.3
	>=dev-libs/boost-1.32
	=x11-libs/qt-3*
	minuit? ( !root? >=sci-libs/minuit-5 )
	numarray? ( dev-python/numarray )
	fits? ( sci-libs/cfitsio
		numarray? ( dev-python/pyfits )
	      )
	root? ( >=sci-physics/root-5 )"
#	sip? ( >=dev-python/PyQt-3.14 )"

# really, pyfits should not be a dep, rather only rdep
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	local docdir=/usr/share/doc/${PF}
	# fix the install doc directory to gentoo's one
	if use doc; then
		sed -i \
			-e "s:\$(pkgdatadir)/html:${docdir}/html:" \
			doc/Makefile.in
	fi

	# fix an extra DESTDIR inherited from Makefile.am
	sed -i \
		-e "s:\$(DESTDIR)\$(pkgdatadir)/examples:${docdir}/examples:" \
		examples/Makefile.in

	# since we do not slot, remove version name in includes
	sed -i \
		-e 's/$(pkgincludedir)-$(VERSION)/$(pkgincludedir)/' \
		*/Makefile.in

	#if use sip; then
	#	sed -i \
	#		-e "s:/usr/local:/usr:g"\
	#		-e "" \
	#		sip/Makefile.in
	#fi	
}

src_compile() {

	local myconf="--with-boost-include=/usr/include"
	myconf="${myconf} --with-Qt-include-dir=/usr/qt/3/include"
	myconf="${myconf} --with-Qt-lib-dir=/usr/qt/3/$(get_libdir)"
	myconf="${myconf} --with-Qt-bin-dir=/usr/qt/3/bin"
	myconf="${myconf} --with-boost-lib=/usr/$(get_libdir)"
	myconf="${myconf} --with-boost-libname=boost_python"
	#built_with_use dev-libs/boost threads && myconf="${myconf}-mt"

	if use minuit && ! use root; then
		myconf="${myconf} --with-minuit2-include=/usr/include"
		myconf="${myconf} --with-minuit2-lib=/usr/$(get_libdir)"
	fi

	if use root; then
		myconf="${myconf} --with-root-include=/usr/include/root"
		myconf="${myconf} --with-root-lib=/usr/$(get_libdir)/root"
	fi

	if use fits; then
		myconf="${myconf} --with-cfitsio-include=/usr/include"
		myconf="${myconf} --with-cfitsio-lib=/usr/$(get_libdir)"
	fi

	econf \
		$(use_enable numarray numarraybuild) \
		$(use_enable doc help) \
		${myconf} || die "econf failed"
	# qtui failed with -j2, so build it first with -j1
	emake -j1 -C qtui || die "make qtui failed"
	emake || die "emake failed"
	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	make_desktop_entry hippodraw HippoDraw hippoApp Science "/usr/share/${MY_PN}"
	dodoc README DISCLAIMER.rtf
}
