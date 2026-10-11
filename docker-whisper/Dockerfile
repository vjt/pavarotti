# whisper.cpp is compiled inside the image: no third-party code on the host.
FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential cmake git ca-certificates && rm -rf /var/lib/apt/lists/*
ARG WHISPER_REF=c44b60b
RUN git clone https://github.com/ggml-org/whisper.cpp /src && cd /src \
 && git checkout "$WHISPER_REF" \
 && cmake -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
 && cmake --build build -j"$(nproc)" --target whisper-cli

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 ffmpeg \
 && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/build/bin/whisper-cli /usr/local/bin/
WORKDIR /w
