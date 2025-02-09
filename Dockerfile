FROM rust
ARG TARGETARCH
RUN apt-get update && apt-get install -y musl-tools
WORKDIR /root
COPY . .
RUN rustup target add "$(./target.py $TARGETARCH)"
RUN cargo build --target "$(./target.py $TARGETARCH)"
RUN cp "target/$(./target.py $TARGETARCH)/debug/foo" .

FROM scratch
COPY --from=0 /root/foo /root/foo
ENTRYPOINT ["/root/foo"]
