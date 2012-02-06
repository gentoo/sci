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
KEYWORDS="~amd64"
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
	epatch "${FILESDIR}"/tools_vdb-vcopy_Makefile.patch || die
	epatch "${FILESDIR}"/libs_sra_Makefile.patch || die
	mkdir -p /var/tmp/portage/sci-biology/"${P}"/image//var/tmp/portage/sci-biology/
	ln -s /var/tmp/portage/sci-biology/"${P}" /var/tmp/portage/sci-biology/"${P}"/image//var/tmp/portage/sci-biology/"${P}"

}

src_compile(){
	# COMP env variable may have 'GCC' or 'ICC' values
	if use static; then
		emake static LIBDIR=/usr/lib64 DESTDIR="${D}"
	else
		emake dynamic LIBDIR=/usr/lib64 DESTDIR="${D}"
	fi

	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir out LIBDIR=/usr/lib64 DESTDIR="${D}" || die
	LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir LIBDIR=/usr/lib64 DESTDIR="${D}" || die

	# preserve the libs written directly into $DESTDIR by ar/ld/gcc
	mkdir -p "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/lib
	mv "${D}"/usr/lib64/* "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/lib/
}

src_install(){
	rm -rf  /var/tmp/portage/sci-biology/"${P}"/image//var
	# BUG: at the moment every binary is installed three times, e.g.:
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2.1.6
	if use amd64; then
		mkdir "${D}"/usr
		mkdir "${D}"/usr/bin
		dobin "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/bin/*
		# for f in ${W}/objdir/linux/rel/gcc/i386/bin/*; do if [ ! -l "$f" ]; then cp "$f" ${D}/usr/bin || die "copy failed" ; fi; done

		dolib "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/lib/*
		dolib "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/ilib/*
		dolib "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/mod/*
		dolib "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/wmod/*
	fi
}
