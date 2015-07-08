'use strict';

var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');
var glob = require('glob');

module.exports = yeoman.generators.Base.extend({
  initializing: function () {
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the Bright ' + chalk.red('iOS Project') + ' generator!'
    ));

    var prompts = [
      {
        type: "checkbox",
        message: "Cocoapods",
        name: "cocoapods",
        store: true,
        choices: [
          {
            name: "AFNetworking"
          },
          {
            name: "CocoaLumberjack"
          },
          {
            name: "MBProgressHUD"
          },
          {
            name: "SDWebImage"
          },
          {
            name: "ReactiveCocoa"
          },
          {
            name: "Mantle"
          },
          {
            name: "PureLayout"
          },
          {
            name: "Overcoat"
          }
        ]
      },
      {
        type: 'input',
        name: 'projectName',
        message: 'Project',
        default: 'Hola'
      },
      {
        type: 'input',
        name: 'companyName',
        message: 'Company',
        default: 'Bright Inventions'
      },
      {
        type: 'input',
        name: 'reverseDomain',
        message: 'Reverse Domain',
        default: 'pl.brightinventions'
      }
    ];

    this.prompt(prompts, function (props) {
      this.props = props;
      // To access props later use this.props.someOption;

      done();
    }.bind(this));
  },

  writing: {
    app: function () {
      console.log(this.templatePaths);

      function endsWith(str, suffix) {
        return str.indexOf(suffix, str.length - suffix.length) !== -1;
      }

      var tp = this.templatePath('ios');

      var files = glob.sync(tp + '/**', {nodir: true, dot: true});

      files.forEach(function (file) {
        //console.dir(file);
        if (endsWith(file, "apple.cer") || endsWith(file, "mpParse") || endsWith(file, ".png")) {
          //console.log("ignoring");
          var source = file.slice(tp.length + 1);
          var destination = this.props.projectName + '/' + source.replace(/ProjectName/g, this.props.projectName);
          this.fs.copy(tp + '/' + source, this.destinationPath(destination));

          return;
        }

        var source = file.slice(tp.length + 1);
        var destination = this.props.projectName + '/' + source.replace(/ProjectName/g, this.props.projectName);
        this.props.originalKeychainsHack1 = '${ORIGINAL_KEYCHAINS//\\"/}';
        this.props.originalKeychainsHack2 = '${ORIGINAL_KEYCHAINS//$\'\\n\'/}';

        this.fs.copyTpl(
          tp + '/' + source,
          this.destinationPath(destination),
          this.props
        );

      }, this);

    }
  },

  install: function () {

//        curl -k -X POST --user user:pass "https://api.bitbucket.org/1.0/repositories" -d "name=project_name"

  }
});