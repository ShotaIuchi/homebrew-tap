class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.5/amu-aarch64-apple-darwin.tar.xz"
      sha256 "a32e951be64a5a19dbd5a54998f272eeaea0132a3a3c1c36a450a75b9bc7c63f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.5/amu-x86_64-apple-darwin.tar.xz"
      sha256 "15c1bb2318d2372120b13f093519451d459e8c5a0698838cc35c8a60de799a43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.5/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eeb4945afa36fb41ea3af6959819a910bdebfc99669ed0fac9ace2c6de53646f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.5/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c5a955b4ea2b4d4d85b1acca6702c13eba63b87e638241eb0c2d558684035a6"
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
