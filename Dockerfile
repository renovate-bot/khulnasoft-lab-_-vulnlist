# syntax=docker/dockerfile:1
FROM python:3.11-slim@sha256:6d2502238109c929569ae99355e28890c438cb11bc88ef02cd189c173b3db07c

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

COPY dist dist
RUN pip install ./dist/vulnlist-*.whl

# This is needed to prevent newer versions of git raising dubious ownership
# errors if the repo directory or .git sub-directory are not owned by the
# current user.
#
# https://medium.com/@thecodinganalyst/git-detect-dubious-ownership-in-repository-e7f33037a8f
# https://github.com/actions/runner-images/issues/6775#issuecomment-1410270956
RUN git config --system safe.directory '*'

ENTRYPOINT ["vulnlist"]

LABEL org.opencontainers.image.source https://github.com/khulnasoft-lab/vulnlist
LABEL org.opencontainers.image.description "A tool for pulling and processing vulnerability data from mutiple sources"
