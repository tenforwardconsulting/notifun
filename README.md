# Notifun

To install run: `rails g notifun:install`

This will generate three things:
The config initializer at `config/initializers/notifun.rb`.
The migration to create the notifun tables.
The json file for loading message templates at `config/notifun_templates.json`.


Once installed, edit `config/notifun_templates.json` to add your message templates.
You can edit them at `/notifun/message_templates`.
You can see the generated messages at `/notifun/messages`.
Users can edit their preferences at `/notifun/preferences`.

`rails g notifun:install` can also be used to install missing fields after updates.
