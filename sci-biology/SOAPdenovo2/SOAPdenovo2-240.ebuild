# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Whole genome shotgun assembler (sparse de Bruijn graph)"
HOMEPAGE="https://sourceforge.net/projects/soapdenovo2
	https://github.com/aquaskyline/SOAPdenovo2
	http://gigascience.biomedcentral.com/articles/10.1186/2047-217X-1-18"
SRC_URI="https://sourceforge.net/projects/soapdenovo2/files/${PN}/src/r${PV}/${PN}-src-r${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-src-r"${PV}"
