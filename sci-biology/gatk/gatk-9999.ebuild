# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit java-pkg-2 git-r3 # building from tar.gz snapshots is unsupported

DESCRIPTION="The Genome Analysis Toolkit"
HOMEPAGE="http://www.broadinstitute.org/gsa/wiki/index.php/The_Genome_Analysis_Toolkit"
EGIT_REPO_URI="https://github.com/broadinstitute/gatk.git" # git tree for >=gatk-4
EGIT_CLONE_TYPE="mirror"
# building outside of git is not possible,
# see https://github.com/broadinstitute/picard/issues/605
#
# 
# must run 'git clone https://github.com/broadinstitute/gatk.git gatk'
# see https://github.com/broadinstitute/gatk/issues/4687

LICENSE="BSD-3" # since gatk-4
SLOT="0"
IUSE=""
KEYWORDS="" # 148.19 MB git download and 134MB "${W}"/.m2 download

COMMON_DEPS=""
# gatk-4 needs java-1.8
DEPEND="
	>=virtual/jdk-1.8
	>=dev-vcs/git-2.5
	>=dev-vcs/git-lfs-1.1.0
	>=dev-java/maven-bin-3.1:* || ( dev-java/netbeans-java )
	dev-java/cofoja
	${COMMON_DEPS}"
RDEPEND="
	>=virtual/jre-1.8
	>=sci-biology/SnpEff-2.0.5
	>=dev-lang/R-3.2.5
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
	default
}

src_compile(){
	# work around gradle writing $HOME/.gradle, requiring $HOME/.git and $HOME/.m2/
	# https://github.com/samtools/htsjdk/issues/660#issuecomment-232155965
	# make jure SDK-1.8 is available, JRE-1.8 is not enough
	#
	# https://github.com/broadinstitute/gatk#building
	# gradlew tragets are bundle, localJar, sparkJar, ...
	GRADLE_USER_HOME="${WORKDIR}" ./gradlew --stacktrace --debug bundle || die
}

src_install() {
	cd build/libs || die
	java-pkg_dojar "${PN}".jar
	java-pkg_dojar "${PN}"-*-SNAPSHOT.jar
	#java-pkg_dolauncher ${PN} --main picard.cmdline.PicardCommandLine
	#use source && java-pkg_dosrc "${S}"/src/java/*
	#use doc && java-pkg_dojavadoc "${S}"/javadoc
	#
	# install a bash-completion script gatk-completion.sh into proper place
}
