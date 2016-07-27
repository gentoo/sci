# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EANT_BUILD_TARGET="dist"
EANT_NEEDS_TOOLS="true"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit java-pkg-2 java-ant-2 vcs-snapshot

DESCRIPTION="The Genome Analysis Toolkit"
HOMEPAGE="http://www.broadinstitute.org/gsa/wiki/index.php/The_Genome_Analysis_Toolkit"
SRC_URI="https://github.com/broadgsa/gatk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

COMMON_DEPS=""
DEPEND="
	>=virtual/jdk-1.6
	dev-java/maven-bin:*
	dev-java/cofoja
	${COMMON_DEPS}"
RDEPEND="
	>=virtual/jre-1.6
	>=sci-biology/SnpEff-2.0.5
	${COMMON_DEPS}"

src_prepare() {
	sh ant-bridge.sh || die # BUG: this download and compiles lot of stuff
	java-pkg-2_src_prepare
}

src_install() {
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository || die
	find public -name \*.jar | grep -v tests | grep -v cofoja | while read f; do \
		java-pkg_dojar $f # FIXME: Java QA Notice: installing versioned jar 'gatk-tools-public-3.6.jar'
	done
}

pkg_postinst(){
	einfo "The ebuild also installs bundled SnpEff-2.0.5.jar file until the"
	einfo "installation layout gets more testing"
}
