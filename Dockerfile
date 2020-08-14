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
# create working directory
RUN mkdir -p /root/catkin_ws/src \
 && touch /root/catkin_ws/.catkin_workspace
WORKDIR /root/catkin_ws
# copy entry point script
COPY container-files/min-env/cm_entrypoint.sh /
RUN chmod +x /cm_entrypoint.sh


FROM base as builder
# set CMD to the build script
CMD [ "/cm_entrypoint.sh" ]


FROM base as dev
# install development utilities
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        bash-completion \
        cowsay \
        doxygen \
        ruby \
        vim \
        wget \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*
# copy utility files
COPY container-files/dev-env/root/ /root/
RUN echo "\nif [ -f /root/.bashrcs/entrypoint.bashrc ]; then\n    source /root/.bashrcs/entrypoint.bashrc\nfi" >> /root/.bashrc
# install git utilities for cli
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -q -O /root/.bashrcs/bashrc-git-completion \
 && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh       -q -O /root/.bashrcs/bashrc-git-prompt
# install vim plugins
RUN mkdir -p /root/.vim/bundles \
 && git -C /root/.vim/bundles clone -q https://github.com/Shougo/dein.vim \
 && git -C /root/.vim/bundles/dein.vim checkout -q 1.0 \
 && while true; do echo " "; sleep 1s; done | vim -c exit > /dev/null
