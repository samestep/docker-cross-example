# Example code for Docker question on Stack Overflow

This repository holds a full code example to reproduce the issue in my Stack Overflow question:

> [**Can I build a multi-platform Docker image containing Rust code with native dependencies targeting musl?**](https://stackoverflow.com/q/79425799/5044950)

You'll need [Rust](https://www.rust-lang.org/tools/install) and [Docker](https://docs.docker.com/engine/install/). To build [multi-platform Docker images](https://docs.docker.com/build/building/multi-platform/), you must enable [containerd](https://docs.docker.com/storage/containerd/) in Docker. If you're running Docker Engine on Linux, without Docker Desktop, you also need to install [QEMU](https://docs.docker.com/build/building/multi-platform/#qemu-without-docker-desktop).

---

First, to run the program outside Docker entirely, use this command:

```sh
cargo run
```

To build and run natively but inside Docker, use this command:

```sh
docker build . -t foo && docker run --rm foo
```

To build a multi-platform Docker image, comment out the `wasmtime` dependency in [`Cargo.toml`](Cargo.toml) and then use this command:

```sh
docker build --platform linux/amd64,linux/arm64 .
```

To reproduce the error, simply use that last command without commenting out the dependency. For instance, [`log.txt`](log.txt) shows the error log I get when attempting to build this image for `linux/amd64` on my M1 MacBook.

As another data point, you can also use [`cross`](https://github.com/cross-rs/cross) to successfully build cross-platform musl binaries:

```sh
cross build --target x86_64-unknown-linux-musl
cross build --target aarch64-unknown-linux-musl
```
