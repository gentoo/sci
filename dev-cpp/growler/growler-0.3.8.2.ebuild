# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler is a distributed object architecture and environment."

HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"

IUSE=""

RDEPEND=">=dev-cpp/growler-link-0.3.7
		 >=dev-cpp/growler-thread-0.3.4
		 >=dev-cpp/growler-core-0.3.7
		 >=dev-cpp/growler-arch-0.3.7.1"

DEPEND="${RDEPEND}"
