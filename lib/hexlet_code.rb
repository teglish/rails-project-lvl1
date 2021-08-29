# frozen_string_literal: true

require 'hexlet_code/version'

# module HexletCode
module HexletCode
  class Error < StandardError; end

  def self.form_for(_, url: '#', &_)
    "<form action=\"#{url}\" method=\"post\">\n</form>"
  end

  # Class for work with html tag
  class Tag
    def self.build(tag, **kwargs, &block)
      result = ([tag] + kwargs.map { |k, v| "#{k}=\"#{v}\"" }).join(' ')
      result = "<#{result}>"
      result = "#{result}#{block.call}</#{tag}>" if block_given?

      result
    end
  end
end
