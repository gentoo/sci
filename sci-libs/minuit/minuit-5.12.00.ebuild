# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN=Minuit2

DESCRIPTION="A C++ physics analysis tool for function minimization"
HOMEPAGE="http://seal.web.cern.ch/seal/MathLibs/Minuit2/html/index.html"
# watch out: needs to change the package versioning (always same name)
SRC_URI="http://seal.web.cern.ch/seal/MathLibs/${MY_PN}/${MY_PN}.tar.gz
	doc? http://seal.cern.ch/documents/minuit/mnusersguide.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}-${PV}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	insinto /usr/share/doc/${PF}/MnTutorial
	doins tests/MnTutorial/*.{h,cpp}
	if use doc; then
		insinto /usr/share/doc/${P}
		doins ${DISTDIR}/mnusersguide.pdf || die "doins failed"
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}
