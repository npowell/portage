# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmlto/xmlto-0.0.21.ebuild,v 1.1 2008/09/22 14:20:37 flameeyes Exp $

inherit eutils

DESCRIPTION="A bash script for converting XML and DocBook formatted documents to a variety of output formats"
HOMEPAGE="https://fedorahosted.org/xmlto/browser"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="app-shells/bash
	dev-libs/libxslt
	>=app-text/docbook-xsl-stylesheets-1.62.0-r1
	~app-text/docbook-xml-dtd-4.2
	|| (
		sys-apps/util-linux
		app-misc/getopt )
	|| (
		|| ( >=sys-apps/coreutils-6.10-r1 sys-apps/mktemp )
		sys-freebsd/freebsd-ubin )"

#	tetex? ( >=app-text/passivetex-1.4 )"
# Passivetex/xmltex need some sorting out <obz@gentoo.org>

src_compile() {
	local myconf

	has_version sys-apps/util-linux \
		|| myconf="${myconf} --with-getopt=getopt-long"

	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install || die
	dodoc AUTHORS ChangeLog FAQ NEWS README
	insinto /usr/share/doc/${PF}/xml
	doins doc/*.xml
}
