# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Tools for discovering and connecting to SRP CSI targets on InfiniBand fabrics"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/openib-userspace-${PV}/src/userspace/${PN}"
