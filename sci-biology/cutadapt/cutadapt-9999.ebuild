# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Remove adapter sequences from high-throughput sequencing data"
HOMEPAGE="https://code.google.com/p/cutadapt/"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/marcelm/cutadapt"
	KEYWORDS=""
else
	SRC_URI="https://pypi.python.org/packages/source/c/cutadapt/"${PN}"-"${PV}".tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
