class Song < ApplicationRecord
  belongs_to :album
  has_many :playlistinfos

  paginates_per 10
  searchkick
  def liked(status)
    self.like = status ? like - 1 : like + 1
    save!
  end
end
