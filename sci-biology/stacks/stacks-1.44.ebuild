# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit flag-o-matic eutils perl-module webapp autotools

DESCRIPTION="Analyze restriction enzyme data, draw gen. maps, population genomics"
HOMEPAGE="http://creskolab.uoregon.edu/stacks"
SRC_URI="http://creskolab.uoregon.edu/stacks/source/${P}.tar.gz"

LICENSE="GPL-3"
# SLOT="0" # webapp ebuilds do not set SLOT
KEYWORDS=""
IUSE=""

DEPEND="
	>=sci-libs/htslib-1.3.1:0
	dev-cpp/sparsehash
	sci-biology/samtools:*
	sci-biology/bamtools
	sci-biology/gmap" # Source code for both GMAP and GSNAP
RDEPEND="${DEPEND}
	dev-lang/perl
	>=dev-lang/php-5
	dev-perl/DBD-mysql"

src_prepare(){
	sed -e 's/SUBDIRS = htslib/SUBDIRS = /' -i Makefile.am || die
	#mycppflags=`pkg-config --cflags htslib` # is blocked by bug #601366
	if [ -z "$mycppflags" ]; then mycppflags="."; fi
	sed -e "s#-I./htslib/htslib#-I/usr/include/bam -I${mycppflags}#" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf --enable-bam --enable-sparsehash
	webapp_src_preinst
	sed -i 's#/usr/lib/libbam.a#-lbam#;#./htslib/libhts.a#-lhts#' Makefile || die
}

src_compile(){
	rm -rf htslib # zap bundled htslib-1.3.1
	emake DESTDIR="${D}"
}

src_install() {
	emake install DESTDIR="${D}"
	mydoc="Changes README TODO INSTALL"
	perl-module_src_install DESTDIR="${D}"
	webapp_src_install || die "Failed running webapp_src_install"
}

pkg_postinst() {
	webapp_pkg_postinst || die "webapp_pkg_postinst failed"
}
