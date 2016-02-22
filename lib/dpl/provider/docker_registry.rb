module DPL
  class Provider
    class DockerRegistry < Provider

      experimental 'DockerRegistry'

      def check_auth
        if options[:email] && options[:username] && options[:password]
          login_cmd = %W(docker --debug login
            --username="#{options[:username]}"
            --password="#{options[:password]}"
            --email="#{options[:email]}"
          )
          login_cmd << options[:url] unless options[:url].nil?
          log "Running: #{login_cmd.join(' ')}"
          context.shell login_cmd.join(' ')
          if $?.exitstatus != 0
            raise Error, "Failed to login to Docker registry"
          end
        else
          raise Error, "Missing email, username and password to login to Docker registry"
        end
      end

      def check_app
      end

      def needs_key?
        false
      end

      def push_app
        images.each do |image|
          log "Runing: `docker push #{image}`"
          context.shell "docker --debug push #{image}"
          if $?.exitstatus != 0
            raise Error, "Failed to push to Docker registry"
          end
        end
      end

      def images
        Array(options[:images])
      end
    end
  end
end
