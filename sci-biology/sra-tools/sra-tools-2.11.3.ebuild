# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NCBI Sequence Read Archive (SRA) sratoolkit"
HOMEPAGE="https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi https://github.com/ncbi/sra-tools"
SRC_URI="https://github.com/ncbi/sra-tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
# Fix ncbi-vdb first
KEYWORDS=""

DEPEND="
	virtual/zlib:=
	app-arch/bzip2
	dev-libs/libxml2:2=
	sci-libs/hdf5
	sci-biology/ngs
	sci-biology/ncbi-vdb
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/sra-tools-${PV}"

src_configure() {
	# this is some non-standard configure script
	./configure \
		--with-ngs-sdk-prefix=/usr/ngs/ngs-sdk \
		--with-hdf5-prefix=/usr \
		|| die
}

src_install() {
	dodir /usr/include
	dodir /etc/profile.d
	# Hard way around hard coded paths
	find . -type f -exec sed -i \
		-e "s:/usr/local:${ED}/usr:g" \
		-e "s:/etc:${ED}/etc:g" \
		-e "s:/usr/lib:${ED}/usr/lib:g" \
		-e "s:/usr/include:${ED}/usr/include:g" \
		-e "s:setup.py -q install:setup.py install --root="${D}":g" \
		{} \; || die
	default
}
