fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios beta_diawi
```
fastlane ios beta_diawi
```
Mandatory for use in circle-ci

Description of what the lane does
### ios beta_testflight
```
fastlane ios beta_testflight
```
Upload to TestFlight
### ios prepare_release
```
fastlane ios prepare_release
```
Prepare version

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
