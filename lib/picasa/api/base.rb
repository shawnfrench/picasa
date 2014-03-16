module Picasa
  module API
    class Base
      attr_reader :user_id, :authorization_header
      @@back_compat = false

      # @param [Hash] credentials
      # @option credentials [String] :user_id google username/email
      # @option credentials [String] :authorization_header header for authenticating requests
      def initialize(credentials = {})
        @user_id  = credentials.fetch(:user_id)
        @authorization_header = credentials[:authorization_header]
      end

      def auth_header
        {}.tap do |header|
          header["Authorization"] = authorization_header if authorization_header
        end
      end

      def user_api_path
        "/data/feed/#{Base.back_compat? ? 'back_compat' : 'api'}/user/#{user_id}"
      end

      def self.back_compat=(val)
        @@back_compat = !!val
      end

      def self.back_compat?
        @@back_compat
      end
    end
  end
end
