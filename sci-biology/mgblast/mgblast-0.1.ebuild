# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Customized version of megablast from TIGR Gene Indices project"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/mgblast.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="" # upstream binary is provided by sci-biology/tgicl currently
#KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-biology/ncbi-tools"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# mgblast needs old version of ncbi-tools unpacked and compiled during its own compilation
# from newer tools you need to include blfmtutl.h but the next error is no go for me:
#   mgblast.c:2205: error: too few arguments to function ‘BXMLBuildOneQueryIteration’

# Quoting from mgblast/README: the present package was built and tested only with the release 20060507

src_prepare(){
	# mgblast cannot be compiled against newer ncbi-tools but let's try
	mv mgblast/makefile mgblast/Makefile 2>/dev/null || true
	sed -i 's#/usr/local/projects/tgi/ncbitoolkit/ncbi#/usr#' mgblast/Makefile || die
	sed -i 's#NCBIDIR = /mylocal/src/ncbi#NCBIDIR = /usr#' mgblast/Makefile || die
	sed -i 's#NCBI_INCDIR = .*#NCBI_INCDIR = /usr/include/ncbi#' mgblast/Makefile || die
	sed -i 's#NCBI_LIBDIR = .*#NCBI_LIBDIR = /usr/lib#' mgblast/Makefile || die # a PATH to NCBI-TOOLKIT (/usr/lib) while NOT /usr/lib/ncbi-tools++ !
	sed -i "s#-I-#-iquote#" mgblast/Makefile || die
}

src_compile(){
	cd "${S}"/mgblast || die
	default
}

src_install(){
	cd "${S}"/mgblast || die
	dobin mgblast
}
