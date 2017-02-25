# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Whole genome shotgun OLC assembler for Sanger reads (overlap-layout-contig)"
HOMEPAGE="https://www.broadinstitute.org/crd/wiki
	http://genome.cshlp.org/content/12/1/177.abstract"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ARACHNE/latest_source_code/${P}.tar.gz"

LICENSE="MIT" # not exactly MIT ... hence no KEYWORDS
SLOT="0"
KEYWORDS=""
IUSE="doc openmp"

DEPEND="dev-libs/xerces-c
	doc? ( virtual/latex-base app-text/dvipsk )"
RDEPEND="${DEPEND}"

# needs >=g++-4.7 but does not compile with 5.3.0

# --disable-openmp to disable requirement for OpenMP-capable compiler
src_configure() {
	local myconf=()
	use openmp || myconf+=( --disable-openmp )
	econf ${myconf[@]}
}

# set the following environment variables
# http://www.broadinstitute.org/crd/wiki/index.php/Setup
#
# ARACHNE_PRE
# ARACHNE_BIN_DIR
# ARACHNE_PRETTY_HELP

pkg_postinst(){
	einfo "Please add these to your ~/.bashrc"
	einfo "limit stacksize 100000"
	einfo "limit datasize unlimited"
}
