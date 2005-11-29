# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=Minuit-${PV//./_}

DESCRIPTION="A C++ physics analysis tool for function minimization"
HOMEPAGE="http://seal.web.cern.ch/seal/snapshot/work-packages/mathlibs/minuit"
SRC_URI="http://seal.web.cern.ch/seal/${PN}/releases/${MY_P}.tar.gz
    doc? http://seal.cern.ch/documents/${PN}/mnusersguide.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	if use doc; then
		make docs || die "make docs failed"
	fi	
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodir /usr/share/doc/${PF}/MnTutorial
	insinto /usr/share/doc/${PF}/MnTutorial
	doins tests/MnTutorial/*.{h,cpp}
	if use doc; then
		doins ${DISTDIR}/mnusersguide.pdf || die "doins failed"
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}
