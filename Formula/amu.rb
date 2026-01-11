class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.2/amu-aarch64-apple-darwin.tar.xz"
      sha256 "ccfc7ae5a11965b315ee5a548338410d8b1bbed0c6bf855734aaea36df661d9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.2/amu-x86_64-apple-darwin.tar.xz"
      sha256 "fd11e58c4955c5e1354ad40de6ccbc35b634c253ec5ad99d93558e65847722f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.2/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "344855907a01c33c04935edaad9a3637f73ff4b8f7ffe0c1f7cac12ba2346fe6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.2/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "752c97c172f4de69cb5a77257c88d93afcd249e108c24591e824801e7f632a49"
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
