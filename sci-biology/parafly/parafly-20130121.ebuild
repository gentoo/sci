# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Some dependency for transdecoder"
HOMEPAGE="http://sourceforge.net/projects/transdecoder/"
SRC_URI="http://downloads.sourceforge.net/project/transdecoder/TransDecoder_r20140704.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TransDecoder_r20140704/3rd_party/parafly-r2013-01-21

src_configure(){
	./configure --prefix=/usr
}
