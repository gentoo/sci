# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=show&f=faspftp_runs_v1&m=downloads&s=download_sra"
SRC_URI="http://trace.ncbi.nlm.nih.gov/Traces/sra/static/sra_sdk-"${PV}".tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-shells/bash
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

# icc, icpc are supported: tested with 11.0 (64-bit) and 10.1 (32-bit), 32-bit 11.0 does not work

src_compile(){
	# -I/usr/include/libxml2
	# -I/var/tmp/portage/sci-biology/sra_sdk-2.0.1/work/sra_sdk-2.0.1/interfaces/os/unix
	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir out || die
	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir || die
}

src_install(){
	if use amd64; then
		dobin ${WORKDIR}"/objdir/linux/rel/gcc/x86_64/bin/*"
	elif use x86; then
		dobin ${WORKDIR}"/objdir/linux/rel/gcc/i386/bin/*"
	fi

	# mkdir -p ${D}/usr/bin || die
	# for f in ${W}/objdir/linux/rel/gcc/i386/bin/*; do if [ ! -l "$f" ]; then cp "$f" ${D}/usr/bin || die "copy failed" ; fi; done

	# looks the binaries have the folllowing libs statically linked
	# mkdir -p ${D}/usr/ilib || die
	# dolib ${W}/objdir/linux/rel/gcc/i386/ilib/*

	# mkdir -p ${D}/usr/lib || die
	# dolib ${W}/objdir/linux/rel/gcc/i386/lib/*
}
