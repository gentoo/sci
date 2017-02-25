# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

PYTHON_COMPAT=( python2_7 )

inherit autotools-utils distutils-r1 subversion

DESCRIPTION="General Hidden Markov Model library"
HOMEPAGE="http://ghmm.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="https://ghmm.svn.sourceforge.net/svnroot/ghmm/trunk/ghmm"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="gsl lapack +python static-libs"

RDEPEND="
	dev-libs/libxml2
	gsl? ( sci-libs/gsl )
	lapack? (
		sci-libs/clapack
		virtual/lapack
		)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

ESVN_BOOTSTRAP="autotools-utils_src_prepare"

PATCHES=(
	"${FILESDIR}"/${P}-clapack.patch
	"${FILESDIR}"/${P}-out-of-source.patch
	"${FILESDIR}"/${P}-link.patch
	"${FILESDIR}"/${P}-respect.patch
	"${FILESDIR}"/${P}-obsolete.patch
)

src_prepare() {
	use python && AUTOTOOLS_IN_SOURCE_BUILD=1
	autotools-utils_src_prepare
	use python && cd "${S}"/ghmmwrapper && distutils-r1_python_prepare
}

src_configure() {
	local myeconfargs=(
		--without-python
		--disable-obsolete
		$(use_enable gsl)
		$(use_enable lapack atlas)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use python && cd "${S}"/ghmmwrapper && distutils-r1_src_compile
}

src_install() {
	autotools-utils_src_install
	use python && cd "${S}"/ghmmwrapper && distutils-r1_src_install
}
