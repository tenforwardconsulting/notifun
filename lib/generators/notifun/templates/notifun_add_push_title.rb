class NotifunAddPushTitle < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :notifun_message_templates, :push_title, :text
    add_column :notifun_messages, :message_title, :text
    add_column :notifun_messages, :error_message, :text
    add_column :notifun_messages, :data, :jsonb, null: false, default: {}
  end
end
