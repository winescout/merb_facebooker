module MerbFacebooker

  # :stopdoc:
  VERSION = '1.0.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

end  # module MerbFacebooker


if defined?(Merb::Plugins)
  dependency "facebooker"
  dependency "merb_helpers"
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  facebook_config = "#{Merb.root}/config/facebooker.yml"
  if File.exist?(facebook_config)
    Merb::Plugins.config[:merb_facebooker] = YAML.load_file(facebook_config)[Merb.environment]
    ENV['FACEBOOK_API_KEY'] = Merb::Plugins.config[:merb_facebooker]['api_key']
    ENV['FACEBOOK_SECRET_KEY'] = Merb::Plugins.config[:merb_facebooker]['secret_key']
    ENV['FACEBOOKER_RELATIVE_URL_ROOT'] = Merb::Plugins.config[:merb_facebooker]['canvas_page_name']
    #ActionController::Base.asset_host = FACEBOOKER['callback_url']
  end
  
  Merb.add_mime_type(:fbml,  :to_fbml,  %w[application/fbml text/fbml], :Encoding => "UTF-8")
  Merb::Request.http_method_overrides.push(
    proc { |c| c.params[:fb_sig_request_method].clone }
  )
  
  Merb::BootLoader.before_app_loads do
    Merb::Controller.send(:include, Facebooker::Merb::Controller) 
    Merb::Controller.send(:include, Facebooker::Merb::Helpers)
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "merb-facebooker/merbtasks"
end

MerbFacebooker.require_all_libs_relative_to(__FILE__)

# EOF
