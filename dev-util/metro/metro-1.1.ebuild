# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/catalyst/catalyst-2.0.6.ebuild,v 1.4 2008/06/12 23:54:26 wolf31o2 Exp $

SRC_URI="http://www.funtoo.org/metro/${P}.tar.bz2"
DESCRIPTION="release metatool used for creating Gentoo releases"
HOMEPAGE="http://www.github.com/funtoo/metro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/python app-arch/pbzip2 dev-util/ccache dev-util/git"

src_install() {
	install -d "${D}/usr/lib" || die "/usr/lib fail"
	cp -a "${S}" "${D}/usr/lib/metro" || die "/usr/lib/metro fail"
	install -d "${D}/etc" || die "/etc fail"
	cp -a "${S}/etc" "${D}/etc/metro" || die "/etc/metro fail"
	install -d /usr/bin || die "/usr/bin fail"
	dosym ../lib/metro/metro /usr/bin/metro || die "link fail"
}
