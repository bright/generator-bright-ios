'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('Bright iOS:app', function () {
    before(function (done) {
        helpers.run(path.join(__dirname, '../app'))
            .withOptions({skipInstall: true})
            .withPrompts({projectName: 'Testy'})
            .on('end', done);
    });

    it('creates files', function () {
        assert.file([
            'Testy/src/AppDelegate.swift',
            'Testy/src/Info.plist',
            'Testy/src/ViewController.swift',

            'Testy/Testy.gyp',

            'Testy/Gemfile',
            'Testy/Podfile',

            'Testy/.gitignore'
        ]);
    });

    it('replaces text', function () {
        assert.fileContent('Testy/Testy.gyp', /"target_name": "Testy",/);
    });
});