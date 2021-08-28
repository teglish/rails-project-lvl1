# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/hexlet_code'

class GeneratorTest < Minitest::Test
  def test_tag
    assert_equal HexletCode::Tag.build('br'), '<br>'
    assert_equal HexletCode::Tag.build('img', src: 'path/to/image'), '<img src="path/to/image">'
    assert_equal HexletCode::Tag.build('input', type: 'submit', value: 'Save'), '<input type="submit" value="Save">'
    assert_equal HexletCode::Tag.build('label') { 'Email' }, '<label>Email</label>'
    assert_equal HexletCode::Tag.build('label', for: 'email') { 'Email' }, '<label for="email">Email</label>'
  end
end
