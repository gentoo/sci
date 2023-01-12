# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
inherit python-single-r1 java-pkg-2

DESCRIPTION="NGS Language Bindings "
HOMEPAGE="https://github.com/ncbi/ngs"
SRC_URI="https://github.com/ncbi/ngs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sci-biology/bamtools
	virtual/jdk:1.8
"
RDEPEND="${DEPEND}
	virtual/jre:1.8
"

src_configure() {
	# this is some non-standard configure script
	./configure || die
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
