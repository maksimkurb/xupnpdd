FROM alpine:latest

# Install packages
RUN apk --no-cache add bash git alpine-sdk util-linux-dev openssl-dev mc
RUN git clone https://github.com/clark15b/xupnpd.git
WORKDIR "/xupnpd/src/"
RUN make
RUN sed -i "s|interface='lo'|interface='br0'|g" "/xupnpd/src/xupnpd/xupnpd.lua" 
RUN sed -i "s|cfg.daemon=false|cfg.daemon=true|g" "/xupnpd/src/xupnpd/xupnpd.lua" 

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
EXPOSE 4044

ENTRYPOINT ["/entrypoint.sh"]
