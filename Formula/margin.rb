class Margin < Formula
  desc "A fast, keyboard-first terminal diff viewer for Git changes, patches, and AI-authored code."
  homepage "https://github.com/imrajyavardhan12/Margin"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.3.0/margin-aarch64-apple-darwin.tar.xz"
      sha256 "327193481fac95d84b290da086fee0af9b48d936988be8b300b9a5f0a853c800"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.3.0/margin-x86_64-apple-darwin.tar.xz"
      sha256 "2aa94249344d979741c59e5efdde9d33b8b6a305e880fab53e9bee5db9054615"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.3.0/margin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86378b6cf5cf9673cebb7c0f4a332d67f239f0065e64878ce1387d230b014564"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.3.0/margin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6267dbac4bfa034966f4a44136f5e7be1de9fcdfc3dcb52188ef56cda67b9f9"
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
