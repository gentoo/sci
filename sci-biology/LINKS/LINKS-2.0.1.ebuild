# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scaffold genome assemblies by Chromium/PacBio/Nanopore reads"
HOMEPAGE="https://github.com/bcgsc/LINKS"
SRC_URI="https://github.com/bcgsc/LINKS/releases/download/v${PV}/links-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/links-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-lang/perl-1.6
	dev-lang/swig
	dev-util/cppcheck
"
DEPEND="${RDEPEND}"
