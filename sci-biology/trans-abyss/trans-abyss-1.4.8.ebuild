# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Analyze and combine multiple assemblies from abyss"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss"
SRC_URI="http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss/releases/"${PV}"/trans-ABySS-v"${PV}"_20130916.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

# perl and python
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/trans-ABySS-v"${PV}"

# TODO
#src_install(){
#}
