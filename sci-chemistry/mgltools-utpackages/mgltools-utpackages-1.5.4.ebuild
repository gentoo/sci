# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

MY_P="UTpackages-${PV}"

DESCRIPTION="mgltools plugin -- UTpackages"
HOMEPAGE="http://mgltools.scripps.edu"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/numpy"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	distutils_python_version
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz

	find "${S}" -name CVS -type d -exec rm -rf '{}' \; >& /dev/null
	find "${S}" -name LICENSE -type f -exec rm -f '{}' \; >& /dev/null

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in

	epatch "${FILESDIR}"/${PV}-gcc4.3.patch
}

src_install() {
	mglpath="$(python_get_sitedir)/MGLToolsPckgs/"
# Needs this otherwise double ${D}
	mglpath_lib="/usr/$(get_libdir)/python${PYVER}/site-packages/MGLToolsPckgs/"

	distutils_src_install \
		--install-purelib="${mglpath_lib}" \
		--install-platlib="${mglpath_lib}" \
		--install-lib="${mglpath_lib}" \
		--install-scripts="${mglpath}"
}
