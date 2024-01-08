# frozen_string_literal: true

require 'app/models/swipe'
require 'app/models/match'
require 'app/models/user'

module SwipeService
  class Create < BaseService
    def record_swipe_action(swiper_id:, swiped_id:, direction:)
      swiper = User.find_by(id: swiper_id)
      swiped = User.find_by(id: swiped_id)

      return { swipe_recorded: false, match_created: false } unless swiper && swiped

      swipe = Swipe.create(
        user_id: swiper_id,
        swiped_id: swiped_id,
        direction: direction,
        created_at: DateTime.current
      )

      reciprocal_swipe = Swipe.find_by(
        user_id: swiped_id,
        swiped_id: swiper_id,
        direction: 'right'
      )

      match_created = false
      if reciprocal_swipe && direction == 'right'
        Match.create(
          user_id: swiper_id,
          swiped_id: swiped_id,
          created_at: DateTime.current
        )
        match_created = true
      end

      { swipe_recorded: swipe.persisted?, match_created: match_created }
    end
  end
end
