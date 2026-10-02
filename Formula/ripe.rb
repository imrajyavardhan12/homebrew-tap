class Ripe < Formula
  desc "See and update every outdated app on your Mac"
  homepage "https://github.com/imrajyavardhan12/ripe"
  url "https://github.com/imrajyavardhan12/ripe/releases/download/v0.3.0/ripe-0.3.0-universal-macos.tar.gz"
  version "0.3.0"
  sha256 "72f1eb7968618bfeb741a477fb5fcbc794c86e3e17fa51522ac3a19c3a387f2d"
  license "MIT"

  depends_on macos: :sonoma

  def install
    bin.install "ripe"
    generate_completions_from_executable(bin/"ripe", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ripe --version")
    # Runs discovery and the whole pipeline without touching the network: no app matches,
    # so no source has work, and the catalog is off.
    ENV["RIPE_CATALOG_URL"] = "none"
    ENV["RIPE_CACHE_DIR"] = testpath/"cache"
    assert_match "No app named", shell_output("#{bin}/ripe why homebrew-formula-test 2>&1", 1)
  end
end
