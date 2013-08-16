require "rubygems"
require 'compass'
require 'ruby_gntp'


module CompassGrowl
  ICON = File.join(File.expand_path('../../', __FILE__), 'assets', 'compass_icon.png')
  GROWL = GNTP.new("Compass", "127.0.0.1")

  LOADED = "Compass Growl Loaded"
  STYLESHEET_SAVED = "Stylesheet Saved"
  STYLESHEET_ERROR = "Stylesheet Error"
  SPRITE_SAVED = "Sprite Saved"
  GROWL.register({:notifications => [{ :name => LOADED, :enabled => true },
                  { :name => STYLESHEET_SAVED, :enabled => true },
                  { :name => SPRITE_SAVED, :enabled => true },
                  { :name => STYLESHEET_ERROR, :enabled => true }]
  })

  def growl(type, title, message, sticky = false)
    GROWL.notify({
    :name => type,
    :title =>  title,
    :text => message,
    :icon => ICON,
    :sticky => sticky
    })
  end

  def init
    CompassGrowl.growl(LOADED, "Init", "Compass Growl has been initialized")

    config = Compass.configuration

    config.on_stylesheet_saved do |filename|
      CompassGrowl.growl(STYLESHEET_SAVED, "Stylesheet", "#{File.basename(filename)} saved")
    end

    config.on_sprite_saved do |filename|
      CompassGrowl.growl(SPRITE_SAVED, "Sprite", "#{File.basename(filename)} saved")
    end

    config.on_stylesheet_error do |filename, error|
      CompassGrowl.growl(STYLESHEET_ERROR, "Stylesheet Error", "#{File.basename(filename)} had the following error:\n #{error}", true)
    end

  end

  extend self

end

CompassGrowl.init

