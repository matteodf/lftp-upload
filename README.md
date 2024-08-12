# lftp-upload

## Overview

lftp-upload is a GitHub Action that simplifies the process of uploading files to a standard FTP server. This action leverages Docker and **`lftp`**, a sophisticated file transfer program, to perform secure and reliable file transfers in your CI/CD workflows.

## Usage

To use this action, include it as a step in your GitHub Actions workflow. Below is an example configuration:

```yaml
name: Deploy to FTP
on: push
jobs:
  ftp-deploy:
    runs-on: ubuntu-latest
    steps:
        - uses: actions/checkout@v2
        - name: Upload files to FTP
        uses: matteodf/lftp-upload@v1
        with:
            host: ${{ secrets.FTP_HOST }}
            username: ${{ secrets.FTP_USERNAME }}
            password: ${{ secrets.FTP_PASSWORD }}
            forceSsl: "true"
            localDir: ${{ secrets.FTP_LOCAL_DIR }}
            remoteDir: ${{ secrets.FTP_REMOTE_DIR }}
            timeout: "120"
            retries: "5"
            multiplier: "2.0"
            baseInterval: "10"
            pConn: "10"
```

Note: you need to set secrets in the repository settings. See the [documentation](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) for more information.

## Inputs

| Name         | Description                      | Required | Default |
| ------------ | -------------------------------- | -------- | ------- |
| host         | FTP host address                 | true     | -       |
| username     | FTP username                     | true     | -       |
| password     | FTP password                     | true     | -       |
| forceSsl     | Force SSL                        | false    | false   |
| localDir     | Local directory to upload from   | false    | .       |
| remoteDir    | Remote directory to upload to    | false    | .       |
| timeout      | Connection timeout in seconds    | false    | 60      |
| retries      | Maximum number of retry attempts | false    | 20      |
| multiplier   | Multiplier for retry intervals   | false    | 1.5     |
| baseInterval | Base retry interval in seconds   | false    | 5       |
| pConn        | Number of parallel connections   | false    | 5       |

For more information on each input and how they are used, see the [lftp documentation](https://lftp.yar.ru/lftp-man.html).

## Dockerfile

This action runs inside a Docker container built from an Alpine Linux base image, which includes **`lftp`** for file transfers:

```dockerfile
FROM alpine:latest

WORKDIR /

RUN apk --no-cache add lftp
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

## Entry Point

The entrypoint.sh script configures and runs the lftp command based on the input parameters provided:

```sh
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
```

## License

This project is licensed under the [GNU General Public License v3](https://www.gnu.org/licenses/gpl-3.0).

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check out the [issues page](https://github.com/matteodf/lftp-upload/issues).
