require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tmux/tmux/tmux-2.0/tmux-2.0.tar.gz'
  sha1 '977871e7433fe054928d86477382bd5f6794dc3d'

  head do
    url 'git://git.code.sf.net/p/tmux/tmux-code'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  patch :p1 do
    url "https://gist.githubusercontent.com/choppsv1/dd00858d4f7f356ce2cf/raw/75b073e85f3d539ed24907f1615d9e0fa3e303f4/tmux-24.diff"
    sha256 '66207daba09783c49ea61d9b84f54cb5ce002054eea489fbe401306f6d1b7c56'
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
