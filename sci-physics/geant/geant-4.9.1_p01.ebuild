# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=1

inherit eutils fortran multilib versionator

MY_P=${PN}$(replace_version_separator 3 .)

DESCRIPTION="CERN's detector description and simulation Tool"
HOMEPAGE="http://geant4.cern.ch/"

SRC_COM="http://geant4.web.cern.ch/geant4/support/source/"
SRC_URI="${SRC_COM}/${MY_P}.tar.gz"
GEANT4_DATA="G4NDL.3.12
	G4EMLOW.5.1
	G4RadioactiveDecay.3.2
	PhotonEvaporation.2.0
	G4ABLA.3.0"
for d in ${GEANT4_DATA}; do
	SRC_URI="${SRC_URI} data? ( ${SRC_COM}/${d}.tar.gz )"
done

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="athena +data dawn debug examples gdml geant3 minimal +motif
	+opengl openinventor +raytracerx +vrml zlib"

DEPEND="sci-physics/clhep
	motif? ( virtual/motif )
	athena? ( x11-libs/libXaw )
	openinventor? ( media-libs/openinventor )
	raytracerx? ( x11-libs/libX11 x11-libs/libXmu )
	opengl? ( virtual/opengl
			  athena? ( x11-libs/Xaw3d ) )
	gdml? ( dev-libs/xerces-c )
	geant3? ( sci-physics/geant:3 )
	dawn? ( media-gfx/dawn )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	FORTRAN="gfortran g77 ifc"
	use geant3 && fortran_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# this patch sanitize the Configure script
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-no-source.patch

	# propagate user's make options
	sed -i \
		-e "s/g4make=gmake/g4make=\"gmake ${MAKEOPTS}\"/" \
		Configure || die "sed Configure failed"

	# propagate user's flags.
	sed -i \
		-e "s:\(CXXFLAGS*+=\)*-O2:\1 ${CXXFLAGS:--O2}:g" \
		-e "s:\(FCFLAGS*+=\)*-O2:\1 ${FFLAGS:--O2}:g" \
		-e "s:\(CCFLAGS*+=\)*-O2:\1 ${CFLAGS:--O2}:g" \
		config/sys/Linux* || die "flag substitution failed"

	# libdir stuff
	sed -i \
		-e "s:lib/geant4:$(get_libdir)/geant:g" \
		Configure config/scripts/move.sh.SH \
		|| die "multilib substitution failed"
}

g4ui_use() {
	local answer=$(use $1 && echo y || echo n)
	echo "-D g4ui_build_${2:-$1}_session=${answer}
		  -D g4ui_use_${2:-$1}=${answer}"
}

g4vis_use() {
	local answer=$(use $1 && echo y || echo n)
	echo "-D g4vis_build_${2:-$1}_driver=${answer}
		  -D g4vis_use_${2:-$1}=${answer}"
}

g4w_use() {
	local answer=$(use $1 && echo y || echo n)
	echo "-D g4w_use_${2:-$1}=${answer}
		  -D g4wlib_use_${2:-$1}=${answer}"
}

src_compile() {
	GEANT4_DATA_DIR=/usr/share/${PN}
	# The Configure shell script saves its options
	# in .config/bin/*/config.sh

	local myconf="$(g4vis_use opengl openglx)"
	use opengl && myconf="${glconf} $(g4vis_use motif openglxm)"
	use data && myconf="${myconf} -D g4data=${GEANT4_DATA_DIR}"

	 # switch to see compiling flags
	export CPPVERBOSE=y
	use debug && export G4DEBUG=y || export G4OPTIMIZE=y

	# to check what they are doing and working
	# -D d_portable \
	# -D g4global=n \
	# -D g4granular=y
	# -D g4_use_granular=y
	# -D g4make=make \

	./Configure \
		-deE -build \
		-D g4analysis_use=n \
		-D g4includes_flag=y \
		-D g4include="${D}/usr/include/geant4" \
		-D g4final_install="${D}/usr" \
		$(g4ui_use minimal none) \
		$(g4ui_use athena xaw) \
		$(g4ui_use motif xm) \
		$(g4vis_use minimal none) \
		$(g4vis_use dawn) \
		$(g4vis_use raytracerx) \
		$(g4vis_use openinventor oix) \
		$(g4vis_use vrml) \
		$(g4vis_use vrml vrmlfile) \
		$(g4w_use geant3 g3tog4) \
		$(g4w_use zlib) \
		${myconf} \
		${EXTRA_ECONF} \
		|| die "Configure failed"

	# if shared libs are built, the script will also build static libs
	# with pic flags
	# avoid that by building it twice and removing temporary objects

	./Configure \
		-deO -build \
		-D g4lib_build_shared=y \
		-D g4lib_build_static=n \
		|| die "Building shared geant failed"

	rm -rf tmp

	./Configure \
		-deO -build \
		-D g4lib_build_shared=n \
		-D g4lib_build_static=y \
		|| die "Building shared geant failed"
}

src_install() {
	./Configure \
		-install \
		|| die "Install failed"

	./Configure \
		|| die "Final install failed"

	insinto ${GEANT4_DATA_DIR}
	sed -i \
		-e "s:${S}:${GEANT4_DATA_DIR}:g" \
		-e "s:${D}:/:g" \
		env.*sh
	doins env.*sh || die "failed installing shell scripts"
	doins -r config
	if use data; then
		cd "${WORKDIR}"
		for d in ${GEANT4_DATA}; do
			local p=${d/.}
			doins -r *${d/G4} || die "installing data ${d} failed"
		done
	fi

	# doc and examples
	insinto /usr/share/doc/${PF}
	local mypv="4.$(get_version_component_range 2 ${PV})"
	mypv="${mypv}.$(get_version_component_range 3 ${PV})"
	doins ReleaseNotes/ReleaseNotes${mypv}.html
	[[ -e ReleaseNotes/Patch${mypv}-1.txt ]] && \
		dodoc ReleaseNotes/Patch${mypv}-*.txt

	use examples && doins -r examples
	# todo: g4py will probably need a split ebuild since it seems to
	# rely on on geant4 existence.
	# todo: momo with momo or java flag, and check java stuff
}

pkg_postinst() {
	elog "You can set the Geant4 environment variables"
	elog "from ${ROOT}${GEANT4_DATA_DIR} shell scripts."
	elog "Ex: for bash"
	elog "     source ${ROOT}${GEANT4_DATA_DIR}/env.sh"
	elog
	elog "Help us to improve the ebuild and dependencies in"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=212221"
}
