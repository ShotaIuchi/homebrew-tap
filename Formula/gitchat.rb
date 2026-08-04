class Gitchat < Formula
  desc "Asynchronous chat that uses a Git repository as the server"
  homepage "https://github.com/ShotaIuchi/git-chat"
  url "https://github.com/ShotaIuchi/git-chat/releases/download/v0.1.0/gitchat-cli-0.1.0.tar.gz"
  sha256 "72a302c570a274fd7e525f3ea0e1f4e7861e7821805941f294c195df31bbf134"
  license "MIT"

  depends_on "node"
  depends_on "git"

  def install
    libexec.install Dir["*"]
    (bin/"gitchat").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/index.js" "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitchat --version")
  end
end
