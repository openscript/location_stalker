# Location Stalker
This is a [Sails](http://sailsjs.org) application. This application helps you to stalk the geographic locations of others, live on a map.

## Usage
Start Location Stalker with `sails lift`.

### Installation
1. Set up `nodejs` and `npm`.
2. Clone this project to a local folder.
3. Switch to the local folder and install project dependencies with `npm install && bower install`.
4. Configure database access at `config/connections.js`.

#### Configure PostgreSQL database
1. Add a new role with `CREATE ROLE location_stalker WITH CREATEDB LOGIN PASSWORD 'location_stalker';`.
2. Create a new database with `CREATE DATABASE location_stalker OWNER location_stalker`.

#### Configure MySQL database
1. Create a new database with `CREATE DATABASE location_stalker;`.

## Dependencies
This application works thanks to the following projects:
 - [Sails.JS](http://sailsjs.org)
 - [Foundation](http://foundation.zurb.com/)