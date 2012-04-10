# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
JAVA_PKG_IUSE="doc examples"
inherit eutils java-pkg-2 autotools

DESCRIPTION="Java interface to the HDF5 library"
HOMEPAGE="http://www.hdfgroup.org/hdf-java-html/index.html"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/releases/HDF-JAVA/HDF-JAVA-${PV}/src/${P}-src.tar"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hdf szip zlib test"

CDEPEND=">=sci-libs/hdf5-1.8[szip=,zlib=]
	hdf? (
		sci-libs/hdf
		virtual/jpeg
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-shared.patch
	eautoreconf
	rm lib/*.jar
}

src_configure() {
	local stdpath="/usr/include,/usr/$(get_libdir)"
	local myconf="--with-hdf4=no --with-libjpeg=no"
	use hdf && \
		myconf="--with-libjpeg=${stdpath} --with-hdf4=${stdpath}"
	use zlib &&	myconf="${myconf} --with-libz="${stdpath}""
	use szip && myconf="${myconf} --with-libsz="${stdpath}""

	econf \
		${myconf} \
		--with-hdf5="${stdpath}" \
		--with-jdk="$(java-config -o)/include,$(java-config -o)/jre/lib"
}

src_compile() {
	# parallel needs work. anyone?
	emake -j1 just-hdf5 || die

	if use hdf; then
		sed -i "s/MAX_VAR_DIMS/H4_MAX_VAR_DIMS/" \
		native/hdflib/hdfstructsutil.c || die
		sed -i "s/MAX_NC_NAME/H4_MAX_NC_NAME/" \
		native/hdflib/hdfvdataImp.c || die
		sed -i "s/MAX_NC_NAME/H4_MAX_NC_NAME/" \
		native/hdflib/hdfsdsImp.c || die
		emake -j1 just-hdf4|| die
	fi

	if use examples; then
		emake -j1 do-examples || die
	fi

	if use doc; then
		emake -j1 javadocs || die
	fi
}

src_install() {
	java-pkg_dojar "lib/jhdf5.jar"
	java-pkg_doso "lib/linux/libjhdf5.so"

	if 	use hdf; then
		java-pkg_dojar "lib/jhdf.jar"
		java-pkg_doso "lib/linux/libjhdf.so"
	fi
	use doc && java-pkg_dojavadoc "docs/javadocs"
	use examples && java-pkg_doexamples "examples"
}
