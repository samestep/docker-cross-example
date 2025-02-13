FROM rust
ARG TARGETARCH
RUN apt-get update && apt-get install -y musl-tools
WORKDIR /root
COPY . .
RUN rustup target add "$(./target.py $TARGETARCH)"
RUN cargo build -vv --target "$(./target.py $TARGETARCH)" > log.txt
CMD ["cat", "log.txt"]
