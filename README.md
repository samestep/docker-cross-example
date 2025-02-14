# Example code for cc-rs issue about musl archiver

This repository holds a full code example to reproduce this issue I opened in the [rust-lang/cc-rs](https://github.com/rust-lang/cc-rs) repo:

> [**Archiver for musl is not `ar` when in Docker image for a different architecture**](https://github.com/rust-lang/cc-rs/issues/1399)

You'll need [Rust](https://www.rust-lang.org/tools/install) and [Docker](https://docs.docker.com/engine/install/). To build [multi-platform Docker images](https://docs.docker.com/build/building/multi-platform/), you must enable [containerd](https://docs.docker.com/storage/containerd/) in Docker. If you're running Docker Engine on Linux, without Docker Desktop, you also need to install [QEMU](https://docs.docker.com/build/building/multi-platform/#qemu-without-docker-desktop).

---

To run natively:

```sh
rm -rf target && cargo build -vv 2> /dev/null
```

To run natively targeting x86 musl:

```sh
rm -rf target && cargo build -vv --target "$(./target.py amd64)" 2> /dev/null
```

To run natively targeting ARM musl:

```sh
rm -rf target && cargo build -vv --target "$(./target.py arm64)" 2> /dev/null
```

To run in Docker targeting x86 musl:

```sh
docker build --platform linux/amd64 . -t foo-x86 && docker run --rm foo-x86
```

To run in Docker targeting ARM musl:

```sh
docker build --platform linux/arm64 . -t foo-arm && docker run --rm foo-arm
```

In whichever case, look at the archiver printed at the bottom of the output. Here's what I see on the machines I've used to test this:

- ARM macOS
  - native: `"ar"`
  - native targeting x86 musl: `"ar"`
  - native targeting ARM musl: `"ar"`
  - Docker targeting x86 musl: `"musl-ar"`
  - Docker targeting ARM musl: `"ar"`
- x86 Linux
  - native: `"ar"`
  - native targeting x86 musl: `"ar"`
  - native targeting ARM musl: `"ar"`
  - Docker targeting x86 musl: `"ar"`
  - Docker targeting ARM musl: `"aarch64-linux-musl-ar"`

You can also look at other info from the output, e.g. `TARGET` and `HOST`:

- ARM macOS
  - native:
    ```
    TARGET = Some(aarch64-apple-darwin)
    HOST = Some(aarch64-apple-darwin)
    ```
  - native targeting x86 musl: `"ar"`
    ```
    TARGET = Some(x86_64-unknown-linux-musl)
    HOST = Some(aarch64-apple-darwin)
    ```
  - native targeting ARM musl: `"ar"`
    ```
    TARGET = Some(aarch64-unknown-linux-musl)
    HOST = Some(aarch64-apple-darwin)
    ```
  - Docker targeting x86 musl: `"musl-ar"`
    ```
    TARGET = Some(x86_64-unknown-linux-musl)
    HOST = Some(x86_64-unknown-linux-gnu)
    ```
  - Docker targeting ARM musl: `"ar"`
    ```
    TARGET = Some(aarch64-unknown-linux-musl)
    HOST = Some(aarch64-unknown-linux-gnu)
    ```
