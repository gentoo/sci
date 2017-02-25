# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Some dependency for transdecoder"
HOMEPAGE="http://sourceforge.net/projects/transdecoder/"
SRC_URI="http://sourceforge.net/projects/transdecoder/files/OLDER/TransDecoder_r20140704.tar.gz"
# are current sources available only from here?
# https://github.com/trinityrnaseq/trinityrnaseq/tree/f81f0497a211c84ba4299063086604760933e6e3/trinity-plugins/parafly-code

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TransDecoder_r20140704/3rd_party/parafly-r2013-01-21

# maybe we once the CXXFLAGS and LDFLAGS mentioned
#   in https://github.com/trinityrnaseq/trinityrnaseq/issues/65 ?
src_configure(){
	./configure --prefix="${EPREFIX}"/usr
}
