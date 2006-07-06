# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="RKWard aims to provide an easily extensible, easy to use IDE/GUI for the R-project. RKWard tries to combine the power of the R-language with the (relative) ease of use of commercial statistics tools. Long term plans include integration with office suites"

HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="http://rkward.sourceforge.net/temp/rkward-0.3.7pre1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="arts"

DEPEND=">=sci-libs/lapack-3.0
		>=x11-libs/qt-3.3.4
		>=kde-base/kdelibs-3.4.1
		>=dev-lang/R-2.2.0
		>=dev-lang/php-4.3.11
		arts? ( kde-base/arts
	    	|| ( kde-base/kdemultimedia-arts kde-base/kdemultimedia ) )"

src_unpack() {
	unpack ${A} || die
	mv rkward-0.3.7pre1 rkward-0.3.7_pre1 || die
}

src_compile() {
	econf --prefix=$(kde-config --prefix) \
		$(use_with arts) || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
}

