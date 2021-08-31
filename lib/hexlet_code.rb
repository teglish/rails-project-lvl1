# frozen_string_literal: true

require 'hexlet_code/version'

# module HexletCode
module HexletCode
  class Error < StandardError; end

  def self.form_for(user, url: '#', &block)
    form = Form.new user
    block.call form if block_given?
    Tag.build('form', line_break: true, action: url, method: 'post') { form.get }
  end

  # class for form generation
  class Form
    def initialize(user)
      @user = user
      @form = []
    end

    def input(name, **kwargs)
      raise "#{name} doesn't exist in #{@user}" unless @user.respond_to? name

      case kwargs.delete(:as)
      when :text
        @form << as_text(name)
      when :select
        @form << as_select(name, kwargs)
      when nil
        @form << add_label(name)
        @form << Tag.build('input', type: 'text', value: @user.send(name), name: name)
      end
    end

    def submit(*_)
      @form << Tag.build('input', type: 'submit', value: 'Save', name: 'commit')
    end

    def get
      @form.map { |tag| tag.each_line.map { |line| (tab + line).chomp("\n") } }.flatten.join("\n")
    end

    def as_text(name)
      Tag.build('textarea', cols: '20', rows: '40', name: name) { @user.send(name) }
    end

    def as_select(name, args)
      Tag.build('select', line_break: true, name: name) do
        args[:collection].each_with_index.map do |arg, i|
          tab + Tag.build('option', i.zero? ? 'selected' : nil, value: arg) { arg }
        end.join("\n")
      end
    end

    def add_label(name)
      Tag.build('label', for: name) { name[0].upcase + name[1..-1] }
    end

    def tab
      '  '
    end
  end

  # Class for work with html tag
  class Tag
    def self.build(tag, *single, line_break: false, **pairs, &body)
      string_from_block = block_given? ? body.call.to_s : ''
      result = get_first_tag(tag, single, pairs, line_break: line_break) + string_from_block
      result += "\n" if line_break && !string_from_block.empty?
      result += get_close_tag(tag) if line_break || !string_from_block.empty?
      result
    end

    def self.get_first_tag(tag, single, pairs, line_break: false)
      result = ([tag] + pairs
        .reject { |_, v| v.to_s.empty? }
        .map { |k, v| "#{k}=\"#{v}\"" } + single.compact).join(' ')
      result = "<#{result}>"
      result += "\n" if line_break
      result
    end

    def self.get_close_tag(tag)
      "</#{tag}>"
    end
  end
end
