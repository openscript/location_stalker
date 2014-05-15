/**
 * Routes
 *
 * Your routes map URLs to views and controllers.
 * 
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.) 
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg` 
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `config/404.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or 
 * CoffeeScript for the front-end.
 *
 * For more information on routes, check out:
 * http://sailsjs.org/#documentation
 */

module.exports.routes = {

  '/': {
    view: 'start'
  },

  // map routes
  'get /map/:id': {
    controller: 'map',
    action: 'view'
  },

  'post /map/:key': {
    controller: 'map',
    action: 'add',
    cors: true
  },

  '/map/collection/:id': {
    controller: 'map',
    action: 'collection'
  },

  '/map/session/:id': {
    controller: 'map',
    action: 'session'
  },

  // session routes
  'post /session/generate': {
    controller: 'session',
    action: 'generate',
    cors: true
  },

  'post /session': {
    controller: 'session',
    action: 'create',
    cors: true
  },

  // other routes
  '/setting/local': {
    controller: 'setting',
    action: 'local'
  },
};
