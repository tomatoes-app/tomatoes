# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit_point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
    end
  end
end
