class NotifunCreateTables < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :notifun_message_templates do |t|
      t.string :key
      t.string :models, array: true, default: [], null: false
      t.text :description
      t.string :category
      t.string :default_notification_methods, array: true, default: [], null: false
      t.string :backup_notification_methods, array: true, default: [], null: false
      t.jsonb :merge_fields, null: false, default: {}
      t.text :push_title
      t.text :push_body
      t.text :text_body
      t.string :email_subject
      t.text :email_html
      t.text :email_text
      t.boolean :preferences, default: false, null: false
      t.boolean :editable, default: true, null: false

      t.timestamps
    end

    create_table :notifun_messages do |t|
      t.string :message_template_key
      t.string :uuid
      t.string :recipient
      t.string :notification_method
      t.text :message_title
      t.text :message_text
      t.jsonb :data, null: false, default: {}
      t.boolean :success, default: false, null: false
      t.text :error_message

      t.timestamps
    end

    create_table :notifun_preferences do |t|
      t.references :preferable, polymorphic: true
      t.string :message_template_key
      t.string :category
      t.boolean :email, default: false, null: false
      t.boolean :push, default: false, null: false
      t.boolean :text, default: false, null: false

      t.timestamps
    end
  end
end
