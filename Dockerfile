FROM ros:kinetic as base
# install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ros-kinetic-navigation \
        ros-kinetic-tf \
        ros-kinetic-tf2 \
        ros-kinetic-tf2-geometry-msgs \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*
