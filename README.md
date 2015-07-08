# generator-ios

Until we reach some stable state please be understanding and use these commands to set up the generator:


1. Install GYP:

```
brew tap mgamer/homebrew-taps
brew install gyp
```

In case `brew install gyp` fails please reinstall python using brew (`brew install python`).

2. Make sure you have npm and yeoman installed and that command `yo` works from your terminal.

3. Clone this repository. Execute `npm link` in the directory of the cloned repository.

4. You can now generate iOS project by executing `yo ios` (from any directory of your choosing).

In the newly generated project directory you can do this:
`make all` - build XCode project
`make clean` - cleans everything

`fastlane once` - downloads certificate and provisioning profile and puts it into the repository

`fastlane build` - build the app

Please email me at michal.lukasiewicz@brightinventions.pl or create issue here with all support requests. I'll be delighted to help you out.


