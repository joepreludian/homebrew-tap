class DockerBackup < Formula
  desc "Back up and restore Docker volumes, images and container filesystems"
  homepage "https://docker-backup.jon.dev.br/"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.3.0/docker-backup-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "2ecd98e4883d9bed8261cb62300f5f5dc9b71a1ec2fa9ea73aa01e3a05582d8a"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.3.0/docker-backup-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "57034e94e8b50fb2ffd3f5a3a361bc5be0a41b7d23e23002ce68ccfe1118e66d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.3.0/docker-backup-0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c874f573983a2e7bc5240e02de71f59ea91e16c198dc183aec6c4c6c6c4ea1d8"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.3.0/docker-backup-0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "484c73b1b8290eaf8ffdf6c44442e642a23c7e4e994bbddc3942715e5fe155c5"
    end
  end

  # Deliberately no `depends_on "docker"`. Homebrew's docker formula collides
  # with the Docker Desktop, Colima or Rancher Desktop installation most users
  # already have, so the docker CLI stays theirs to manage. `docker-backup
  # doctor` reports it clearly when it is missing.

  def install
    bin.install "docker-backup"
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      docker-backup drives the docker CLI, which this formula does not install.
      Check your setup with:
        docker-backup doctor

      Manual: https://docker-backup.readthedocs.io/
    EOS
  end

  test do
    assert_match "docker-backup #{version}", shell_output("#{bin}/docker-backup --version")
  end
end
