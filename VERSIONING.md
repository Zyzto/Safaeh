# Versioning & releases

Safaeh uses **[SemVer](https://semver.org/)**:

| Part | When to bump |
|------|----------------|
| **MAJOR** | Breaking API changes |
| **MINOR** | Backward-compatible features |
| **PATCH** | Backward-compatible fixes |

The package is **not** on pub.dev (`publish_to: none`). Consumers depend on a
**git tag** `vMAJOR.MINOR.PATCH` that matches `version:` in
[`pubspec.yaml`](pubspec.yaml) (build metadata `+N` is ignored for tagging).

```yaml
dependencies:
  safaeh:
    git:
      url: https://github.com/Zyzto/Safaeh.git
      ref: v0.1.0
```

Do not publish this package to pub.dev until the API is marked stable and
`publish_to` is removed.

## Release checklist

1. Update `version:` in `pubspec.yaml`.
2. Add a `## [X.Y.Z] - YYYY-MM-DD` section to [`CHANGELOG.md`](CHANGELOG.md).
3. Run `./scripts/check_version.sh`.
4. Commit on `main` and push.
5. Run:

```bash
./scripts/release.sh
```

This runs analyze + tests, creates an annotated tag `vX.Y.Z`, and pushes it.
The **Release** GitHub Action then re-verifies the tag, runs tests, and
creates a GitHub Release. This package is not published to pub.dev.

Dry-run:

```bash
./scripts/release.sh --dry-run
```

Optional `VERSION` file, if present, must match pubspec.

## CI

| Workflow | Trigger | What it does |
|----------|---------|----------------|
| [CI](.github/workflows/ci.yml) | push/PR to `main` | version check, `dart analyze --fatal-infos`, `flutter test --coverage`, example analyze + test |
| [GitHub Pages](.github/workflows/pages.yml) | push to `main` | build `example/` web and deploy to [zyzto.github.io/Safaeh](https://zyzto.github.io/Safaeh/) |
| [Release](.github/workflows/release.yml) | tag `v*.*.*` | tag↔pubspec check, CHANGELOG check, tests, GitHub Release |

`scripts/check_version.sh` verifies pubspec semver, a matching CHANGELOG
heading, and an optional `VERSION` file.
