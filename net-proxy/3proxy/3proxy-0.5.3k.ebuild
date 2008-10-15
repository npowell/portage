# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/3proxy/3proxy-0.5.3k.ebuild,v 1.3 2008/10/14 20:55:04 ranger Exp $

inherit toolchain-funcs eutils

DESCRIPTION="really tiny cross-platform proxy servers set"
HOMEPAGE="http://www.security.nnov.ru/soft/3proxy/"
SRC_URI="http://www.security.nnov.ru/soft/3proxy/${PV}/${P}.tgz"

LICENSE="3proxy"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE=""

DEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LN="$(tc-getCC)" \
		-f Makefile.unix \
		|| die "emake failed"
}

src_install() {
	local x

	pushd src
	dobin 3proxy || die "dobin 3proxy failed"
	for x in proxy socks ftppr pop3p tcppm udppm mycrypt dighosts ; do
		newbin ${x} ${PN}-${x} || die "newbin ${x} failed"
		[[ -f ${S}/man/${x}.8 ]] \
			&& newman "${S}"/man/${x}.8 ${PN}-${x}.8
	done
	popd

	doman "${S}"/man/3proxy*.[38]

	cd "${S}"
	dodoc Changelog Readme Release.notes
	dohtml -r doc/html/*
	docinto cfg
	dodoc cfg/*.{txt,sample}
	docinto cfg/sql
	dodoc cfg/sql/*.{cfg,sql}
}
