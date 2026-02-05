class Wtp < Formula
  desc "Worktree Plus - Enhanced worktree management with variable expansion"
  homepage "https://github.com/ShotaIuchi/wtp"
  url "https://github.com/ShotaIuchi/wtp/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "89f0afcfb74c33cbeb4db7bd752e3657c0ec07a7f558bee7f8977fb33b13724b"
  license "MIT"
  head "https://github.com/ShotaIuchi/wtp.git", branch: "main"

  depends_on "go" => :build
  depends_on "git"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wtp"

    generate_completions_from_executable(bin/"wtp", "completion")
  end

  def caveats
    <<~EOS
      This is a fork of satococoa/wtp with additional features:
      - Variable expansion in base_dir: ${DIRNAME}, ${PATHNAME}, ${BRANCH}, ${BRANCH_SLUG}

      Example .wtp.yml:
        version: "1.0"
        defaults:
          base_dir: "../${DIRNAME}-worktrees"

      For shell integration, add to your shell config:
        eval "$(wtp shell-init bash)"  # for bash
        eval "$(wtp shell-init zsh)"   # for zsh
    EOS
  end

  test do
    system "#{bin}/wtp", "--help"
  end
end
