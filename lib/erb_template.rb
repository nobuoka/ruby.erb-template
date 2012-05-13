# coding: UTF-8

require 'erb'

class ERBTemplate

  class MyERB < ERB
    def set_eoutvar( compiler, eoutvar = '_erbout' )
      super
      cmd = []
      compiler.pre_cmd = cmd
    end
  end

  class Engine

    def process( file_name, arg = {} )
      src = File.read( file_name )
      MyERB.new( src, nil, nil, '@_erbout' ).result( binding )
    end

    def wrapper( file_name, arg = {}, &block )
      src = File.read( file_name )
      MyERB.new( src, nil, nil, '@_erbout' ).result( binding )
    end

    def __result( file_name, args )
      @_erbout = ''
      MyERB.new( File.read( file_name ), nil, nil, '@_erbout' ).result( binding )
    end

  end

  def result( file_name, args = {} )
    Engine.new.__result( file_name, args )
  end

end
