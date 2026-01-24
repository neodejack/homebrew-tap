class Rr < Formula
  desc "Simple Rancher API wrapper CLI"
  homepage "https://github.com/neodejack/rr"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.7/rr_macos_arm.tar.gz"
      sha256 "9ea9f17d9551ff06d6ebab4bd72063701d0be58444138bfc03c5c5549cc70aba"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.7/rr_macos.tar.gz"
      sha256 "0763d4aef170fd97361be46dd67af84bc2dd4e9caa0257bd8d74b381118505c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.7/rr_linux_arm.tar.gz"
      sha256 "17b770487330b254b286282ff8739081b2d10b215c41e43d0455061501fb1067"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.7/rr_linux.tar.gz"
      sha256 "661d6a36d8e52fc45c836e092f09343442e91f91ec513ed4556026da7f03253b"
    end
  end

  def install
    bin.install "rr"
  end

  def caveats
    <<~EOS
      To enable the rr zsh integration
        echo 'eval "$(rr zsh)"' >> ~/.zshrc
    EOS
  end

  test do
    system bin/"rr", "--help"
  end
end
