FROM innovanon/builder as builder
USER root
ENV GOPATH=${HOME}/go
ENV PATH=${PATH}:${HOME}/go/bin
COPY ./dpkg.list  /tmp/
RUN sleep 91                        \
 && apt update                      \
 && apt full-upgrade                \
 && test -x       /tmp/dpkg.list    \
 && apt install $(/tmp/dpkg.list)   \
 && rm -v         /tmp/dpkg.list    \
 && git config --global http.proxy socks5h://127.0.0.1:9050 \
 && go get -u github.com/tcnksm/ghr
USER lfs
RUN git config --global http.proxy socks5h://127.0.0.1:9050

#FROM builder as squash-tmp
#USER root
#RUN  squash.sh
#FROM scratch as squash
#ADD --from=squash-tmp /tmp/final.tar /

FROM builder
