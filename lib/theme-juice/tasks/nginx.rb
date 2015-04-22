# encoding: UTF-8

module ThemeJuice
  module Tasks
    class Nginx < Task

      def initialize(opts = {})
        super
      end

      def execute
        create_nginx_file unless nginx_is_setup?
      end

      def unexecute
        remove_nginx_file
      end

      private

      def nginx_file
        "#{@project.location}/vvv-nginx.conf"
      end

      def nginx_is_setup?
        File.exist? nginx_file
      end

      def create_nginx_file
        @interact.log "Creating nginx file"
        @util.create_file nginx_file, { :verbose => @env.verbose, :pretend => @env.dryrun } do
%Q{server \{
  listen 80;
  server_name .#{@project.url};
  root {vm_path_to_folder};
  include /etc/nginx/nginx-wp-common.conf;
\}

}
        end
      end

      def remove_nginx_file
        @interact.log "Removing nginx file"
        @util.remove_file nginx_file, { :verbose => @env.verbose,
          :pretend => @env.dryrun }
      end
    end
  end
end
