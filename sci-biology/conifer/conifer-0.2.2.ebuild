# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

DESCRIPTION="Copy Number Inference/Variants (CNV) from exome reads"
HOMEPAGE="http://conifer.sf.net"
SRC_URI="http://downloads.sourceforge.net/project/conifer/CoNIFER%200.2.2/conifer_v0.2.2.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"_v"${PV}"

src_install(){
	dobin *.py
}
