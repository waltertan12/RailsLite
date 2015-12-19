require 'byebug'
class AssetsController < ControllerBase
  def show
    render_asset(params)
  end
end