# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SCIFIO version of the Java Advanced Imaging Image I/O Tools API Core."
HOMEPAGE="http://jai-imageio.dev.java.net/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scifio/scifio-jai-imageio.git"
	S="${WORKDIR}/${P}"
	MAVEN_ID="io.scif:scifio-jai-imageio:9999"
else
	SRC_URI="
		https://github.com/scifio/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	MAVEN_ID="io.scif:scifio-jai-imageio:1.1.2"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS=""
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)
