module PLSQL
  class Connection
    attr_reader :raw_driver

    def initialize(raw_drv, raw_conn, ar_class = nil)
      @raw_driver = raw_drv
      @raw_connection = raw_conn
      @activerecord_class = ar_class
    end
    
    def self.create(raw_conn, ar_class = nil)
      # MRI 1.8.6 or YARV 1.9.1
      if (!defined?(RUBY_ENGINE) || RUBY_ENGINE == "ruby") &&
            (defined?(OCI8) && raw_conn.is_a?(OCI8) ||
            defined?(::ActiveRecord) && [ar_class, ar_class.superclass].include?(::ActiveRecord::Base))
        OCIConnection.new(:oci, raw_conn, ar_class)
      # JRuby
      elsif (defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby") &&
            (raw_conn.respond_to?(:java_class) && raw_conn.java_class.to_s =~ /jdbc/ ||
            defined?(::ActiveRecord) && [ar_class, ar_class.superclass].include?(::ActiveRecord::Base))
        JDBCConnection.new(:jdbc, raw_conn, ar_class)
      else
        raise ArgumentError, "Unknown raw driver or ActiveRecord class"
      end
    end
    
    def raw_connection
      if @activerecord_class
        @activerecord_class.connection.raw_connection
      else
        @raw_connection
      end
    end
    
    def oci?
      @raw_driver == :oci
    end

    def jdbc?
      @raw_driver == :jdbc
    end
    
    def logoff
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def commit
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def rollback
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def autocommit?
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def autocommit=(value)
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def select_first(sql, *bindvars)
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def select_all(sql, *bindvars, &block)
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def exec(sql, *bindvars)
      raise NoMethodError, "Not implemented for this raw driver"
    end

    def parse(sql)
      raise NoMethodError, "Not implemented for this raw driver"
    end

  end

end