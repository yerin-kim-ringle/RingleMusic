class Song < ApplicationRecord
  belongs_to :album
  has_many :playlistinfos
end
