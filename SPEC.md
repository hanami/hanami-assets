# Hanami Assets Bundler Specification

This document specifies the contract an asset bundler must satisfy to be a well-behaved Hanami
assets implementation. It is for implementers providing an alternative bundler (for example,
Sprockets, Rollup, or Vite) as a drop-in replacement for the default esbuild-based bundler shipped
in [hanami-assets-js].

The `hanami-assets` Ruby gem *consumes* the output described here: it loads the manifest, builds
URLs, and exposes `Hanami::Assets::Asset` objects to helpers. Any bundler that conforms to this
specification can be paired with `hanami-assets` and used by a Hanami application.

[hanami-assets-js]: https://github.com/hanami/hanami-assets-js

## Overview

Given a Hanami project with assets in app and one slice:

```
my_app/
├── app/
│   └── assets/
│       ├── js/app.ts
│       ├── css/app.css
│       └── images/logo.png
└── slices/admin/
    └── assets/
        ├── js/app.ts
        └── css/app.css
```

Running `bundle exec hanami assets compile` produces:

```
my_app/public/assets/
├── assets.json
├── app-QECGTTYG.js
├── app-MB666W4Y.css
├── logo-C6CAD725.png
└── _admin/
    ├── assets.json
    ├── app-A8K3JDLQ.js
    └── app-7HZ2M9PR.css
```

The app's `public/assets/assets.json`:

```json
{
  "app.js":   { "url": "/assets/app-QECGTTYG.js" },
  "app.css":  { "url": "/assets/app-MB666W4Y.css" },
  "logo.png": { "url": "/assets/logo-C6CAD725.png" }
}
```

In templates, helpers look up these logical names: `javascript_tag "app"` finds `app.js` in the
manifest and renders `<script src="/assets/app-QECGTTYG.js">`.

The rest of this document specifies each part of the pipeline.

## 1. Conformance

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** in this document are
to be interpreted as described in [BCP 14] ([RFC 2119], [RFC 8174]) when, and only when, they appear
in all capitals.

[BCP 14]: https://www.rfc-editor.org/info/bcp14
[RFC 2119]: https://www.rfc-editor.org/rfc/rfc2119
[RFC 8174]: https://www.rfc-editor.org/rfc/rfc8174

A bundler that satisfies every **MUST** in this document is **conformant**. A bundler that
additionally satisfies every **SHOULD** is **fully conformant**.

## 2. Terminology

- **App**: the top-level Hanami application; its assets live under `app/assets/`.
- **Slice**: a sub-application within a Hanami project; its assets live under
  `slices/<slice_name>/assets/`. Slices may be nested (e.g. `slices/admin/slices/users/`).
- **Assets source root**: the directory containing a single app's or slice's assets (i.e. the
  `assets/` directory itself).
- **Destination directory**: the directory under `public/` where compiled output for one app or
  slice is written.
- **Entry point**: a source file that the bundler treats as the root of a dependency graph and
  emits as a top-level bundle.
- **Static asset**: any asset that is not bundled as code (typically images, fonts, audio, video,
  and similar files).
- **Manifest**: a JSON file describing the mapping from logical asset names to their compiled
  output (see §5).

## 3. Project structure (input)

A Hanami project organises asset sources by app and slice.

### 3.1 App and slice assets source roots

```
<project_root>/
├── app/
│   └── assets/                        ← app assets source root
│       ├── js/
│       ├── css/
│       └── images/                    ← static assets
└── slices/
    └── <slice_name>/
        └── assets/                    ← slice assets source root
            ├── js/
            ├── css/
            └── images/
```

- The bundler MUST be invocable independently for the app and for each slice.
- The bundler MUST treat each invocation as isolated: it MUST NOT merge sources across slices, and
  it MUST NOT emit output for one slice into another's destination.

### 3.2 Default entry points

A conformant bundler SHOULD adopt these entry point conventions, matching [hanami-assets-js]:

- App: `app/assets/js/app.{js,ts,mjs,mts,tsx,jsx}`
- Slice: `slices/<slice_name>/assets/js/app.{js,ts,mjs,mts,tsx,jsx}`
- Additional entry points are any file matching `app.{js,ts,mjs,mts,tsx,jsx}` at any depth under
  `assets/js/` (e.g. `assets/js/login/app.ts` becomes a separate entry point named `login/app.js`).

A bundler MAY use different entry point conventions when the toolchain calls for it (for example,
a Sprockets-based bundler may treat any file under `assets/javascripts/` as bundleable). It MUST
document those conventions clearly.

### 3.3 Static assets

- Any file under the assets source root that is not part of the JS/CSS dependency graph SHOULD be
  treated as a static asset.
- In the reference implementation, every directory under `assets/` other than `js/` and `css/` is
  treated as a static asset directory (e.g. `images/`, `fonts/`).
- Static assets MUST be reachable in templates by their source-relative logical path (see §5).

## 4. Output structure

### 4.1 Destination directories

