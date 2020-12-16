# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-Sync support for LabVIEW 2020"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-sync-labview-2020-support-20.1.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/ni_sync_labview_2020_api-20.1
>=sci-ni/ni_sync_labview_2020_examples-20.1
>=sci-ni/ni_sync_labview_2020_exfinder-20.1
>=sci-ni/ni_sync_labview_2020_help-20.1
"
