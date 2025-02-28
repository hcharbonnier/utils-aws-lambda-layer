FROM amazonlinux

RUN yum install zip -y
RUN yum install unzip -y
RUN yum install jq -y
RUN mkdir -p /tmp/utils-lambda-layer

CMD export IGNORED_LIBS="linux-vdso.so|libc.so.6|ld-linux-x86-64.so|libm.so.6" && \
    cd /tmp/utils-lambda-layer && \
    mkdir -p bin && \
    mkdir -p lib && \
    cp /bin/unzip ./bin && \
    for lib in $(ldd /bin/unzip |grep -vE "$IGNORED_LIBS" | cut -d " " -f3 | xargs); do cp $lib ./lib/; done && \
    cp /bin/jq ./bin && \
    for lib in $(ldd /bin/jq |grep -vE "$IGNORED_LIBS" | cut -d " " -f3 | xargs); do cp $lib ./lib/; done && \
    zip -r utils-lambda-layer.zip ./* && \
    rm -rf lib bin
