# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="1"

inherit eutils fortran multilib versionator toolchain-funcs

PV1=$(get_version_component_range 1 ${PV})
PV2=$(get_version_component_range 2 ${PV})
PV3=$(get_version_component_range 3 ${PV})
MY_P=${PN}$(replace_version_separator 3 .)

DESCRIPTION="CERN's detector description and simulation Tool"
HOMEPAGE="http://www.geant4.org/"

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
IUSE="athena +data dawn debug examples gdml geant3 global minimal +motif
	+opengl openinventor +raytracerx static +vrml zlib"

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
	eval unset ${!G4_*}
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# propagate user's flags.
	sed -i \
		-e "/CXXFLAGS[[:space:]]*.=[[:space:]]-O2/s:=.*:= ${CXXFLAGS}:" \
		-e "/FCFLAGS[[:space:]]*.=[[:space:]]-O2/s:=.*:= ${FFLAGS:--O2}:" \
		-e "/CCFLAGS[[:space:]]*.=[[:space:]]-O2/s:=.*:= ${CFLAGS}:" \
		config/sys/Linux*gmk || die "flag substitution failed"

	# fix forced lib directory
	sed -i \
		-e 's:$(G4LIB)/$(G4SYSTEM):$(G4LIB):g' \
		config/binmake.gmk || die "sed binmake.gmk failed"
	sed -i \
		-e '/$(G4LIB)\/$(G4SYSTEM)/d' \
		config/architecture.gmk || die "sed architecture.gmk failed"
}

src_compile() {
	export GEANT4_DIR="/usr/share/${PN}${PV1}"
	# where to put compiled libraries;
	# we set env var G4LIB in src_install()
	# to avoid confusing make
	export GEANT4_LIBDIR=/usr/$(get_libdir)/${PN}${PV1}

	# these should always to be set
	[[ $(tc-getCXX) = ic*c ]] && export G4SYSTEM=Linux-icc \
							  || export G4SYSTEM=Linux-g++
	export G4INSTALL="${S}"
	export G4INCLUDE="${D}/usr/include/${PN}"
	export CLHEP_BASE_DIR=/usr

	# parse USE; just set flags of drivers to build, G4*_USE_* vars are set
	# later automatically for G4*_BUILD_*_DRIVER
	use minimal             && export G4UI_NONE=y \
							&& export G4VIS_NONE=y

	use motif               && export G4UI_BUILD_XM_SESSION=y
	use athena              && export G4UI_BUILD_XAW_SESSION=y

	use dawn                && export G4VIS_BUILD_DAWN_DRIVER=y
	use raytracerx          && export G4VIS_BUILD_RAYTRACERX_DRIVER=y
	use openinventor        && export G4VIS_BUILD_OI_DRIVER=y
	use opengl              && export G4VIS_BUILD_OPENGLX_DRIVER=y
	use opengl && use motif && export G4VIS_BUILD_OPENGLXM_DRIVER=y

	use geant3              && export G4LIB_BUILD_G3TOG4=y
	use zlib                && export G4LIB_BUILD_ZLIB=y
	use vrml                && export G4VIS_BUILD_VRML_DRIVER=y \
							&& export G4VIS_BUILD_VRMLFILE_DRIVER=y

	use data                && export G4DATA="${GEANT4_DIR}/data"
	use debug               && export G4DEBUG=y || export G4OPTIMIZE=y

	# switch to see compiling flags
	export CPPVERBOSE=y

	# if shared libs are built, the script will also build static libs
	# with pic flags
	# avoid that by building it twice and removing temporary objects
	cd "${S}/source/"
	export G4LIB_BUILD_SHARED=y
	emake || die "Building shared geant failed"

	if use static; then
		rm -rf tmp
		export G4LIB_BUILD_STATIC=y ; unset G4LIB_BUILD_SHARED
		emake || die "Building static geant failed"
	fi

	if use global; then
		export G4LIB_USE_GRANULAR=y
		emake global || die "Building global libraries failed"
	fi
}

g4_create_env_script() {
	# we need to change some variables to the final values since we hide these
	# from make during the compile
	export G4INSTALL=${GEANT4_DIR}
	export G4LIB=${GEANT4_LIBDIR}
	export G4INCLUDE=${G4INCLUDE/${D}/}
	export G4WORKDIR=\${HOME}/${PN}${PV1}

	local g4env=99${PN}${PV1}
	cat <<-EOF > ${g4env}
		LDPATH=${G4LIB}
		CLHEP_BASE_DIR=${CLHEP_BASE_DIR}
	EOF
	# read env variables defined upto now
	printenv | grep ^G4 | uniq >> ${g4env}

	# define env vars for capabilities we can build into user projects
	printenv | uniq | \
		sed -n -e '/^G4/s:BUILD\(.*\)_DRIVER:USE\1:gp' >> ${g4env}

	doenvd ${g4env} || die "Installing environment scripts failed "
}

src_install() {
	# install headers via make since we want them in a single directory
	cd "${S}/source/"
	emake includes || die 'Installing headers failed'
	cd "${S}"

	# but install libraries and Geant library tool manually
	insinto ${GEANT4_LIBDIR}
	doins -r lib/${G4SYSTEM}/* || die
	exeinto ${GEANT4_LIBDIR}
	doexe lib/${G4SYSTEM}/liblist || die

	g4_create_env_script

	# configs
	insinto ${GEANT4_DIR}
	doins -r config || die

	# install data
	if use data; then
		insinto ${G4DATA}
		pushd "${WORKDIR}"
		for d in ${GEANT4_DATA}; do
			local p=${d/.}
			doins -r *${p/G4} || die "installing data ${d} failed"
		done
		popd
	fi

	# doc and examples
	insinto /usr/share/doc/${PF}
	local mypv="${PV1}.${PV2}.${PV3}"
	doins ReleaseNotes/ReleaseNotes${mypv}.html
	[[ -e ReleaseNotes/Patch${mypv}-1.txt ]] && \
		dodoc ReleaseNotes/Patch${mypv}-*.txt

	use examples && doins -r examples

	# TODO: g4py will probably need a split ebuild since it seems to
	# rely on on geant4 existence.
	# TODO: momo with momo or java flag, and check java stuff
}

pkg_postinst() {
	elog "Geant4 projects are by default expected in each user's "
	elog "If you want to change, set \$G4WORKDIR to another directory"
	elog
	elog "Help us to improve the ebuild and dependencies in"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=212221"
}
