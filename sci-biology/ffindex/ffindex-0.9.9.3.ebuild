# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Simple index/database for huge amounts of small files"
HOMEPAGE="http://pubshare.genzentrum.lmu.de/scientific_computing/software/ffindex"
#SRC_URI="http://downloads.sourceforge.net/project/transdecoder/TransDecoder_r20140704.tar.gz"
SRC_URI="https://github.com/TransDecoder/TransDecoder/archive/TransDecoder.tar.gz -> TransDecoder-2.0.1.tar.gz"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TransDecoder_r20140704/3rd_party/ffindex-0.9.9.3

src_compile(){
	emake HAVE_MPI=1
}

src_install(){
	dodoc README
	cd src || die
	dobin ffindex_apply ffindex_unpack ffindex_modify ffindex_get ffindex_from_fasta ffindex_build ffindex_apply_mpi

	#  * QA Notice: The following files contain writable and executable sections
	#  *  Files with such sections will not work properly (or at all!) on some
	#  *  architectures/operating systems.  A bug should be filed at
	#  *  http://bugs.gentoo.org/ to make sure the issue is fixed.
	#  *  For more information, see http://hardened.gentoo.org/gnu-stack.xml
	#  *  Please include the following list of files in your report:
	#  *  Note: Bugs should be filed for the respective maintainers
	#  *  of the package in question and not hardened@g.o.
	#  * RWX --- --- usr/lib64/libffindex.so.0.1
	# 
	dolib libffindex.so.0.1 libffindex.so

	# make install INSTALL_DIR="${DESTDIR}" HAVE_MPI=1
}
