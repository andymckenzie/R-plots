#!/usr/bin/env node
//from coursera startup engineering 
var fs = require('fs');
var outfile = "hello.txt";
var out = "Test whether this works.\n";
fs.writeFileSync(outfile, out);
// __filename is a variable with the pathto the current file
console.log("Script: " + __filename + "\nWrote: " + out + "To: " + outfile);