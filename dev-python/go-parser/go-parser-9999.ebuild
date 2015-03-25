# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

# A much more robust code is at https://github.com/ntamas/biopython in Bio/GO subdir
# When that gets incorporated into biopython the go-parser should be dropped altogether.

DESCRIPTION="Gene Ontology OBO flatfile parser"
HOMEPAGE="http://hal.elte.hu/~nepusz/development/"
SRC_URI="http://bazaar.launchpad.net/~ntamas/+junk/go-parser/tarball/7?start_revid=7 -> go-parser-r7.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}"/~ntamas/+junk/go-parser
