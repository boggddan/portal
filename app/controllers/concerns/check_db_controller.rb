module CheckDbController
  extend ActiveSupport::Concern

  included do

    def product_code( code )
      code = code.nil? ? '' : code.strip
      if product = Product.find_by( code: code )
        product
      else
        { error: { product: "Не знайдений код продукту [#{ code }]" } }
      end
    end

    def child_code( code )
      code = code.nil? ? '' : code.strip
      if child = Child.find_by( code: code )
        child
      else
        { error: { child: "Не знайдений код дитини [#{ code }]" } }
      end
    end

    def reasons_absence_code( code )
      code = code.nil? ? '' : code.strip
      if reasons_absence = ReasonsAbsence.find_by( code: code )
        reasons_absence
      else
        { error: { reasons_absence: "Не знайдений код причини відсутності [#{ code }]" } }
      end
    end

    def children_group_code( code )
      code = code.nil? ? '' : code.strip
      if children_group = ChildrenGroup.find_by( code: code )
        children_group
      else
        { error: { children_group:  "Не знайдений код дитячої группи [#{ code }]" } }
      end
    end

    def causes_deviation_code( code )
      code = code.nil? ? '' : code.strip
      if causes_deviation = CausesDeviation.find_by( code: code )
        causes_deviation
      else
        { error: { causes_deviation: "Не знайдений код причини відхилення [#{ code }]" } }
      end
    end


    def exists_codes( table, codes )
      sql = "SELECT code, COALESCE( bb.id, -1 ) as id " +
      "FROM UNNEST(ARRAY"+
          codes.map { | o | o || '' }.to_s.gsub( '"', '\'' ) +
        ") AS code " +
      "LEFT JOIN #{ table } bb USING( code )"

      obj = JSON.parse( ActiveRecord::Base.connection.execute( sql ).to_json, symbolize_names: true )
      error_codes = obj.select { | o | o[ :id ] == -1 }.map{ | o | o[ :code ] }

      { status: error_codes.empty?,
        obj: obj.map { | o | [ o[ :code ], o[ :id ] ] }.to_h,
        error: { table => "Не знайдені кода: #{ error_codes.to_s.gsub( '"', '\'' ) }" } }
    end

  end

end
