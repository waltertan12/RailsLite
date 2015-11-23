require 'tilt'

class ScssAssets
  @@styles = nil

  def self.render_styles
    unless @@styles
      @@styles = ""

      Dir.glob("#{ROOT_PATH}app/assets/stylesheets/*.scss").each do |file|
        @@styles += Tilt::ScssTemplate.new(file).render
      end
    end

    @@styles
  end

  def initialize
    @scss_templates = Dir.glob("#{ROOT_PATH}app/assets/stylesheets/*.scss").map do |file|
      p file
      m = Tilt::ScssTemplate.new(file)
    end
  end

  def serve
    style = ""

    @scss_templates.each do |template|
      style += template.render
    end

    style
  end
end