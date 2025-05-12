# Change the base image to the one you want to use
FROM danenherdi/faas-netes:faasflows-0.1

# Change user to root to install dependencies and copy files
USER root

# Copy the flow config file to flow directory
RUN mkdir -p /etc/open-faas/flows
COPY config.json /etc/open-faas/flows/config.json
RUN chmod 644 /etc/open-faas/flows/config.json

# Change user to app to run the flow
USER app