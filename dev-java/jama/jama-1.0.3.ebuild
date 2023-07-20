# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Jama"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAMA is a basic linear algebra package for Java. "
HOMEPAGE="https://math.nist.gov/javanumerics/jama/"

SRC_URI="https://math.nist.gov/javanumerics/jama/${MY_PN}-{PV}.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${MY_PN}"
KEYWORDS="~amd64"

LICENSE="public-domain"
SLOT="0"

BDEPEND=">=virtual/jdk-1.8:*"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR=(
	"./"
	"util"
)
JAVA_MAIN_CLASS="gov.math.nist.Main"

JAVA_TEST_SRC_DIR="test"
