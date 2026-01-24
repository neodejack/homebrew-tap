class Rr < Formula
  desc "Simple Rancher API wrapper CLI"
  homepage "https://github.com/neodejack/rr"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.9/rr_macos_arm.tar.gz"
      sha256 "9443aa823754023b30ec525d9df07c5181d73734da2b9e6ccdb2dc37e7e30c52"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.9/rr_macos.tar.gz"
      sha256 "fe308393f2a223d6ce4582791ded9509ba8d13c20eca65c7019b199008be0645"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/neodejack/rr/releases/download/v0.1.9/rr_linux_arm.tar.gz"
      sha256 "7f57cab7237771cec64a20cb65d2865da7186d47c56ea5cedd987dfd10972040"
    else
      url "https://github.com/neodejack/rr/releases/download/v0.1.9/rr_linux.tar.gz"
      sha256 "395fba877f7a8be6ec3fcb269f0a639414e639ffe4eb34358d94cfb931abfb6f"
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
