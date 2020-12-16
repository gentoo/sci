# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="System Diagnostic Reporting Tool"
HOMEPAGE="http://git.natinst.com/cgit/systemreport/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/system-report-1.0.0-3.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
"
