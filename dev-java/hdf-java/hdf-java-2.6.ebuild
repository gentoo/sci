# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
JAVA_PKG_IUSE="doc examples source"
inherit eutils java-pkg-2 autotools

DESCRIPTION="Java interface to the HDF5 library"
HOMEPAGE="http://www.hdfgroup.org/hdf-java-html/index.html"
SRC_URI="http://www.hdfgroup.org/ftp/HDF5/hdf-java/src/${P}-src.tar"

LICENSE="NCSA-HDF"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hdf mpi"

CDEPEND=">=sci-libs/hdf5-1.8[szip,mpi=]
	hdf? ( sci-libs/hdf )
	>=media-libs/jpeg-7
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e 's|case JH5F_SCOPE_DOWN|//case JH5F_SCOPE_DOWN|' \
		native/hdf5lib/h5Constants.c || die
	epatch "${FILESDIR}"/${P}-shared.patch
	eautoreconf
	use mpi && export CC=mpicc
}

src_configure() {
	local stdpath="/usr/include,/usr/$(get_libdir)"
	local myconf="--with-hdf4=no --with-libjpeg=no"
	use hdf && \
		myconf="--with-libjpeg=${stdpath} --with-hdf4=${stdpath}"

	econf \
		${myconf} \
		--with-libz="${stdpath}" \
		--with-libsz="${stdpath}" \
		--with-hdf5="${stdpath}" \
		--with-jdk="$(java-config -o)/include,$(java-config -o)/jre/lib"
}

src_compile() {
	# parallel needs work. anyone?
	emake -j1 || die "emake failed"
}

src_install() {
	java-pkg_dojar "lib/jhdf5.jar"
	java-pkg_doso "lib/linux/libjhdf5.so"
}
