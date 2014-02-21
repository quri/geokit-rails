module Geokit
  module Adapters
    class PostgreSQL < Abstract

      def sphere_distance_sql(lat, lng, multiplier)
        %|
          CASE WHEN #{qualified_lat_column_name} IS NULL OR #{qualified_lng_column_name} IS NULL
          THEN
            NULL
          ELSE
            (ACOS(least(1,COS(#{lat})*COS(#{lng})*COS(RADIANS(#{qualified_lat_column_name}))*COS(RADIANS(#{qualified_lng_column_name}))+
            COS(#{lat})*SIN(#{lng})*COS(RADIANS(#{qualified_lat_column_name}))*SIN(RADIANS(#{qualified_lng_column_name}))+
            SIN(#{lat})*SIN(RADIANS(#{qualified_lat_column_name}))))*#{multiplier})
          END
         |
      end

      def flat_distance_sql(origin, lat_degree_units, lng_degree_units)
        %|
          CASE WHEN #{qualified_lat_column_name} IS NULL OR #{qualified_lng_column_name} IS NULL
          THEN
            NULL
          ELSE
            #{lat} IS NOT NULL AND
            #{lng} IS NOT NULL AND
            SQRT(POW(#{lat_degree_units}*(#{origin.lat}-#{qualified_lat_column_name}),2)+
            POW(#{lng_degree_units}*(#{origin.lng}-#{qualified_lng_column_name}),2))
          END
         |
      end

    end
  end
end