# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://ftp.arm.linux.org.uk/~rmk/libdrm-armada.git"

inherit autotools git-r3

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="https://dri.freedesktop.org/"

KEYWORDS=""

SLOT="0"

RDEPEND=">=x11-libs/libdrm-2.4.38"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}
