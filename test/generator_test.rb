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

  def test_form_for_base
    user_struct = Struct.new(:name, :job, :gender, keyword_init: true)
    user = user_struct.new name: 'rob'
    form = HexletCode.form_for user do |f|
    end

    assert_equal form, "<form action=\"#\" method=\"post\">\n</form>"

    form = HexletCode.form_for user, url: '/users' do |f|
    end

    assert_equal form, "<form action=\"/users\" method=\"post\">\n</form>"
  end

  def test_form_for_pro
    user_struct = Struct.new(:name, :job, :gender, keyword_init: true)
    user = user_struct.new name: 'rob', job: 'hexlet', gender: 'm'
    form = HexletCode.form_for user do |f|
      f.input :name
      f.input :job, as: :text
      f.input :gender, as: :select, collection: %w[m f]
    end

    assert_equal form, form_for_pro_text
  end

  def test_form_for_pro2
    user_struct = Struct.new(:name, :job, keyword_init: true)
    user = user_struct.new job: 'hexlet'
    form = HexletCode.form_for user do |f|
      f.input :name
      f.input :job
      f.submit
    end

    assert_equal form, form_for_pro2_text
  end

  def form_for_pro_text
    '<form action="#" method="post">
  <label for="name">Name</label>
  <input type="text" value="rob" name="name">
  <textarea cols="20" rows="40" name="job">hexlet</textarea>
  <select name="gender">
    <option value="m" selected>m</option>
    <option value="f">f</option>
  </select>
</form>'
  end

  def form_for_pro2_text
    '<form action="#" method="post">
  <label for="name">Name</label>
  <input type="text" name="name">
  <label for="job">Job</label>
  <input type="text" value="hexlet" name="job">
  <input type="submit" value="Save" name="commit">
</form>'
  end
end
