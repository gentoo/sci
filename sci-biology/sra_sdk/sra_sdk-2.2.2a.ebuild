# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

W="${WORKDIR}"/"${P}"

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=show&f=faspftp_runs_v1&m=downloads&s=download_sra"
SRC_URI="http://ftp-private.ncbi.nlm.nih.gov/sra/sdk/2.2.2a/sra_sdk-"${PV}".tar.gz"
# http://ftp-private.ncbi.nlm.nih.gov/sra/sdk/2.2.2a/sratoolkit.2.2.2a-centos_linux64.tar.gz

LICENSE="public-domain"
SLOT="0"
#KEYWORDS=""
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="
	app-shells/bash:*
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/libxml2:2="
RDEPEND="${DEPEND}"

# upstream says:
# icc, icpc are supported: tested with 11.0 (64-bit) and 10.1 (32-bit), 32-bit 11.0 does not work

#src_prepare(){
	# epatch "${FILESDIR}"/sra_sdk-destdir.patch || die
	# epatch "${FILESDIR}"/tools_vdb-vcopy_Makefile.patch || die
	# epatch "${FILESDIR}"/libs_sra_Makefile.patch || die
	# mkdir -p /var/tmp/portage/sci-biology/"${P}"/image//var/tmp/portage/sci-biology/
	# ln -s /var/tmp/portage/sci-biology/"${P}" /var/tmp/portage/sci-biology/"${P}"/image//var/tmp/portage/sci-biology/"${P}"

#}

src_compile(){
	# # COMP env variable may have 'GCC' or 'ICC' values
	#if use static; then
	#	emake static LIBDIR=/usr/lib64 DESTDIR="${D}"
	#else
	#	emake dynamic LIBDIR=/usr/lib64 DESTDIR="${D}"
	#fi

	#LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir out LIBDIR=/usr/lib64 DESTDIR="${D}" || die
	#LIBXML_INCLUDES="/usr/include/libxml2" make -j1 OUTDIR="${WORKDIR}"/objdir LIBDIR=/usr/lib64 DESTDIR="${D}" || die

	# preserve the libs written directly into $DESTDIR by ar/ld/gcc
	#mkdir -p "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/lib
	#mv "${D}"/usr/lib64/* "${WORKDIR}"/objdir/linux/rel/gcc/x86_64/lib/
	emake OUTDIR="${WORKDIR}"/objdir out
	emake dynamic
	emake release
	default
}

src_install(){
	rm -rf  /var/tmp/portage/sci-biology/"${P}"/image/var
	# BUG: at the moment every binary is installed three times, e.g.:
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2.1.6
	if use amd64; then
		builddir="x86_64"
	elif use x86; then
		builddir="i386"
	fi
	dodir /usr/bin /usr/lib/ncbi /usr/ncbi/schema

	OBJDIR="${WORKDIR}"/objdir/linux/gcc/dyn/"${builddir}"/rel

	# BUG: neither 'doins -r' nor cp --preserve=all work
	#insinto /usr/bin
	#doins -r "${WORKDIR}"/objdir/linux/rel/gcc/"${builddir}"/bin/*
	for f in "${OBJDIR}"/bin/*; do cp --preserve=all "$f" "${D}"/usr/bin/ || die "$f copying failed" ; done

	# install the main libs and the ncbi/vdb-copy.kfg file
	insinto /usr/lib/ncbi
	doins "${OBJDIR}"/lib/ncbi/*

	# zap the subdirectory so that copying below does not fail
	rm -rf "${OBJDIR}"/lib/ncbi || die

	# BUG: neither the dolib nor cp --preserve=all work
	#insinto /usr/lib64
	#dolib "${WORKDIR}"/objdir/linux/rel/gcc/"${builddir}"/lib/*
	mkdir -p "${D}"/usr/lib64
	for f in "${OBJDIR}"/lib/*; do cp --preserve=all "$f" "${D}"/usr/lib64/ || die "$f copying failed" ; done

	insinto /usr/ncbi/schema
	doins \
		"${W}"/interfaces/align/*.vschema \
		"${W}"/interfaces/sra/*.vschema \
		"${W}"/interfaces/vdb/*.vschema \
		"${W}"/interfaces/ncbi/*.vschema \
		"${W}"/interfaces/insdc/*.vschema
}
