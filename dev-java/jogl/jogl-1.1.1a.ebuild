# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WANT_ANT_TASKS="ant-antlr"
JAVA_PKG_IUSE="cg source doc"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java(TM) Binding fot the OpenGL(TM) API"
HOMEPAGE="https://jogl.dev.java.net/"
SRC_URI="http://download.java.net/media/${PN}/builds/archive/jsr-231-${PV}/${P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	dev-java/ant-core
	>=dev-java/cpptasks-1.0_beta4-r2
	dev-java/gluegen:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm
	cg? ( media-gfx/nvidia-cg-toolkit )"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.4
	${COMMON_DEPEND}"

RDEPEND="
	>=virtual/jre-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}"

java_prepare() {
	epatch "${FILESDIR}/1.1.0/uncouple-gluegen.patch"
	cd "${S}/make" || die
	mv build.xml build.xml.bak || die

	sed 's_/usr/X11R6_/usr_g' build.xml.bak > build.xml || die
	sed -i -e 's/suncc/gcc/g' build.xml ../../gluegen/make/gluegen-cpptasks.xml || die

	rm -R "${S}/build/gensrc/classes/javax" || die

	cd "${WORKDIR}/gluegen/make/lib" || die
	rm -v *.jar || die
	java-pkg_jar-from cpptasks
}

src_compile() {
	cd make/ || die
	local antflags="-Dgluegen.prebuild=true"
	antflags="${antflags} -Dantlr.jar=$(java-pkg_getjars --build-only antlr)"
	local gcp="$(java-pkg_getjars ant-core):$(java-config --tools)"

	local gluegen="-Dgluegen.jar=$(java-pkg_getjar gluegen gluegen.jar)"
	local gluegenrt="-Dgluegen-rt.jar=$(java-pkg_getjar gluegen gluegen-rt.jar)"

	use cg && antflags="${antflags} -Djogl.cg=1 -Dx11.cg.lib=/usr/lib"
	# -Dbuild.sysclasspath=ignore fails with missing ant dependencies.

	export ANT_OPTS="-Xmx1g"
	eant \
		-Dgentoo.classpath="${gcp}" \
		${antflags} "${gluegen}" "${gluegenrt}" \
		all $(use_doc)
}

src_install() {
	use source && java-pkg_dosrc src/classes/*
	java-pkg_doso build/obj/*.so
	java-pkg_dojar build/*.jar
	use doc && java-pkg_dojavadoc javadoc_public
}
