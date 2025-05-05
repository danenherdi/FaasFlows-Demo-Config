# Ubah base image sesuai kebutuhan
FROM danenherdi/faas-netes:faasflows-0.1

# Beralih ke user root untuk membuat direktori dan menyalin file
USER root

# Buat direktori dan salin file konfigurasi
RUN mkdir -p /etc/open-faas/flows
COPY config.json /etc/open-faas/flows/config.json
RUN chmod 644 /etc/open-faas/flows/config.json

# Kembali ke user non-root (biasanya app)
USER app