module.exports = function(grunt) {
    grunt.config.set('bower', {
        dev: {
            dest: '.tmp/public',
            js_dest: '.tmp/public/scripts',
            css_dest: '.tmp/public/styles'
        }
    });

    grunt.loadNpmTasks('grunt-bower');
};