Compiled output MUST be written to the following destination directories, relative to the project
root:

| Source              | Destination directory                              |
|---------------------|----------------------------------------------------|
| App                 | `public/assets/`                                   |
| Top-level slice     | `public/assets/_<slice_name>/`                     |
| Nested slice        | `public/assets/_<parent_slice>/_<child_slice>/`    |

The leading `_` underscore on each slice path segment is required: it namespaces slice output
away from the app's own asset paths. The bundler MUST use the destination directory it is given;
hanami-cli applies the underscore prefix upstream.

### 4.2 Filename fingerprinting

In compile mode (see §6), each compiled file's filename MUST embed a content-derived fingerprint,
so changing content yields a new filename and clients can cache aggressively.

- The fingerprint MUST be deterministic for a given file's content.
- The fingerprint MAY use any algorithm and length the bundler chooses; the reference implementation
  uses the first 8 hex characters (uppercased) of a SHA-256 digest, e.g. `app-QECGTTYG.js`.
- The exact filename format is not part of the contract: consumers MUST resolve asset URLs through
  the manifest (§5), not by reconstructing filenames.

In watch mode (see §7), the bundler SHOULD omit the fingerprint and emit stable filenames so that
browsers reload predictably during development.

## 5. Manifest

The manifest is the single source of truth that the `hanami-assets` Ruby gem uses to resolve
logical asset names to URLs.

### 5.1 Location

Each app or slice MUST produce exactly one manifest file at:

```
<destination_directory>/assets.json
```

For example:

- App: `public/assets/assets.json`
- Slice `admin`: `public/assets/_admin/assets.json`
- Nested slice `admin/users`: `public/assets/_admin/_users/assets.json`

The filename `assets.json` is fixed (see `Hanami::Assets::MANIFEST_PATH`).

### 5.2 Format

The manifest MUST be a UTF-8 encoded JSON document whose top-level value is an object. Each key MUST
be a logical asset name (string) and each value MUST be an object with the following shape:

```json
{
  "<logical_name>": {
    "url": "<absolute path beginning with '/'>",
    "sri": ["<algorithm>-<base64>", ...]
  }
}
```

| Field | Required | Type             | Description |
|-------|----------|------------------|-------------|
| `url` | Yes      | string           | Absolute path under `public/` at which the compiled file is served, e.g. `/assets/app-QECGTTYG.js`. Despite the name, this MUST be a path, not a full URL: hanami-assets prepends a `base_url` at runtime to support CDN deployments. |
| `sri` | No       | array of strings | One subresource integrity value per algorithm requested (see §8). Each entry is `<algorithm>-<base64-digest>` (e.g. `sha384-…`). The field is present if and only if SRI was requested for that build. |

A bundler MAY include additional fields in entry objects; consumers other than `hanami-assets`
SHOULD ignore unknown fields. `hanami-assets` itself currently recognises only `url` and `sri`.

### 5.3 Logical names

Manifest keys are **logical names**: the path under which an asset is addressed by application
code and helpers, not output filenames. They MUST be:

- Source-relative paths with the `assets/` prefix removed.
- For JS/CSS entry points: the source path with its bundleable extension rewritten to its emitted
  extension (`.ts` → `.js`, `.tsx` → `.js`, `.scss` → `.css`, etc.). Example:
  `app/assets/js/admin/app.ts` → `admin/app.js`.
- For static assets: the source path with the asset-type directory prefix stripped. Example:
  `app/assets/images/icons/logo.png` → `icons/logo.png`.

This is the convention `hanami-assets` users already rely on through helpers (`stylesheet_tag "app"`
looks up `app.css` in the manifest). A conformant bundler MUST produce keys that match this scheme
so existing templates continue to work.

### 5.4 Coverage

The manifest MUST contain an entry for every asset the application can reach, including:

- Each entry point (JS, CSS).
- Every static asset under the assets source root (images, fonts, etc.), even if it is not
  referenced by any JS/CSS entry point.
- Every asset emitted as a side effect of bundling (e.g. images referenced from CSS via `url(...)`
  or from JS via `import`).

If an asset has no manifest entry, `Hanami::Assets#[]` raises `Hanami::Assets::AssetMissingError`.

### 5.5 Atomicity

A bundler SHOULD write the manifest atomically (e.g. write to a temp file then rename) so
consumers never read a partially-written file. This matters in watch mode, where the manifest can
be rewritten while the application server is running.

## 6. Compile mode

`hanami assets compile` runs the bundler once and exits. In this mode the bundler MUST:

1. Resolve all entry points and emit fingerprinted output (§4.2) to the destination directory.
2. Copy and fingerprint all static assets to the destination directory.
3. Write a complete manifest (§5).
4. Exit with status `0` on success and a non-zero status on failure.

A bundler SHOULD additionally:

- Minify compiled JS/CSS output.
- Emit source maps alongside compiled output.

Neither is part of the manifest contract, but production builds typically include both.

## 7. Watch mode

