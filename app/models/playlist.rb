class Playlist < ApplicationRecord
  enum p_type: { user_type: 0, group_type:1}
end
