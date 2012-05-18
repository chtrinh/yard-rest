module YARD::Rest
  class Routes 
    class << self
      def with_resource_links(resources)
        all_routes = Rails.application.routes.routes # Journey::Routes object
        all_routes.to_a.map do |route|
          {:verb => verb(route), :path => path(route), :link_object => resource(route, resources)}
        end
        all_routes.reject { |route_hash| route_hash[:link_object].nil? }
      end

      def resource(route, resources)
        if controller_name = route.requirements[:controller]
          controller_class =  "#{controller_name}_controller".classify
        
          resources.find { |object| object.path == controller_class }
        end
      end

      # The following implementation is dervied from Rails::Applicaiton::RouteWrapper
      def verb(route)
        route.verb.source.gsub(/[$^]/, '')
      end

      def path(route)
        route.path.spec.to_s
      end
    end
  end
end