# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Automatic correct of discrepancies in multiple sequence alignments"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/amos/index.php?title=AutoEditor"
SRC_URI="
	ftp://ftp.cbcb.umd.edu/pub/software/autoEditor/autoEditor-1.20.tar.gz
	test? ( ftp://ftp.cbcb.umd.edu/pub/software/autoEditor/autoEditor-1.20-sample.tar.gz )"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=sci-libs/io_lib-1.8.11
	sci-biology/tigr-foundation-libs
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/autoEditor-1.20

src_prepare(){
	epatch "${FILESDIR}"/Makefile.patch
	rm -rf TigrFoundation-2.0 || die "Failed to drop TigrFoundation-2.0/"
}

# TODO:
#  * QA Notice: Package has poor programming practices which may compile
#  *            fine but exhibit random runtime failures.
#  * getConsQV.c:1051: warning: implicit declaration of function 'memset'

src_test(){
	emake sample > sample.out
	diff -u -w "${FILESDIR}"/sample_expected.out sample.out || die
}
