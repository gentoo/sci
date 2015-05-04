# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

PYTHON_DEPEND="2"

inherit eutils python

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

RDEPEND="
	virtual/jpeg
	opengl? ( virtual/opengl )
	glut? ( media-libs/freeglut )
	openssl? ( dev-libs/openssl )
	imagemagick? ( media-gfx/imagemagick )
	gsl? ( sci-libs/gsl )
	ieee1394? ( sys-libs/libraw1394 media-libs/libdc1394 )
	java? ( virtual/jdk )
	gtk? ( x11-libs/gtk+:2 )
	gnome? ( >=gnome-base/libgnomecanvas-2.0 )
	boost? ( dev-libs/boost )
	sphinx2? ( app-accessibility/sphinx2 )
	festival? ( app-accessibility/festival )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	java? ( dev-lang/swig )
	doc? ( app-doc/doxygen )"

pkg_setup () {
	python_set_active_version 2
}

src_compile() {
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

	# Parallel make will fail
	emake -j1 || die "emake failed"

	if use doc; then
		pushd doc > /dev/null
		emake doc || die "emake doc failed"
		popd > /dev/null
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		cd doc
		emake DESTDIR="${D}" doc-install || die "emake doc-install failed"
		cd ..
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
