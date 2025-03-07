class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.48",
      revision: "808f6cc5e1b1ca6ddd599dd7fcf941c408cb3f0d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75377ba19df63e447dfaf1f5356d5fce30d86b35f4bc10fb15ce72da0ed7c7a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75377ba19df63e447dfaf1f5356d5fce30d86b35f4bc10fb15ce72da0ed7c7a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75377ba19df63e447dfaf1f5356d5fce30d86b35f4bc10fb15ce72da0ed7c7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "95838098567c918f63b6a8443314264b09ef3c74d3a4bb9ad79c1aed07a09829"
    sha256 cellar: :any_skip_relocation, monterey:       "95838098567c918f63b6a8443314264b09ef3c74d3a4bb9ad79c1aed07a09829"
    sha256 cellar: :any_skip_relocation, big_sur:        "95838098567c918f63b6a8443314264b09ef3c74d3a4bb9ad79c1aed07a09829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c77e7ea0451a3ea7a667c40d0ac0422d92a5db0b5dbd12f34390a9d5ebe5c60"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
