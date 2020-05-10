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

## Description

This module installs and configures [PiWeatherRock](https://piweatherrock.technicalissues.us) on a Raspberry Pi. Additional details are provide on the project website.

> **NOTE**: this module is actively evolving and may change over the next few weeks. I suggest waiting for v1 before using it.

## Setup

This module will install PiWeatherRock from [PyPI](https://pypi.org/project/piweatherrock/), along with all its pre-requisites, and create systemd services for the app and the web-based configuration utility named `PiWeatherRock` and `PiWeatherRockConfig`, respectively.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`.

## Development

Pull requests are welcome!
