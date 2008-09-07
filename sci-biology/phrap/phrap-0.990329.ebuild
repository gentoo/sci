# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Phrap, swat, cross_match: Shotgun assembly and alignment utilities"
HOMEPAGE="http://www.phrap.org/"
SRC_URI="phrap-distrib.tar.Z"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please visit http://www.phrap.org/phredphrapconsed.html and obtain the file"
	einfo '"distrib.tar.Z", then rename it to "phrap-distrib.tar.Z" and put it in'
	einfo "${DISTDIR}"
}

src_compile() {
	sed -i 's/CFLAGS=/#CFLAGS=/' makefile
	sed -i 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' phrapview
	emake || die "emake failed"
}

src_install() {
	dobin cluster cross_match loco phrap phrapview swat
	for i in {general,phrap,swat}.doc ; do
		newdoc ${i} ${i}.txt
	done
}
