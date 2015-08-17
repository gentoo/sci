# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

W="${WORKDIR}"/"${P}"

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=show&f=faspftp_runs_v1&m=downloads&s=download_sra"
SRC_URI="http://trace.ncbi.nlm.nih.gov/Traces/sra/static/sra_sdk-"${PV}".tar.gz"
# http://trace.ncbi.nlm.nih.gov/Traces/sra/static/sratoolkit.2.0.1-centos_linux64.tar.gz

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="app-shells/bash
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

# upstream says:
# icc, icpc are supported: tested with 11.0 (64-bit) and 10.1 (32-bit), 32-bit 11.0 does not work

src_compile(){
	# # COMP env variable may have 'GCC' or 'ICC' values
	make OUTDIR="${WORKDIR}"/objdir out || die
	LIBXML_INCLUDES="/usr/include/libxml2" make dynamic || die
	LIBXML_INCLUDES="/usr/include/libxml2" make release || die
	LIBXML_INCLUDES="/usr/include/libxml2" emake || die
}

src_install(){
	rm -rf  /var/tmp/portage/sci-biology/"${P}"/image//var
	# BUG: at the moment every binary is installed three times, e.g.:
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2
	# -rwxr-xr-x 1 root root 1797720 Sep 23 01:31 abi-dump.2.1.6
	if use amd64; then
		builddir="x86_64"
	elif use x86; then
		builddir="i386"
	fi
	mkdir "${D}"/usr
	mkdir "${D}"/usr/bin
	mkdir -p "${D}"/usr/lib/ncbi
	mkdir -p "${D}"/usr/ncbi/schema
	for f in "${WORKDIR}"/objdir/linux/rel/gcc/"${builddir}"/bin/*; do cp --preserve=links "$f" "${D}"/usr/bin || die "copy failed" ; done
	dolib "${WORKDIR}"/objdir/linux/rel/gcc/"${builddir}"/lib/*

	# install the main libs and the ncbi/vdb-copy.kfg file
	insinto /usr/lib/ncbi
	doins "${WORKDIR}"/objdir/linux/rel/gcc/"${builddir}"/lib/ncbi/*

	insinto /usr/ncbi/schema
	doins "${W}"/interfaces/align/*.vschema
	doins "${W}"/interfaces/sra/*.vschema
	doins "${W}"/interfaces/vdb/*.vschema
	doins "${W}"/interfaces/ncbi/*.vschema
	doins "${W}"/interfaces/insdc/*.vschema
}
