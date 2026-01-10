class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.0/amu-aarch64-apple-darwin.tar.xz"
      sha256 "d91b5d5685032685dd7ea71b83f3da9751404b6ed379a6d38f522f9b33b19089"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.0/amu-x86_64-apple-darwin.tar.xz"
      sha256 "5d65abdc52ce147ecaeac81d82876a1eb804351d4333e29515812e9d86aed55f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.0/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f6b0fae7d51be738f25943b6c3e5077be92f39676fc479ce2d90d10669ad272"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.0/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "97185699ed256c73aab2d7a612390bc18749b753cbbb4c083305e074d835fd24"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "amu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "amu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "amu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "amu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