`hanami assets watch` runs the bundler indefinitely, rebuilding output as sources change. In this
mode the bundler MUST:

1. Perform an initial full build, equivalent to compile mode but with non-fingerprinted filenames
   (§4.2).
2. Continue running until it receives `SIGINT`, at which point it MUST shut down cleanly (releasing
   file watchers, closing the bundler context, etc.) and exit with status `0`.
3. Keep the manifest correct after every rebuild: after any change, the manifest on disk MUST
   describe the current set of compiled outputs.

A bundler SHOULD also:

- **Pick up newly-added entry points without restart.** When a new file matching the entry point
  convention (§3.2) is added under `assets/js/`, the bundler SHOULD detect it, emit its bundle,
  and add a manifest entry without requiring a restart.
- **Pick up changes to static assets without restart.** When a static asset (image, font, etc.) is
  added, modified, or removed, the bundler SHOULD update the destination directory and the
  manifest accordingly, without restarting.
- Stream build progress and errors to stdout/stderr line-by-line. hanami-cli prefixes each line with
  the slice name when running multiple bundlers in parallel; line-buffered output produces the
  cleanest result.
- Continue running after a build error rather than exiting, so the developer can fix the source and
  trigger a successful rebuild.

## 8. Subresource Integrity (SRI)

When the application is configured with one or more SRI algorithms (via
`config.assets.subresource_integrity`), hanami-cli passes a `--sri=<algos>` flag to the bundler (a
comma-separated list, e.g. `--sri=sha256,sha384`).

When SRI is requested, the bundler MUST:

- Compute one digest per requested algorithm for each non-source-map asset it emits.
- Include those digests in the asset's manifest entry under the `sri` key, in the form
  `<algorithm>-<base64-digest>` (e.g. `sha384-d9ndh67…`).

When SRI is not requested, the bundler MUST omit the `sri` key from manifest entries.

## 9. CLI invocation contract (current)

The default bundler is JavaScript-based, and `hanami assets compile` / `hanami assets watch` are
hard-wired to invoke it through Node. There is no general bundler registration mechanism yet; one
is planned (see §12). Until then, a non-JS bundler has three options:

- **Impersonate the JS interface.** Provide a `config/assets.js` shim that translates the Node CLI
  invocation below into the bundler's own driver.
- **Register parallel commands.** For example, [hanami-sprockets] registers
  `hanami sprockets:compile` and `hanami sprockets:watch`, and asks users to invoke those instead.
- **Override the built-in commands.** Replace the registrations for `hanami assets compile` and
  `hanami assets watch` with the bundler's own implementations.

Whichever path a bundler takes, the §3–§8 output contract is stable: a bundler that produces the
correct manifest and directory layout will keep working when first-class hooks arrive.

### 9.1 Node CLI signature

hanami-cli locates a `config/assets.js` file (slice-local first, then app-level) and invokes:

```
node <path/to/config/assets.js> -- \
  --path=<assets_source_root> \
  --dest=<destination_directory> \
  [--watch] \
  [--sri=<algorithm>[,<algorithm>...]]
```

Both paths are relative to the project root.

A bundler that hooks in via this CLI MUST:

- Parse the flags above. Unknown flags MAY be ignored.
- Treat `--path` as the assets source root and `--dest` as the destination directory. The bundler
  MUST NOT recompute these.
- Honour `--watch` (see §7) and `--sri` (see §8) when present.

[hanami-sprockets]: https://github.com/andrew/hanami-sprockets

## 10. Configuration on the Ruby side

The `hanami-assets` Ruby gem exposes settings on `config.assets` that affect how the bundler is
called and how its output is consumed:

| Setting                  | Purpose                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| `subresource_integrity`  | Array of algorithm symbols (e.g. `[:sha384]`). When non-empty, hanami-cli passes the corresponding `--sri` flag. |
| `base_url`               | Used at runtime to build absolute URLs from manifest `url` paths. The bundler does not need to know about this; it only writes paths. |
| `path_prefix`            | Defaults to `/assets`. The bundler emits manifest URLs that begin with this prefix. |

A bundler MUST NOT bake the configured `base_url` into manifest URLs: manifest entries are paths,
and the consumer prepends the base URL at request time.

## 11. Out of scope

- The on-disk layout of intermediate or cache files used by the bundler.
- Whether and how the bundler supports plugins, transformations, or framework integrations beyond
  what is needed to satisfy §3–§8.
- Hot module replacement and other live-reload mechanisms beyond rebuilding the manifest.

## 12. Future work

This specification will evolve as the following work lands:

- First-class integration hooks for alternative bundlers. The built-in `hanami assets compile` and
  `hanami assets watch` commands will gain a registration mechanism so an installed bundler gem can
  declare itself as the project's bundler and be invoked in place of the default Node CLI. With this
  in place, alternative bundlers will no longer need to register parallel commands or override the
  built-in ones (see §9).
- A versioning scheme for the manifest format, should it gain new required fields.
