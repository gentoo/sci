# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Remove adapter sequences from high-throughput sequencing data"
HOMEPAGE="https://code.google.com/p/cutadapt/"
SRC_URI="https://cutadapt.googlecode.com/files/"${PN}"-"${PV}".tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
