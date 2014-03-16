# -*- encoding: utf-8 -*-
require "helper"

describe Picasa::API::Base do
  before do
    @user_id = 'foo.bar'
    @base = Picasa::API::Base.new(:user_id => @user_id)
  end

  it "provides default api user_api_path" do
    assert_equal "/data/feed/api/user/#{@user_id}", @base.user_api_path
  end

  it "provides back_compat user_api_path" do
    Picasa::API::Base.back_compat = true
    assert_equal "/data/feed/back_compat/user/#{@user_id}", @base.user_api_path

    Picasa::API::Base.back_compat = false
    assert_equal "/data/feed/api/user/#{@user_id}", @base.user_api_path
  end

  after do
    Picasa::API::Base.back_compat = false
  end
end
