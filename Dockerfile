FROM python:3.12-slim

# Base deps
RUN apt-get update && apt-get install -y --no-install-recommends build-essential git \
 && rm -rf /var/lib/apt/lists/*

# App user
RUN useradd -U -m -s /bin/bash -d /eegml_resting_alpha eegml_resting_alpha
USER eegml_resting_alpha
WORKDIR /eegml_resting_alpha

# Ensure PATH finds user-site scripts
ENV PATH=/eegml_resting_alpha/.local/bin:$PATH
ENV PYTHONPATH=/eegml_resting_alpha/.local/lib/python3.12/site-packages

# Install package (user site)
RUN pip install --no-cache-dir --user mne==1.10.2 mne_bids==0.17.0 autoreject==0.4.3 pandas==2.3.3

# Copy your entrypoint script and make it executable with LF endings
USER root
COPY bin/eegml_resting_alpha /eegml_resting_alpha/.local/bin/eegml_resting_alpha
RUN dos2unix /eegml_resting_alpha/.local/bin/eegml_resting_alpha 2>/dev/null || true \
 && chmod 0755 /eegml_resting_alpha/.local/bin/eegml_resting_alpha \
 && chown eegml_resting_alpha:eegml_resting_alpha /eegml_resting_alpha/.local/bin/eegml_resting_alpha
USER eegml_resting_alpha

# Prefer absolute path to avoid PATH resolution issues
ENTRYPOINT ["/eegml_resting_alpha/.local/bin/eegml_resting_alpha"]