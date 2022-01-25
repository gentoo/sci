# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module webapp autotools

DESCRIPTION="Analyze restriction enzyme data, draw gen. maps, population genomics"
HOMEPAGE="http://creskolab.uoregon.edu/stacks"
SRC_URI="http://creskolab.uoregon.edu/stacks/source/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"

RESTRICT="test"

DEPEND="
	>=sci-libs/htslib-1.3.1:0
	dev-cpp/sparsehash
	sci-biology/samtools:*
	sci-biology/bamtools
	sci-biology/gmap
"

RDEPEND="${DEPEND}
	dev-lang/perl
	>=dev-lang/php-5:*
	dev-perl/DBD-mysql
"

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
	sed -e 's#/usr/lib/libbam.a#-lbam#;#./htslib/libhts.a#-lhts#' -i Makefile || die
}

src_install() {
	webapp_src_preinst
	DESTDIR="${ED}" default
	DESTDIR="${ED}" perl-module_src_install
	dodir /usr/share/webapps/${PN}/${PV}
	webapp_src_install
}
