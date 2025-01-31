# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Reads key-value pairs from a .env file and can set them as environment variables"
HOMEPAGE="https://saurabh-kumar.com/python-dotenv/"
SRC_URI="https://github.com/theskumar/python-dotenv/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/python-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/sh[$PYTHON_USEDEP]"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
