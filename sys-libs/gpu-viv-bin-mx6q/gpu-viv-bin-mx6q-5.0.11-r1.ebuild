# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GPU driver and apps for imx6"
#at the moment only with support for the framebuffer
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

MY_PV=${PV}.p8.4-hfp
MY_PN=imx-gpu-viv
SRC_URI="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${MY_PN}-${MY_PV}.bin"

LICENSE="freescale"

SLOT="0"

KEYWORDS="-* arm"

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${MY_PV}
OPENGLDIR=usr/lib/opengl/vivante

src_unpack() {
	sh ${DISTDIR}/${A} --force --auto-accept
}

src_compile() {
	cd "${S}/gpu-core"

	rm -r etc

	cd usr

	#prepare include dir
	rm -r include/wayland-viv

	#prepare lib dir
	cd lib

	# They are the same... why not a link?
	rm libOpenVG.so
	ln -sf libOpenVG.3d.so libOpenVG.so

	# update pkgconfig for fb
	cd pkgconfig
	mv egl_x11.pc egl.pc
	rm wayland-egl.pc egl_linuxfb.pc egl_wayland.pc gc_wayland_protocol.pc glesv1_cm.pc glesv2.pc vg.pc wayland-viv.pc
	mv glesv1_cm_x11.pc glesv1_cm.pc
	mv glesv2_x11.pc glesv2.pc
	mv vg_x11.pc vg.pc

	cd ..

	rm libgc_wayland_protocol*
	rm libwayland-viv*

	#the libs are already linked to the fb, just remove the other libs
	rm *fb*
	rm *wl*
	#rm *x11*

	for i in libEGL.so libEGL.so.1 libEGL.so.1.0
	do
		ln -sf libEGL-x11.so ${i}
	done
	ln -sf libGAL-x11.so libGAL.so
	for i in libGLESv2.so libGLESv2.so.2 libGLESv2.so.2.0.0
	do
		ln -sf libGLESv2-x11.so ${i}
	done
	ln -sf libVIVANTE-x11.so libVIVANTE.so

	#create the gentoo folder structure
	cd "${S}/gpu-core"
	mkdir -p $OPENGLDIR/include $OPENGLDIR/lib $OPENGLDIR/extensions

	#and move it into the gentoo structure
	mv usr/include/* $OPENGLDIR/include/
	mv usr/lib/lib* $OPENGLDIR/lib/
}


src_install() {
	cd "${S}/apitrace/x11"
	cp ./* "${D}" -R
	cd "${S}/g2d"
	cp ./* "${D}" -R
	cd "${S}/gpu-tools/gmem-info"
	cp ./* "${D}" -R
	cd "${S}/gpu-demos"
	cp ./* "${D}" -R
	cd "${S}/gpu-core"
	cp ./* "${D}" -R
}

pkg_postinst() {
	eselect opengl set xorg-x11
	eselect opengl set vivante

	elog "At the moment this ebuild only installs x11 support"
}
