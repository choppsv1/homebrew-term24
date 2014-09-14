require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tmux/tmux/tmux-1.9/tmux-1.9a.tar.gz'
  sha1 '815264268e63c6c85fe8784e06a840883fcfc6a2'

  option "with-true-color", "Build with support for 24-bit color (CSI SGR codes)"

  if build.without? "true-color"
    bottle do
      cellar :any
      sha1 "258df085ed5fd3ff4374337294641bd057b81ff4" => :mavericks
      sha1 "3838e790a791d44464df6e7fcd25d8558d864d9c" => :mountain_lion
      sha1 "4368a7f81267c047050758338eb8f4207da12224" => :lion
    end
  end

  head do
    url 'git://git.code.sf.net/p/tmux/tmux-code'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if build.with? "true-color"
    patch :p1 do
      url "https://gist.githubusercontent.com/choppsv1/dd00858d4f7f356ce2cf/raw/b66c1726b7d38b9a43d0e199f5b874e5f9d08526/tmux-24.diff"
      sha1 "1e97dbaaa45684e7441adb2a1139097eafbd8868"
    end
  end

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    bash_completion.install "examples/bash_completion_tmux.sh" => 'tmux'
    (share/'tmux').install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{share}/tmux/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
