# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Boost cmake modules"
HOMEPAGE="http://bcm.readthedocs.io"

EGIT_REPO_URI="https://github.com/simoncblyth/bcm.git"
EGIT_COMMIT="2045990a6ace40eb4c4a9f6e5cc1aeeaf7a05fc9"
KEYWORDS="~amd64"

LICENSE="Boost-1.0"
SLOT="0"

PATCHES=( "${FILESDIR}"/bcm-0.0.1_donot-send-error.patch )
