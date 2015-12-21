require 'tilt'

class AssetPipeline
  @@styles = nil

  def self.read_manifest(folders = [["javascripts","js"], ["stylesheets","css"]])
    regex = Regexp.new("\/\/=\srequire\s(?<file>\\w+)(?<ext>\.css|\.scss|\.jsx|\.js)?")

    assets = ""

    folders.each do |folder|
      manifest = "./app/assets/#{folder.first}/application.#{folder.last}"
      
      File.open(manifest).each_line do |line|
        m = regex.match(line)

        if m && m[:ext] 
          case folder.first
          when "javascripts"
            if m[:ext] == ".jsx"
              mime = "type='text/babel'"
            else
              mime = ""
            end
            
            assets += "<script #{mime} src='/assets/javascripts/" + 
                      "#{m[:file]}#{m[:ext]}'></script>\n"
          when "stylesheets"
            assets += "<link rel='stylesheet' href='/assets/stylesheets/" + 
                      "#{m[:file]}#{m[:ext]}'>\n"
          end
        elsif m && m[:file]# matches a folder
          assets += AssetPipeline.pipeline(["#{folder.first}/#{m[:file]}"])
        end
      end
    end

    assets
  end

  def self.pipeline(folders = ["javascripts", "stylesheets", "images"])
    result = ""

    folders.each do |folder|
      files = Dir.glob("./app/assets/#{folder}/**.{js,css,scss,jsx}")

      files.each do |file|
        if file.match(/(jsx|js)/)
          result += "<script src='#{file[5..-1]}'></script>\n"
        elsif file.match(/(css|scss)/)
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