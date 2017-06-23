# frozen_string_literal: true

# Module de API
module Api
  # Controller de API
  class ApisController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate?

    def all_rooms
      @rooms = Room.all
      render json: @rooms
    end

    def buildings
      building = Building.find(params[:id])
      rooms = Room.where('building' => building.id)
      allocation = Allocation.where('room' => rooms.ids)
      @building_allocation = generate_return_building(building, allocation)
      render json: @building_allocation
    end

    def generate_return_building(building, allocations)
      hash = {}
      allocations.each do |allocation|
        hash[allocation.id] = {
          building_name: building.name,
          building_code: building.code,
          room_name: allocation.room.name,
          room_capacity: allocation.room.capacity,
          discipline_name: allocation.school_room.discipline.name,
          discipline_code: allocation.school_room.discipline.code,
          school_room_name: allocation.school_room.name,
          school_room_vacancies: allocation.school_room.vacancies,
          allocation_day: allocation.day,
          allocation_start_time: allocation.start_time.strftime('%H:%M'),
          allocation_final_time: allocation.final_time.strftime('%H:%M')
        }
      end
      hash
    end

    private

    def authenticate?
      authenticate_or_request_with_http_token do |token, _options|
        decoded_token = JWT.decode token, nil, false
        email = decoded_token[0]['email']
        user = ApiUser.find_by(email: email)
        unless user.nil?
          ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(token),
            ::Digest::SHA256.hexdigest(user.token)
          )
        end
      end
    end
  end
end
