# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-fetch-restrict.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI System Configuration API 18.0"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="nisyscfgi-18.0.0.49152-f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror fetch"

DEPEND="
acct-group/avahi
app-arch/rpm
app-shells/bash
>=sci-ni/nicurli-15.0.0
>=sci-ni/nissli-14.0.0
>=sci-ni/nitargetcfgi-3.0.0
"

pkg_nofetch() {
	einfo "This ebuild requires: ${SRC_URI}"
	einfo "Please download LabVIEW from https://www.ni.com/en-us/support/downloads/software-products/download.labview.html"
	einfo "Extract the ISOs and tarballs and place all the rpm files in your DESTDIR directory (e.g. /var/cache/distfiles)"
}
