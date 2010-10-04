#!/usr/bin/env ruby -wKU
require 'win32ole'

class << Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end

class SqlServer
  attr_accessor :connection

  def initialize(params = {})
    # Set the connection parameters
    params = { :host => nil, :user_name => nil, :password => nil,
               :database => nil, :timeout => nil }.merge!(params)
    @connection = open(params)
  end
 
  def query(sql)
    # Create an instance of an ADO Recordset
    recordset = WIN32OLE.new('ADODB.Recordset')
    
    # Open the recordset, using an SQL statement and the
    # existing ADO connection
    recordset.Open(sql, @connection)
    
    # Create and populate an array of field names
    fields = []
    data = []
    recordset.Fields.each do |field|
        fields << field.Name
    end
    
    begin
      # Move to the first record/row, if any exist
      recordset.MoveFirst

      # Grab all records
      data = recordset.GetRows
    rescue Exception => e
      # Do nothing, it's an empty recordset
    end
    recordset.Close
    
    # An ADO Recordset's GetRows method returns an array 
    # of columns, so we'll use the transpose method to 
    # convert it to an array of rows
    data = data.transpose
    
    result_set = []
    data.each { |row| result_set << Hash.create(fields, row) }
    
    return result_set
  end
  
  def execute_command(sql_statement)
    # Create an instance of an ADO COmmand
    command = WIN32OLE.new('ADODB.Command')
    
    # Execute the SQL statement using the existing ADO connection
    command.ActiveConnection = @connection
    command.CommandText=sql_statement
    command.Execute
  end

  def close
    @connection.Close
  end
  
  private
  
   def open(params)
    connection_string =  "Provider=SQLNCLI;"
    connection_string << "Server=#{params[:host]};"
    connection_string << "Uid=#{params[:user_name]};"
    connection_string << "Pwd=#{params[:password]};"
    connection_string << "Database=#{params[:database]};"
    
    connection = WIN32OLE.new('ADODB.Connection')
    connection.Open(connection_string)
    connection.CommandTimeout = params[:timeout] unless params[:timeout].nil?
    
    return connection
  end
end