# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'SqlServer/version'
 
Gem::Specification.new do |s|
  s.name        = "sql_server"
  s.version     = SqlServer::VERSION

  s.author      = "Ed Botzum"
  s.email       = "contact@edbotz.us"

  s.summary     = "Fast and easy Microsoft Sql Server querying."
  s.description = "Uses ole to interact with the Mocrosoft ADO objects and interface with Microsft SQL Server."
  s.homepage    = "http://github.com/ebot/sql_server"
 
  s.add_dependency 'win32ole-pp'
  
  s.files       = Dir.glob("{lib}/**/*") + %w(README.textile CHANGELOG.textile)
end