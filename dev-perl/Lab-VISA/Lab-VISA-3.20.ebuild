# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Perl interface to National Instrument's VISA library"
HOMEPAGE="https://github.com/lab-measurement/Lab-VISA"
SRC_URI="https://github.com/lab-measurement/Lab-VISA/archive/lab-visa-${PV}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64"
SLOT="0"

S="${WORKDIR}/${PN}-lab-visa-${PV}"

# Only works if nipalk.ko is loaded
# which does not load on new kernels
RESTRICT="test"

DEPEND="
	dev-lang/perl
	sci-ni/ni_visa
	sci-ni/ni_visa_devel
	sci-ni/ni_visa_headers
"
RDEPEND="${DEPEND}"

src_prepare() {
	# header files are in subdir
	find . -type f -exec \
		sed -i -e 's/visa.h/ni-visa\/visa.h/g' \
		-e 's/visatype.h/ni-visa\/visatype.h/g' \
		-e 's/vpptype.h/ni-visa\/vpptype.h/g' \
		{} + || die
	default
}
