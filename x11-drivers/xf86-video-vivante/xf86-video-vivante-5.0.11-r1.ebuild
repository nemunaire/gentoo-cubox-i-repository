# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cubox-i xorg driver"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}.p8.4
MY_PN=xserver-xorg-video-imx-viv
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="CLOSED"

SLOT="0"

KEYWORDS="-* arm"

DEPEND="=sys-libs/gpu-viv-bin-mx6q-5.0.11-r1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${MY_PV}/EXA/src

src_prepare() {
	epatch "${FILESDIR}"/Stop-using-Git-to-write-local-version.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS} -I/usr/lib/opengl/vivante/include" LOCAL_LFLAGS="-L/usr/lib/opengl/vivante/lib -lGAL" BUILD_HARD_VFP=1 BUSID_HAS_NUMBER=1 XSERVER_GREATER_THAN_13=1 -f makefile.linux || die
}

src_install() {
	mkdir -p ${D}/usr/lib/xorg/modules/drivers
	mv vivante_drv.so ${D}/usr/lib/xorg/modules/drivers || die
}
