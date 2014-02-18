require 'formula'

class AprUtil < Formula
  homepage 'http://apr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.3.tar.bz2'
  sha1 'de0184ee03dfdc6dec4d013970d1862251e86925'

  keg_only :provided_by_osx

  depends_on 'dboune/personal/apr'
  depends_on 'openssl' if build.include? 'with-homebrew-openssl'
  if build.include? 'with-homebrew-openldap'
    if build.include? 'with-homebrew-openssl'
      depends_on 'dboune/personal/openldap' => ['with-homebrew-openssl']
    else
      depends_on 'dboune/personal/openldap'
    end
  end

  option 'with-homebrew-openssl', 'Include OpenSSL support via Homebrew'
  option 'with-homebrew-openldap', 'Include OpenLDAP support via Homebrew'

  def install
    # Compilation will not complete without deparallelize
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--with-apr=#{Formula.factory('apr').opt_prefix}",
            "--with-crypto",
            "--with-ldap=yes"]

    if build.include? 'with-homebrew-openssl'
      args << "--with-openssl=#{Formula.factory('openssl').opt_prefix}"
    else
      args << "--with-ssl=/usr"
    end

    if build.include? 'with-homebrew-openldap'
      # args << "--with-ldap=#{Formula.factory('openldap').opt_prefix}"
      ENV.append "LDFLAGS", "-L#{Formula.factory('openldap')}/lib"
      ENV.append "CPPFLAGS", "-I#{Formula.factory('openldap')}/include"
    else
      #args << "--with-ldap=yes"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
