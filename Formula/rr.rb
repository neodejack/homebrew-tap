class Rr < Formula
  desc "Simple Rancher API wrapper CLI"
  homepage "https://github.com/neodejack/rr"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.10/rr_macos_arm.tar.gz"
      sha256 "922de80c9c28d9f861b98c3e1399b0a43d5c3059c4c19c802b0a9fadaaf210dd"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.10/rr_macos.tar.gz"
      sha256 "a4036e42f41ac2bf376373e996223e7fa327a4f42fded356b73c5a3ee0b537d6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.10/rr_linux_arm.tar.gz"
      sha256 "b787f9ca4d0592b7e44c80c4b553f39aabca60484583f6e9bf603b5bb4c3ce4e"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.10/rr_linux.tar.gz"
      sha256 "29a34593cbd9598ebbf3947080e85e3892b920061a072c7e29d9b86416c188e6"
    end
  end

  def install
    bin.install "rr"
  end

  def caveats
    <<~EOS
      ======================================================
       ██████╗ ██████╗     ZSH INTEGRATION REQUIRED
       ██╔══██╗██╔══██╗    (rr is not enabled yet)
       ██████╔╝██████╔╝
       ██╔══██╗██╔══██╗
       ██║  ██║██║  ██║
       ╚═╝  ╚═╝╚═╝  ╚═╝

      Run this to enable rr in zsh:

      echo 'eval "$(rr zsh)"' >> ~/.zshrc

      congrats. your life will be easier and happier from now on

      click me and don't forget to dance!
      https://www.youtube.com/watch?v=dQw4w9WgXcQ
      ======================================================
    EOS
  end

  test do
    system bin/"rr", "--help"
  end
end
