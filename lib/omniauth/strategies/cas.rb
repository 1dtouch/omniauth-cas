require 'omniauth/strategy'

module OmniAuth
  module Strategies
    class CAS
      include OmniAuth::Strategy

      autoload :Configuration, 'omniauth/strategies/cas/configuration'

      option :name, :cas # TODO: Why do I need to specify this?

      option :host, nil
      option :port, nil
      option :ssl,  true
      option :serviceValidateUri, '/serviceValidate'
      option :login_url,          '/login'
      option :logout_url,         '/logout'

      def initialize( app, *args, &block )
        super
        @configuration = Configuration.new( @options )
      end

      def callback_phase
        ticket = request.params['ticket']
        return fail!(:no_ticket, 'No CAS Ticket') unless ticket
        # validator = ServiceTicketValidator.new(@configuration, callback_url, ticket)
        # @user_info = validator.user_info
        return fail!(:invalid_ticket, 'Invalid CAS Ticket') if @user_info.nil? or @user_info.empty?
        super
      end

      # def request_call
      #   ap "REQUEST CALL"
      #   super
      # end

      # def setup_phase
      #   ap "SETUP PHASE"
      #   super
      # end

      def request_phase
        [
          302,
          {
            'Location' => login_url(callback_url),
            'Content-Type' => 'text/plain'
          },
          ["You are being redirected to CAS for sign-in."]
        ]
      end

      # Build a CAS host with protocol and port
      #
      #
      def cas_host
        @host ||= begin
          host = @options.ssl ? "https" : "http"
          port = @options.port ? ":#{@options.port}" : ''

          "#{host}://#{@options.host}#{port}"
        end
      end

      # Build a CAS login URL from +service+.
      #
      # @param [String] service the service (a.k.a. return-to) URL
      #
      # @return [String] a URL like `http://cas.mycompany.com/login?service=...`
      def login_url(service)
        cas_host + append_service( @options.login_url, service )
      end

      # Adds +service+ as an URL-escaped parameter to +base+.
      #
      # @param [String] base the base URL
      # @param [String] service the service (a.k.a. return-to) URL.
      #
      # @return [String] the new joined URL.
      def append_service(base, service)
        result = base.dup
        result << (result.include?('?') ? '&' : '?')
        result << 'service='
        result << Rack::Utils.escape(service)
      end




      # def cas_url( path )
      #   "#{cas_protocol}://#{@options.host}#{@options.port}#{path}"
      # end
      # 
      # def cas_protocol
      #   @options.ssl ? "https" : "http"
      # end

      # uid do
      #   ap "UID"
      #   # request.params[options.uid_field.to_s]
      # end

      # info do
      #   ap "INFO"
      #   # options.fields.inject({}) do |hash, field|
      #   #   hash[field] = request.params[field.to_s]
      #   #   hash
      #   # end
      # end

      # extra do
      #   ap "EXTRA"
      # end

      # credentials do
      #   ap "CREDENTIALS"
      # end

    end
  end
end

OmniAuth.config.add_camelization 'cas', 'CAS'
