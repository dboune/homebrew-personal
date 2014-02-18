require 'formula'

class Openldap < Formula
  homepage 'http://www.openldap.org/software/'
  url 'http://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.39.tgz'
  sha1 '2b8e8401214867c361f7212e7058f95118b5bd6c'

  depends_on 'openssl' if build.include? 'with-homebrew-openssl'
  depends_on 'openslp' => :optional
  depends_on 'unixodbc' => :optional
  depends_on 'berkeley-db' => :optional

  option 'with-homebrew-openssl', 'Include OpenSSL support via Homebrew'

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-dynamic",
            "--enable-proctitle",
            "--enable-slapd",
            "--enable-dynacl",
            "--enable-aci",
            "--enable-cleartext",
            "--enable-crypt",
            "--disable-lmpasswd",
            "--enable-spasswd",
            "--enable-modules",
            "--enable-rewrite",
            "--enable-rlookups",
            "--enable-slapi",
            "--enable-backends=mod",
            "--disable-ndb",
            "--enable-overlays",
            "--with-threads",
            "--with-tls=openssl"]

    args << "--enable-slp" if build.with? 'openslp'
    args << "--with-odbc=unixodbc" if build.with? 'unixodbc'
    args << "--disable-bdb" unless build.with? "berkeley-db"
    args << "--disable-hdb" unless build.with? "berkeley-db"

    if build.include? 'with-homebrew-openssl'
      ENV.append "LDFLAGS", "-L#{Formula.factory('openssl')}/lib"
      ENV.append "CPPFLAGS", "-I#{Formula.factory('openssl')}/include"
    end

    system "./configure", *args
    system "make install"
    (var+'run').mkpath
  end
end
