class Pluralith < Formula
  desc "Terraform state visualisation and automated infrastructure documentation"
  homepage "https://pluralith.com"
  url "https://github.com/Pluralith/pluralith-cli/releases/download/v0.2.2/pluralith_cli_tap_darwin_amd64_v0.2.2.tar.gz"
  sha256 "c732e4c93102231d92e6872bce71783df60bc23a340e48cdd01001389627e4d5"
  version "0.2.2"

  on_macos do
    def install
      bin.install "darwin/pluralith"
    end

    if Hardware::CPU.arm?
      def caveats
        <<~EOS
          The darwin_arm64 architecture is not supported for the Pluralith
          formula at this time. The darwin_amd64 binary may work in compatibility
          mode, but it might not be fully supported.
        EOS
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Pluralith/pluralith-cli/releases/download/v0.2.2/pluralith_cli_tap_linux_amd64_v0.2.2.tar.gz"
      sha256 "6c01db115596774dad5a2445f3091e4c40c999237a1a0e3f0cf1a88fcc70684e"

      def install
        bin.install "linux/pluralith"
      end
    end
  end

  test do
    system "#{bin}/pluralith version"
  end
end
