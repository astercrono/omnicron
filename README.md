# Overview

A framework for developing and coordinating multiple bot "backends" into a single bot.

For example, this framework can be used scrape posts off Reddit and share them in Discord.

## Features

Omnicron functionality is opt-in at runtime and is broken up into combinations of **features**. Each feature itself is tied to one or more backends.

As such, to enable functionality, a list of features must be provided (more on that later).

Here is the current list of supported features and their required backends:

 - `google-api` (Google)
 - `discord` (Discord)
 - `discord-message-read` (Discord)
 - `reddit` (Reddit)
 - `reddit-sub-scrape` (Reddit)
 - `reddit-keyword-scan` (Reddit)
 - `reddit-keyword-to-discord` (Reddit, Discord)

Combining features is how to enable overall functionality.

### Current Functionality

 | Functionality                    | Features 
 |----------------------------------|----------
 | Discord URL Protection           | `google-api`, `discord`, `discord-message-read`
 | Reddit-to-Discord Keyword Scrape | `discord`, `discord-message-read`, `reddit`, `reddit-sub-scrape`, `reddit-keyword-scan`, `reddit-keyword-to-discord`

## Prerequisites

The setup process can vary based on what features are being enabled. Essentially, you will need API credentials for some backends.

### Discord

If you wish to activate Discord features, then the following API credentials are required from Discord:

 - App ID
 - App Key
 - Bot Key
 - An Invite Link to your Server

Review Discord's Getting Started Guide for help obtaining those: https://discord.com/developers/docs/getting-started

**Note**: The Invite Link is an invite link to *your desired* server.

### Reddit

No special credentials are required from Reddit. The current Reddit backend is read-only. Just enable the features.

### Google

If enabling the `discord-url-protection` feature, then a Google API Key is required.

Directions for obtaining an API Key: https://developers.google.com/maps/documentation/javascript/get-api-key

For typical Discords, a free tier is probably just fine. Review Google's Quota Guide to determine it the free tier is sufficient for your needs: https://developers.google.com/analytics/devguides/reporting/mcf/v3/limits-quotas.

## Setup

### Project Setup

Clone this repository: `git clone https://github.com/cronkib/omnicron.git`

Enter the project: `cd omnicron`

Create some directories: `mkdir data logs`

### The Config File

Provided that you have all of the necessary API Credentials, you can setup the config file.

Omnicron includes a sample config under `config/sample.json`. Copy this file for your own use: `cp config/sample.json config/myconfig.json`

Open the new config up and enter your API credentials into it. Additionally, set your desired features and any related configuration that is required for them.

**Note**: The config file may be named anything, though it should remain within the `config` directory.

## Running

### With Docker

The `scripts` directory contains scripts to use. 

**Build**: `./docker-build.sh`

**Run**: `./docker-run.sh -c <filename>`

**Example**:

```
cd scripts
./docker-build.sh
./docker-run.sh -c myconfig.json
```

Additionally, the `-n <container-extra-name>` argument maye be used with `docker-run.sh` to provide an additional qualifier to the container name: `./docker-run.sh -c myconfig.json -n special`

### From Source

Ruby 3.2 is recommended and ensure that you have Bundler installed.

**Build**

`rake build_prod`

**Run**

`bundle exec run.rb -c config/myconfig.json`

**Note**: When running from source, the config file path is specified in full, relative from the omnicron directory.
