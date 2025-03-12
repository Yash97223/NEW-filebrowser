FROM alpine:latest

RUN apk --update add ca-certificates \
                     mailcap \
                     curl \
                     jq

# Copy and set executable permissions for the health check script
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh  

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

# Define volume and expose port
VOLUME /srv
EXPOSE 80

# Copy configuration file
COPY docker_config.json /.filebrowser.json

# Copy the filebrowser binary and ensure it has executable permissions
COPY filebrowser /filebrowser
RUN chmod +x /filebrowser  

# Set entrypoint
ENTRYPOINT [ "/filebrowser" ]
