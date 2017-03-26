# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 eutils

DESCRIPTION="A bus factor analyzer for Git repositories"
HOMEPAGE="https://github.com/SOM-Research/busfactor"
SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	~dev-python/gitana-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PV}/setup.py.patch"
)

src_prepare() {
	cp "${FILESDIR}/${PV}/main.py" "${S}/main.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/main.py' to '${S}/main.py'"
	# patches are applied by distutils-r1.eclass
	distutils-r1_python_prepare_all
}
