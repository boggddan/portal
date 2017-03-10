class Institution::TimesheetsController < Institution::BaseController

  def index
  end

  def ajax_filter_timesheets # Фильтрация документов
    if params[ :date_start ] && params[ :date_start ]
      date_start = params[ :date_start ] ? params[ :date_start ] : params[ :date_end ]
      date_end = params[ :date_end ] ? params[ :date_end ] : params[ :date_start ]
      @timesheets = Timesheet.where( institution: current_institution, date: date_start..date_end ).order( :date )
    end
  end

  def delete_timesheet # Удаление документа
    Timesheet.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def dates # Отображение дней табеля
    @timesheet = Timesheet.find_by( id: params[ :id ] )

    select_column = [:id, 'children_categories.name AS category_name', 'children_groups.name AS group_name', 'children.name AS child_name']

    ( @timesheet.date_vb..@timesheet.date_ve ).each_with_index do | value, index |
      select_column << "MAX(CASE date WHEN '#{value}' THEN timesheet_dates.id || '_' || reasons_absences.id || '_' ||
                        reasons_absences.mark ELSE '' END) AS d_#{index+1}"
    end

    @timesheet_dates = @timesheet.timesheet_dates.select( select_column ).
      joins( :children_category, :child, :reasons_absence ).group( 'children_categories.code', 'children_groups.code', 'children.code' )

    #render json: @timesheet_dates

  end

  def update # Обновление реквизитов документа
    update = params.permit( :date ).to_h
    Timesheet.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end


end
