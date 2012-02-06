# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=show&f=faspftp_runs_v1&m=downloads&s=download_sra"
SRC_URI="http://trace.ncbi.nlm.nih.gov/Traces/sra/static/sra_sdk-"${PV}".tar.gz"
# http://trace.ncbi.nlm.nih.gov/Traces/sra/static/sratoolkit.2.0.1-centos_linux64.tar.gz

LICENSE="public-domain"
SLOT="0"
#KEYWORDS=""
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="app-shells/bash
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

# upstream says:
# icc, icpc are supported: tested with 11.0 (64-bit) and 10.1 (32-bit), 32-bit 11.0 does not work

src_prepare(){
	epatch "${FILESDIR}"/sra_sdk-destdir.patch || die
}

src_compile(){
	# -I/usr/include/libxml2
	# -I/var/tmp/portage/sci-biology/sra_sdk-2.0.1/work/sra_sdk-2.0.1/interfaces/os/unix

	# COMP env variable may have 'GCC' or 'ICC' values
	if use static; then
		emake static LIBDIR=/lib64 DESTDIR="${D}"
	else
		emake dynamic LIBDIR=/lib64 DESTDIR="${D}"
	fi

	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir out LIBDIR=/lib64 DESTDIR="${D}" || die
	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir LIBDIR=/lib64 DESTDIR="${D}" || die
}

src_install(){
	# for details see "${WORKDIR}"/sra_sdk-2.1.6/README-build

	# BUG: at the moment every binary is installed three times, e.g.:
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2.1.6
	if use amd64; then
		dobin "${WORKDIR}"/objdir/linux/pub/gcc/x86_64/bin/*
		insinto /usr/bin/ncbi
		dobin "${WORKDIR}"/objdir/linux/pub/gcc/x86_64/bin/ncbi/*
	elif use x86; then
		dobin "${WORKDIR}"/objdir/linux/pub/gcc/i386/bin/*
		insinto /usr/bin/ncbi
		dobin "${WORKDIR}"/objdir/linux/pub/gcc/i386/bin/ncbi/*
	fi

	# mkdir -p ${D}/usr/bin || die
	# for f in ${W}/objdir/linux/rel/gcc/i386/bin/*; do if [ ! -l "$f" ]; then cp "$f" ${D}/usr/bin || die "copy failed" ; fi; done

	# looks the binaries have the folllowing libs statically linked in so we do NOT need these files
	# mkdir -p ${D}/usr/ilib || die
	# dolib ${W}/objdir/linux/rel/gcc/i386/ilib/*
	# insinto "${D}"/usr/lib/ncbi
	# doins ${W}/objdir/linux/rel/gcc/i386/ilib/ncbi/*

	# mkdir -p ${D}/usr/lib || die
	# dolib ${W}/objdir/linux/rel/gcc/i386/lib/*
	# insinto "${D}"/usr/lib/ncbi
	# doins ${W}/objdir/linux/rel/gcc/i386/lib/ncbi/*

	# same for mod/ and wmod/ subdirs
}
