# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils java-pkg-opt-2 python-single-r1

DESCRIPTION="A network server for robot control"
HOMEPAGE="http://playerstage.sourceforge.net/index.php?src=player"
SRC_URI="mirror://sourceforge/playerstage/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#DRIVERS NOT INCLUDED
#	nd            - unknown
#	passthrough   - unknown
#   artoolkitplus - needs arToolKitPlus (not in portage)
#	garcia        - needs Garcia (not in portage)
#	imageseq      - needs openCV (not in portage)
#	shapetracker  - needs openCV (not in portage)
#	simpleshape   - needs openCV (not in portage)
#	upcbarcode    - needs openCV (not in portage)
#	isense        - needs iSense (not in portage)
#	nomad         - needs Creative Nomad (maybe in portage)
#	yarpimage     - needs YarpCam (not in portage)
#	rcore_xbridge - needs libparticle (not in portage)

IUSE="ieee1394 imagemagick sphinx2 test v4l wifi
	boost gnome gtk openssl festival
	opengl glut gsl java python doc"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/jpeg:0
	boost? ( dev-libs/boost:= )
	festival? ( app-accessibility/festival )
	gtk? ( x11-libs/gtk+:2 )
	glut? ( media-libs/freeglut )
	gnome? ( >=gnome-base/libgnomecanvas-2.0 )
	gsl? ( sci-libs/gsl )
	ieee1394? ( sys-libs/libraw1394 media-libs/libdc1394 )
	imagemagick? ( media-gfx/imagemagick )
	java? ( virtual/jdk:* )
	opengl? ( virtual/opengl )
	openssl? ( dev-libs/openssl:0= )
	python? ( ${PYTHON_DEPS} )
	sphinx2? ( app-accessibility/sphinx2 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( dev-lang/swig:0 )
	python? ( dev-lang/swig:0 )"

pkg_setup () {
	use python && python-single-r1_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare
}

src_configure() {
	local drivers driver nodep_drivers

	nodep_drivers="acoustics acts amcl amtecpowercube
		aodv bumpersafe canonvcc4 clodbuster cmucam2
		cmvision dummy er1 fakelocalize flockofbirds
		garminnmea iwspy khepera laserbar laserbarcode
		lasercspace laserposeinterpolator laserrescan
		lasersafe laservisualbarcode laservisualbw
		lifomcom linuxjoystick logfile mapcspace
		microstrain mixer obot p2os erratic wbr914
		ptu46 reb relay kartowriter rflex segwayrmp
		service_adv_mdns sicklms200 sicknav200 sickpls
		sicks3000 highspeedsick sonyevid30 urglaser	vfh
		vmapfile waveaudio roomba wavefront insideM300
		skyetekM1 mica2 cameracompress"

	for driver in ${NODEP_DRIVERS}; do
		drivers="${drivers} $(use_enable ${driver})"
	done
	drivers="${drivers}
		$(use_enable sphinx2)
		$(use_enable gtk mapfile)
		$(use_enable gtk mapscale)
		$(use_enable wifi linuxwifi)
		$(use_enable festival)
		$(use_enable v4l camerauvc)
		$(use_enable v4l camerav4l)
		$(use_enable v4l sphere)
		$(use_enable ieee1394 camera1394)"

	econf \
		$(use_enable java jplayer) \
		$(use_enable openssl md5) \
		$(use_enable python libplayerc-py) \
		$(use_enable gtk rtkgui) \
		$(use_enable test tests) \
		--with-playercc \
		${drivers}
}

src_compile() {
	# Parallel make will fail
	emake -j1

	if use doc; then
		cd doc || die
		emake doc
	fi
}

src_install() {
	default

	if use doc; then
		cd doc || die
		emake DESTDIR="${D}" doc-install
	fi

}
