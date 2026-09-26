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
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.4.0/docker-backup-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9de944edfad5fd90226029513bb104ba02232df449312266edf1841b73e49f1e"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.4.0/docker-backup-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "f0e8d56078ebd5921d0bbea6fd070db0446fb1042a82ecc006cef977d722edbf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.4.0/docker-backup-0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9c7bdf7c25d4f8c19253a3ffd73bfd34e2d8d4f6e1cd7736b27feffbee8a22d8"
    end
    on_intel do
      url "https://github.com/joepreludian/docker-backup/releases/download/v0.4.0/docker-backup-0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cbbe087a2a4d91328f6207f424bf2de02ff45c9f8a8898aa9708a4c73f2c6d38"
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
