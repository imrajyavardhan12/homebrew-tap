class Margin < Formula
  desc "A fast, keyboard-first terminal diff viewer for Git changes, patches, and AI-authored code."
  homepage "https://github.com/imrajyavardhan12/Margin"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.5.1/margin-aarch64-apple-darwin.tar.xz"
      sha256 "e3925c6e9da6747c5b1bd2f5a4069445a1d957bd3896e3d4a69929d35e79a605"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.5.1/margin-x86_64-apple-darwin.tar.xz"
      sha256 "97f3295ed270edb854bee63c00dc1136c3e69e52e8fc3ed48211ee2ddd0ac4b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.5.1/margin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70847e625f6a35b0d0586c07402da3e708656111960c3ec932a4584da4895359"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.5.1/margin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56a7824db5f2c880bbaf77ab0d8fd74e346fa4ad581405545554acc46826d9d7"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "margin" if OS.mac? && Hardware::CPU.arm?
    bin.install "margin" if OS.mac? && Hardware::CPU.intel?
    bin.install "margin" if OS.linux? && Hardware::CPU.arm?
    bin.install "margin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
