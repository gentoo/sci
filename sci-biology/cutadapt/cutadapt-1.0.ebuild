# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Remove adapter sequences from high-throughput sequencing data"
HOMEPAGE="https://code.google.com/p/cutadapt/"
SRC_URI="https://cutadapt.googlecode.com/files/"${PN}"-"${PV}".tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
