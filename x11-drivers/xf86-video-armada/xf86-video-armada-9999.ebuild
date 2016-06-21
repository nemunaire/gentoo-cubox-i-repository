# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-r3

DESCRIPTION="Cubox-i xorg driver"
HOMEPAGE="https://github.com/Freescale/meta-fsl-arm"

EGIT_REPO_URI="git://github.com/xobs/xserver-xorg-video-armada"

LICENSE="CLOSED"

SLOT="0"

KEYWORDS="-* arm"

DEPEND="x11-libs/libdrm-armada"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf || die
}
