require 'hashie/trash'

module RSynology
  class Client
    class SurveillanceStationEvent < API

      class Event < Hashie::Trash
        TIME_TRANSFORM = lambda { |epoch| Time.at(epoch) }
        property :id
        property :camera_id, from: :cameraId
        property :event_size, from: :eventSize
        property :frame_count, from: :frameCount
        property :mode
        property :start_time, from: :startTime, with: TIME_TRANSFORM
        property :stop_time, from: :stopTime, with: TIME_TRANSFORM
        property :status
        property :video_codec, from: :videoCodec
        property :owner_id, from: :ownerDsId

        def duration
          stop_time - start_time
        end
      end

      def self.api_name
        'SYNO.SurveillanceStation.Event'
      end

      def query(params = {})
        default_params = {
          offset: 0,
          limit: 10,
          mode: nil,
          locked: nil,
          camera_ids: nil,
          from_time: nil,
          to_time: nil
        }

        merged_params = default_params.merge(params).reject do |k, v|
          v.nil?
        end

        resp = request("Query", merged_params)
        event_collection = handle_response(resp)
        event_collection['events'].map! { |event_data| Event.new(event_data) }
        event_collection
      end
    end
  end
end
