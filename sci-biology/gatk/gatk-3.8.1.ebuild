# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 git-r3 # building from tar.gz snapshots is unsupported

MY_PV=${PV/.1/-1} # convert 3.8.1 to 3.8-1
DESCRIPTION="The Genome Analysis Toolkit"
HOMEPAGE="http://www.broadinstitute.org/gsa/wiki/index.php/The_Genome_Analysis_Toolkit"
EGIT_REPO_URI="https://github.com/broadgsa/gatk.git" # git tree for <=gatk-3
# check out 3.8-1 branch but using a proper commit, not ${MY_PV}
# https://github.com/broadinstitute/gatk/issues/4685#issuecomment-383188772
EGIT_COMMIT="41147a655594c2aae6e2cad8462bd1648570b32b"
# building outside of git is not possible,
# see https://github.com/broadinstitute/picard/issues/605

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64" # 608.21 MiB git download and 134MB "${W}"/.m2 download

COMMON_DEPS=""
DEPEND="
	>=virtual/jdk-1.6
	dev-java/maven-bin:* || ( dev-java/netbeans-java )
	dev-java/cofoja
	${COMMON_DEPS}"
RDEPEND="
	>=virtual/jre-1.6
	>=sci-biology/SnpEff-2.0.5
	${COMMON_DEPS}"

#S="${WORKDIR}/${PN}-${MY_PV}"

# https://maven.apache.org/settings.html
# The two settings files are located at:
#   The Maven installation directory: $M2_HOME/conf/settings.xml
#   The user's home directory: ${user.home}/.m2/settings.xml
#
# localRepository: This value is the path of this build system's local repository. 
#    The default value is ${user.home}/.m2/repository. This element is especially
#    useful for a main build server allowing all logged-in users to build from a
#    common local repository.
# interactiveMode: true if Maven should attempt to interact with the user for input,
#    false if not. Defaults to true.
# usePluginRegistry: true if Maven should use the ${user.home}/.m2/plugin-registry.xml
#    file to manage plugin versions, defaults to false. Note that for the current version
#    of Maven 2.0, the plugin-registry.xml file should not be depended upon. Consider it
#    dormant for now.
# offline: true if this build system should operate in offline mode, defaults to false.
#    This element is useful for build servers which cannot connect to a remote repository,
#    either because of network setup or security reasons.

src_prepare() {
	mvn clean -Dmaven.repo.local="${WORKDIR}"/.m2/repository || die
	sed -e 's#mvn_args="#mvn_args="-Dmaven.repo.local=${WORKDIR}/.m2/repository #' -i ant-bridge.sh || die
	mkdir -p "${WORKDIR}"/.m2/repository || die
	cp "${FILESDIR}"/settings.xml "${WORKDIR}"/.m2/repository/ || die
	#export M2_HOME="${EPREFIX}"/usr/share/maven-bin-3.3
	#export MAVEN_HOME="${EPREFIX}"/usr/share/maven-bin-3.3
	export M2="${WORKDIR}"/.m2/repository # not recognized?
	#export MAVEN_OPTS="-Xms256m -Xmx512m" # works but not needed actually
	sh ant-bridge.sh || die # BUG: this downloads and compiles lot of stuff
	java-pkg-2_src_prepare
}

src_install() {
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository || die
	# Java QA Notice: installing versioned jar 'gatk-tools-public-3.8-1.jar'
	# Java QA Notice: installing versioned jar 'gatk-queue-extensions-generator-3.8-1.jar'
	# Java QA Notice: installing versioned jar 'gatk-engine-3.8-1.jar'
	# Java QA Notice: installing versioned jar 'gatk-queue-extensions-public-3.8-1.jar'
	# Java QA Notice: installing versioned jar 'gatk-utils-3.8-1.jar'
	# Java QA Notice: installing versioned jar 'gatk-queue-3.8-1.jar'
	find public -name \*.jar | grep -v tests | grep -v cofoja | while read f; do \
		java-pkg_dojar $f
	done
}

pkg_postinst(){
	einfo "The ebuild also installs bundled SnpEff-2.0.5.jar file until the"
	einfo "installation layout gets more testing"
}

# TODO: adjust the build system to output GenomeAnalysisTK.jar file like in an official
#       binary release
# # equery files gatk
#   * Searching for gatk ...
#   * Contents of sci-biology/gatk-3.8.1:
#  /usr
#  /usr/share
#  /usr/share/gatk
#  /usr/share/gatk/lib
#  /usr/share/gatk/lib/external-example-1.0-SNAPSHOT.jar
#  /usr/share/gatk/lib/gatk-engine-3.8-1.jar
#  /usr/share/gatk/lib/gatk-queue-3.8-1.jar
#  /usr/share/gatk/lib/gatk-queue-extensions-generator-3.8-1.jar
#  /usr/share/gatk/lib/gatk-queue-extensions-public-3.8-1.jar
#  /usr/share/gatk/lib/gatk-tools-public-3.8-1.jar
#  /usr/share/gatk/lib/gatk-utils-3.8-1.jar
#  /usr/share/gatk/lib/original-external-example-1.0-SNAPSHOT.jar
#  /usr/share/gatk/lib/snpeff-2.0.5.jar
#  /usr/share/gatk/package.env
