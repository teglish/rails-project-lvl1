require "hexlet_code/version"

module HexletCode
  class Error < StandardError; end
  class Tag
    def self.build(tag, **kwargs, &block)
      result = ([tag] + kwargs.map { |k, v| "#{k}=\"#{v}\"" }).join(' ')
      result = "<#{result}>"
      result = "#{result}#{block.call}</#{tag}>" if block_given?

      result
    end
  end
end
