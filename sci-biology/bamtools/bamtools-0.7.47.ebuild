# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="BamTools provides a fast, flexible C++ API for reading and writing BAM files."
HOMEPAGE="http://sourceforge.net/projects/bamtools"
SRC_URI="http://downloads.sourceforge.net/project/bamtools/bamtools/${PN}-v${PV}/BamTools-v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${WORKDIR}"/BamTools-v"${PV}" || die "Failed to chdir to ${WORKDIR}/BamTools-v${PV}"
	sed -i -e 's/^CXX/#CXX/' Makefile || die "Failed to fix Makefile"
}

src_compile() {
	cd "${WORKDIR}"/BamTools-v"${PV}" || die "Failed to chdir to ${WORKDIR}/BamTools-v${PV}"
	emake || die "Failed to make"
}

src_install() {
	cd "${WORKDIR}"/BamTools-v"${PV}" || die "Failed to chdir to ${WORKDIR}/BamTools-v${PV}"
	dobin BamConversion BamDump BamTrim || die "Failed to install binaries"
	insinto /usr/include
	doins BamReader.h BamWriter.h BGZF.h BamAux.h || die "Failed to install headers"
	dodoc README
}
