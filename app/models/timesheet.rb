class Timesheet < ApplicationRecord
  belongs_to :branch
  belongs_to :institution

  has_many :timesheet_dates, dependent: :destroy

  has_many :timesheet_dates_join,
    -> { select( :id, :timesheet_id, 'children_groups.children_category_id', :children_group_id, :child_id,
                 :reasons_absence_id, :date,
                 'children_categories.name AS category_name', 'children_groups.name AS group_name',
                 'children.name AS child_name', 'reasons_absences.mark AS mark',
                 'children_categories.code AS category_code', 'children_groups.code AS group_code',
                 'children.code AS child_code', 'reasons_absences.code AS reason_code' )
       .joins( :children_category, :children_group, :child, :reasons_absence )
       .order( 'category_name', 'group_name', 'child_name', :date ) }, class_name: TimesheetDate

  #default_scope{ order( :date, :number ) }

  #
  before_save :set_default_value

  def set_default_value
    self.number ||= number_next( self.class, institution_id )
    self.date ||= Date.today
  end
end
