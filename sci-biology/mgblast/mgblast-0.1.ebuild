# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Customized version of megablast from TIGR Gene Indices project"
HOMEPAGE="https://web.archive.org/web/20140726030702/http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/mgblast.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""

DEPEND="sci-biology/ncbi-tools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

# mgblast needs old version of ncbi-tools unpacked and compiled during its own compilation
# from newer tools you need to include blfmtutl.h but the next error is no go for me:
#   mgblast.c:2205: error: too few arguments to function ‘BXMLBuildOneQueryIteration’

# Quoting from mgblast/README: the present package was built and tested only with the release 20060507

src_prepare(){
	# mgblast cannot be compiled against newer ncbi-tools but let's try
	mv makefile Makefile 2>/dev/null || true
	sed -i -e 's#/usr/local/projects/tgi/ncbitoolkit/ncbi#/usr#' \
		-e's#NCBIDIR = /mylocal/src/ncbi#NCBIDIR = /usr#' \
		-e's#NCBI_INCDIR = .*#NCBI_INCDIR = /usr/include/ncbi#' \
		-e 's#NCBI_LIBDIR = .*#NCBI_LIBDIR = /usr/lib#' \
		-e "s#-I-#-iquote#" Makefile || die # a PATH to NCBI-TOOLKIT (/usr/lib) while NOT /usr/lib/ncbi-tools++ !
	default
}
