FROM alpine:latest

# Install required packages
RUN apk --update add ca-certificates \
                     mailcap \
                     curl \
                     jq \
                     tar

# Copy and set executable permissions for the health check script
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh  

# Set up healthcheck
HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

# Define volume and expose port
VOLUME /srv
EXPOSE 80

# Copy configuration file
COPY docker_config.json /.filebrowser.json

# Download correct filebrowser binary for x86_64 architecture
RUN curl -L https://github.com/filebrowser/filebrowser/releases/latest/download/linux-amd64-filebrowser.tar.gz -o filebrowser.tar.gz && \
    tar -xvzf filebrowser.tar.gz && \
    mv filebrowser /filebrowser && \
    chmod +x /filebrowser && \
    rm filebrowser.tar.gz

# Set entrypoint
ENTRYPOINT [ "/filebrowser" ]
