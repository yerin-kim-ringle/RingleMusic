class Album < ApplicationRecord
  has_many :songs
  searchkick
end
