class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.7/amu-aarch64-apple-darwin.tar.xz"
      sha256 "e581ebffae716e25729f46257212c14a173702f780691a8da42a25a57cbdab07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.7/amu-x86_64-apple-darwin.tar.xz"
      sha256 "7f9f2aafdcbc9e9f57d82f88289cd0e543b7844a854cd31ab24934e9e358dadc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.7/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42c049f9c9a188825a30c26194c132abe91647f943d98b6472b841276c43ac88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.7/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b7dc35da38383444241d83f662f4aca86374929caa35db2b9c607d6f6a2e30f1"
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
