# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
inherit python-single-r1

DESCRIPTION=" NCBI SRA ( Sequence Read Archive )"
HOMEPAGE="https://github.com/ncbi/ncbi-vdb"
SRC_URI="https://github.com/ncbi/ncbi-vdb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
# Sandbox error: tries to access files from within deleted dir in compile phase
KEYWORDS=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sci-libs/hdf5
	sci-biology/ngs
"
RDEPEND="${DEPEND}"

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
