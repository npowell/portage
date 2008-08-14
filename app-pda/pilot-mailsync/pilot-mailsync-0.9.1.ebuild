# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/pilot-mailsync/pilot-mailsync-0.9.1.ebuild,v 1.3 2007/09/16 19:22:31 philantrop Exp $

inherit flag-o-matic eutils

DESCRIPTION="An application to transfer outgoing mail from and deliver incoming mail to a Palm OS device."
HOMEPAGE="http://wissrech.iam.uni-bonn.de/people/garcke/pms/"
SRC_URI="http://wissrech.iam.uni-bonn.de/people/garcke/pms/${P}.tar.gz"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ssl gnome"

DEPEND="ssl? ( dev-libs/openssl )
	gnome? ( >=app-pda/gnome-pilot-2 )
	~app-pda/pilot-link-0.11.8"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	if use gnome; then
		mv ${P} ${P}-gpilot
		unpack ${A}
	fi
	cd "${S}"
	# Fixes bug 151351.
	epatch "${FILESDIR}/${P}-glibc.patch"
}

src_compile() {
	# bug 45755
	#append-flags -fPIC

	cd "${S}"
	econf $(use_enable ssl)
	if use gnome; then
		cd "${S}-gpilot"
		econf $(use_enable ssl) --enable-gpilot
	fi

	cd "${S}"
	emake || die "make failed"
	if use gnome; then
		cd "${S}-gpilot"
		emake || die "gpilot plugin make failed"
	fi

}

src_install() {
	cd "${S}"
	make RPM_BUILD_ROOT="${D}" install || die "install failed"
	dodoc README INSTALL docs/* || die "installing docs failed"

	if use gnome; then
		cd "${S}-gpilot"
		insinto /usr/share/gnome-pilot/conduits/
		doins mailsync.conduit
		insinto /usr/lib/gnome-pilot/conduits/
		doins .libs/libgnome_mailsync_conduit.so
	fi
}
