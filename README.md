# genebean-piweatherrock

[![Gitter](https://badges.gitter.im/PiWeatherRock/community.svg)](https://gitter.im/PiWeatherRock/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![](https://img.shields.io/puppetforge/pdk-version/genebean/piweatherrock.svg?style=popout)
![](https://img.shields.io/puppetforge/v/genebean/piweatherrock.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/genebean/piweatherrock.svg?style=popout)
[![Build Status](https://travis-ci.com/genebean/genebean-piweatherrock.svg?branch=master)](https://travis-ci.com/genebean/genebean-piweatherrock)

- [Description](#description)
- [Setup](#setup)
- [Reference](#reference)
- [Changelog](#changelog)
- [Development](#development)
  - [Releasing](#releasing)

## Description

This module installs and configures [PiWeatherRock](https://piweatherrock.technicalissues.us) on a Raspberry Pi. Additional details are provide on the project website in the "Getting started" section of the documentation.

## Setup

This module will install PiWeatherRock from [PyPI](https://pypi.org/project/piweatherrock/), along with all its pre-requisites, and create systemd services for the app and the web-based configuration utility named `PiWeatherRock` and `PiWeatherRockConfig`, respectively.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`.

## Development

Pull requests are welcome!

### Releasing

Run these commands:

```bash
git checkout master
git pull
git checkout release
git rebase master
git push
pdk bundle exec rake module:bump:minor
pdk bundle exec rake changelog
pdk bundle exec puppet strings generate --format markdown
```

- Review the output of the last command to make sure there are no errors or warnings at the beginning of it.
- Review any changes to `REFERENCE.md`
- Review `CHANGELOG.md` for the following:
  - nothing is uncategorized
  - that the previous release's version number is still present.
    If its been replaced a tag didn't get pushed last time.

If all is well, run these commands:

```bash
git commit -a -m "Release prep for $(jq -r '.version' metadata.json)"
git tag $(jq -r '.version' metadata.json)
git push
git push --tags
hub pull-request -l maintenance
pdk build
read -s forgeapikey
curl -H "User-Agent: curl-from-genebean" \
-H "Authorization: Bearer $forgeapikey" \
-H "Content-Type: application/json" \
-d "{\"file\":\"$(base64 pkg/genebean-piweatherrock-$(jq -r '.version' metadata.json).tar.gz)\"}" https://forgeapi.puppet.com/v3/releases
```
