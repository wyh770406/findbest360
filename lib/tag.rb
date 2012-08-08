module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        @template.params.delete_if{|key, value| key == "authenticity_token"||key == "utf8"||key == "commit" }
        puts @template.params
        @template.url_for @template.params.merge(@param_name => (page < 1 ? nil : page))
      end
    end
  end
end
