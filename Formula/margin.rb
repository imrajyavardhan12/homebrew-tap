class Margin < Formula
  desc "A fast, keyboard-first terminal diff viewer for Git changes, patches, and AI-authored code."
  homepage "https://github.com/imrajyavardhan12/Margin"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.1.0/margin-aarch64-apple-darwin.tar.xz"
      sha256 "d921e2886f291248340d881046e517630ca2c6052c0ee9372af6396113f77555"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.1.0/margin-x86_64-apple-darwin.tar.xz"
      sha256 "7e0894eff8e071a026cbf86436aec00a928fc772e7949253aecc360faec50ff7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.1.0/margin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aa761d0a88e3cfa4978342d8f1e254418df1c1aac582fc383611e2ec2a73af43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.1.0/margin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2150322bec9696c7d776fcfbfce20053cdb9bc258436d95354b49eb99161d8df"
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
