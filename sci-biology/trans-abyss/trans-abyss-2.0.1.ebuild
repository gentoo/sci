# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1

DESCRIPTION="Analyze and combine multiple assemblies from abyss"
HOMEPAGE="https://www.bcgsc.ca/resources/software/trans-abyss"
SRC_URI="https://github.com/bcgsc/transabyss/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-lang/perl
	dev-python/python-igraph[${PYTHON_USEDEP}]
	sci-biology/abyss
	sci-biology/blat
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/transabyss-${PV}"

src_install() {
	einstalldocs
	python_foreach_impl python_domodule utilities
	dobin transabyss
	dobin transabyss-merge
}
