# Location Stalker
This is a [Sails](http://sailsjs.org) application, which helps you to stalk the geographic locations of others, live on a map. Post the coordinates to the REST interface. They will be immediately shown on the map.

## Usage
Start Location Stalker with `sails lift`.

### Installation
1. Set up `nodejs`, `npm`, `bower`, `ruby`, `rubygems` and the ruby bundler.
2. Clone this project to a local folder.
3. Switch to the local folder and install projects dependencies with `npm install && bower install && bundle install`.
4. Configure database access at `config/connections.js`.

#### Configure PostgreSQL database
1. Add a new role with `CREATE ROLE location_stalker WITH CREATEDB LOGIN PASSWORD 'location_stalker';`.
2. Create a new database with `CREATE DATABASE location_stalker OWNER location_stalker;`.

#### Configure MySQL database
1. Install the npm package `sails-mysql`.
2. Create a new database with `CREATE DATABASE location_stalker;`.

### Debugging
1. Install `node-inspector` via `npm`.
2. Run `node-inspector &` and `sails debug` or `node --debug-brk app.js`. Set break points with `debugger`.
3. Visit the url as node inspector indicates. Make sure that you run the code, which containts your break point.

## Issues
- Foundation is not optimized for `SASS > 3.2`. So grunt is throwing a bunch of warnings about deprecated things Foundation does. 

## Dependencies
This application works thanks to the following projects:
 - [Sails.JS](http://sailsjs.org)
 - [Foundation](http://foundation.zurb.com/)
 - [socket.io](http://socket.io/)
 - [Jade](http://jade-lang.com/)

## Note of thanks
Many thanks to everyone who contributed to the project.

## Copyright
This projected is licensed under the terms of the GPL v3 license. Please consult the license file for further information.

Copyright © 2014 Robin Bühler