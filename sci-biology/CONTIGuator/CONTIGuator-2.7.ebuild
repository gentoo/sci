# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Speed up bacterial genome assemblies by artemis and compare chromosome regions"
HOMEPAGE="http://contiguator.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/contiguator/CONTIGuator_v2.7.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="( sci-biology/artemis sci-biology/artemis-bin )"
RDEPEND="${DEPEND}"
