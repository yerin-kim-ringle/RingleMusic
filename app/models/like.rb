# frozen_string_literal: true

class Like < ApplicationRecord
  def new_liked
    Like.create(user_id: current_user.id, song_id: params[:song_id], status: 1)
  end
  def liked
    self.status = !status
    save!
  end
end
