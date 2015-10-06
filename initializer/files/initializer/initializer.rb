#!/usr/bin/ruby

include Math
require 'influxdb'

# setup_db: Add the user, database, and retention policy
def setup_db(opts)
  influxdb = InfluxDB::Client.new(host: opts[:host], port: opts[:port], username: opts[:adminusername], password: opts[:adminpassword])
  influxdb.create_cluster_admin(opts[:adminusername], opts[:adminpassword])
  influxdb.create_database(opts[:db])
  influxdb.create_database_user(opts[:db], opts[:username], opts[:password], permissions: :all)
  influxdb.alter_retention_policy('default', opts[:db], opts[:db_duration], opts[:db_replication])
end

# Write data to influxdb
# This is lifted almost directly from the https://github.com/influxdb/influxdb-ruby README
def write_data(opts)
  influxdb = InfluxDB::Client.new opts[:db],
                                  host: opts[:host], 
                                  port: opts[:port],
                                  username: opts[:username],
                                  password: opts[:password]

  # Enumerator that emits a sine wave
  values = (0..360).to_a.map {|i| Math.send(:sin, i / 10.0) * 10 }
  
  loop do
    360.times do |c|
      data = {
        values: { value: values[c] },
        tags: { wave: 'sine' } # tags are optional
      }
      
      influxdb.write_point(opts[:series], data)
      
      sleep 1
    end
  end
end

def main
  opts = {
    host:           ENV['INFLUXDB_HOST'] || fail('INFLUXDB_HOST Env var is required'),
    port:           ENV['INFLUXDB_PORT'] || 8086,
    adminusername:  'root',
    adminpassword:  'secret',
    db:             'testdb',
    username:       'testuser',
    password:       'password',
    db_duration:    '1w',
    db_replication: 2,    
    series:         'testdata'
  }

  setup_db(opts)
  write_data(opts)
end

if __FILE__ == $0
  main()
end
