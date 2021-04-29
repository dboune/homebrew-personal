# Originally from https://github.com/anarchivist/homebrew-hamradio/blob/master/Formula/direwolf.rb
# All credit to anarchivist
class Direwolf < Formula
  desc "Dire Wolf is a software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder."
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.6.tar.gz"
  sha256 "208b0563c9b339cbeb0e1feb52dc18ae38295c40c0009d6381fc4acb68fdf660"
  version "1.6"
  option "with-initial-config", "Do initial configuration step, i.e. 'make install-conf'. Do for the first install only."
  license "GPL-2.0"

  depends_on "hamlib"
  depends_on "portaudio"
  depends_on "gpsd" => :optional
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    mkdir "build"
    cd "build"
    system "cmake", "..", *args
    system "make", "-j4"
    system "make", "install"

    if build.with? "initial-config"
      system "make", "install-conf"
    end
  end
end
