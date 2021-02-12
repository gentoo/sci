# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="python frontend for the fast ripser tda tool"
HOMEPAGE="https://ripser.scikit-tda.org/"
COMMIT="2846e1dd3265d95d2bddb0cf4190b830cbb4efe6"
SRC_URI="https://github.com/sofiatolaosebikan/hopcroftkarp/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-setup_py.patch )

distutils_enable_tests pytest
