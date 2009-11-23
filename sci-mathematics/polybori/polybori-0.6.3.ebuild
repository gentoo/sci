# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils python versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${PN}-$(replace_version_separator 2 '-').tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc sage"

DEPEND=">=dev-util/scons-0.98
		>=dev-libs/boost-1.34.1
		>=dev-lang/python-2.5
		dev-python/ipython
		>=sci-libs/m4ri-20090512
		doc? ( dev-tex/tex4ht
		      app-doc/doxygen )"
RDEPEND=">=dev-libs/boost-1.34.1
		>=dev-lang/python-2.5
		dev-python/ipython"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

src_prepare(){
	use sage && cp "${FILESDIR}/PyPolyBoRi.py" "${S}/pyroot/polybori/"
}

src_compile(){

#	hevea and l2h are deprecated and will be removed so we focus on tex4ht
#	tried to summarize all the options in a variable but it didn't parse correctly
	if ( use doc); then
	    DOC="True"
	else
	    DOC="False"
	fi

	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" prepare-install || die "scons prepare-install failed"

	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" prepare-devel || die "scons prepare-devel failed"

}

src_install() {
	mkdir -p "${D}"
	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" \
		PREFIX="${D}/usr" PYINSTALLPREFIX="${D}$(python_get_sitedir)" install \
		|| die "scons install failed"

	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" \
		DEVEL_PREFIX="${D}/usr" PYINSTALLPREFIX="${D}$(python_get_sitedir)" devel-install \
		|| die "scons devel-install failed"

}
