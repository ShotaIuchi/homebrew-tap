class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.1/amu-aarch64-apple-darwin.tar.xz"
      sha256 "30568d76c7f67fa9275d45ae16b81b80461afa5f5dd5f65fcbb59de37467abad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.1/amu-x86_64-apple-darwin.tar.xz"
      sha256 "816b6a044954892053792b9c387159e18c8c1436fe1cb51ed5d9cf6ae179fb46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.1/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31def2c9f754b82fcfc2c2b329c2457af106d8efa01d7f19da0065db05e36127"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.1/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "83233799f9ceeb0abea0d0975730b640551ed086ea20b018b1e2a026efce1ef9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "amu" if OS.mac? && Hardware::CPU.arm?
    bin.install "amu" if OS.mac? && Hardware::CPU.intel?
    bin.install "amu" if OS.linux? && Hardware::CPU.arm?
    bin.install "amu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
