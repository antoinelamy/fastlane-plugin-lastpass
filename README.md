# LastPass plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-lastpass)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-lastpass`, add it to your project by running:

```bash
fastlane add_plugin lastpass
```

## About the LastPass plugin

Easily sync your Apple ID credentials stored in LastPass with your keychain. This action may require user input if two factor authentication is enabled for the account you're logging in with.

### Step 1
Find out the id for the crendentials you wish to sync. You can do so by executing the `lastpass` action with the list option enabled.
```
fastlane run lastpass username:"user@test.com" password:"mysuperpassword" list:true
```

### Step 2
Create a file named `lastpass.yaml` containing the ids of your vault items.
```
vault-items:
- "5576281234514771203"
- "3942334544195479218"
```

### Step 3
Use the fastlane `lastpass` action standalone or as part of a lane. If you are using it on CI system, you probably don't want to have an account with two factor authentication enabled since it requires manual text entry during execution.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```
desc "Sync LastPass credentials with the local keychain"
lane :syncCredentials do
    lastpass(username: "user@test.com", password: "mysuperpassword", overwrite: true)
end
```

## Available parameters

| Parameter        | Description           | Optional (default value)  |
| ------------- |-------------| -----:|
| username      | Your LastPass username | _Required_ |
| password      | Your LastPass password      |   _Required_ |
| overwirte | In case the passwords don't match, should the existing passwords be replaced      | _Optional_ (false) |
| list | List available credentials in the account, do not modify the keychain      | _Optional_ (false) |

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Credits

This plugin use the  [LastPass](https://github.com/detunized/lastpass-ruby) ruby gem by Dmitry Yakimenko

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
