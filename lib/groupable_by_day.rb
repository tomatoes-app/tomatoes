module GroupableByDay
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def group_by_day(resources)
      resources.order_by([[:created_at, :desc]]).group_by do |resource|
        date = resource.created_at
        Time.gm(date.year, date.month, date.day) if date
      end
    end
  end
end