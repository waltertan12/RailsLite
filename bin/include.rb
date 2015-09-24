require_relative '../config/root_path'

def require_all_files
  folders = [
    "lib",
    "app/controllers",
    "app/models",
    "config"
  ]

  included_files = []

  folders.each do |folder|
    Dir.glob(folder + "/*.rb").each do |file|
      next if included_files.include?("./" + file)

      require "./" + file
      included_files << file
    end
  end
end

require_all_files