# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi https://github.com/ncbi/sra-tools"
SRC_URI="https://github.com/ncbi/sra-tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
# missing dep ngs-sdk
KEYWORDS=""

DEPEND="
	app-shells/bash:*
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/libxml2:2="
RDEPEND="${DEPEND}"

S="${WORKDIR}/sra-tools-${PV}"

src_configure() {
	# this is some non-standard configure script
	./configure || die
}

src_compile(){
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
