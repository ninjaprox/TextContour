'use strict';

const exec = require('child_process').execSync;
const ios = require('./contours-ios.json');
const web = require('./contours-web.json');
const fs = require('fs');

var offsets = {};

for (let font in web) {
    const offset = {
        x: web[font].x - ios[font].x,
        y: web[font].y - ios[font].y
    };

    offsets[font] = offset;
}

fs.writeFile('offsets.json', JSON.stringify(offsets));
