class ApplicationController < ActionController::Base
  def index
    @songs = Song.all
  end
end
