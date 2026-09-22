class DockerBackup < Formula
  desc "Back up and restore Docker volumes, images and container filesystems"
  homepage "https://docker-backup.jon.dev.br/"
  version "0.2.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.2.0/docker-backup-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "49fae1cbc15ab32de059fdb65fd1fbdb339676c3bb3a9eb9eab6c33f7750ba2c"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.2.0/docker-backup-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "5a35011692ae2d87b1e1e4ef1256b71b0e700bf6a93844be9791e8a37706b028"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.2.0/docker-backup-0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "941a0cbffe17e1ec725d63f94cfff5ce6d957011006a00feb56b734ab6c8b244"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.2.0/docker-backup-0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cd9bc1ec919211b669a6696538549b3b080edee3c9ad1e9c7659a04a76a20558"
    end
  end

  # Deliberately no `depends_on "docker"`. Homebrew's docker formula collides
  # with the Docker Desktop, Colima or Rancher Desktop installation most users
  # already have, so the docker CLI stays theirs to manage. `docker-backup
  # doctor` reports it clearly when it is missing.

  livecheck do
    url "https://github.com/joepreludian/docker-backup/releases/latest"
    strategy :page_match
    regex(%r{tag/v?(\d+(?:\.\d+)+)}i)
  end

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
