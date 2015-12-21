require 'tilt'

class AssetPipeline
  @@styles = nil

  def self.pipeline(folders = ["javascripts", "stylesheets", "images"])
    result = ""

    folders.each do |folder|
      files = Dir.glob("./app/assets/#{folder}/**.{js,css,scss,jsx}")
      files.each do |file|
        case folder
        when "javascripts"
          result += "<script src='#{file[5..-1]}'></script>\n"
        when "stylesheets"
          result += "<link rel='stylesheet' href='#{file[5..-1]}'>\n"
        end
      end
    end

    result
  end

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