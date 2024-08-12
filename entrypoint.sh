#!/bin/sh -l

lftp ${INPUT_HOST} -u ${INPUT_USERNAME},${INPUT_PASSWORD} -e "
  set net:timeout $INPUT_TIMEOUT;
  set net:max-retries $INPUT_RETRIES;
  set net:reconnect-interval-multiplier $INPUT_MULTIPLIER;
  set net:reconnect-interval-base $INPUT_BASEINTERVAL;
  set ftp:ssl-force $INPUT_FORCESSL; 
  set sftp:auto-confirm yes;
  set ssl:verify-certificate $INPUT_FORCESSL; 
  mirror -v -P $INPUT_PCONN -R -n -L -x ^\.git/$ $INPUT_LOCALDIR $INPUT_REMOTEDIR;
  quit
"