class Song < ApplicationRecord
  belongs_to :album
  has_many :playlistinfos

  paginates_per 10
end
