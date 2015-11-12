require "picasa/api/base"

module Picasa
  module API
    class Photo < Base
      # Creates photo for given album
      #
      # @param [String] album_id album id
      # @param [Hash] options request parameters
      # @option options [String] :file_path path to photo file, rest of required attributes might be guessed based on file (i.e. "/home/john/Images/me.png")
      # @option options [String] :title title of photo
      # @option options [String] :summary summary of photo
      # @option options [String] :binary binary data (i.e. File.open("my-photo.png", "rb").read)
      # @option options [String] :content_type ["image/jpeg", "image/png", "image/bmp", "image/gif"] content type of given image
      def create(album_id, params = {})
        file = params[:file_path] ? File.new(params.delete(:file_path)) : File::Null.new
        params[:boundary]     ||= "===============PicasaRubyGem=="
        params[:title]        ||= file.name || raise(ArgumentError.new("title must be specified"))
        params[:binary]       ||= file.binary || raise(ArgumentError.new("binary must be specified"))
        params[:content_type] ||= file.content_type || raise(ArgumentError.new("content_type must be specified"))

        template = Template.new(:new_photo, params)
        headers = auth_header.merge({"Content-Type" => "multipart/related; boundary=\"#{params[:boundary]}\""})

        path = user_api_path + "/albumid/#{album_id}"
        response = Connection.new.post(path: path, body: template.render, headers: headers)

        Presenter::Photo.new(response.parsed_response["entry"])
      end

      # Updates metadata for photo
      #
      # @param [String] album_id album id
      # @param [String] photo_id photo id
      # @param [Hash] options request parameters
      # @option options [String] :album_id album id that photo will be moved to
      # @option options [String] :title title of photo
      # @option options [String] :summary summary of photo
      # @option options [String] :timestamp timestamp of photo
      # @option options [String] :keywords
      # @option options [String] :etag updates only when ETag matches - protects before destroying other client changes
      #
      # @return [Presenter::Photo] the updated photo
      def update(album_id, photo_id, params = {})
        template = Template.new(:update_photo, params)
        headers = auth_header.merge({"Content-Type" => "application/xml",
                                     "If-Match" => params.fetch(:etag, "*")})

        if params.has_key?(:timestamp)
          params[:timestamp] = params[:timestamp].to_i * 1000
        end
        path = user_api_path + "/albumid/#{album_id}/photoid/#{photo_id}"
        response = Connection.new.patch(path: path, body: template.render, headers: headers)

        Presenter::Photo.new(response.parsed_response["entry"])
      end

      # Destroys given photo
      #
      # @param [String] album_id album id
      # @param [String] photo_id photo id
      # @param [Hash] options request parameters
      # @option options [String] :etag destroys only when ETag matches - protects before destroying other client changes
      #
      # @return [true]
      # @raise [NotFoundError] raised when album or photo cannot be found
      # @raise [PreconditionFailedError] raised when ETag does not match
      def destroy(album_id, photo_id, options = {})
        headers = auth_header.merge({"If-Match" => options.fetch(:etag, "*")})
        path = user_api_path + "/albumid/#{album_id}/photoid/#{photo_id}"
        Connection.new.delete(path: path, headers: headers)
        true
      end
      alias :delete :destroy

      # Gets given photo
      #
      # @param [String] album_id album id
      # @param [String] photo_id photo id
      # @param [Hash] options request parameters
      # @option options [String] :etag destroys only when ETag matches - protects before destroying other client changes
      #
      # @return [Presenter::Photo] the photo
      # @raise [NotFoundError] raised when album or photo cannot be found
      # @raise [PreconditionFailedError] raised when ETag does not match
      def destroy(album_id, photo_id, options = {})
        headers = auth_header.merge({"If-Match" => options.fetch(:etag, "*")})
        path = user_api_path + "/albumid/#{album_id}/photoid/#{photo_id}"
        response = Connection.new.get(path: path, headers: headers)

        Presenter::Photo.new(response.parsed_response["entry"])
      end
    end
  end
end
