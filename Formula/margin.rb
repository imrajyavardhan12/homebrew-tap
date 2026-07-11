class Margin < Formula
  desc "A fast, keyboard-first terminal diff viewer for Git changes, patches, and AI-authored code."
  homepage "https://github.com/imrajyavardhan12/Margin"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.2.0/margin-aarch64-apple-darwin.tar.xz"
      sha256 "f4770649bcc8b18dd65d6479939ac97385aa8683fe90958cb61e21447c9f0b4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.2.0/margin-x86_64-apple-darwin.tar.xz"
      sha256 "07e27e92ba300f15362b44e719765545f508157d3158324d99c13b3e3905b4c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.2.0/margin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5fd6527e16b1395577b1689e8dbba840c8e0d0b94daf1187122ac33fb700389"
    end
    if Hardware::CPU.intel?
      url "https://github.com/imrajyavardhan12/Margin/releases/download/v0.2.0/margin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb570695d0d545f89bdc5b20e538850420f0f6f2c7eb7d0482f13529abaff418"
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
