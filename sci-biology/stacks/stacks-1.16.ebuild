# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit flag-o-matic eutils perl-module webapp

DESCRIPTION="Analyze Restriction enzyme data, draw gen. maps, population genomics (RAD-seq Illumina sequencing)"
HOMEPAGE="http://creskolab.uoregon.edu/stacks"
SRC_URI="http://creskolab.uoregon.edu/stacks/source/${P}.tar.gz"

LICENSE="GPL-3"
# SLOT="0" # webapp ebuilds do not set SLOT
KEYWORDS=""
IUSE=""

# sys-cluster/openmpi
DEPEND="
	dev-cpp/sparsehash
	sci-biology/samtools
	sci-biology/bamtools"
RDEPEND="${DEPEND}
	dev-lang/perl
	>=dev-lang/php-5
	dev-perl/DBD-mysql"

src_configure() {
	econf --enable-bam --enable-sparsehash
	webapp_src_preinst
	sed -i 's#/usr/lib/libbam.a#-lbam#' Makefile || die
}

src_compile(){
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
