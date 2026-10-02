class Ripe < Formula
  desc "See and update every outdated app on your Mac"
  homepage "https://github.com/imrajyavardhan12/ripe"
  url "https://github.com/imrajyavardhan12/ripe/releases/download/v0.2.0/ripe-0.2.0-universal-macos.tar.gz"
  version "0.2.0"
  sha256 "e697aa644f3f73b8753b1226e03d163b8c7af760af1131c9deba18995cb67a25"
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
