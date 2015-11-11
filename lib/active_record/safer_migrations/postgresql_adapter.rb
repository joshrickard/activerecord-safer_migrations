module ActiveRecord
  module SaferMigrations
    module PostgreSQLAdapter
      SET_SETTING_SQL = <<-SQL
      UPDATE
        pg_settings
      SET
        setting = :value
      WHERE
        name = :setting_name
      SQL

      GET_SETTING_SQL = <<-SQL
      SELECT
        setting
      FROM
        pg_settings
      WHERE
        name = :setting_name
      SQL

      def set_setting(setting_name, value)
        execute(fill_sql_values(SET_SETTING_SQL, value: value, setting_name: setting_name))
      end

      def get_setting(setting_name)
        execute(fill_sql_values(GET_SETTING_SQL, setting_name: setting_name)).first["setting"]
      end

      def fill_sql_values(sql, values)
        ActiveRecord::Base.send(:replace_named_bind_variables, sql, values)
      end
    end
  end
end
