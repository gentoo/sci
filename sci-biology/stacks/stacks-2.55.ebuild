# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic perl-module webapp autotools

DESCRIPTION="Analyze restriction enzyme data, draw gen. maps, population genomics"
HOMEPAGE="http://creskolab.uoregon.edu/stacks"
SRC_URI="http://creskolab.uoregon.edu/stacks/source/${P}.tar.gz"

LICENSE="GPL-3"
# SLOT="0" # webapp ebuilds do not set SLOT
KEYWORDS=""

# No rule to make target test
RESTRICT="test"

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

PATCHES=(
	"${FILESDIR}/${PN}-make-install.patch"
)

src_prepare(){
	default
	#mycppflags=`pkg-config --cflags htslib` # is blocked by bug #601366
	if [ -z "$mycppflags" ]; then mycppflags="."; fi
	sed -e "s#-I./htslib/htslib#-I/usr/include/bam -I${mycppflags}#" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf
	webapp_src_preinst
	sed -e 's#/usr/lib/libbam.a#-lbam#;#./htslib/libhts.a#-lhts#' -i Makefile || die
}

src_install() {
	emake install DESTDIR="${ED}"
	mydoc="Changes README TODO INSTALL"
	perl-module_src_install DESTDIR="${ED}"
	webapp_src_install || die "Failed running webapp_src_install"
}

pkg_postinst() {
	webapp_pkg_postinst || die "webapp_pkg_postinst failed"
}
