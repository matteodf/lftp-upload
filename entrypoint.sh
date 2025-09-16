#!/bin/sh -l

# Build mirror command flags
MIRROR_FLAGS="-v -P $INPUT_PCONN -R -n -L -x ^\.git/$"

# Add delete flag if enabled
if [ "$INPUT_DELETE" = "true" ]; then
  MIRROR_FLAGS="$MIRROR_FLAGS -e"
fi

lftp ${INPUT_HOST} -u ${INPUT_USERNAME},${INPUT_PASSWORD} -e "
  set net:timeout $INPUT_TIMEOUT;
  set net:max-retries $INPUT_RETRIES;
  set net:reconnect-interval-multiplier $INPUT_MULTIPLIER;
  set net:reconnect-interval-base $INPUT_BASEINTERVAL;
  set ftp:ssl-force $INPUT_FORCESSL; 
  set sftp:auto-confirm yes;
  set ssl:verify-certificate $INPUT_FORCESSL; 
  mirror $MIRROR_FLAGS $INPUT_LOCALDIR $INPUT_REMOTEDIR;
  quit
"