#! /usr/bin/env ruby
# coding: UTF-8

require 'optparse'
opt = OptionParser.new

args = {}
opt.on( '--srcdir=SRCDIR' ){|v| args[:srcdir] = v }
opt.on( '--dstdir=DSTDIR' ){|v| args[:dstdir] = v }

opt.parse!(ARGV)
p ARGV


[ :srcdir, :dstdir ].each do |key|
  if not args.has_key? key
    $stderr << "コマンドラインオプション #{key} は必須です\n"
    exit 1
  end
end


#p Dir.glob args[:srcdir] + "/**/*"
Dir.foreach args[:srcdir] do |n|
  p n
end


require 'find'
require 'pathname'

puts '----'
pn_srcdir = Pathname.new( args[:srcdir] )
#Find.find( args[:srcdir] ) do |n|
pn_srcdir.find do |pn|
  #pn = Pathname.new( n )
  p relpath = pn.relative_path_from( pn_srcdir )
  p dstpath = Pathname.new( File.expand_path( relpath, args[:dstdir] ) )
  case pn.ftype
  when 'file'
    puts '古ければ上書き'
  when 'directory'
    if not dstpath.exist?
      puts '存在しないから作成'
    end
  else
    p relpath.ftype
  end
end
