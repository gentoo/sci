# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

# A much more robust code is at https://github.com/ntamas/biopython in Bio/GO subdir
# When that gets incorporated into biopython the go-parser should be dropped altogether.

DESCRIPTION="Gene Ontology OBO flatfile parser"
HOMEPAGE="http://hal.elte.hu/~nepusz/development/"
SRC_URI="http://bazaar.launchpad.net/~ntamas/+junk/go-parser/tarball/7?start_revid=7 -> go-parser-r7.tgz"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/~ntamas/+junk/go-parser
