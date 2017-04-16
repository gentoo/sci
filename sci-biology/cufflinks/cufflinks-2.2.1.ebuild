# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/cufflinks/cufflinks-1.3.0-r1.ebuild,v 1.1 2014/02/05 08:16:11 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Transcript assembly, differential expression, and differential regulation for RNA-Seq"
HOMEPAGE="http://cufflinks.cbcb.umd.edu/"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-biology/samtools-0.1.18
	dev-cpp/eigen
	dev-libs/boost:="
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)/"
		--with-bam="${EPREFIX}/usr/"
		$(use_enable debug)
	)
	CFLAGS="-I${EPREFIX}/usr/include/eigen3 ${CFLAGS}" \
	autotools-utils_src_configure
}

src_compile() {
	cd "${WORKDIR}/${P}_build"
	find . -name Makefile -exec sed -i "/^BAM_LIB =/s|$| -lhts|" {} \;
	emake
}
