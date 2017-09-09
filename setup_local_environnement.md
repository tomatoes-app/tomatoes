# Setup your local environnement

## Installation

	$ git clone https://github.com/tomatoes-app/tomatoes
	$ bundle install

Make sure you have **MongoDB** installed.

	$ sudo apt-get install mongodb

## Setup Github Registration

On Github [register a new OAuth application](https://github.com/settings/applications/new) with these settings:

* **Application name**: Tomatoes
* **Homepage URL**: http://localhost:3000
* **Authorization callback URL**: http://localhost:3000/auth/github/callback

Then copy your **Client ID** & **Client Secret** into _config/github.example.yml_

## Setup Twitter Registration

TODO