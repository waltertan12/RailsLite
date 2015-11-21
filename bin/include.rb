require_relative '../config/root_path'
require 'set'

def require_all_files
  folders = [
    "action_view/lib",
    "active_record/lib",
    "app/controllers",
    "app/models",
    "config"
  ]

  included_files = Set.new

  folders.each do |folder|
    Dir.glob(folder + "/*.rb").each do |file|
      require "./" + file if included_files.add?("./" + file)
    end
  end
end


require_all_files