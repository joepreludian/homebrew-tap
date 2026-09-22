# joepreludian/homebrew-tap

Homebrew formulas for my projects.

    brew install joepreludian/tap/docker-backup

## What's here

| Formula | Project |
| --- | --- |
| `docker-backup` | [joepreludian/docker-backup](https://github.com/joepreludian/docker-backup) — back up and restore Docker volumes, images and container filesystems |

The formula installs the pre-built binary attached to the GitHub Release
instead of compiling from source. The macOS builds are signed with a Developer
ID certificate and notarized by Apple, and rebuilding locally would throw that
away.

It deliberately does not depend on a `docker` package: Homebrew's `docker`
formula collides with the Docker Desktop, Colima or Rancher Desktop
installation most people already have. Run `docker-backup doctor` to check
your setup.

## Updating a formula

`Formula/docker-backup.rb` is generated. Edit
`template/docker-backup.rb.tmpl` instead — changes made directly to the
formula are overwritten by the next release.

After a new docker-backup release, either dispatch the workflow:

    gh workflow run update-formula.yml -f version=0.3.0

or render and commit it locally:

    bin/render-formula.sh 0.3.0

Both read the SHA-256 values out of the `SHA256SUMS` file published with that
release, so the formula cannot disagree with what GitHub is serving. Either
will fail rather than write a formula if any of the four archives is missing
from that release.

## License

The formula and the scripts here are offered under GPL-3.0-or-later, the same
licence as [docker-backup](https://github.com/joepreludian/docker-backup)
itself.
