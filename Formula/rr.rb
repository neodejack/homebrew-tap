class Rr < Formula
  desc "Simple Rancher API wrapper CLI"
  homepage "https://github.com/neodejack/rr"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.12-rc0/rr_macos_arm.tar.gz"
      sha256 "67787b7f36b1061acc6f9f9e6b51aa0900738ace9f89bca978d66b2cae4155da"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.12-rc0/rr_macos.tar.gz"
      sha256 "22b233a083cfb725507ef403d00e3c3e565ba4c6dbc606840a6e334acdba4cde"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.12-rc0/rr_linux_arm.tar.gz"
      sha256 "5db1497571c774700351c05f5db28e340d1eed2172c8a3d4044df045fd2b9518"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.12-rc0/rr_linux.tar.gz"
      sha256 "879735ae9449d6fcc9ddccaa9560b2d7dd0663123f87188fec744790b576342a"
    end
  end

  def install
    bin.install "rr"
  end

  def caveats
    <<~EOS
      ======================================================
      Run this to enable the `yo` command, if you use zsh:

        rr yo >> ~/.zshrc

      or if you use bash:

        rr yo >> ~/.bashrc

      congrats. your life will be easier and happier from now on.
      don't forget to dance!
      https://www.youtube.com/watch?v=dQw4w9WgXcQ
      ======================================================
    EOS
  end

  test do
    system bin/"rr", "--help"
  end
end
