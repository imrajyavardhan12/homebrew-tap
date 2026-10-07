class Ripe < Formula
  desc "See and update every outdated app on your Mac"
  homepage "https://github.com/imrajyavardhan12/ripe"
  url "https://github.com/imrajyavardhan12/ripe/releases/download/v0.4.0/ripe-0.4.0-universal-macos.tar.gz"
  version "0.4.0"
  sha256 "31ea9c9131b11a44f61b17678905ad9e7045f2269fc8669c3fe63feeec49eb65"
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
