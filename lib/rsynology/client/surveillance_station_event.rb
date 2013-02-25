module RSynology
  class Client
    class SurveillanceStationEvent < API

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

        request("Query", merged_params)
      end
    end
  end
end
