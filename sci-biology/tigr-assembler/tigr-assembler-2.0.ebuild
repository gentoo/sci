# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A whole-genome shotgun assembler from TIGR"
HOMEPAGE="http://www.tigr.org/software/assembler/"
SRC_URI="ftp://ftp.tigr.org/pub/software/assembler/TIGR_Assembler_v2.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/TIGR_Assembler_v2"

src_prepare() {
	cd "${S}"/bin || die
	mv run_TA run_TA.csh || die
	cp "${FILESDIR}"/run_TA run_TA || die
}
src_compile() {
	sed -i 's/^CC/#CC/' "${S}/src/Makefile" || die "sed failed"
	sed -i 's/CFLAGS.*= -O/CFLAGS := ${CFLAGS}/' "${S}/src/Makefile" || die "sed failed"
	cd "${S}/src" || die
	emake || die "emake failed"
}

src_install() {
	dobin bin/{run_TA,run_TA.csh,TIGR_Assembler} || die
	dodoc README || die
}

src_test() {
	cd "${S}"/data/201.pre || die
	PATH="${D}"/usr/bin:$PATH run_TA '-s -q 201.qual -C 201.contigs' 201.seq || die "Failed to execute run_TA"
	for f in *; do diff -I "^ed_date" -u -w ../201.post/$f $f; done || die "Found some differences in the output files compared to expected results."
	for f in 201.align/*; do diff -u -w ../201.post/$f $f; done || die "Found some differences in the output files compared to expected results."
}
