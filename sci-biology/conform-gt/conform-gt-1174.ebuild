# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Modify your Variant Call Format file to be consistent with reference VCF"
HOMEPAGE="https://faculty.washington.edu/browning/conform-gt.html"
SRC_URI="https://faculty.washington.edu/browning/conform-gt/conform-gt.24May16.cee.jar"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jre-1.7:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}/conform-gt.24May16.cee.jar" "${PN}.jar"
}
