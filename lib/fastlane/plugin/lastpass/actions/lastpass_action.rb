require 'fastlane/action'
require_relative '../helper/lastpass_helper'

module Fastlane
    module Actions
        class LastpassAction < Action
            def self.run(params)
                require 'lastpass.rb'
                require 'yaml'
                require 'credentials_manager'

                begin
                  unless params[:list]
                    credentials = YAML.load_file "lastpass.yaml"
                    vault_items = credentials["vault-items"]
                  end
                
                  begin
                      vault = LastPass::Vault.open_remote params[:username], params[:password]
                  rescue LastPass::LastPassIncorrectGoogleAuthenticatorCodeError => e
                      multifactor_password = other_action.prompt(text: "Enter Google Authenticator code: ")
                      vault = LastPass::Vault.open_remote params[:username], params[:password], multifactor_password
                  rescue LastPass::LastPassIncorrectYubikeyPasswordError => e
                      multifactor_password = other_action.prompt(text: "Enter Yubikey password: ")
                      vault = LastPass::Vault.open_remote params[:username], params[:password], multifactor_password
                  end
                  
                  if params[:list]
                    puts "Account id          | Account name"
                    puts "-----------------------------------------"
                  end

                  vault.accounts.each_with_index do |account, index|
                      if params[:list]
                        puts "#{account.id} | #{account.name}"
                      else
                        if vault_items.include? account.id
                            UI.message("Adding account \"#{account.name} (#{account.id})\" to keychain")

                            account_manager = CredentialsManager::AccountManager.new(user: account.username)
                            existingPassword = account_manager.password(ask_if_missing: false)

                            if existingPassword != account.password && existingPassword != nil
                                if params[:overwrite]
                                    account_manager = CredentialsManager::AccountManager.new(user: account.username)
                                    account_manager.remove_from_keychain

                                    account_manager = CredentialsManager::AccountManager.new(user: account.username, password: account.password)
                                    account_manager.add_to_keychain
                                    UI.success("Account successfully overwrited with updated credentials")
                                else
                                    UI.important("Account is already in the keychain with a different password, use force option to overwrite")
                                end
                            else
                                if existingPassword == nil
                                    account_manager = CredentialsManager::AccountManager.new(user: account.username, password: account.password)
                                    account_manager.add_to_keychain
                                    UI.success("Account successfully added to keychain")
                                else
                                    UI.success("Account is already in the keychain, skipping")
                                end
                            end
                        end
                      end
                  end; nil
                rescue Errno::ENOENT
                  UI.error("No lastpass.yaml file found, read the Readme to get started. Aborting...")
                end
            end

            def self.description
                "Easily sync your Apple ID credentials stored in LastPass with your keychain using CredentialManager"
            end

            def self.authors
                ["Antoine Lamy"]
            end

            def self.available_options
                [
                FastlaneCore::ConfigItem.new(key: :username,
                                             env_name: "LASTPASS_USERNAME",
                                             description: "Your LastPass username",
                                             optional: false,
                                             type: String),
                FastlaneCore::ConfigItem.new(key: :password,
                                             env_name: "LASTPASS_PASSWORD",
                                             description: "Your LastPass password",
                                             optional: false,
                                             type: String,
                                             sensitive: true),
                FastlaneCore::ConfigItem.new(key: :overwrite,
                                             env_name: "LASTPASS_OVERWRITE",
                                             description: "In case the passwords don't match, should the existing passwords be replaced",
                                             default_value: false,
                                             optional: true,
                                             type: Boolean,
                                             sensitive: true),
                FastlaneCore::ConfigItem.new(key: :list,
                                             env_name: "LASTPASS_LIST",
                                             description: "List available credentials in the account, do not modify the keychain",
                                             default_value: false,
                                             optional: true,
                                             type: Boolean,
                                             sensitive: false)
                ]
            end

            def self.is_supported?(platform)
                [:ios, :mac, :android].include?(platform)
            end
        end
    end
end
