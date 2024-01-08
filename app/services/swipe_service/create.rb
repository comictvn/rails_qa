# frozen_string_literal: true

require_relative '../../models/match'
require 'app/models/user'

module SwipeService
  class Create < BaseService
    def record_swipe_action(swiper_id:, swiped_id:, direction:)
      swiper = User.find(swiper_id)
      swiped = User.find(swiped_id)

      return { swipe_recorded: false, match_created: false } unless swiper && swiped

      swipe = Swipe.create(
        user_id: swiper_id,
        swiped_id: swiped_id,
        direction: direction,
        created_at: Time.zone.now
      )

      reciprocal_swipe = Swipe.find_by(
        user_id: swiped_id,
        swiped_id: swiper_id,
        direction: 'right'
      )

      match_created = false
      if reciprocal_swipe && swipe.direction_right?
        Match.create(
          user_id: swiper_id,
          swiped_id: swiped_id,
          created_at: DateTime.current
        )
        match_created = true
      end

      begin
        swipe.save!
        { swipe_recorded: swipe.persisted?, match_created: match_created }
      rescue ActiveRecord::RecordInvalid => e
        logger.error "SwipeService::Create: #{e.message}"
        { swipe_recorded: false, match_created: false }
      end
    end
  end
end
