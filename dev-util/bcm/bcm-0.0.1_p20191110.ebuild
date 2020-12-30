# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Boost cmake modules"
HOMEPAGE="http://bcm.readthedocs.io"

COMMIT="2045990a6ace40eb4c4a9f6e5cc1aeeaf7a05fc9"
SRC_URI="https://github.com/simoncblyth/bcm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

KEYWORDS="~amd64"
LICENSE="Boost-1.0"
SLOT="0"

PATCHES=( "${FILESDIR}"/bcm-0.0.1_donot-send-error.patch )
