require_relative './phase6/controller_base'
require_relative './flash'

module Bonus
  class ControllerBase < Phase6::ControllerBase
    def flash
      @flash ||= Flash.new(req)
    end

    def redirect_to(url)
      flash.store_flash(res)
      super(url)
    end
  end
end