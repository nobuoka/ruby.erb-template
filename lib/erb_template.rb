# coding: UTF-8

require 'erb'
require 'pathname'

##
# ERB を使ってファイルを処理して結果を出力するためのクラス
#
# 文字列に対して処理を行う ERB と異なり, ファイルシステム上のファイルに処理を行う.
# 出力は文字列である. 処理されるファイル中で process メソッドと wrapper
# メソッドを使うことができる. これらは別のファイルを読み込むためのものである.
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

  ##
  # process メソッドや wrapper メソッドでファイルを読み込む際の,
  # ファイルパスの基準となるディレクトリを指定してインスタンス化する.
  # @param base_dir [String] process メソッドや wrapper メソッドでファイルを読み込む際のファイルパスの基準となるディレクトリ
  def initialize( base_dir )
    @base_dir_path = Pathname.new base_dir
  end

  def get_file_path_str( rel_path_str )
    Pathname.new( File.expand_path( rel_path_str, @base_dir_path ) )
  end

  ##
  # 指定したファイルに対して ERB で処理を行う
  # @param file_name [String] 処理する対象のファイルパス (base_dir を基準とする)
  # @return [String] 処理した結果
  def result( file_name, args = {} )
    Engine.new( self ).__result( get_file_path_str( file_name ), args )
  end

end
