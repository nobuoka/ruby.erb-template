# coding: UTF-8

require 'erb'
require 'pathname'

class ERBTemplate

  class MyERB < ERB
    def set_eoutvar( compiler, eoutvar = '_erbout' )
      super
      cmd = []
      compiler.pre_cmd = cmd
    end
  end

  class Engine

    include ERB::Util

    def initialize( erb_template )
      @erb_template = erb_template
      @erb_trim_mode = '%-'
      @site_root_path = '/'
    end

    def site_path( path )
      @site_root_path + path
    end

    def process( file_name, arg = {} )
      src = File.read( @erb_template.get_file_path_str( file_name ) )
      MyERB.new( src, nil, @erb_trim_mode, '@_erbout' ).result( binding )
    end

    def wrapper( file_name, arg = {}, &block )
      src = File.read( @erb_template.get_file_path_str( file_name ) )
      MyERB.new( src, nil, @erb_trim_mode, '@_erbout' ).result( binding )
    end

    def __result( file_name, arg )
      @_erbout = ''
      src = File.read( @erb_template.get_file_path_str( file_name ) )
      MyERB.new( src, nil, @erb_trim_mode, '@_erbout' ).result( binding )
    end

  end

  def initialize( base_dir )
    @base_dir_path = Pathname.new base_dir
  end

  def get_file_path_str( rel_path_str )
    Pathname.new( File.expand_path( rel_path_str, @base_dir_path ) )
  end

  def result( file_name, args = {} )
    Engine.new( self ).__result( get_file_path_str( file_name ), args )
  end

end
