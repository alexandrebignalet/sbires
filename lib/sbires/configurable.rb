module Sbires
  module Configurable

    def config
      @config ||= ::Sbires::Configuration.new
    end

    def configure
      yield config if block_given?
    end

  end
end