class Amu < Formula
  desc "Merge multiple sources into one target with symlinks using stow"
  homepage "https://github.com/ShotaIuchi/amu"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.8/amu-aarch64-apple-darwin.tar.xz"
      sha256 "4abfb13882d090e88056537c5598b08064446e49826fe1c5b78a61a8070999fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.8/amu-x86_64-apple-darwin.tar.xz"
      sha256 "295dfb5e8b33ec74ff5d2787e73e803349bf494161fa29fb65bfbdbd7433e150"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.8/amu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b3d52e04de7940cf130abe5a944428d98c9ffbf971f59b6ffb0128ac21ea706"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ShotaIuchi/amu/releases/download/v0.1.8/amu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8bc7983e8240ae3762c019f1fb16eec28eb4671e9b32f459ed338620f51c5bbf"
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
