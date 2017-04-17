class Notifun::Engine < Rails::Engine
  initializer 'notifun.engine', :group => :all do |app|
    app.config.assets.paths << root.join('assets', 'stylesheets')
  end
end
