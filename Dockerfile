# estos ProCall Enterprise STUN/TURN image
FROM coturn/coturn:4.5.2-r8

# Use root for admin task
USER root:root

# Apply most recent userspace updates
RUN apt update && apt -y upgrade

# Copy entrypoint script
COPY stunturn-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/stunturn-entrypoint.sh

# Switch to a less privileged user
USER nobody:nogroup

# Run entrypoint script checking for environment variables and executing turnserver
ENTRYPOINT ["stunturn-entrypoint.sh"]

CMD ["--no-stdout-log"]